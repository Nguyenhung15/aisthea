package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.VoucherDAO;
import com.aisthea.fashion.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * URL mapping (web.xml / @WebServlet):
 * /voucher → toàn bộ xử lý voucher (admin CRUD + user apply)
 *
 * GET ?action=list → Admin: danh sách
 * GET ?action=add → Admin: form thêm mới
 * GET ?action=edit&id=X → Admin: form sửa
 * GET ?action=delete&id=X → Admin: xoá
 * GET ?action=toggle&id=X&active=0|1 → Admin: bật/tắt
 * POST ?action=save → Admin: lưu (thêm mới + cập nhật)
 * POST ?action=apply (AJAX/JSON) → User: kiểm tra & áp dụng mã voucher
 * POST ?action=remove → User: xoá voucher khỏi session
 */
public class VoucherServlet extends HttpServlet {

    private final VoucherDAO voucherDAO = new VoucherDAO();

    // ── GET ───────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Chỉ admin mới được dùng các action dưới đây
        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "list" -> listVouchers(req, res);
            case "add" -> showForm(req, res, null);
            case "edit" -> showForm(req, res, getVoucherById(req));
            case "delete" -> deleteVoucher(req, res);
            case "toggle" -> toggleVoucher(req, res);
            default -> listVouchers(req, res);
        }
    }

    // ── POST ──────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null)
            action = "";
        switch (action) {
            case "save" -> saveVoucher(req, res);
            case "apply" -> applyVoucher(req, res); // AJAX – user side
            case "remove" -> removeVoucher(req, res); // user: xoá voucher
            default -> res.sendRedirect(req.getContextPath() + "/voucher");
        }
    }

    // ── Admin: list ───────────────────────────────────────────────────────

    private void listVouchers(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        List<Voucher> vouchers = voucherDAO.findAll();
        req.setAttribute("vouchers", vouchers);
        req.getRequestDispatcher("/WEB-INF/views/admin/voucher/manage_vouchers.jsp").forward(req, res);
    }

    // ── Admin: form (add/edit) ────────────────────────────────────────────

    private void showForm(HttpServletRequest req, HttpServletResponse res, Voucher voucher)
            throws ServletException, IOException {
        req.setAttribute("voucher", voucher); // null → add mode
        req.getRequestDispatcher("/WEB-INF/views/admin/voucher/voucher_form.jsp").forward(req, res);
    }

    // ── Admin: save (insert or update) ───────────────────────────────────

    private void saveVoucher(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        String idStr = req.getParameter("voucherId");
        Voucher v = buildVoucherFromRequest(req);

        boolean ok;
        if (idStr != null && !idStr.isBlank()) {
            v.setVoucherId(Integer.parseInt(idStr));
            ok = voucherDAO.update(v);
        } else {
            ok = voucherDAO.insert(v);
        }
        String flash = ok ? "success" : "error";
        res.sendRedirect(req.getContextPath() + "/voucher?action=list&" + flash + "=true");
    }

    // ── Admin: delete ────────────────────────────────────────────────────

    private void deleteVoucher(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int id = intParam(req, "id", 0);
        voucherDAO.delete(id);
        res.sendRedirect(req.getContextPath() + "/voucher?action=list&deleted=true");
    }

    // ── Admin: toggle active ──────────────────────────────────────────────

    private void toggleVoucher(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int id = intParam(req, "id", 0);
        boolean active = "1".equals(req.getParameter("active"));
        voucherDAO.toggleActive(id, active);
        res.sendRedirect(req.getContextPath() + "/voucher?action=list");
    }

    // ── User: apply voucher (AJAX) ────────────────────────────────────────

    /**
     * Request: POST /voucher?action=apply
     * Body params: code, orderTotal
     * Response JSON:
     * { "ok": true, "voucherId": 3, "discount": 50000, "message": "Giảm 50.000 ₫" }
     * { "ok": false, "message": "Mã không hợp lệ hoặc đã hết hạn." }
     */
    private void applyVoucher(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        String code = req.getParameter("code");
        String totalStr = req.getParameter("orderTotal");

        if (code == null || code.isBlank() || totalStr == null) {
            out.print("{\"ok\":false,\"message\":\"Thiếu thông tin.\"}");
            return;
        }

        BigDecimal orderTotal;
        try {
            orderTotal = new BigDecimal(totalStr);
        } catch (NumberFormatException e) {
            out.print("{\"ok\":false,\"message\":\"Tổng đơn hàng không hợp lệ.\"}");
            return;
        }

        Voucher v = voucherDAO.findByCode(code);
        if (v == null || !v.isUsable()) {
            out.print("{\"ok\":false,\"message\":\"Mã voucher không hợp lệ hoặc đã hết hạn.\"}");
            return;
        }
        if (v.getMinOrderValue() != null && orderTotal.compareTo(v.getMinOrderValue()) < 0) {
            String min = String.format("%,.0f", v.getMinOrderValue());
            out.print("{\"ok\":false,\"message\":\"Đơn hàng tối thiểu " + min + " ₫ để dùng mã này.\"}");
            return;
        }

        BigDecimal discount = v.calculateDiscount(orderTotal);

        // Lưu vào session để checkout dùng
        HttpSession session = req.getSession();
        session.setAttribute("appliedVoucher", v);
        session.setAttribute("appliedDiscount", discount);

        String msg = "PERCENT".equalsIgnoreCase(v.getDiscountType())
                ? "Giảm " + v.getDiscountValue().stripTrailingZeros().toPlainString() + "%"
                : "Giảm " + String.format("%,.0f", discount) + " ₫";

        out.print("{\"ok\":true,\"voucherId\":" + v.getVoucherId() +
                ",\"discount\":" + discount.toPlainString() +
                ",\"message\":\"" + escapeJson(msg) + "\"}");
    }

    // ── User: remove voucher from session ────────────────────────────────

    private void removeVoucher(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("appliedDiscount");
        }
        // Redirect về checkout
        res.sendRedirect(req.getContextPath() + "/checkout");
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    private Voucher getVoucherById(HttpServletRequest req) {
        int id = intParam(req, "id", 0);
        return id > 0 ? voucherDAO.findById(id) : null;
    }

    private Voucher buildVoucherFromRequest(HttpServletRequest req) {
        Voucher v = new Voucher();
        v.setCode(req.getParameter("code"));
        v.setDescription(req.getParameter("description"));
        v.setDiscountType(req.getParameter("discountType"));
        v.setDiscountValue(parseBD(req.getParameter("discountValue")));
        v.setMinOrderValue(parseBD(req.getParameter("minOrderValue")));
        v.setMaxDiscountAmount(parseBD(req.getParameter("maxDiscountAmount")));
        v.setUsageLimit(intParam(req, "usageLimit", -1));
        v.setStartDate(parseTimestamp(req.getParameter("startDate")));
        v.setEndDate(parseTimestamp(req.getParameter("endDate")));
        v.setActive("1".equals(req.getParameter("isActive")));
        return v;
    }

    private int intParam(HttpServletRequest req, String name, int def) {
        try {
            return Integer.parseInt(req.getParameter(name));
        } catch (Exception e) {
            return def;
        }
    }

    private BigDecimal parseBD(String s) {
        if (s == null || s.isBlank())
            return null;
        try {
            return new BigDecimal(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Timestamp parseTimestamp(String s) {
        if (s == null || s.isBlank())
            return null;
        try {
            return Timestamp.valueOf(s.trim().replace("T", " ") + (s.length() == 16 ? ":00" : ""));
        } catch (Exception e) {
            return null;
        }
    }

    private String escapeJson(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}

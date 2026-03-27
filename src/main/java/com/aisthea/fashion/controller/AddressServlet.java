package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.UserAddressDAO;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.model.UserAddress;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddressServlet", urlPatterns = { "/address" })
public class AddressServlet extends HttpServlet {

    private UserAddressDAO addressDAO;

    @Override
    public void init() throws ServletException {
        addressDAO = new UserAddressDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<UserAddress> addresses = addressDAO.getByUserId(user.getUserId());
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/WEB-INF/views/user/address.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/address");
            return;
        }

        try {
            switch (action) {
                case "add":      handleAdd(request, user);       break;
                case "update":   handleUpdate(request, user);    break;
                case "delete":   handleDelete(request, user);    break;
                case "setDefault": handleSetDefault(request, user); break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/address");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /** Parse and validate common address fields from the request. */
    private UserAddress buildAddressFromRequest(HttpServletRequest request, int userId, int addressId)
            throws Exception {

        String fullName = request.getParameter("fullName");
        String phone    = request.getParameter("phone");

        // Validate phone
        if (phone == null || !phone.matches("^(84|0[3|5|7|8|9])+([0-9]{8})$")) {
            throw new Exception("Số điện thoại không hợp lệ. Vui lòng nhập 10 số (VD: 0912345678).");
        }

        // Street/detail is required and must contain both letters + numbers
        String street = request.getParameter("street");
        if (street == null || !street.matches("(?s).*\\d.*") || !street.matches("(?s).*\\p{L}.*")) {
            throw new Exception("Vui lòng nhập địa chỉ cụ thể có cả chữ và số (VD: Số 12 Đường Lê Lợi).");
        }

        boolean isDefault = request.getParameter("isDefault") != null;

        // Geographic IDs & names
        int    provinceId   = parseIntSafe(request.getParameter("provinceId"), 201);
        String provinceName = trimOrNull(request.getParameter("provinceName"));
        int    districtId   = parseIntSafe(request.getParameter("districtId"), 0);
        String districtName = trimOrNull(request.getParameter("districtName"));
        String wardCode     = trimOrNull(request.getParameter("wardCode"));
        String wardName     = trimOrNull(request.getParameter("wardName"));

        String fullDetailedAddress = street.trim();
        if (wardName != null && !wardName.isEmpty()) fullDetailedAddress += ", " + wardName;
        if (districtName != null && !districtName.isEmpty()) fullDetailedAddress += ", " + districtName;
        if (provinceName != null && !provinceName.isEmpty()) fullDetailedAddress += ", " + provinceName;

        UserAddress addr = new UserAddress();
        addr.setAddressId(addressId);
        addr.setUserId(userId);
        addr.setFullName(fullName);
        addr.setPhone(phone);
        addr.setDetailedAddress(fullDetailedAddress);
        addr.setDefault(isDefault);
        addr.setProvinceId(provinceId);
        addr.setProvinceName(provinceName);
        addr.setDistrictId(districtId);
        addr.setDistrictName(districtName);
        addr.setWardCode(wardCode);
        addr.setWardName(wardName);
        return addr;
    }

    private void handleAdd(HttpServletRequest request, User user) throws Exception {
        UserAddress address = buildAddressFromRequest(request, user.getUserId(), 0);
        if (address.isDefault()) {
            addressDAO.clearDefault(user.getUserId());
        }
        addressDAO.insert(address);
    }

    private void handleUpdate(HttpServletRequest request, User user) throws Exception {
        int addressId = Integer.parseInt(request.getParameter("addressId"));
        UserAddress address = buildAddressFromRequest(request, user.getUserId(), addressId);
        if (address.isDefault()) {
            addressDAO.clearDefault(user.getUserId());
        }
        addressDAO.update(address);
    }

    private void handleDelete(HttpServletRequest request, User user) throws Exception {
        int addressId = Integer.parseInt(request.getParameter("addressId"));
        addressDAO.delete(addressId, user.getUserId());
    }

    private void handleSetDefault(HttpServletRequest request, User user) throws Exception {
        int addressId = Integer.parseInt(request.getParameter("addressId"));
        addressDAO.setAsDefault(addressId, user.getUserId());
    }

    private static int parseIntSafe(String s, int defaultVal) {
        if (s == null || s.isBlank()) return defaultVal;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return defaultVal; }
    }

    private static String trimOrNull(String s) {
        return (s == null || s.isBlank()) ? null : s.trim();
    }
}

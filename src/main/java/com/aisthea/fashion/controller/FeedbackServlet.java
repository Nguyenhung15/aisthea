package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Feedback;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.FeedbackService;
import com.aisthea.fashion.service.IFeedbackService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "FeedbackServlet", urlPatterns = { "/feedback" })
public class FeedbackServlet extends HttpServlet {

    private IFeedbackService feedbackService;

    @Override
    public void init() {
        this.feedbackService = new FeedbackService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== DEBUG MODE =====
        if ("1".equals(request.getParameter("debug"))) {
            response.setContentType("text/html;charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();
            out.println("<html><body style='font-family:monospace;padding:24px'>");
            out.println("<h2>🛠 Feedback Debug - DB Query</h2>");
            try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection()) {
                // All feedback records
                out.println("<h3>Tất cả records trong bảng feedback:</h3>");
                out.println("<table border='1' cellpadding='6' style='border-collapse:collapse'>");
                out.println(
                        "<tr style='background:#e5e7eb'><th>feedbackid</th><th>userid</th><th>productid</th><th>rating</th><th>comment</th><th>status</th><th>createdat</th></tr>");
                try (java.sql.PreparedStatement ps = conn
                        .prepareStatement("SELECT * FROM feedback ORDER BY feedbackid DESC");
                        java.sql.ResultSet rs = ps.executeQuery()) {
                    int cnt = 0;
                    while (rs.next()) {
                        cnt++;
                        out.println("<tr><td>" + rs.getInt("feedbackid") + "</td><td>" + rs.getInt("userid")
                                + "</td><td>" + rs.getInt("productid") + "</td><td>" + rs.getInt("rating")
                                + "</td><td>" + rs.getString("comment") + "</td><td><b>" + rs.getString("status")
                                + "</b></td><td>" + rs.getTimestamp("createdat") + "</td></tr>");
                    }
                    out.println("</table><p><b>Total: " + cnt + " rows</b></p>");
                }
                // Status distinct
                out.println("<h3>Distinct status values:</h3>");
                try (java.sql.PreparedStatement ps2 = conn
                        .prepareStatement("SELECT DISTINCT status, COUNT(*) as cnt FROM feedback GROUP BY status");
                        java.sql.ResultSet rs2 = ps2.executeQuery()) {
                    while (rs2.next()) {
                        out.println("status='" + rs2.getString("status") + "' | count=" + rs2.getInt("cnt") + "<br/>");
                    }
                }
            } catch (Exception e) {
                out.println("<pre style='color:red'>ERROR: " + e.getMessage() + "</pre>");
            }
            out.println("</body></html>");
            return;
        }
        // ===== END DEBUG =====

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        request.setAttribute("orderId", orderIdStr);

        // Load danh sách sản phẩm trong đơn hàng để hiển thị dropdown chọn SP
        try {
            int orderId = Integer.parseInt(orderIdStr);
            List<Map<String, Object>> orderItems = new ArrayList<>();

            try (Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                            "SELECT DISTINCT pcs.productid, p.name AS product_name, oi.image_url " +
                                    "FROM orderitems oi " +
                                    "JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid " +
                                    "JOIN products p ON pcs.productid = p.productid " +
                                    "WHERE oi.orderid = ?")) {

                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> item = new LinkedHashMap<>();
                        item.put("productId", rs.getInt("productid"));
                        item.put("productName", rs.getString("product_name"));
                        item.put("imageUrl", rs.getString("image_url"));
                        orderItems.add(item);
                    }
                }
            }

            request.setAttribute("orderItems", orderItems);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/user/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            String productIdStr = request.getParameter("productId");
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");

            java.util.logging.Logger log = java.util.logging.Logger.getLogger("FeedbackServlet");
            log.info("[Feedback] userId=" + user.getUserId()
                    + " productId=" + productIdStr
                    + " rating=" + ratingStr
                    + " comment=" + comment);

            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                log.warning("[Feedback] productId is empty, aborting.");
                response.sendRedirect(request.getContextPath() + "/order?action=history");
                return;
            }

            int productId = Integer.parseInt(productIdStr.trim());
            int rating = (ratingStr != null && !ratingStr.isEmpty()) ? Integer.parseInt(ratingStr) : 1;

            Feedback feedback = new Feedback();
            feedback.setUserid(user.getUserId());
            feedback.setProductid(productId);
            feedback.setRating(rating);
            feedback.setComment(comment != null ? comment : "");
            boolean saved = feedbackService.addFeedback(feedback);
            log.info("[Feedback] saved=" + saved);

            String orderId = request.getParameter("orderId");
            if (orderId != null && !orderId.isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/order?action=view&id=" + orderId + "&feedback=success");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/product?action=view&id=" + productId + "&feedback=success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/order?action=history");
        }
    }
}

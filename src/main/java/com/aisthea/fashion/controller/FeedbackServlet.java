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
                            "SELECT DISTINCT pcs.productid, oi.product_name, oi.image_url " +
                                    "FROM orderitems oi " +
                                    "JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid " +
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
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            if (feedbackService.canUserReview(user.getUserId(), productId)) {
                Feedback feedback = new Feedback();
                feedback.setUserid(user.getUserId());
                feedback.setProductid(productId);
                feedback.setRating(rating);
                feedback.setComment(comment);
                feedbackService.addFeedback(feedback);
            }

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

package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Notification;
import com.aisthea.fashion.model.Order;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.INotificationService;
import com.aisthea.fashion.service.NotificationService;
import com.aisthea.fashion.service.IOrderService;
import com.aisthea.fashion.service.OrderService;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class NotificationServlet extends HttpServlet {

    private INotificationService notificationService;
    private IOrderService orderService;

    @Override
    public void init() {
        notificationService = new NotificationService();
        orderService = new OrderService();
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

        String action = request.getParameter("action");
        try {
            if ("markRead".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                notificationService.markAsRead(id);
                String redirectUrl = request.getParameter("redirectUrl");
                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/notifications");
                }
                return;
            } else if ("markAllRead".equals(action)) {
                notificationService.markAllAsRead(user.getUserId());
                response.sendRedirect(request.getContextPath() + "/notifications");
                return;
            }

            // 1. Sync old orders into notifications
            syncOrderNotifications(user.getUserId());

            // 3. Get all notifications
            String type = request.getParameter("type");
            List<Notification> notifications = notificationService.getNotificationsByUserId(user.getUserId());

            // 4. Filter by type
            if (type != null && !type.isEmpty() && !"ALL".equalsIgnoreCase(type)) {
                notifications = notifications.stream()
                    .filter(n -> n.getType() != null && n.getType().equalsIgnoreCase(type))
                    .collect(Collectors.toList());
            }

            request.setAttribute("notifications", notifications);
            request.setAttribute("activeType", type == null ? "ALL" : type);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải thông báo: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/user/notifications.jsp").forward(request, response);
    }

    /**
     * Sync existing orders into notifications.
     * For each order that doesn't have a corresponding notification, create one.
     */
    private void syncOrderNotifications(int userId) {
        try {
            List<Order> orders = orderService.getOrderHistory(userId);
            List<Notification> existing = notificationService.getNotificationsByUserId(userId);

            for (Order order : orders) {
                String marker = "#" + order.getOrderid();
                boolean alreadyExists = existing.stream()
                    .anyMatch(n -> "ORDER".equalsIgnoreCase(n.getType())
                               && n.getContent() != null
                               && n.getContent().contains(marker));

                if (!alreadyExists) {
                    String title = getOrderTitle(order.getStatus());
                    String content = "Đơn hàng #" + order.getOrderid()
                        + " - Trạng thái: " + translateStatus(order.getStatus());
                    notificationService.sendNotification(userId, title, content, "ORDER");
                }
            }
        } catch (Exception e) {
            System.err.println("syncOrderNotifications error: " + e.getMessage());
        }
    }


    private String getOrderTitle(String status) {
        if (status == null) return "Cập nhật đơn hàng";
        switch (status.toLowerCase()) {
            case "pending": return "Đơn hàng mới";
            case "confirmed": return "Đơn hàng đã xác nhận";
            case "shipping": return "Đơn hàng đang giao";
            case "completed": case "paid": return "Đơn hàng hoàn thành";
            case "cancelled": return "Đơn hàng đã hủy";
            default: return "Cập nhật đơn hàng";
        }
    }

    private String translateStatus(String status) {
        if (status == null) return "Không rõ";
        switch (status.toLowerCase()) {
            case "pending": return "Chờ xác nhận";
            case "confirmed": return "Đã xác nhận";
            case "shipping": return "Đang giao hàng";
            case "completed": return "Hoàn thành";
            case "paid": return "Đã thanh toán";
            case "cancelled": return "Đã hủy";
            default: return status;
        }
    }
}

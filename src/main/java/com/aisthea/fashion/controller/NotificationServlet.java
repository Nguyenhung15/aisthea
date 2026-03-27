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
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "NotificationServlet", urlPatterns = { "/admin-notifs", "/notifications", "/admin/system-notifications" })
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
        String servletPath = request.getServletPath();
        String role = (user.getRole() != null) ? user.getRole().trim() : "";
        boolean isStaffOrAdmin = "ADMIN".equalsIgnoreCase(role) || "STAFF".equalsIgnoreCase(role);
        
        boolean isAdminRequest = servletPath != null && (servletPath.startsWith("/admin") || servletPath.contains("/admin") || servletPath.contains("/admin-notifs") || servletPath.contains("/notifications-admin-hub"));

        // Debug info: LOG TO CONSOLE
        System.out.println("[NotificationServlet] Access - ID: " + user.getUserId() + " | Role: " + role + " | isStaff: " + isStaffOrAdmin + " | Path: " + servletPath);

        try {
            // 1. Handle Shared Actions (Mark Read)
            if ("markRead".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                notificationService.markAsRead(id);
                String redirectUrl = request.getParameter("redirectUrl");
                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                } else {
                    String returnPath = isAdminRequest ? "/admin-notifs" : "/notifications";
                    response.sendRedirect(request.getContextPath() + returnPath);
                }
                return;
            } else if ("markAllRead".equals(action)) {
                notificationService.markAllAsRead(user.getUserId());
                String returnPath = isAdminRequest ? "/admin-notifs" : "/notifications";
                response.sendRedirect(request.getContextPath() + returnPath);
                return;
            }

            // 2. Branch Logic: ADMIN vs CUSTOMER
            if (isAdminRequest || isStaffOrAdmin) {
                // If it is an admin request OR the user is an admin, show the hub
                
                // Get Admin Notifications (Assigned to this staff/admin)
                String type = request.getParameter("type");
                List<Notification> notifications = notificationService.getNotificationsByUserId(user.getUserId());
                
                // STRICT FILTER: Only show admin-relevant types
                notifications = notifications.stream()
                    .filter(n -> n.getType() != null && (
                        (n.getType().equalsIgnoreCase("CHAT") && !n.isRead()) || 
                        (n.getType().equalsIgnoreCase("SUPPORT") && !n.isRead()) || 
                        n.getType().equalsIgnoreCase("RETURN") || 
                        n.getType().equalsIgnoreCase("ORDER")
                    ))
                    .collect(Collectors.toList());

                if (type != null && !type.isEmpty() && !"ALL".equalsIgnoreCase(type)) {
                    final String filterType = type;
                    notifications = notifications.stream()
                        .filter(n -> {
                            if (n.getType() == null) return false;
                            if (filterType.equalsIgnoreCase("SUPPORT")) {
                                return n.getType().equalsIgnoreCase("SUPPORT") || n.getType().equalsIgnoreCase("CHAT");
                            }
                            return n.getType().equalsIgnoreCase(filterType);
                        })
                        .collect(Collectors.toList());
                }
               
                request.setAttribute("notifications", notifications);
                request.setAttribute("activeType", type == null ? "ALL" : type);
                request.getRequestDispatcher("/WEB-INF/views/admin/notifications.jsp").forward(request, response);
                
            } else {
                // STICK TO CUSTOMER FLOW
                if (!isStaffOrAdmin) {
                    syncOrderNotifications(user.getUserId());
                    seedPromotions(user.getUserId());
                }
                
                String type = request.getParameter("type");
                List<Notification> notifications = notificationService.getNotificationsByUserId(user.getUserId());
                if (type != null && !type.isEmpty() && !"ALL".equalsIgnoreCase(type)) {
                    notifications = notifications.stream()
                        .filter(n -> n.getType() != null && n.getType().equalsIgnoreCase(type))
                        .collect(Collectors.toList());
                }
                
                request.setAttribute("notifications", notifications);
                request.setAttribute("activeType", type == null ? "ALL" : type);
                request.getRequestDispatcher("/WEB-INF/views/user/notifications.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
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

    /**
     * Seed promotional notifications if user has none.
     */
    private void seedPromotions(int userId) {
        try {
            List<Notification> existing = notificationService.getNotificationsByUserId(userId);
            boolean hasPromo = existing.stream()
                .anyMatch(n -> "PROMOTION".equalsIgnoreCase(n.getType()));

            if (!hasPromo) {
                notificationService.sendNotification(userId,
                    "Chào mừng bạn đến với AISTHÉA",
                    "Khám phá bộ sưu tập Thu Đông mới nhất với ưu đãi lên đến 50%. Nhập mã SPRING50 ngay!",
                    "PROMOTION");
                notificationService.sendNotification(userId,
                    "Ưu đãi thành viên mới",
                    "Bạn đã nhận được phiếu giảm giá 20% cho đơn hàng đầu tiên. Hạn dùng: 30 ngày.",
                    "PROMOTION");
            }
        } catch (Exception e) {
            System.err.println("seedPromotions error: " + e.getMessage());
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

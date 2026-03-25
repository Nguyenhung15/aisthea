package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Notification;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.INotificationService;
import com.aisthea.fashion.service.NotificationService;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * REST-like JSON endpoint for the notification bell dropdown.
 * GET /notifications/api          -> { unreadCount, notifications[] }
 * POST /notifications/api?action=markRead&id=X  -> marks one as read
 * POST /notifications/api?action=markAllRead    -> marks all as read
 */
public class NotificationApiServlet extends HttpServlet {

    private INotificationService notificationService;

    @Override
    public void init() {
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Not logged in — return empty payload
            response.getWriter().write("{\"unreadCount\":0,\"notifications\":[]}");
            return;
        }

        try {
            int unreadCount = notificationService.getUnreadCount(user.getUserId());
            List<Notification> all = notificationService.getNotificationsByUserId(user.getUserId());

            // Return up to 8 most recent
            int limit = Math.min(8, all.size());
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

            StringBuilder sb = new StringBuilder();
            sb.append("{\"unreadCount\":").append(unreadCount).append(",\"notifications\":[");

            for (int i = 0; i < limit; i++) {
                Notification n = all.get(i);
                if (i > 0) sb.append(",");
                sb.append("{");
                sb.append("\"id\":").append(n.getNotificationId()).append(",");
                sb.append("\"title\":\"").append(escapeJson(n.getTitle())).append("\",");
                sb.append("\"content\":\"").append(escapeJson(n.getContent())).append("\",");
                sb.append("\"type\":\"").append(escapeJson(n.getType())).append("\",");
                sb.append("\"read\":").append(n.isRead()).append(",");
                sb.append("\"time\":\"").append(
                        n.getCreatedAt() != null ? sdf.format(n.getCreatedAt()) : ""
                ).append("\"");
                sb.append("}");
            }

            sb.append("]}");
            response.getWriter().write(sb.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"ok\":false}");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("markRead".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                notificationService.markAsRead(id);
            } else if ("markAllRead".equals(action)) {
                notificationService.markAllAsRead(user.getUserId());
            }
            response.getWriter().write("{\"ok\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"ok\":false,\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}

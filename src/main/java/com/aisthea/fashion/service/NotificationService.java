package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.INotificationDAO;
import com.aisthea.fashion.dao.NotificationDAO;
import com.aisthea.fashion.model.Notification;
import java.sql.SQLException;
import java.util.List;

public class NotificationService implements INotificationService {
    private INotificationDAO notificationDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }

    @Override
    public List<Notification> getNotificationsByUserId(int userId) throws SQLException {
        return notificationDAO.getNotificationsByUserId(userId);
    }

    @Override
    public boolean markAsRead(int notificationId) throws SQLException {
        return notificationDAO.markAsRead(notificationId);
    }

    @Override
    public boolean markAllAsRead(int userId) throws SQLException {
        return notificationDAO.markAllAsRead(userId);
    }

    @Override
    public boolean sendNotification(int userId, String title, String content, String type) {
        try {
            Notification n = new Notification();
            n.setUserId(userId);
            n.setTitle(title);
            n.setContent(content);
            n.setType(type);
            n.setRead(false);
            return notificationDAO.addNotification(n);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getUnreadCount(int userId) throws SQLException {
        return notificationDAO.getUnreadCount(userId);
    }
}

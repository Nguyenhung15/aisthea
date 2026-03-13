package com.aisthea.fashion.service;

import com.aisthea.fashion.model.Notification;
import java.sql.SQLException;
import java.util.List;

public interface INotificationService {
    List<Notification> getNotificationsByUserId(int userId) throws SQLException;
    boolean markAsRead(int notificationId) throws SQLException;
    boolean markAllAsRead(int userId) throws SQLException;
    boolean sendNotification(int userId, String title, String content, String type);
    int getUnreadCount(int userId) throws SQLException;
}

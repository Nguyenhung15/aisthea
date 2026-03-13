package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Notification;
import java.sql.SQLException;
import java.util.List;

public interface INotificationDAO {
    List<Notification> getNotificationsByUserId(int userId) throws SQLException;
    boolean markAsRead(int notificationId) throws SQLException;
    boolean markAllAsRead(int userId) throws SQLException;
    boolean addNotification(Notification notification) throws SQLException;
    int getUnreadCount(int userId) throws SQLException;
}

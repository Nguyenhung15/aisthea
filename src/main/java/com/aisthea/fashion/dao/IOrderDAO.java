package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Order;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface IOrderDAO {

    int addOrder(Order order, Connection conn) throws SQLException;

    List<Order> getOrdersByUserId(int userId) throws SQLException;

    Order getOrderById(int orderId, int userId) throws SQLException;

    boolean updateOrderStatus(int orderId, String status) throws SQLException;

    List<Order> getAllOrders() throws SQLException;

    Order getAdminOrderById(int orderId) throws SQLException;

    boolean deleteOrder(int orderId) throws SQLException;

    boolean updateOrderStatus(int orderId, String status, Connection conn) throws SQLException;

}

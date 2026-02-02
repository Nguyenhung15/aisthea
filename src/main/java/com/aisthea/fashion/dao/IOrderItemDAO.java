package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.OrderItem;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface IOrderItemDAO {

    void addOrderItem(OrderItem item, Connection conn) throws SQLException;

    boolean updateStock(OrderItem item, Connection conn) throws SQLException;

    List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException;
    
    boolean increaseStock(OrderItem item, Connection conn) throws SQLException;
}
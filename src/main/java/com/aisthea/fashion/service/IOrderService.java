package com.aisthea.fashion.service;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.Order;
import com.aisthea.fashion.model.User;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.List;

public interface IOrderService {

    Order placeOrder(User user, Cart cart, HttpServletRequest request) throws Exception;

    List<Order> getOrderHistory(int userId);

    Order getOrderDetails(int orderId, int userId);

    List<Order> getAllOrders();

    boolean updateOrderStatus(int orderId, String newStatus);

    Order getAdminOrderDetails(int orderId);

    boolean deleteOrder(int orderId);

    int getTotalOrderCount();

    BigDecimal getTotalRevenue();

    List<Order> getRecentOrders(int limit);
    
    boolean cancelOrder(int orderId, int userId) throws Exception;
}

package com.aisthea.fashion.service;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.Order;
import com.aisthea.fashion.model.ReturnRequest;
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

    boolean cancelOrder(int orderId, int userId, String reason) throws Exception;

    boolean adminCancelOrder(int orderId, String reason) throws Exception;

    boolean markRefunded(int orderId) throws Exception;

    List<Order> getFilteredOrders(String orderId, String status, String customerName, String date);

    /** Customer submits a return request for a Completed order (7-day window). */
    ReturnRequest submitReturnRequest(ReturnRequest rr) throws Exception;

    /** Admin approves or rejects a pending return request. */
    boolean processReturnRequest(int returnId, String newStatus, String adminNote) throws Exception;

    /** Customer cancels a pending return request. */
    boolean cancelReturnRequest(int returnId, int userId) throws Exception;
}

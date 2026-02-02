package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.IOrderDAO;
import com.aisthea.fashion.dao.IOrderItemDAO;
import com.aisthea.fashion.dao.OrderDAO;
import com.aisthea.fashion.dao.OrderItemDAO;
import com.aisthea.fashion.model.*;
import com.aisthea.fashion.dao.DBConnection;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class OrderService implements IOrderService {

    private IOrderDAO orderDAO;
    private IOrderItemDAO orderItemDAO;
    private static final Logger logger = Logger.getLogger(OrderService.class.getName());

    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.orderItemDAO = new OrderItemDAO();
    }

    @Override
    public Order placeOrder(User user, Cart cart, HttpServletRequest request) throws Exception {

        Order newOrder = new Order();
        newOrder.setUserid(user.getUserId());
        newOrder.setTotalprice(cart.getTotalPrice());
        newOrder.setStatus("Pending");

        newOrder.setFullname(request.getParameter("fullname"));
        newOrder.setEmail(user.getEmail());
        newOrder.setPhone(request.getParameter("phone"));
        newOrder.setAddress(request.getParameter("address"));
        newOrder.setPaymentMethod(request.getParameter("paymentMethod"));

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int newOrderId = orderDAO.addOrder(newOrder, conn);

            if (newOrderId == -1) {
                throw new SQLException("Không thể tạo đơn hàng. DAO trả về -1.");
            }
            newOrder.setOrderid(newOrderId);

            List<OrderItem> items = new ArrayList<>();
            for (CartItem cartItem : cart.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderid(newOrderId);
                orderItem.setProductcolorsizeid(cartItem.getProductColorSizeId());
                orderItem.setColor(cartItem.getColor());
                orderItem.setSize(cartItem.getSize());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getPrice());
                orderItem.setImageUrl(cartItem.getProductImageUrl());
                orderItem.setProductName(cartItem.getProductName());

                items.add(orderItem);
                orderItemDAO.addOrderItem(orderItem, conn);

                boolean stockUpdated = orderItemDAO.updateStock(orderItem, conn);
                if (!stockUpdated) {
                    throw new SQLException("Hết hàng cho sản phẩm: " + cartItem.getProductName());
                }
            }

            newOrder.setItems(items);
            conn.commit();
            return newOrder;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    logger.log(Level.SEVERE, "Lỗi khi rollback", ex);
                }
            }
            logger.log(Level.SEVERE, "Lỗi khi đặt hàng", e);
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public List<Order> getOrderHistory(int userId) {
        try {
            return orderDAO.getOrdersByUserId(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public Order getOrderDetails(int orderId, int userId) {
        try {
            Order order = orderDAO.getOrderById(orderId, userId);
            if (order != null) {
                List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
                order.setItems(items);
            }
            return order;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Order> getAllOrders() {
        try {
            return orderDAO.getAllOrders();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public boolean updateOrderStatus(int orderId, String newStatus) {
        try {
            return orderDAO.updateOrderStatus(orderId, newStatus);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái đơn hàng", e);
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Order getAdminOrderDetails(int orderId) {
        try {
            Order order = orderDAO.getAdminOrderById(orderId);
            if (order != null) {
                List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
                order.setItems(items);
            }
            return order;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean deleteOrder(int orderId) {
        try {
            return orderDAO.deleteOrder(orderId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi xóa đơn hàng", e);
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean cancelOrder(int orderId, int userId) throws Exception {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            Order order = orderDAO.getOrderById(orderId, userId);
            if (order == null) {
                throw new Exception("Không tìm thấy đơn hàng hoặc bạn không có quyền.");
            }
            if (!"Pending".equalsIgnoreCase(order.getStatus())) {
                throw new Exception("Chỉ có thể hủy đơn hàng ở trạng thái 'Pending'.");
            }

            List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
            if (items == null || items.isEmpty()) {
                throw new Exception("Không tìm thấy sản phẩm trong đơn hàng này.");
            }

            for (OrderItem item : items) {
                boolean stockRestored = orderItemDAO.increaseStock(item, conn);
                if (!stockRestored) {
                    throw new SQLException("Lỗi: Không thể hoàn trả kho cho sản phẩm ID: " + item.getProductcolorsizeid());
                }
            }

            boolean statusUpdated = orderDAO.updateOrderStatus(orderId, "Cancelled", conn);
            if (!statusUpdated) {
                throw new SQLException("Lỗi: Không thể cập nhật trạng thái đơn hàng.");
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            logger.log(Level.SEVERE, "Lỗi khi hủy đơn hàng (ID: " + orderId + ")", e);
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    @Override
    public int getTotalOrderCount() {
        try {
            return orderDAO.getAllOrders().size();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi đếm đơn hàng", e);
            return 0;
        }
    }

    @Override
    public BigDecimal getTotalRevenue() {
        try {
            return orderDAO.getAllOrders().stream()
                    .filter(order -> "Completed".equalsIgnoreCase(order.getStatus()))
                    .map(Order::getTotalprice)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi tính doanh thu", e);
            return BigDecimal.ZERO;
        }
    }

    @Override
    public List<Order> getRecentOrders(int limit) {
        try {
            List<Order> allOrders = orderDAO.getAllOrders();
            return allOrders.stream().limit(limit).collect(Collectors.toList());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi lấy đơn hàng gần đây", e);
            return new ArrayList<>();
        }
    }
}

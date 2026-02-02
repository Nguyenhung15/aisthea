package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Order;
import com.aisthea.fashion.dao.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO implements IOrderDAO {

    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());

    private static final String INSERT_ORDER = "INSERT INTO orders (userid, totalprice, status, fullname, email, phone, address, payment_method) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ORDERS_BY_USERID = "SELECT * FROM orders WHERE userid = ? ORDER BY createdat DESC";
    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM orders WHERE orderid = ? AND userid = ?";
    private static final String UPDATE_ORDER_STATUS = "UPDATE orders SET status = ?, updatedat = GETDATE() WHERE orderid = ?";
    private static final String SELECT_ALL_ORDERS = "SELECT * FROM orders ORDER BY createdat DESC";
    private static final String SELECT_ADMIN_ORDER_BY_ID = "SELECT * FROM orders WHERE orderid = ?";
    private static final String DELETE_ORDER = "DELETE FROM orders WHERE orderid = ?";

    @Override
    public int addOrder(Order order, Connection conn) throws SQLException {
        int newOrderId = -1;

        try (PreparedStatement psOrder = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
            psOrder.setInt(1, order.getUserid());
            psOrder.setBigDecimal(2, order.getTotalprice());
            psOrder.setString(3, order.getStatus());
            psOrder.setString(4, order.getFullname());
            psOrder.setString(5, order.getEmail());
            psOrder.setString(6, order.getPhone());
            psOrder.setString(7, order.getAddress());
            psOrder.setString(8, order.getPaymentMethod());

            psOrder.executeUpdate();

            try (ResultSet rs = psOrder.getGeneratedKeys()) {
                if (rs.next()) {
                    newOrderId = rs.getInt(1);
                } else {
                    throw new SQLException("Tạo đơn hàng thất bại, không lấy được ID.");
                }
            }
        }
        return newOrderId;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ORDERS_BY_USERID)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        }
        return orders;
    }

    @Override
    public Order getOrderById(int orderId, int userId) throws SQLException {
        Order order = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ORDER_BY_ID)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = mapResultSetToOrder(rs);
                }
            }
        }
        return order;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status, Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderid(rs.getInt("orderid"));
        order.setUserid(rs.getInt("userid"));
        order.setTotalprice(rs.getBigDecimal("totalprice"));
        order.setStatus(rs.getString("status"));
        order.setCreatedat(rs.getTimestamp("createdat"));
        order.setUpdatedat(rs.getTimestamp("updatedat"));

        try {
            order.setFullname(rs.getString("fullname"));
            order.setEmail(rs.getString("email"));
            order.setPhone(rs.getString("phone"));
            order.setAddress(rs.getString("address"));
            order.setPaymentMethod(rs.getString("payment_method"));
        } catch (SQLException e) {
            logger.warning("Không thể đọc đầy đủ thông tin giao hàng (có thể từ listOrders): " + e.getMessage());
        }

        return order;
    }

    @Override
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ALL_ORDERS)) {

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        }
        return orders;
    }

    @Override
    public Order getAdminOrderById(int orderId) throws SQLException {
        Order order = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ADMIN_ORDER_BY_ID)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = mapResultSetToOrder(rs);
                }
            }
        }
        return order;
    }

    @Override
    public boolean deleteOrder(int orderId) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_ORDER)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }
}

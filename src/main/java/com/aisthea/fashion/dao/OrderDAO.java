package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Order;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class OrderDAO implements IOrderDAO {

    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());

    private static final String INSERT_ORDER = "INSERT INTO orders (userid, totalprice, status, fullname, email, phone, address, payment_method, voucherid, discountamount, gift_message) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ORDERS_BY_USERID = "SELECT * FROM orders WHERE userid = ? ORDER BY createdat DESC";
    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM orders WHERE orderid = ? AND userid = ?";
    private static final String UPDATE_ORDER_STATUS = "UPDATE orders SET status = ?, updatedat = GETDATE(), "
            + "confirmed_at = CASE WHEN ? = 'Processing' THEN COALESCE(confirmed_at, GETDATE()) ELSE confirmed_at END, "
            + "shipped_at = CASE WHEN ? = 'Shipped' THEN COALESCE(shipped_at, GETDATE()) ELSE shipped_at END, "
            + "completed_at = CASE WHEN ? = 'Completed' THEN COALESCE(completed_at, GETDATE()) ELSE completed_at END "
            + "WHERE orderid = ?";
    private static final String UPDATE_CANCEL_INFO = "UPDATE orders SET cancel_reason = ?, refund_status = ? WHERE orderid = ?";
    private static final String UPDATE_REFUND_STATUS = "UPDATE orders SET refund_status = ? WHERE orderid = ?";
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

            // nullable voucher
            if (order.getVoucherId() != null) {
                psOrder.setInt(9, order.getVoucherId());
            } else {
                psOrder.setNull(9, java.sql.Types.INTEGER);
            }
            psOrder.setBigDecimal(10,
                    order.getDiscountAmount() != null ? order.getDiscountAmount() : java.math.BigDecimal.ZERO);
            psOrder.setString(11, order.getGiftMessage());

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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ORDERS_BY_USERID)) {
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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ORDER_BY_ID)) {
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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setString(3, status);
            ps.setString(4, status);
            ps.setInt(5, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status, Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setString(3, status);
            ps.setString(4, status);
            ps.setInt(5, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateCancelInfo(int orderId, String cancelReason, String refundStatus, Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(UPDATE_CANCEL_INFO)) {
            ps.setString(1, cancelReason);
            ps.setString(2, refundStatus);
            ps.setInt(3, orderId);
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
            int voucherId = rs.getInt("voucherid");
            order.setVoucherId(rs.wasNull() ? null : voucherId);
            order.setDiscountAmount(rs.getBigDecimal("discountamount"));
            order.setGiftMessage(rs.getString("gift_message"));
            
            // New columns
            order.setCancelReason(rs.getString("cancel_reason"));
            order.setRefundStatus(rs.getString("refund_status"));
            order.setConfirmedAt(rs.getTimestamp("confirmed_at"));
            order.setShippedAt(rs.getTimestamp("shipped_at"));
            order.setCompletedAt(rs.getTimestamp("completed_at"));
        } catch (SQLException e) {
            logger.warning("Không thể đọc đầy đủ thông tin giao hàng (có thể từ listOrders): " + e.getMessage());
        }

        return order;
    }

    @Override
    public boolean updateRefundStatus(int orderId, String refundStatus) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(UPDATE_REFUND_STATUS)) {
            ps.setString(1, refundStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ALL_ORDERS)) {

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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ADMIN_ORDER_BY_ID)) {
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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(DELETE_ORDER)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Order> getFilteredOrders(String orderId, String status, String customerName, String date)
            throws SQLException {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (orderId != null && !orderId.trim().isEmpty()) {
            try {
                sql.append(" AND orderid = ?");
                params.add(Integer.parseInt(orderId.trim()));
            } catch (NumberFormatException e) {
                // Ignore invalid ID filter
            }
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }
        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append(" AND fullname LIKE ?");
            params.add("%" + customerName.trim() + "%");
        }
        if (date != null && !date.trim().isEmpty()) {
            sql.append(" AND CAST(createdat AS DATE) = ?");
            params.add(date.trim()); // Expecting 'YYYY-MM-DD'
        }

        sql.append(" ORDER BY createdat DESC");
        
        System.out.println(">>> SQL Filter: " + sql.toString());
        System.out.println(">>> Params: " + params);

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.err.println(">>> DB ERROR: Connection is NULL!");
                return orders;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        orders.add(mapResultSetToOrder(rs));
                    }
                }
            }
        }
        return orders;
    }
}

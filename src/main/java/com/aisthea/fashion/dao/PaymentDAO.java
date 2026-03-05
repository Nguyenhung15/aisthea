package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Payment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO for the {@code payments} table.
 *
 * <p>
 * Typical usage flow:
 * <ol>
 * <li>On order creation → call {@link #insertPayment(Payment, Connection)} with
 * status "Pending".</li>
 * <li>After QR / online callback → call
 * {@link #updatePaymentStatus(int, String, String)} with
 * the transaction code and final status.</li>
 * <li>For display/admin → call {@link #getByOrderId(int)}.</li>
 * </ol>
 */
public class PaymentDAO {

    private static final Logger logger = Logger.getLogger(PaymentDAO.class.getName());

    // ── SQL ───────────────────────────────────────────────────────────────

    private static final String INSERT_SQL = "INSERT INTO payments (orderid, method, amount, status, transactioncode, paidat) "
            +
            "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_BY_ORDERID = "SELECT * FROM payments WHERE orderid = ? ORDER BY paymentid DESC";

    private static final String SELECT_BY_ID = "SELECT * FROM payments WHERE paymentid = ?";

    private static final String UPDATE_STATUS_SQL = "UPDATE payments SET status = ?, transactioncode = ?, paidat = ? WHERE paymentid = ?";

    private static final String UPDATE_STATUS_BY_ORDERID = "UPDATE payments SET status = ?, transactioncode = ?, paidat = GETDATE() WHERE orderid = ?";

    private static final String DELETE_BY_ORDERID = "DELETE FROM payments WHERE orderid = ?";

    // ── public methods ────────────────────────────────────────────────────

    /**
     * Insert a new payment record.
     * Call within an existing transaction (pass the outer {@code conn}).
     *
     * @return generated paymentid, or -1 on failure
     */
    public int insertPayment(Payment payment, Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getOrderId());
            ps.setString(2, payment.getMethod());
            ps.setBigDecimal(3, payment.getAmount());
            ps.setString(4, payment.getStatus() != null ? payment.getStatus() : "Pending");
            ps.setString(5, payment.getTransactionCode()); // may be null
            if (payment.getPaidAt() != null) {
                ps.setTimestamp(6, payment.getPaidAt());
            } else {
                ps.setNull(6, Types.TIMESTAMP);
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return -1;
    }

    /**
     * Convenience overload — opens its own connection.
     */
    public int insertPayment(Payment payment) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            return insertPayment(payment, conn);
        }
    }

    /**
     * Fetch all payment records for a given order (most recent first).
     */
    public List<Payment> getByOrderId(int orderId) throws SQLException {
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_ORDERID)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            log(e);
            throw e;
        }
        return list;
    }

    /**
     * Fetch a single payment by its primary key.
     */
    public Payment getById(int paymentId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        } catch (SQLException e) {
            log(e);
            throw e;
        }
        return null;
    }

    /**
     * Update a payment's status and transaction code (used after QR/online
     * callback).
     *
     * @param paymentId       primary key of the payment row
     * @param newStatus       e.g. "Paid" | "Failed"
     * @param transactionCode bank/QR transaction reference (may be null for COD)
     */
    public boolean updatePaymentStatus(int paymentId, String newStatus, String transactionCode)
            throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(UPDATE_STATUS_SQL)) {
            ps.setString(1, newStatus);
            ps.setString(2, transactionCode);
            // paidat = now when status becomes Paid
            if ("Paid".equalsIgnoreCase(newStatus)) {
                ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }
            ps.setInt(4, paymentId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Update the latest payment row for an entire order (used by QR callback when
     * we know the orderId but not the paymentId).
     */
    public boolean confirmPaymentByOrderId(int orderId, String transactionCode) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(UPDATE_STATUS_BY_ORDERID)) {
            ps.setString(1, "Paid");
            ps.setString(2, transactionCode);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Delete all payment records for an order (used when order is
     * cancelled/deleted).
     */
    public boolean deleteByOrderId(int orderId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(DELETE_BY_ORDERID)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── private helpers ───────────────────────────────────────────────────

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("paymentid"));
        p.setOrderId(rs.getInt("orderid"));
        p.setMethod(rs.getString("method"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setStatus(rs.getString("status"));
        p.setTransactionCode(rs.getString("transactioncode"));
        p.setPaidAt(rs.getTimestamp("paidat"));
        return p;
    }

    private void log(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException s) {
                logger.log(Level.SEVERE, "PaymentDAO SQL Error", s);
            }
        }
    }
}

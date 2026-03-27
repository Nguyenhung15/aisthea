package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.ReturnRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReturnRequestDAO {

    private static final String INSERT_SQL =
        "INSERT INTO return_requests (order_id, user_id, reason_type, reason_detail, evidence_urls, " +
        "bank_name, bank_account_name, bank_account_number, status, refund_amount) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending', ?)";

    private static final String SELECT_BY_ORDER_ID =
        "SELECT * FROM return_requests WHERE order_id = ?";

    private static final String SELECT_ALL =
        "SELECT * FROM return_requests ORDER BY created_at DESC";

    private static final String UPDATE_STATUS_SQL =
        "UPDATE return_requests SET status = ?, admin_note = ?, updated_at = GETDATE() WHERE return_id = ?";

    /** Insert a new return request. Returns the generated return_id. */
    public int insert(ReturnRequest rr) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, rr.getOrderId());
            ps.setInt(2, rr.getUserId());
            ps.setString(3, rr.getReasonType());
            ps.setString(4, rr.getReasonDetail());
            ps.setString(5, rr.getEvidenceUrls());
            ps.setString(6, rr.getBankName());
            ps.setString(7, rr.getBankAccountName());
            ps.setString(8, rr.getBankAccountNumber());
            if (rr.getRefundAmount() != null) {
                ps.setBigDecimal(9, rr.getRefundAmount());
            } else {
                ps.setNull(9, Types.DECIMAL);
            }

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    /** Get the return request for a given order (at most one active request). */
    public ReturnRequest getByOrderId(int orderId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ORDER_ID)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Get all return requests (admin view). */
    public List<ReturnRequest> getAll() throws SQLException {
        List<ReturnRequest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /**
     * Admin approves or rejects the return request.
     * @param returnId  PK of return_requests
     * @param newStatus "Approved" or "Rejected"
     * @param adminNote Optional note from admin
     */
    public boolean updateStatus(int returnId, String newStatus, String adminNote) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_STATUS_SQL)) {
            ps.setString(1, newStatus);
            ps.setString(2, adminNote);
            ps.setInt(3, returnId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * User cancels a pending return request (hard delete).
     * @param returnId PK of return_requests
     * @param userId Owner of the request
     * @return true if deleted
     */
    public boolean delete(int returnId, int userId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM return_requests WHERE return_id = ? AND user_id = ? AND status = 'Pending'")) {
            ps.setInt(1, returnId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Get all return requests with customer info (admin list view).
     * JOINs with users table to get the customer's name and email.
     */
    public List<ReturnRequest> getAllWithCustomerInfo() throws SQLException {
        String sql = "SELECT rr.*, u.fullname, u.email AS customer_email " +
                     "FROM return_requests rr " +
                     "JOIN Users u ON rr.user_id = u.userid " +
                     "ORDER BY rr.created_at DESC";
        List<ReturnRequest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ReturnRequest rr = mapRow(rs);
                rr.setCustomerName(rs.getString("fullname"));
                rr.setCustomerEmail(rs.getString("customer_email"));
                list.add(rr);
            }
        }
        return list;
    }

    private ReturnRequest mapRow(ResultSet rs) throws SQLException {
        ReturnRequest rr = new ReturnRequest();
        rr.setReturnId(rs.getInt("return_id"));
        rr.setOrderId(rs.getInt("order_id"));
        rr.setUserId(rs.getInt("user_id"));
        rr.setReasonType(rs.getString("reason_type"));
        rr.setReasonDetail(rs.getString("reason_detail"));
        rr.setEvidenceUrls(rs.getString("evidence_urls"));
        rr.setBankName(rs.getString("bank_name"));
        rr.setBankAccountName(rs.getString("bank_account_name"));
        rr.setBankAccountNumber(rs.getString("bank_account_number"));
        rr.setStatus(rs.getString("status"));
        rr.setAdminNote(rs.getString("admin_note"));
        rr.setRefundAmount(rs.getBigDecimal("refund_amount"));
        rr.setCreatedAt(rs.getTimestamp("created_at"));
        rr.setUpdatedAt(rs.getTimestamp("updated_at"));
        return rr;
    }
}

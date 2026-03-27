package com.aisthea.fashion.dao;

import java.sql.*;

/**
 * DAO to track birthday discount usage (max 1 time per year per user).
 */
public class BirthdayDiscountDAO {

    /**
     * Check if a user has already used their birthday discount this year.
     */
    public boolean hasUsedBirthdayDiscount(int userId, int year) {
        String sql = "SELECT COUNT(*) FROM birthday_discount_usage WHERE userid = ? AND used_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("BirthdayDiscountDAO.hasUsed error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Record that a user has used their birthday discount for a given year.
     */
    public void recordUsage(int userId, int year, int orderId, java.math.BigDecimal discountAmount, Connection conn) throws SQLException {
        String sql = "INSERT INTO birthday_discount_usage (userid, used_year, order_id, discount_amount) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, year);
            ps.setInt(3, orderId);
            ps.setBigDecimal(4, discountAmount);
            ps.executeUpdate();
        }
    }
    /**
     * Remove the birthday discount usage record for a cancelled or returned order.
     */
    public void removeUsageByOrderId(int orderId, Connection conn) throws SQLException {
        String sql = "DELETE FROM birthday_discount_usage WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        }
    }
}

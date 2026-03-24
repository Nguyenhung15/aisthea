package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Feedback;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class FeedbackDAO implements IFeedbackDAO {

    private static final Logger logger = Logger.getLogger(FeedbackDAO.class.getName());

    private static final String SELECT_BY_PRODUCT_ID = "SELECT f.*, u.fullname, u.username AS uname "
            + "FROM feedback f "
            + "LEFT JOIN users u ON f.userid = u.userid "
            + "WHERE f.productid = ? "
            + "ORDER BY f.createdat DESC";
    private static final String CHECK_PURCHASE = "SELECT TOP 1 1 FROM orders o " +
            "JOIN orderitems oi ON o.orderid = oi.orderid " +
            "JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid " +
            "WHERE o.userid = ? AND pcs.productid = ? AND o.status = 'Completed'";

    private static final String SELECT_ALL_FOR_ADMIN = "SELECT f.*, u.fullname, u.username AS uname, p.name as product_name "
            + "FROM feedback f "
            + "LEFT JOIN users u ON f.userid = u.userid "
            + "LEFT JOIN products p ON f.productid = p.productid "
            + "ORDER BY f.createdat DESC";

    @Override
    public List<Feedback> getFeedbacksByProductId(int productId) throws SQLException {
        List<Feedback> list = new ArrayList<>();
        logger.info("[FeedbackDAO] Loading feedbacks for productId=" + productId);
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_PRODUCT_ID)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback f = mapResultSetToFeedback(rs);
                    // Filter in Java code if SQL filter is not reliable
                    if (f.getStatus() == null || f.getStatus().isBlank() || f.getStatus().equalsIgnoreCase("Visible")) {
                        list.add(f);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[FeedbackDAO] SQL Error loading feedbacks for productId=" + productId, e);
            throw e;
        }
        return list;
    }

    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        ResultSetMetaData meta = rs.getMetaData();
        List<String> labels = new ArrayList<>();
        int colCount = meta.getColumnCount();
        for (int i = 1; i <= colCount; i++) {
            labels.add(meta.getColumnLabel(i).toLowerCase());
        }

        // Basic fields
        if (labels.contains("feedbackid"))
            f.setFeedbackid(rs.getInt("feedbackid"));
        if (labels.contains("userid"))
            f.setUserid(rs.getInt("userid"));
        if (labels.contains("productid"))
            f.setProductid(rs.getInt("productid"));
        if (labels.contains("rating"))
            f.setRating(rs.getInt("rating"));
        if (labels.contains("comment"))
            f.setComment(rs.getString("comment"));
        if (labels.contains("status"))
            f.setStatus(rs.getString("status"));

        // Status filter fallback (if not filtered in SQL)
        String st = f.getStatus();
        if (st != null && !st.isBlank() && !st.equalsIgnoreCase("Visible") && !st.equalsIgnoreCase("Hidden")) {
            // If it has some other status, maybe we should skip?
            // But let's follow the 'Visible' rule.
        }

        // Optional/Additional fields
        if (labels.contains("is_verified"))
            f.setVerified(rs.getBoolean("is_verified"));
        else if (labels.contains("isverified"))
            f.setVerified(rs.getBoolean("isverified"));

        if (labels.contains("image_url"))
            f.setImageUrl(rs.getString("image_url"));
        if (labels.contains("helpful_count"))
            f.setHelpfulCount(rs.getInt("helpful_count"));
        if (labels.contains("admin_reply"))
            f.setAdminReply(rs.getString("admin_reply"));
        if (labels.contains("replied_at"))
            f.setRepliedAt(rs.getTimestamp("replied_at"));
        if (labels.contains("createdat"))
            f.setCreatedat(rs.getTimestamp("createdat"));
        if (labels.contains("updatedat"))
            f.setUpdatedat(rs.getTimestamp("updatedat"));

        // Display name logic
        String displayName = null;
        if (labels.contains("fullname"))
            displayName = rs.getString("fullname");
        if (displayName == null || displayName.isBlank()) {
            if (labels.contains("uname"))
                displayName = rs.getString("uname");
            else if (labels.contains("username"))
                displayName = rs.getString("username");
        }
        if (displayName == null || displayName.isBlank()) {
            displayName = "Anonymous";
        }
        f.setUsername(displayName);

        return f;
    }

    @Override
    public boolean addFeedback(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO feedback (userid, productid, rating, comment, status, image_url, createdat) " +
                "VALUES (?, ?, ?, ?, 'Visible', ?, GETDATE())";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedback.getUserid());
            ps.setInt(2, feedback.getProductid());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());
            ps.setString(5, feedback.getImageUrl()); // null nếu không kèm ảnh

            boolean success = ps.executeUpdate() > 0;
            logger.info("[FeedbackDAO] Insert success: " + success + " for product " + feedback.getProductid());
            return success;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[FeedbackDAO] Insert FAILED: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public boolean hasUserPurchasedProduct(int userId, int productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(CHECK_PURCHASE)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Returns the feedback of userId for productId, or null if not reviewed yet.
     *  @deprecated Use getFeedbackByUserAndProductForOrder for per-order scoped checks. */
    public Feedback getFeedbackByUserAndProduct(int userId, int productId) throws SQLException {
        String sql = "SELECT f.*, u.fullname, u.username AS uname FROM feedback f " +
                "LEFT JOIN users u ON f.userid = u.userid " +
                "WHERE f.userid = ? AND f.productid = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToFeedback(rs);
            }
        }
        return null;
    }

    /**
     * Returns the feedback written by userId for productId that was created
     * ON OR AFTER the specified order's creation date.
     * This ensures Order #2 (re-purchase) doesn't show the review from Order #1.
     * Returns null if no such review exists (= eligible to write a new review).
     */
    public Feedback getFeedbackByUserAndProductForOrder(int userId, int productId, int orderId) throws SQLException {
        String sql =
            "SELECT f.*, u.fullname, u.username AS uname FROM feedback f " +
            "LEFT JOIN users u ON f.userid = u.userid " +
            "JOIN orders o ON o.orderid = ? " +
            "WHERE f.userid = ? AND f.productid = ? AND f.createdat >= o.createdat " +
            "ORDER BY f.createdat DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToFeedback(rs);
            }
        }
        return null;
    }

    /** Returns a Set of productIds that the given user has already reviewed
     *  FOR THE SPECIFIC ORDER (only feedbacks created on or after the order's creation date
     *  are counted, so a new purchase of the same product can still be reviewed). */
    public java.util.Set<Integer> getReviewedProductIdsForOrder(int userId, int orderId) throws SQLException {
        // Get the order's creation date, then find feedbacks for this user+products of this order
        // that were written on or after the order was placed.
        String sql =
            "SELECT DISTINCT f.productid FROM feedback f " +
            "JOIN orders o ON o.orderid = ? " +
            "WHERE f.userid = ? " +
            "  AND f.productid IN (" +
            "      SELECT pcs.productid FROM orderitems oi " +
            "      JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid " +
            "      WHERE oi.orderid = ?" +
            "  ) " +
            "  AND f.createdat >= o.createdat";
        java.util.Set<Integer> set = new java.util.HashSet<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ps.setInt(3, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) set.add(rs.getInt("productid"));
            }
        }
        return set;
    }

    /** @deprecated Use getReviewedProductIdsForOrder for per-order review checks. 
     *  This global check is kept for other use cases. */
    public java.util.Set<Integer> getReviewedProductIds(int userId) throws SQLException {
        String sql = "SELECT productid FROM feedback WHERE userid = ?";
        java.util.Set<Integer> set = new java.util.HashSet<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) set.add(rs.getInt("productid"));
            }
        }
        return set;
    }

    public List<Feedback> getAllFeedbacks() throws SQLException {
        List<Feedback> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ALL_FOR_ADMIN);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Feedback f = mapResultSetToFeedback(rs);
                list.add(f);
            }
        }
        return list;
    }

    public boolean updateFeedbackStatus(int feedbackId, String status) throws SQLException {
        String sql = "UPDATE feedback SET status = ?, updatedat = GETDATE() WHERE feedbackid = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, feedbackId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean replyToFeedback(int feedbackId, String reply) throws SQLException {
        String sql = "UPDATE feedback SET admin_reply = ?, replied_at = GETDATE(), updatedat = GETDATE() WHERE feedbackid = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, feedbackId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean incrementHelpfulCount(int feedbackId) throws SQLException {
        String sql = "UPDATE feedback SET helpful_count = helpful_count + 1 WHERE feedbackid = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Returns [avgRating, reviewCount] for a given product (only Visible
     * feedbacks).
     */
    public double[] getAvgRatingForProduct(int productId) throws SQLException {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) AS avg_rating, COUNT(*) AS review_count "
                + "FROM feedback WHERE productid = ? AND (status IS NULL OR status = 'Visible')";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double avg = rs.getDouble("avg_rating");
                    int count = rs.getInt("review_count");
                    return new double[] { rs.wasNull() ? 0.0 : avg, count };
                }
            }
        }
        return new double[] { 0.0, 0 };
    }

    @Override
    public List<Feedback> getFeedbacksByUserId(int userId) throws SQLException {
        String sql = "SELECT f.*, u.fullname, u.username AS uname, p.name AS product_name "
                + "FROM feedback f "
                + "LEFT JOIN users u ON f.userid = u.userid "
                + "LEFT JOIN products p ON f.productid = p.productid "
                + "WHERE f.userid = ? "
                + "ORDER BY f.createdat DESC";
        List<Feedback> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback f = mapResultSetToFeedback(rs);
                    ResultSetMetaData meta = rs.getMetaData();
                    for (int i = 1; i <= meta.getColumnCount(); i++) {
                        if ("product_name".equalsIgnoreCase(meta.getColumnLabel(i))) {
                            f.setProductName(rs.getString("product_name"));
                            break;
                        }
                    }
                    list.add(f);
                }
            }
        }
        return list;
    }

    @Override
    public boolean updateFeedback(int feedbackId, int userId, int rating, String comment) throws SQLException {
        String sql = "UPDATE feedback SET rating = ?, comment = ? WHERE feedbackid = ? AND userid = ?";
        logger.info("[FeedbackDAO.updateFeedback] feedbackId=" + feedbackId + " userId=" + userId);
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setInt(3, feedbackId);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteFeedback(int feedbackId, int userId) throws SQLException {
        String sql = "DELETE FROM feedback WHERE feedbackid = ? AND userid = ?";
        logger.info("[FeedbackDAO.deleteFeedback] feedbackId=" + feedbackId + " userId=" + userId);
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }
}

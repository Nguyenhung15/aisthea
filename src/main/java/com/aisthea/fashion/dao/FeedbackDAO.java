package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Feedback;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class FeedbackDAO implements IFeedbackDAO {

    private static final Logger logger = Logger.getLogger(FeedbackDAO.class.getName());

    private static final String SELECT_BY_PRODUCT_ID = "SELECT f.feedbackid, f.userid, f.productid, f.rating, f.comment, f.status, f.createdat, f.updatedat, "
            +
            "       u.fullname, u.username AS uname " +
            "FROM feedback f " +
            "LEFT JOIN users u ON f.userid = u.userid " +
            "WHERE f.productid = ? AND LOWER(f.status) = 'visible' " +
            "ORDER BY f.createdat DESC";
    private static final String INSERT_FEEDBACK = "INSERT INTO feedback (userid, productid, rating, comment, status, createdat, updatedat) VALUES (?, ?, ?, ?, 'Visible', GETDATE(), GETDATE())";
    private static final String CHECK_PURCHASE = "SELECT TOP 1 1 FROM orders o " +
            "JOIN orderitems oi ON o.orderid = oi.orderid " +
            "JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid " +
            "WHERE o.userid = ? AND pcs.productid = ? AND o.status = 'Completed'";

    @Override
    public List<Feedback> getFeedbacksByProductId(int productId) throws SQLException {
        List<Feedback> list = new ArrayList<>();
        logger.info("[FeedbackDAO] Loading feedbacks for productId=" + productId);
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_PRODUCT_ID)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback f = new Feedback();
                    f.setFeedbackid(rs.getInt("feedbackid"));
                    f.setUserid(rs.getInt("userid"));
                    f.setProductid(rs.getInt("productid"));
                    f.setRating(rs.getInt("rating"));
                    f.setComment(rs.getString("comment"));
                    // Ưu tiên fullname, fallback về username DB
                    String displayName = rs.getString("fullname");
                    if (displayName == null || displayName.isBlank()) {
                        displayName = rs.getString("uname");
                    }
                    if (displayName == null || displayName.isBlank()) {
                        displayName = "Anonymous";
                    }
                    f.setUsername(displayName);
                    f.setCreatedat(rs.getTimestamp("createdat"));
                    f.setUpdatedat(rs.getTimestamp("updatedat"));
                    list.add(f);
                    logger.info("[FeedbackDAO] Loaded feedback id=" + f.getFeedbackid() + " rating=" + f.getRating()
                            + " user=" + displayName);
                }
            }
            logger.info("[FeedbackDAO] Total feedbacks loaded: " + list.size());
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[FeedbackDAO] SQL Error loading feedbacks for productId=" + productId, e);
            throw e;
        }
        return list;
    }

    @Override
    public boolean addFeedback(Feedback feedback) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(INSERT_FEEDBACK)) {
            ps.setInt(1, feedback.getUserid());
            ps.setInt(2, feedback.getProductid());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());
            return ps.executeUpdate() > 0;
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
}

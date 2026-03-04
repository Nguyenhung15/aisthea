package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Feedback;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO implements IFeedbackDAO {

    private static final String SELECT_BY_PRODUCT_ID = "SELECT f.*, u.fullname FROM feedback f " +
            "JOIN users u ON f.userid = u.userid " +
            "WHERE f.productid = ? AND f.status = 'Visible' " +
            "ORDER BY f.createdat DESC";
    private static final String INSERT_FEEDBACK = "INSERT INTO feedback (userid, productid, rating, comment, status, createdat, updatedat) VALUES (?, ?, ?, ?, 'Visible', GETDATE(), GETDATE())";
    private static final String CHECK_PURCHASE = "SELECT TOP 1 1 FROM orders o " +
            "JOIN orderitems oi ON o.orderid = oi.orderid " +
            "JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid " +
            "WHERE o.userid = ? AND pcs.productid = ? AND o.status = 'Completed'";

    @Override
    public List<Feedback> getFeedbacksByProductId(int productId) throws SQLException {
        List<Feedback> list = new ArrayList<>();
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
                    f.setUsername(rs.getString("fullname"));
                    f.setCreatedat(rs.getTimestamp("createdat"));
                    f.setUpdatedat(rs.getTimestamp("updatedat"));
                    list.add(f);
                }
            }
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

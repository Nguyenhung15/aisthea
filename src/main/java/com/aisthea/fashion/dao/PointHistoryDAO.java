package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.PointHistory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PointHistoryDAO implements IPointHistoryDAO {

    private static final String INSERT_HISTORY_SQL = "INSERT INTO membership_point (userid, points_earned, reason, createdat) VALUES (?, ?, ?, GETDATE())";
    private static final String SELECT_BY_USER_ID_SQL = "SELECT * FROM membership_point WHERE userid = ? ORDER BY createdat DESC";

    @Override
    public void addPointHistory(PointHistory history) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(INSERT_HISTORY_SQL)) {
            ps.setInt(1, history.getUserId());
            ps.setInt(2, history.getPointsEarned());
            ps.setString(3, history.getReason());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<PointHistory> getPointHistoryByUserId(int userId) {
        List<PointHistory> histories = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_USER_ID_SQL)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PointHistory h = new PointHistory();
                    h.setHistoryId(rs.getInt("history_id"));
                    h.setUserId(rs.getInt("userid"));
                    h.setPointsEarned(rs.getInt("points_earned"));
                    h.setReason(rs.getString("reason"));
                    h.setCreatedAt(rs.getTimestamp("createdat"));
                    histories.add(h);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return histories;
    }
}

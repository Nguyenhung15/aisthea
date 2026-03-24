package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO implements IUserDAO {

    private static final String INSERT_USER_SQL = "INSERT INTO Users (username, password, fullname, email, gender, phone, avatar, role, active, createdat, updatedat, dob) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, GETDATE(), GETDATE(), ?)";
    private static final String SELECT_BY_ID_SQL = "SELECT * FROM Users WHERE userid = ?";
    private static final String FIND_BY_EMAIL_SQL = "SELECT * FROM Users WHERE email = ?";
    private static final String FIND_BY_USERNAME_SQL = "SELECT * FROM Users WHERE username = ?";
    private static final String SELECT_ALL_SQL = "SELECT * FROM Users ORDER BY createdat DESC";
    private static final String UPDATE_USER_SQL = "UPDATE Users SET username=?, fullname=?, email=?, gender=?, phone=?, avatar=?, role=?, active=?, dob=?, updatedat = GETDATE() WHERE userid=?";
    private static final String UPDATE_PASSWORD_SQL = "UPDATE Users SET password = ?, updatedat = GETDATE() WHERE userid = ?";
    private static final String DELETE_USER_SQL = "DELETE FROM Users WHERE userid = ?";
    private static final String ACTIVATE_USER_SQL = "UPDATE Users SET active = 1, updatedat = GETDATE() WHERE email = ? AND active = 0";
    private static final String BAN_USER_SQL = "UPDATE Users SET is_banned = 1, ban_reason = ?, updatedat = GETDATE() WHERE userid = ?";
    private static final String UNBAN_USER_SQL = "UPDATE Users SET is_banned = 0, ban_reason = NULL, updatedat = GETDATE() WHERE userid = ?";
    private static final String UPDATE_MEMBERSHIP_POINTS_SQL = "UPDATE Users SET membership_points = ISNULL(membership_points, 0) + ?, updatedat = GETDATE() WHERE userid = ?";

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("userid"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullname(rs.getString("fullname"));
        u.setEmail(rs.getString("email"));
        u.setGender(rs.getString("gender"));
        u.setPhone(rs.getString("phone"));
        u.setAvatar(rs.getString("avatar"));
        u.setRole(rs.getString("role"));
        u.setActive(rs.getBoolean("active"));
        u.setDob(rs.getDate("dob"));
        u.setMembershipPoints(rs.getInt("membership_points"));
        u.setCreatedAt(rs.getTimestamp("createdat"));
        u.setUpdatedAt(rs.getTimestamp("updatedat"));
        u.setBanned(rs.getBoolean("is_banned"));
        u.setBanReason(rs.getString("ban_reason"));
        try {
            u.setLastActive(rs.getTimestamp("last_active"));
        } catch (SQLException e) {
            /* Column might not exist in all queries */ }
        return u;
    }

    @Override
    public void insertUser(User user) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(INSERT_USER_SQL)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullname());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getGender());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getAvatar());
            ps.setString(8, user.getRole());

            if (user.getDob() != null) {
                ps.setDate(9, user.getDob());
            } else {
                ps.setNull(9, java.sql.Types.DATE);
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public User selectUser(int id) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID_SQL)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User findByEmail(String email) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(FIND_BY_EMAIL_SQL)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findByUsername(String username) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(FIND_BY_USERNAME_SQL)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ALL_SQL);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = extractUserFromResultSet(rs);
                u.setPassword(null);
                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean updateUser(User user) throws SQLException {
        boolean rowUpdated = false;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(UPDATE_USER_SQL)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getFullname());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getGender());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAvatar());
            ps.setString(7, user.getRole());
            ps.setBoolean(8, user.isActive());

            if (user.getDob() != null) {
                ps.setDate(9, user.getDob());
            } else {
                ps.setNull(9, java.sql.Types.DATE);
            }

            ps.setInt(10, user.getUserId());

            rowUpdated = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return rowUpdated;
    }

    @Override
    public boolean updatePassword(int userId, String hashedPassword) throws SQLException {
        boolean rowUpdated = false;
        try (Connection c = DBConnection.getConnection();
                PreparedStatement ps = c.prepareStatement(UPDATE_PASSWORD_SQL)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            rowUpdated = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return rowUpdated;
    }

    @Override
    public boolean deleteUser(int id) throws SQLException {
        boolean rowDeleted = false;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(DELETE_USER_SQL)) {
            ps.setInt(1, id);
            rowDeleted = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return rowDeleted;
    }

    @Override
    public boolean toggleUserStatus(int userId) throws SQLException {
        String sql = "UPDATE users SET is_banned = CASE WHEN is_banned = 1 THEN 0 ELSE 1 END, updatedat = GETDATE() WHERE userid = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public boolean banUser(int userId, String reason) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(BAN_USER_SQL)) {
            ps.setString(1, reason);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public boolean unbanUser(int userId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(UNBAN_USER_SQL)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public boolean activateUserByEmail(String email) throws SQLException {
        boolean rowUpdated = false;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(ACTIVATE_USER_SQL)) {
            ps.setString(1, email);
            rowUpdated = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return rowUpdated;
    }

    @Override
    public boolean updateMembershipPoints(int userId, int pointsToAdd) throws SQLException {
        return updateMembershipPoints(userId, pointsToAdd, "Reward Points");
    }

    @Override
    public boolean updateMembershipPoints(int userId, int pointsToAdd, String reason) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Update points in users table
            try (PreparedStatement ps = conn.prepareStatement(UPDATE_MEMBERSHIP_POINTS_SQL)) {
                ps.setInt(1, pointsToAdd);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            // 2. Add to point history table
            String insertHistorySql = "INSERT INTO membership_point (userid, points_earned, reason, createdat) VALUES (?, ?, ?, GETDATE())";
            try (PreparedStatement ps = conn.prepareStatement(insertHistorySql)) {
                ps.setInt(1, userId);
                ps.setInt(2, pointsToAdd);
                ps.setString(3, reason);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    @Override
    public void updateLastActive(int userId) {
        String sql = "UPDATE users SET last_active = GETDATE() WHERE userid = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[UserDAO] updateLastActive error: " + e.getMessage());
        }
    }

    @Override
    public boolean resetMembershipPoints(String reason) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Reset points for all users
            String resetPointsSql = "UPDATE Users SET membership_points = 0, updatedat = GETDATE()";
            try (PreparedStatement ps = conn.prepareStatement(resetPointsSql)) {
                ps.executeUpdate();
            }

            // 2. Log the reset action in membership_point for all users
            String logResetSql = "INSERT INTO membership_point (userid, points_earned, reason, createdat) " +
                    "SELECT userid, 0, ?, GETDATE() FROM Users";
            try (PreparedStatement ps = conn.prepareStatement(logResetSql)) {
                ps.setString(1, reason);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    @Override
    public int countOnlineAdmins(int secondsThreshold) {
        String sql = "SELECT COUNT(*) FROM users " +
                "WHERE (role = 'ADMIN' OR role = 'STAFF') " +
                "AND last_active >= DATEADD(second, ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, -secondsThreshold);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int c = rs.getInt(1);
                    return c;
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] countOnlineAdmins error: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public java.sql.Timestamp getLastSystemResetDate() throws SQLException {
        String sql = "SELECT MAX(createdat) FROM membership_point WHERE reason LIKE 'PERIODIC_SYSTEM_RESET%'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getTimestamp(1);
            }
        }
        return null;
    }
}

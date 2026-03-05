package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO implements IUserDAO {

    private static final String INSERT_USER_SQL = "INSERT INTO Users (username, password, fullname, email, gender, phone, avatar, address, role, active, createdat, updatedat, dob, membership_points) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0, GETDATE(), GETDATE(), ?, 0)";
    private static final String SELECT_BY_ID_SQL = "SELECT * FROM Users WHERE userid = ?";
    private static final String FIND_BY_EMAIL_SQL = "SELECT * FROM Users WHERE email = ?";
    private static final String FIND_BY_USERNAME_SQL = "SELECT * FROM Users WHERE username = ?";
    private static final String SELECT_ALL_SQL = "SELECT * FROM Users ORDER BY createdat DESC";
    private static final String UPDATE_USER_SQL = "UPDATE Users SET username=?, fullname=?, email=?, gender=?, phone=?, avatar=?, address=?, role=?, active=?, is_banned=?, dob=?, membership_points=?, ban_reason=?, updatedat = GETDATE() WHERE userid=?";
    private static final String UPDATE_PASSWORD_SQL = "UPDATE Users SET password = ?, updatedat = GETDATE() WHERE userid = ?";
    private static final String DELETE_USER_SQL = "DELETE FROM Users WHERE userid = ?";
    private static final String ACTIVATE_USER_SQL = "UPDATE Users SET active = 1, updatedat = GETDATE() WHERE email = ? AND active = 0";
    private static final String TOGGLE_USER_STATUS_SQL = "UPDATE Users SET is_banned = CASE WHEN is_banned = 1 THEN 0 ELSE 1 END, updatedat = GETDATE() WHERE userid = ?";

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
        u.setAddress(rs.getString("address"));
        u.setRole(rs.getString("role"));
        u.setActive(rs.getBoolean("active"));
        u.setBanned(rs.getBoolean("is_banned"));
        u.setDob(rs.getDate("dob"));
        u.setMembershipPoints(rs.getInt("membership_points"));
        u.setBanReason(rs.getString("ban_reason"));
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
            ps.setString(8, user.getAddress());
            ps.setString(9, user.getRole());
            ps.setDate(10, user.getDob());

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
        if (email == null)
            return null;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(FIND_BY_EMAIL_SQL)) {

            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            System.err.println("❌ Error in findByEmail (" + email + "): " + e.getMessage());
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
            ps.setString(7, user.getAddress());
            ps.setString(8, user.getRole());
            ps.setBoolean(9, user.isActive());
            ps.setBoolean(10, user.isBanned());
            ps.setDate(11, user.getDob());
            ps.setInt(12, user.getMembershipPoints());
            ps.setString(13, user.getBanReason());
            ps.setInt(14, user.getUserId());

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
    public boolean toggleUserStatus(int userId) throws SQLException {
        boolean rowUpdated = false;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(TOGGLE_USER_STATUS_SQL)) {
            ps.setInt(1, userId);
            rowUpdated = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return rowUpdated;
    }
}

package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.EmailVerification;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailVerificationDAO implements IEmailVerificationDAO {

    private static final Logger LOGGER = Logger.getLogger(EmailVerificationDAO.class.getName());
    private static final String INSERT_TOKEN
            = "INSERT INTO emailverifications (token, userid, expiresat, verified, createdat) VALUES (?, ?, ?, 0, GETDATE())";
    private static final String FIND_TOKEN
            = "SELECT * FROM emailverifications WHERE token = ?";
    private static final String MARK_VERIFIED
            = "UPDATE emailverifications SET verified = 1 WHERE token = ?";

    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }

    @Override
    public boolean saveToken(int userId, String token, LocalDateTime expiresAt) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(INSERT_TOKEN)) {

            ps.setString(1, token);
            ps.setInt(2, userId);
            ps.setTimestamp(3, Timestamp.valueOf(expiresAt));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving token", e);
            printSQLException(e);
            return false;
        }
    }

    @Override
    public EmailVerification findByToken(String token) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(FIND_TOKEN)) {

            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    EmailVerification ev = new EmailVerification();
                    ev.setToken(rs.getString("token"));
                    ev.setUserId(rs.getInt("userid"));

                    Timestamp ts = rs.getTimestamp("expiresat");
                    if (ts != null) {
                        ev.setExpiresAt(ts.toLocalDateTime());
                    }

                    ev.setVerified(rs.getBoolean("verified"));

                    Timestamp created = rs.getTimestamp("createdat");
                    if (created != null) {
                        ev.setCreatedAt(created.toLocalDateTime());
                    }

                    return ev;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding token", e);
            printSQLException(e);
        }
        return null;
    }

    @Override
    public boolean markVerified(String token) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(MARK_VERIFIED)) {

            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking token verified", e);
            printSQLException(e);
            return false;
        }
    }
}

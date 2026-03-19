package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.EmailLog;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO implementation for emaillogs table.
 * Uses try-with-resources on all connections to guarantee no leaks.
 */
public class EmailLogDAO implements IEmailLogDAO {

    private static final Logger logger = LoggerFactory.getLogger(EmailLogDAO.class);

    // ─── INSERT ──────────────────────────────────────────────────────────────

    @Override
    public boolean save(EmailLog log) {
        final String sql = """
                INSERT INTO emaillogs (userid, subject, content, sentat, status, emailtype, recipientemail)
                VALUES (?, ?, ?, GETDATE(), ?, ?, ?)
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // userid is nullable
            if (log.getUserid() == null || log.getUserid() == 0) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, log.getUserid());
            }
            ps.setString(2, log.getSubject());
            ps.setString(3, log.getContent());
            ps.setString(4, log.getStatus());
            ps.setString(5, log.getEmailtype());
            ps.setString(6, log.getRecipientemail());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.error("❌ Failed to save EmailLog for [{}]: {}", log.getRecipientemail(), e.getMessage());
            return false;
        }
    }

    // ─── SELECT ALL (paginated) ───────────────────────────────────────────────

    @Override
    public List<EmailLog> findAll(int page, int pageSize) {
        final String sql = """
                SELECT emailid, userid, subject, content, sentat, status, emailtype, recipientemail
                FROM emaillogs
                ORDER BY sentat DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        return query(sql, ps -> {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
        });
    }

    // ─── SELECT BY TYPE ───────────────────────────────────────────────────────

    @Override
    public List<EmailLog> findByType(String emailType, int page, int pageSize) {
        final String sql = """
                SELECT emailid, userid, subject, content, sentat, status, emailtype, recipientemail
                FROM emaillogs
                WHERE emailtype = ?
                ORDER BY sentat DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        return query(sql, ps -> {
            ps.setString(1, emailType);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
        });
    }

    // ─── SELECT BY STATUS ─────────────────────────────────────────────────────

    @Override
    public List<EmailLog> findByStatus(String status, int page, int pageSize) {
        final String sql = """
                SELECT emailid, userid, subject, content, sentat, status, emailtype, recipientemail
                FROM emaillogs
                WHERE status = ?
                ORDER BY sentat DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        return query(sql, ps -> {
            ps.setString(1, status);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
        });
    }

    // ─── COUNT ALL ────────────────────────────────────────────────────────────

    @Override
    public int count() {
        return countBy("SELECT COUNT(*) FROM emaillogs", null);
    }

    // ─── COUNT BY STATUS ──────────────────────────────────────────────────────

    @Override
    public int countByStatus(String status) {
        return countBy("SELECT COUNT(*) FROM emaillogs WHERE status = ?", status);
    }

    // ─── COUNT BY TYPE ────────────────────────────────────────────────────────

    public int countByType(String emailType) {
        return countBy("SELECT COUNT(*) FROM emaillogs WHERE emailtype = ?", emailType);
    }

    // ─── Private Helpers ──────────────────────────────────────────────────────

    @FunctionalInterface
    private interface StatementSetter {
        void set(PreparedStatement ps) throws SQLException;
    }

    private List<EmailLog> query(String sql, StatementSetter setter) {
        List<EmailLog> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setter.set(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            logger.error("❌ EmailLogDAO query error: {}", e.getMessage());
        }
        return list;
    }

    private int countBy(String sql, String param) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (param != null) ps.setString(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            logger.error("❌ EmailLogDAO count error: {}", e.getMessage());
            return 0;
        }
    }

    private EmailLog map(ResultSet rs) throws SQLException {
        EmailLog log = new EmailLog();
        log.setEmailid(rs.getInt("emailid"));
        int uid = rs.getInt("userid");
        log.setUserid(rs.wasNull() ? null : uid);
        log.setSubject(rs.getString("subject"));
        log.setContent(rs.getString("content"));
        log.setSentat(rs.getTimestamp("sentat"));
        log.setStatus(rs.getString("status"));
        log.setEmailtype(rs.getString("emailtype"));
        log.setRecipientemail(rs.getString("recipientemail"));
        return log;
    }
}

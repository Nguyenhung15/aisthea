package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.ChatMessage;
import com.aisthea.fashion.model.Conversation;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO for conversations + messages tables.
 * Supports AI chat, Staff handoff, and HTTP polling.
 */
public class ChatMessageDAO {

    private static final Logger logger = Logger.getLogger(ChatMessageDAO.class.getName());

    // ═══════════════════════════════════════════════════
    // CONVERSATION MANAGEMENT
    // ═══════════════════════════════════════════════════

    public int getStaffIdByUserId(int userId) {
        String sql = "SELECT staffid FROM staff WHERE userid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("staffid");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] getStaffIdByUserId error", e);
        }
        return -1;
    }

    /**
     * Find an existing OPEN conversation for a customer (AI or STAFF), or create a new AI one.
     */
    public int findOrCreateConversation(int customerId) {
        // Find any OPEN conversation (AI or STAFF)
        String findSql = "SELECT TOP 1 conversationid FROM conversations "
                + "WHERE customerid = ? AND status = 'OPEN' "
                + "ORDER BY updatedat DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("conversationid");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] findConversation error", e);
        }

        // Create new AI conversation
        String insertSql = "INSERT INTO conversations (customerid, chattype, status) "
                + "VALUES (?, 'AI', 'OPEN')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] createConversation error", e);
        }
        return -1;
    }

    public boolean handoffToStaff(int conversationId, Integer userId) {
        int staffId = (userId != null) ? getStaffIdByUserId(userId) : -1;
        String sql = "UPDATE conversations SET chattype = 'STAFF', staffid = ?, updatedat = GETDATE(), status = 'OPEN' "
                + "WHERE conversationid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (staffId > 0) {
                ps.setInt(1, staffId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setInt(2, conversationId);
            int rows = ps.executeUpdate();
            if (rows == 0) {
                System.err.println("[ChatMessageDAO] handoffToStaff: 0 rows affected for ID " + conversationId);
            }
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("[ChatMessageDAO] handoffToStaff error (staffId=" + staffId + "): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Close a conversation (set status = 'CLOSED').
     */
    public boolean closeConversation(int conversationId) {
        String sql = "UPDATE conversations SET status = 'CLOSED', updatedat = GETDATE() WHERE conversationid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] closeConversation error", e);
            return false;
        }
    }

    /**
     * Get the chattype of a conversation.
     */
    public String getChatType(int conversationId) {
        String sql = "SELECT chattype FROM conversations WHERE conversationid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("chattype");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] getChatType error", e);
        }
        return "AI";
    }
    /**
     * Get the status of a conversation.
     */
    public String getConversationStatus(int conversationId) {
        String sql = "SELECT status FROM conversations WHERE conversationid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("status");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] getConversationStatus error", e);
        }
        return "CLOSED";
    }

    /**
     * Reopen a closed conversation.
     */
    public boolean reopenConversation(int conversationId) {
        String sql = "UPDATE conversations SET status = 'OPEN', updatedat = GETDATE() WHERE conversationid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] reopenConversation error", e);
            return false;
        }
    }

    // ═══════════════════════════════════════════════════
    // MESSAGE MANAGEMENT
    // ═══════════════════════════════════════════════════

    /**
     * Save a message and return its generated messageid.
     */
    public int saveMessageReturnId(int conversationId, String sender, String content) {
        String sql = "INSERT INTO messages (conversationid, sender, content) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, conversationId);
            ps.setString(2, sender);
            ps.setNString(3, content);
            ps.executeUpdate();

            // Update conversation's updatedat
            try (PreparedStatement ps2 = conn.prepareStatement(
                    "UPDATE conversations SET updatedat = GETDATE() WHERE conversationid = ?")) {
                ps2.setInt(1, conversationId);
                ps2.executeUpdate();
            }

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] saveMessage error", e);
        }
        return -1;
    }

    /**
     * Save a message (backward compatibility).
     */
    public boolean saveMessage(int conversationId, String sender, String content) {
        return saveMessageReturnId(conversationId, sender, content) > 0;
    }

    /**
     * Get messages for a conversation (ordered oldest first).
     */
    public List<ChatMessage> getMessagesByConversation(int conversationId) {
        String sql = "SELECT messageid, conversationid, sender, content, createdat "
                + "FROM messages WHERE conversationid = ? ORDER BY createdat ASC";
        List<ChatMessage> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMessage(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] getMessagesByConversation error", e);
        }
        return list;
    }

    /**
     * Get NEW messages after a given messageId (for polling).
     */
    public List<ChatMessage> getNewMessages(int conversationId, int afterMessageId) {
        String sql = "SELECT messageid, conversationid, sender, content, createdat "
                + "FROM messages WHERE conversationid = ? AND messageid > ? ORDER BY createdat ASC";
        List<ChatMessage> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            ps.setInt(2, afterMessageId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMessage(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] getNewMessages error", e);
        }
        return list;
    }

    /**
     * Get the most recent messages for a customer's OPEN conversation (last 50).
     */
    public List<ChatMessage> getRecentMessages(int customerId) {
        int convoId = findOrCreateConversation(customerId);
        if (convoId <= 0) return new ArrayList<>();
        String sql = "SELECT TOP 50 messageid, conversationid, sender, content, createdat "
                + "FROM messages WHERE conversationid = ? ORDER BY createdat DESC";
        List<ChatMessage> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, convoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMessage(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] getRecentMessages error", e);
        }
        java.util.Collections.reverse(list);
        return list;
    }

    // ═══════════════════════════════════════════════════
    // ADMIN VIEWS
    // ═══════════════════════════════════════════════════

    /**
     * Admin: Get all conversations with customer info, message count, and last message.
     */
    public List<Conversation> getAllConversations() {
        String sql = "SELECT c.conversationid, c.customerid, c.chattype, c.status, "
                + "c.createdat, c.updatedat, c.staffid, "
                + "u.fullname, u.username, u.avatar, "
                + "(SELECT COUNT(*) FROM messages WHERE conversationid = c.conversationid) as msg_count, "
                + "(SELECT TOP 1 content FROM messages WHERE conversationid = c.conversationid ORDER BY createdat DESC) as last_message "
                + "FROM conversations c "
                + "JOIN users u ON c.customerid = u.userid "
                + "ORDER BY c.updatedat DESC";
        List<Conversation> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Conversation conv = new Conversation();
                conv.setConversationId(rs.getInt("conversationid"));
                conv.setCustomerId(rs.getInt("customerid"));
                conv.setChatType(rs.getString("chattype"));
                conv.setStatus(rs.getString("status"));
                conv.setCreatedAt(rs.getTimestamp("createdat"));
                conv.setUpdatedAt(rs.getTimestamp("updatedat"));
                int staffId = rs.getInt("staffid");
                conv.setStaffId(rs.wasNull() ? null : staffId);
                conv.setCustomerName(rs.getString("fullname"));
                conv.setCustomerUsername(rs.getString("username"));
                conv.setCustomerAvatar(rs.getString("avatar"));
                conv.setMessageCount(rs.getInt("msg_count"));
                conv.setLastMessage(rs.getNString("last_message"));
                list.add(conv);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] getAllConversations error", e);
        }
        return list;
    }

    public List<ChatMessage> getMessagesForAdmin(int conversationId) {
        return getMessagesByConversation(conversationId);
    }

    /**
     * Get conversation by ID.
     */
    public Conversation getConversationById(int conversationId) {
        String sql = "SELECT c.*, u.fullname, u.username FROM conversations c "
                + "JOIN users u ON c.customerid = u.userid "
                + "WHERE c.conversationid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Conversation conv = new Conversation();
                    conv.setConversationId(rs.getInt("conversationid"));
                    conv.setCustomerId(rs.getInt("customerid"));
                    conv.setChatType(rs.getString("chattype"));
                    conv.setStatus(rs.getString("status"));
                    conv.setCreatedAt(rs.getTimestamp("createdat"));
                    conv.setUpdatedAt(rs.getTimestamp("updatedat"));
                    conv.setCustomerName(rs.getString("fullname"));
                    conv.setCustomerUsername(rs.getString("username"));
                    return conv;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "[ChatMessageDAO] getConversationById error", e);
        }
        return null;
    }

    // ═══════════════════════════════════════════════════
    // HELPER
    // ═══════════════════════════════════════════════════

    private ChatMessage mapMessage(ResultSet rs) throws SQLException {
        ChatMessage m = new ChatMessage();
        m.setMessageId(rs.getInt("messageid"));
        m.setConversationId(rs.getInt("conversationid"));
        m.setSender(rs.getString("sender"));
        m.setContent(rs.getNString("content"));
        m.setCreatedAt(rs.getTimestamp("createdat"));
        return m;
    }
}

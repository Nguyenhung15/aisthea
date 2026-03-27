package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.ChatMessageDAO;
import com.aisthea.fashion.model.ChatMessage;
import com.aisthea.fashion.model.Conversation;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.GeminiService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Chat Servlet with Staff Handoff + HTTP Polling.
 *
 * POST /chat — customer sends message (AI auto-reply or staff mode)
 * POST /chat?action=staffReply — admin/staff sends reply to customer
 * POST /chat?action=handoff — customer requests staff handoff
 * POST /chat?action=close — close conversation
 * GET /chat?action=history — customer: load current conversation
 * GET /chat?action=poll&convoId=X&after=Y — poll new messages (both sides)
 * GET /chat?action=conversations — admin: list all conversations
 * GET /chat?action=admin&convoId=X — admin: view conversation messages
 * GET /chat?action=manage — admin: forward to manage_chats.jsp
 * GET /chat?action=status — customer: get current conversation status
 */
@WebServlet(name = "ChatServlet", urlPatterns = { "/chat" })
public class ChatServlet extends HttpServlet {

    private GeminiService geminiService;
    private ChatMessageDAO chatMessageDAO;
    private com.aisthea.fashion.dao.ProductDAO productDAO;
    private com.aisthea.fashion.dao.UserDAO userDAO;
    private Gson gson;

    private static final List<String> serverLogs = Collections.synchronizedList(new ArrayList<>());
    private static final Map<Integer, Long> adminActivity = new ConcurrentHashMap<>();
    private static final java.text.SimpleDateFormat ISO_FORMAT = new java.text.SimpleDateFormat(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    private static void logTrace(String msg) {
        String logLine = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date()) + " - " + msg;
        serverLogs.add(logLine);
        if (serverLogs.size() > 100)
            serverLogs.remove(0);
        System.out.println(logLine);
    }

    @Override
    public void init() throws ServletException {
        try {
            this.gson           = new Gson();
            this.geminiService    = new GeminiService(); // Now auto-configures from application.properties
            this.chatMessageDAO   = new ChatMessageDAO();
            this.productDAO       = new com.aisthea.fashion.dao.ProductDAO();
            this.userDAO          = new com.aisthea.fashion.dao.UserDAO();
            
            ISO_FORMAT.setTimeZone(java.util.TimeZone.getTimeZone("UTC"));
            System.out.println("[ChatServlet] Initialization SUCCESSFUL (AI auto-config).");
        } catch (Throwable t) {
            System.err.println("[ChatServlet] CRITICAL ERROR in init(): " + t.getMessage());
            t.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = null;
        try {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            out = response.getWriter();

            String action = request.getParameter("action");
            if (action == null)
                action = "";

            // Track admin/staff activity
            User currentUser = (User) request.getSession().getAttribute("user");
            if (currentUser != null && userDAO != null) {
                String role = (currentUser.getRole() != null) ? currentUser.getRole().trim() : "";
                if ("ADMIN".equalsIgnoreCase(role) || "STAFF".equalsIgnoreCase(role)) {
                    logTrace("Tracking active admin: " + currentUser.getUserId() + " (" + role + ")");
                    adminActivity.put(currentUser.getUserId(), System.currentTimeMillis());
                    userDAO.updateLastActive(currentUser.getUserId());
                }
            }

            switch (action) {
                case "history": {
                    User user = (User) request.getSession().getAttribute("user");
                    if (user == null) {
                        response.setStatus(401);
                        out.print(gson.toJson(safeMap("error", "Login required")));
                        return;
                    }
                    int convoId = chatMessageDAO.findOrCreateConversation(user.getUserId());
                    String chatType = chatMessageDAO.getChatType(convoId);
                    String convoStatus = chatMessageDAO.getConversationStatus(convoId);
                    List<ChatMessage> messages = chatMessageDAO.getRecentMessages(user.getUserId());
                    List<Map<String, Object>> result = new ArrayList<>();
                    for (ChatMessage m : messages) {
                        String role = "CUSTOMER".equals(m.getSender()) ? "user" : "model";
                        result.add(safeMap(
                                "id", m.getMessageId(),
                                "role", role,
                                "sender", m.getSender(),
                                "text", m.getContent(),
                                "time", m.getCreatedAt() != null ? ISO_FORMAT.format(m.getCreatedAt()) : ""));
                    }
                    out.print(gson.toJson(safeMap(
                            "messages", result,
                            "convoId", convoId,
                            "chatType", chatType,
                            "status", convoStatus)));
                    break;
                }
                case "status": {
                    User user = (User) request.getSession().getAttribute("user");
                    if (user == null) {
                        response.setStatus(401);
                        out.print(gson.toJson(safeMap("error", "Login required")));
                        return;
                    }
                    int convoId = chatMessageDAO.findOrCreateConversation(user.getUserId());
                    String chatType = chatMessageDAO.getChatType(convoId);
                    out.print(gson.toJson(safeMap("convoId", convoId, "chatType", chatType)));
                    break;
                }
                case "poll": {
                    String convoIdParam = request.getParameter("convoId");
                    String afterParam = request.getParameter("after");
                    if (convoIdParam == null || afterParam == null) {
                        response.setStatus(400);
                        out.print(gson.toJson(safeMap("error", "convoId and after required")));
                        return;
                    }
                    int convoId = Integer.parseInt(convoIdParam);
                    int afterId = Integer.parseInt(afterParam);
                    String chatType = chatMessageDAO.getChatType(convoId);
                    List<ChatMessage> newMsgs = chatMessageDAO.getNewMessages(convoId, afterId);
                    List<Map<String, Object>> result = new ArrayList<>();
                    for (ChatMessage m : newMsgs) {
                        result.add(safeMap(
                                "id", m.getMessageId(),
                                "sender", m.getSender(),
                                "text", m.getContent(),
                                "time", m.getCreatedAt() != null ? ISO_FORMAT.format(m.getCreatedAt()) : ""));
                    }
                    out.print(gson.toJson(safeMap("messages", result, "chatType", chatType)));
                    break;
                }
                case "conversations": {
                    User user = (User) request.getSession().getAttribute("user");
                    if (user == null || !isAdminOrStaff(user)) {
                        response.setStatus(403);
                        out.print(gson.toJson(safeMap("error", "Admin access required")));
                        return;
                    }
                    List<Conversation> convos = chatMessageDAO.getAllConversations();
                    List<Map<String, Object>> result = new ArrayList<>();
                    for (Conversation c : convos) {
                        result.add(safeMap(
                                "convoId", c.getConversationId(),
                                "customerId", c.getCustomerId(),
                                "fullname", c.getCustomerName() != null ? c.getCustomerName() : "",
                                "username", c.getCustomerUsername() != null ? c.getCustomerUsername() : "",
                                "avatar", c.getCustomerAvatar() != null ? c.getCustomerAvatar() : "",
                                "chatType", c.getChatType() != null ? c.getChatType() : "AI",
                                "status", c.getStatus() != null ? c.getStatus() : "OPEN",
                                "msgCount", c.getMessageCount(),
                                "lastMessage", c.getLastMessage() != null ? c.getLastMessage() : "",
                                "lastActive", c.getUpdatedAt() != null ? ISO_FORMAT.format(c.getUpdatedAt()) : ""));
                    }
                    out.print(gson.toJson(safeMap(
                            "conversations", result, 
                            "onlineCount", adminActivity.size(),
                            "serverTime", System.currentTimeMillis()
                    )));
                    break;
                }
                case "admin": {
                    User user = (User) request.getSession().getAttribute("user");
                    if (user == null || !isAdminOrStaff(user)) {
                        response.setStatus(403);
                        out.print(gson.toJson(safeMap("error", "Admin access required")));
                        return;
                    }
                    String convoIdParam = request.getParameter("convoId");
                    if (convoIdParam == null) {
                        response.setStatus(400);
                        out.print(gson.toJson(safeMap("error", "convoId required")));
                        return;
                    }
                    int convoId = Integer.parseInt(convoIdParam);
                    Conversation conv = chatMessageDAO.getConversationById(convoId);
                    List<ChatMessage> messages = chatMessageDAO.getMessagesForAdmin(convoId);
                    List<Map<String, Object>> result = new ArrayList<>();
                    for (ChatMessage m : messages) {
                        result.add(safeMap(
                                "id", m.getMessageId(),
                                "sender", m.getSender(),
                                "text", m.getContent(),
                                "time", m.getCreatedAt() != null ? ISO_FORMAT.format(m.getCreatedAt()) : ""));
                    }
                    out.print(gson.toJson(safeMap(
                            "messages", result,
                            "customerName",
                            conv != null && conv.getCustomerName() != null ? conv.getCustomerName() : "",
                            "status", conv != null && conv.getStatus() != null ? conv.getStatus() : "",
                            "chatType", conv != null && conv.getChatType() != null ? conv.getChatType() : "")));
                    break;
                }
                case "manage": {
                    User user = (User) request.getSession().getAttribute("user");
                    if (user == null || !isAdminOrStaff(user)) {
                        response.sendRedirect(request.getContextPath() + "/login");
                        return;
                    }
                    response.setContentType("text/html; charset=UTF-8");
                    request.getRequestDispatcher("/WEB-INF/views/admin/chat/manage_chats.jsp")
                            .forward(request, response);
                    break;
                }
                case "online": {
                    out.print(gson.toJson(adminActivity));
                    break;
                }
                case "log": {
                    out.print(gson.toJson(serverLogs));
                    break;
                }
                default: {
                    response.setStatus(400);
                    out.print(gson.toJson(safeMap("error", "Invalid action")));
                }
            }
        } catch (Throwable t) {
            handleGenericError(t, response, out);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = null;
        try {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            out = response.getWriter();

            String action = request.getParameter("action");
            if (action == null)
                action = "";

            // Track admin/staff activity
            User currentUser = (User) request.getSession().getAttribute("user");
            if (currentUser != null) {
                String role = (currentUser.getRole() != null) ? currentUser.getRole().trim() : "";
                if ("ADMIN".equalsIgnoreCase(role) || "STAFF".equalsIgnoreCase(role)) {
                    System.out.println("[ChatServlet] Tracking active admin (POST): " + currentUser.getUserId());
                    adminActivity.put(currentUser.getUserId(), System.currentTimeMillis());
                    userDAO.updateLastActive(currentUser.getUserId());
                }
            }

            switch (action) {
                case "staffReply": {
                    handleStaffReply(request, response, out);
                    return;
                }
                case "handoff": {
                    handleHandoff(request, response, out);
                    return;
                }
                case "close": {
                    handleClose(request, response, out);
                    return;
                }
                default: {
                    handleCustomerMessage(request, response, out);
                }
            }
        } catch (Throwable t) {
            handleGenericError(t, response, out);
        }
    }

    /**
     * Customer sends a message. If AI mode → auto-reply. If STAFF mode → just save.
     */
    private void handleCustomerMessage(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setStatus(401);
            out.print(gson.toJson(safeMap("error", "Bạn cần đăng nhập để sử dụng chat.")));
            return;
        }

        try {
            Map<String, Object> requestData = parseBody(request);
            String userMessage = (String) requestData.get("message");

            if (userMessage == null || userMessage.isBlank()) {
                response.setStatus(400);
                out.print(gson.toJson(safeMap("error", "Message is required")));
                return;
            }

            int conversationId = chatMessageDAO.findOrCreateConversation(user.getUserId());
            if (conversationId <= 0) {
                response.setStatus(500);
                out.print(gson.toJson(safeMap("error", "Không thể tạo cuộc hội thoại.")));
                return;
            }

            // Check chat type and status
            String chatType = chatMessageDAO.getChatType(conversationId);
            String status = chatMessageDAO.getConversationStatus(conversationId);
            System.out.println("[ChatServlet] Msg from User " + user.getUserId() + " in Convo " + conversationId
                    + " - Initial Mode: " + chatType + ", Status: " + status);

            if (!"OPEN".equalsIgnoreCase(status)) {
                chatMessageDAO.reopenConversation(conversationId);
                status = "OPEN";
                // After reopen, re-fetch mode just in case
                chatType = chatMessageDAO.getChatType(conversationId);
                System.out.println("[ChatServlet] Reopened convo " + conversationId + ". Mode is now: " + chatType);
            }

            // Save customer message
            int msgId = chatMessageDAO.saveMessageReturnId(conversationId, "CUSTOMER", userMessage);

            if (chatType != null && "AI".equalsIgnoreCase(chatType.trim())) {
                System.out.println("[ChatServlet] AI Mode confirmed. Calling Gemini...");
                // AI mode: call Gemini and auto-reply
                System.out.println("[ChatServlet] AI Mode active. Preparing Gemini call...");
                @SuppressWarnings("unchecked")
                List<Map<String, String>> history = (List<Map<String, String>>) requestData.get("history");

                // Fetch full inventory summary for context
                String productContext = "";
                try {
                    productContext = productDAO.getInventorySummary();
                } catch (Exception e) {
                    System.err.println("[ChatServlet] Could not fetch products for context: " + e.getMessage());
                }

                System.out.println("[ChatServlet] Calling Gemini for: " + userMessage);
                String reply = geminiService.chat(userMessage, history, productContext);
                System.out.println("[ChatServlet] Gemini replied: "
                        + (reply != null ? reply.substring(0, Math.min(reply.length(), 30)) + "..." : "NULL"));

                int replyId = chatMessageDAO.saveMessageReturnId(conversationId, "AI", reply);
                out.print(gson.toJson(safeMap(
                        "reply", reply,
                        "msgId", msgId,
                        "replyId", replyId,
                        "chatType", "AI",
                        "convoId", conversationId)));
            } else if (chatType != null && "STAFF".equalsIgnoreCase(chatType.trim())) {
                // STAFF mode: just save customer message, staff will reply via polling
                out.print(gson.toJson(safeMap(
                        "reply", "",
                        "msgId", msgId,
                        "chatType", "STAFF",
                        "convoId", conversationId,
                        "waiting", true)));
            } else {
                // Fallback
                out.print(gson.toJson(safeMap("reply", "", "msgId", msgId, "chattype", chatType)));
            }

        } catch (Throwable t) {
            handleGenericError(t, response, out);
        }
    }

    /**
     * Admin/Staff sends a reply to a customer.
     */
    private void handleStaffReply(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !isAdminOrStaff(user)) {
            response.setStatus(403);
            out.print(gson.toJson(safeMap("error", "Admin access required")));
            return;
        }

        try {
            Map<String, Object> requestData = parseBody(request);
            String convoIdStr = (String) requestData.get("convoId");
            String message = (String) requestData.get("message");

            if (convoIdStr == null || message == null || message.isBlank()) {
                response.setStatus(400);
                out.print(gson.toJson(safeMap("error", "convoId and message required")));
                return;
            }

            int convoId = Integer.parseInt(convoIdStr);
            int msgId = chatMessageDAO.saveMessageReturnId(convoId, "STAFF", message);

            // Also ensure conversation is in STAFF mode
            chatMessageDAO.handoffToStaff(convoId, null);

            out.print(gson.toJson(safeMap("success", true, "msgId", msgId)));

        } catch (Throwable t) {
            handleGenericError(t, response, out);
        }
    }

    /**
     * Customer requests to talk to a human staff member.
     */
    private void handleHandoff(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setStatus(401);
            out.print(gson.toJson(safeMap("error", "Login required")));
            return;
        }

        int convoId = chatMessageDAO.findOrCreateConversation(user.getUserId());
        String dbCT = chatMessageDAO.getChatType(convoId);
        String dbST = chatMessageDAO.getConversationStatus(convoId);
        logTrace("handleHandoff start. UserID=" + user.getUserId() + ", convoId=" + convoId + " (Current DB: " + dbCT
                + "/" + dbST + ")");

        // In-memory online check for admins (within 5 minutes)
        long currentTime = System.currentTimeMillis();
        int onlineCount = 0;
        List<Integer> activeAdminIds = new ArrayList<>();
        
        // Refresh currentUser info from DB to ensure role is up to date
        if (userDAO != null) {
            User freshUser = userDAO.selectUser(user.getUserId());
            if (freshUser != null) {
                user.setRole(freshUser.getRole());
                request.getSession().setAttribute("user", user);
            }
        }

        logTrace("handleHandoff online check. adminActivitySize=" + adminActivity.size());
        for (Map.Entry<Integer, Long> entry : adminActivity.entrySet()) {
            long diff = currentTime - entry.getValue();
            if (diff <= 300000) { // Keep online for 5 minutes of inactivity
                onlineCount++;
                activeAdminIds.add(entry.getKey());
                logTrace("Admin " + entry.getKey() + " is ONLINE (diff: " + diff + "ms)");
            }
        }

        // Fallback: check DB if memory map is empty
        if (onlineCount == 0 && userDAO != null) {
            onlineCount = userDAO.countOnlineAdmins(300);
            logTrace("Fallback to DB check: onlineCount=" + onlineCount);
        }

        // DEBUG: If still zero, we might want to force it for testing, 
        // but let's stick to showing a clear error first.
        if (onlineCount <= 0) {
            String msg = "Hiện tại các nhân viên hỗ trợ của AISTHÉA đều đang không trực (hoặc chưa hoạt động trong 5 phút qua). AI sẽ tiếp tục hỗ trợ bạn nhé! 🙏";
            int msgId = chatMessageDAO.saveMessageReturnId(convoId, "AI", msg);
            out.print(gson.toJson(safeMap("success", false, "error", "STAFF_OFFLINE", "chatType", "AI", "systemMsg",
                    msg, "msgId", msgId, "debugOnline", activeAdminIds, "adminActivityCount", adminActivity.size())));
            return;
        }

        Integer assignedStaffId = activeAdminIds.isEmpty() ? null : activeAdminIds.get(0);
        boolean success = chatMessageDAO.handoffToStaff(convoId, assignedStaffId);
        logTrace("handleHandoff DB handoff result: " + success + " (Assigned staff: " + assignedStaffId + ")");

        if (success) {
            // Gửi thông báo cho tất cả Admin/Staff khi có yêu cầu hỗ trợ chat mới
            try {
                com.aisthea.fashion.dao.NotificationDAO notifDao = new com.aisthea.fashion.dao.NotificationDAO();
                try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement("SELECT userid FROM Users WHERE UPPER(role) IN ('ADMIN', 'STAFF')");
                     java.sql.ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        com.aisthea.fashion.model.Notification n = new com.aisthea.fashion.model.Notification();
                        n.setUserId(rs.getInt("userid"));
                        n.setTitle("Yêu cầu hỗ trợ chat");
                        n.setContent("Khách hàng " + (user.getFullname() != null ? user.getFullname() : user.getUsername()) + " cần hỗ trợ trực tuyến.");
                        n.setType("CHAT");
                        n.setTargetId(convoId);
                        n.setRead(false);
                        notifDao.addNotification(n);
                    }
                }
            } catch (Exception e) {
                logTrace("Lỗi gửi thông báo chat: " + e.getMessage());
            }

            String msg = "Cuộc trò chuyện đã được chuyển cho nhân viên hỗ trợ. Vui lòng đợi trong giây lát, nhân viên sẽ phản hồi sớm nhất có thể! 🧑‍💼";
            int msgId = chatMessageDAO.saveMessageReturnId(convoId, "AI", msg);
            out.print(gson.toJson(safeMap("success", true, "chatType", "STAFF", "systemMsg", msg, "msgId", msgId,
                    "debugOnline", activeAdminIds)));
        } else {
            out.print(gson.toJson(safeMap("success", false, "error", "Handoff failed", "debugOnline", activeAdminIds)));
        }
    }

    /**
     * Close (pause) a conversation — Messenger-style: just mark as CLOSED, no goodbye message.
     * The same conversation will be reopened when the customer chats again.
     */
    private void handleClose(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setStatus(401);
            out.print(gson.toJson(safeMap("error", "Login required")));
            return;
        }

        try {
            Map<String, Object> requestData = parseBody(request);
            String convoIdStr = (String) requestData.get("convoId");
            int convoId;
            if (convoIdStr != null) {
                convoId = Integer.parseInt(convoIdStr);
            } else {
                convoId = chatMessageDAO.findOrCreateConversation(user.getUserId());
            }

            boolean success = chatMessageDAO.closeConversation(convoId);
            
            // Mark corresponding CHAT system notifications as read so they disappear from Dashboard
            if (success) {
                try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement(
                         "UPDATE Notifications SET is_read = 1 WHERE UPPER(type) IN ('CHAT', 'SUPPORT') AND target_id = ?")) {
                    ps.setInt(1, convoId);
                    ps.executeUpdate();
                } catch (Exception e) {
                    logTrace("Failed to mark chat notification as read on close: " + e.getMessage());
                }
            }

            // Messenger-style: no goodbye message — conversation will be reused
            out.print(gson.toJson(safeMap("success", success, "status", "CLOSED")));
        } catch (Throwable t) {
            handleGenericError(t, response, out);
        }
    }

    // ═══════════════════════════════════════════════════
    // HELPERS
    // ═══════════════════════════════════════════════════

    private Map<String, Object> parseBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;
        var reader = request.getReader();
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        return gson.fromJson(sb.toString(), new TypeToken<Map<String, Object>>() {
        }.getType());
    }

    private boolean isAdminOrStaff(User user) {
        if (user == null || user.getRole() == null)
            return false;
        String role = user.getRole().trim();
        return "ADMIN".equalsIgnoreCase(role) || "STAFF".equalsIgnoreCase(role);
    }

    private Map<String, Object> safeMap(Object... entries) {
        Map<String, Object> map = new java.util.HashMap<>();
        for (int i = 0; i < entries.length; i += 2) {
            String key = (String) entries[i];
            Object val = entries[i + 1];
            map.put(key, val == null ? "" : val);
        }
        return map;
    }

    private void handleGenericError(Throwable t, HttpServletResponse response, PrintWriter out) {
        System.err.println("[ChatServlet] ERROR: " + t.getMessage());
        t.printStackTrace();
        try {
            if (response.isCommitted())
                return;
            response.setStatus(500);
            if (out == null)
                out = response.getWriter();

            java.io.StringWriter sw = new java.io.StringWriter();
            t.printStackTrace(new java.io.PrintWriter(sw));
            String stackTrace = sw.toString().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");

            Map<String, String> errorMap = new java.util.HashMap<>();
            errorMap.put("error", "Lỗi hệ thống: " + (t.getMessage() != null ? t.getMessage() : "Unknown"));
            errorMap.put("stack", stackTrace);
            out.print(gson.toJson(errorMap));
            out.flush();
        } catch (Exception ex) {
            System.err.println("[ChatServlet] FATAL: Error handler failed!");
            ex.printStackTrace();
        }
    }
}

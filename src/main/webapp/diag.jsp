<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    List<Map<String, Object>> list = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT conversationid, chattype, status, updatedat FROM conversations WHERE conversationid >= 25 ORDER BY conversationid DESC");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("convoId", rs.getInt("conversationid"));
            map.put("chatType", rs.getString("chattype"));
            map.put("status", rs.getString("status"));
            map.put("updatedAt", rs.getTimestamp("updatedat") != null ? rs.getTimestamp("updatedat").getTime() : null);
            list.add(map);
        }
    } catch (Exception e) {}
    out.print(new com.google.gson.Gson().toJson(list));
%>

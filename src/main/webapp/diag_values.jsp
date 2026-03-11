<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    List<Map<String, Object>> list = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT conversationid, chattype, status FROM conversations ORDER BY conversationid DESC");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("conversationid"));
            String ct = rs.getString("chattype");
            String st = rs.getString("status");
            map.put("ct", ct != null ? ct : "NULL");
            map.put("st", st != null ? st : "NULL");
            map.put("ct_trimmed", ct != null ? ct.trim() : "NULL");
            map.put("st_trimmed", st != null ? st.trim() : "NULL");
            list.add(map);
        }
    } catch (Exception e) {
        Map<String, Object> err = new HashMap<>();
        err.put("error", e.getMessage());
        list.add(err);
    }
    out.print(new com.google.gson.Gson().toJson(list));
%>

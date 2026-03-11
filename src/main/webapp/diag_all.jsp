<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    List<Map<String, Object>> list = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT conversationid, customerid, chattype, status FROM conversations ORDER BY conversationid DESC");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("convoId", rs.getInt("conversationid"));
            map.put("custId", rs.getInt("customerid"));
            map.put("ct", rs.getString("chattype"));
            map.put("st", rs.getString("status"));
            list.add(map);
        }
    } catch (Exception e) {}
    out.print(new com.google.gson.Gson().toJson(list));
%>

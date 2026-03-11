<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    Map<String, Object> result = new HashMap<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT COLUMN_NAME, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'conversations'");
         ResultSet rs = ps.executeQuery()) {
        List<Map<String, Object>> defaults = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("name", rs.getString("COLUMN_NAME"));
            map.put("default", rs.getString("COLUMN_DEFAULT"));
            defaults.add(map);
        }
        result.put("defaults", defaults);
    } catch (Exception e) {}
    out.print(new com.google.gson.Gson().toJson(result));
%>

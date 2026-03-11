<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    List<Map<String, Object>> list = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT s.staffid, s.userid, u.username FROM staff s JOIN users u ON s.userid = u.userid")) {
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("staffId", rs.getInt("staffid"));
            map.put("userId", rs.getInt("userid"));
            map.put("username", rs.getString("username"));
            list.add(map);
        }
    } catch (Exception e) {}
    out.print(new com.google.gson.Gson().toJson(list));
%>

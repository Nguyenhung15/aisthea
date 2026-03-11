<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    List<String> roles = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT role FROM users");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) roles.add(rs.getString("role"));
    } catch (Exception e) {}
    out.print(new com.google.gson.Gson().toJson(roles));
%>

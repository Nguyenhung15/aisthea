<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.sql.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT userid, username, role FROM users WHERE userid = 14")) {
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            out.println("USER 14: " + rs.getString("username") + " ROLE: " + rs.getString("role"));
        } else {
            out.println("USER 14 NOT FOUND");
        }
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    }
%>

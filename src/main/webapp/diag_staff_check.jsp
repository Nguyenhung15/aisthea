<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.sql.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    int userId = 14;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT staffid FROM staff WHERE userid = ?")) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            out.println("STAFF_ID_FOR_USER_14: " + rs.getInt("staffid"));
        } else {
            out.println("USER_14_NOT_IN_STAFF_TABLE");
        }
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    }
%>

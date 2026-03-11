<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.sql.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    int targetId = 37;
    int adminId = 14;
    try (Connection conn = DBConnection.getConnection()) {
        out.println("Trying Update with STAFFID=14...");
        try (PreparedStatement ps = conn.prepareStatement("UPDATE conversations SET chattype = 'STAFF', staffid = ?, updatedat = GETDATE() WHERE conversationid = ?")) {
            ps.setInt(1, adminId);
            ps.setInt(2, targetId);
            int rows = ps.executeUpdate();
            out.println("Result (With StaffID): " + rows + " rows affected");
        } catch (Exception e) {
            out.println("Error (With StaffID): " + e.getMessage());
        }
    } catch (Exception e) {
        out.println("CONN_ERR: " + e.getMessage());
    }
%>

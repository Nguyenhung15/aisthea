<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.sql.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    int targetId = 37;
    try (Connection conn = DBConnection.getConnection()) {
        DatabaseMetaData md = conn.getMetaData();
        out.println("DB Product: " + md.getDatabaseProductName());
        out.println("DB Version: " + md.getDatabaseProductVersion());
        
        // Try update with double quotes (SQL Standard)
        out.println("Trying Update with quotes...");
        try (PreparedStatement ps = conn.prepareStatement("UPDATE \"conversations\" SET \"chattype\" = 'STAFF' WHERE \"conversationid\" = ?")) {
            ps.setInt(1, targetId);
            int rows = ps.executeUpdate();
            out.println("Result (Quotes): " + rows);
        } catch (Exception e) {
            out.println("Error (Quotes): " + e.getMessage());
        }

        // Try update with square brackets (SQL Server specific)
        out.println("Trying Update with brackets...");
        try (PreparedStatement ps = conn.prepareStatement("UPDATE [conversations] SET [chattype] = 'STAFF' WHERE [conversationid] = ?")) {
            ps.setInt(1, targetId);
            int rows = ps.executeUpdate();
            out.println("Result (Brackets): " + rows);
        } catch (Exception e) {
            out.println("Error (Brackets): " + e.getMessage());
        }

    } catch (Exception e) {
        out.println("CONN_ERR: " + e.getMessage());
    }
%>

<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.sql.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    int userId = 14;
    try (Connection conn = DBConnection.getConnection()) {
        // Step 1: Insert into staff table
        String sql = "INSERT INTO staff (userid, staffcode, position, workstatus, salary, hiredate, createdat, updatedat) "
                   + "VALUES (?, 'ADM01', 'Administrator', 'ACTIVE', 0, CAST(GETDATE() AS DATE), GETDATE(), GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        out.println("SUCCESS: User 14 added to STAFF table with STAFFID=" + rs.getInt(1));
                    }
                }
            } else {
                out.println("FAILED: No rows affected.");
            }
        } catch (SQLException e) {
            out.println("SQL_ERROR: " + e.getMessage());
            // If column list is too complex, try minimal insert
            out.println("Retrying minimal insert...");
            try (PreparedStatement ps2 = conn.prepareStatement("INSERT INTO staff (userid, staffcode) VALUES (?, 'ADM01')")) {
                ps2.setInt(1, userId);
                ps2.executeUpdate();
                out.println("MINIMAL_SUCCESS");
            } catch (Exception e2) {
                out.println("MINIMAL_FAILED: " + e2.getMessage());
            }
        }
    } catch (Exception e) {
        out.println("CONN_ERROR: " + e.getMessage());
    }
%>

<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    Map<String, Object> debug = new HashMap<>();
    try (Connection conn = DBConnection.getConnection()) {
        DatabaseMetaData md = conn.getMetaData();
        // Get Check Constraints for SQL Server
        String sql = "SELECT name, definition FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('conversations')";
        List<Map<String, String>> constraints = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> c = new HashMap<>();
                c.put("name", rs.getString("name"));
                c.put("definition", rs.getString("definition"));
                constraints.add(c);
            }
        }
        debug.put("constraints", constraints);
    } catch (Exception e) {
        debug.put("error", e.getMessage());
    }
    out.print(new com.google.gson.Gson().toJson(debug));
%>

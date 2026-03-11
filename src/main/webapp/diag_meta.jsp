<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    String tableName = request.getParameter("table");
    if (tableName == null) tableName = "conversations";
    Map<String, Object> debug = new HashMap<>();
    try (Connection conn = DBConnection.getConnection()) {
        DatabaseMetaData md = conn.getMetaData();
        ResultSet rs = md.getColumns(null, null, tableName, null);
        List<Map<String, String>> cols = new ArrayList<>();
        while (rs.next()) {
            Map<String, String> c = new HashMap<>();
            c.put("name", rs.getString("COLUMN_NAME"));
            c.put("type", rs.getString("TYPE_NAME"));
            c.put("size", rs.getString("COLUMN_SIZE"));
            cols.add(c);
        }
        debug.put("columns", cols);
        debug.put("table_name", tableName);
        
        // Check for child tables / keys
        // or just check for existence of 'staff' table
        ResultSet tables = md.getTables(null, null, null, new String[]{"TABLE"});
        List<String> allTables = new ArrayList<>();
        while (tables.next()) allTables.add(tables.getString("TABLE_NAME"));
        debug.put("all_tables", allTables);
    } catch (Exception e) {
        debug.put("error", e.getMessage());
    }
    out.print(new com.google.gson.Gson().toJson(debug));
%>

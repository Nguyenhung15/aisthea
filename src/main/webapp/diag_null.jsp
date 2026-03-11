<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    Map<String, Object> result = new HashMap<>();
    try (Connection conn = DBConnection.getConnection();
         Statement st = conn.createStatement();
         ResultSet rs = st.executeQuery("SELECT TOP 1 * FROM conversations")) {
        ResultSetMetaData md = rs.getMetaData();
        List<Map<String, Object>> cols = new ArrayList<>();
        for (int i = 1; i <= md.getColumnCount(); i++) {
            Map<String, Object> col = new HashMap<>();
            col.put("name", md.getColumnName(i));
            col.put("nullable", md.isNullable(i) == ResultSetMetaData.columnNullable);
            cols.add(col);
        }
        result.put("columns", cols);
    } catch (Exception e) {}
    out.print(new com.google.gson.Gson().toJson(result));
%>

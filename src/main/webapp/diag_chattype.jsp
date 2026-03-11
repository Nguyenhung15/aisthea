<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.sql.*, com.aisthea.fashion.dao.DBConnection" %>
<%
    try (Connection conn = DBConnection.getConnection();
         Statement st = conn.createStatement();
         ResultSet rs = st.executeQuery("SELECT TOP 1 chattype, status FROM conversations")) {
        ResultSetMetaData md = rs.getMetaData();
        for (int i = 1; i <= md.getColumnCount(); i++) {
            out.println(md.getColumnName(i) + " : " + md.getColumnTypeName(i) + " (" + md.getPrecision(i) + ")");
        }
    } catch (Exception e) {
        out.print("ERROR: " + e.getMessage());
    }
%>

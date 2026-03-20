<%@ page import="java.sql.*" %>
<ul>
<%
Connection conn = null;
try {
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/aisthea_fashion", "root", "");
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM productimages WHERE productid = 89");
    ResultSet rs = ps.executeQuery();
    while(rs.next()) {
        out.println("<li>ID: " + rs.getInt("imageid") + " URL: " + rs.getString("imageurl") + " Color: " + rs.getString("color") + " Primary: " + rs.getInt("isprimary") + "</li>");
    }
} catch (Exception e) {
    out.println("<li>Error: " + e.getMessage() + "</li>");
} finally {
    if(conn != null) conn.close();
}
%>
</ul>

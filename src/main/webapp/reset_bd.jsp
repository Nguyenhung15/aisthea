<%@ page import="java.sql.*" %>
<%@ page import="com.aisthea.fashion.dao.DBConnection" %>
<%
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("DELETE FROM birthday_discount_usage")) {
        int rows = ps.executeUpdate();
        out.println("<h2>Đã reset tất cả các mã sinh nhật! (" + rows + " mã được khôi phục)</h2>");
        out.println("<p>Lưu ý: Bạn phải Khởi động lại Server (Stop/Start Tomcat) hoặc Clean/Build lại Project thì code Java của chức năng Hủy/Hoàn trả mới có tác dụng nhé!</p>");
        out.println("<a href='../cart' style='color:blue; text-decoration:underline;'>Quay lại Giỏ hàng</a>");
    } catch (Exception e) {
        out.println("Lỗi: " + e.getMessage());
    }
%>

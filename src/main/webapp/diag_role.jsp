<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="com.aisthea.fashion.model.User" %>
<%
    User u = (User) session.getAttribute("user");
    if (u != null) {
        String role = u.getRole();
        out.println("Role: [" + role + "]");
        if (role != null) {
            byte[] bytes = role.getBytes();
            for (byte b : bytes) out.print(b + " ");
            out.println();
        }
    } else {
        out.println("No user");
    }
%>

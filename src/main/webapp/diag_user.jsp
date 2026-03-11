<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="com.aisthea.fashion.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    java.util.Map<String, Object> map = new java.util.HashMap<>();
    if (user != null) {
        map.put("id", user.getUserId());
        map.put("role", user.getRole());
        map.put("name", user.getFullname());
    } else {
        map.put("error", "No user in session");
    }
    out.print(new com.google.gson.Gson().toJson(map));
%>

<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.util.*, com.aisthea.fashion.controller.ChatServlet" %>
<%
    Map<String, Object> debug = new HashMap<>();
    debug.put("currentTime", System.currentTimeMillis());
    // Since adminActivity is private static, I might not be able to access it directly here if it's in another package
    // But ChatServlet is in com.aisthea.fashion.controller
    // Let's assume I can't access it unless I expose it. I already exposed it via ?action=online.
    out.print(new com.google.gson.Gson().toJson(debug));
%>

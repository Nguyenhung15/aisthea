<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.net.*, java.io.*" %>
<%
    try {
        String urlStr = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/chat?action=conversations";
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        // We need to pass the session cookie!
        String sessionCookie = "JSESSIONID=" + session.getId();
        conn.setRequestProperty("Cookie", sessionCookie);
        
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String line;
        while ((line = in.readLine()) != null) out.println(line);
        in.close();
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    }
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<ul>
<%
String userHome = System.getProperty("user.home");
out.println("<li>user.home: " + userHome + "</li>");
File uploadsDir = new File(userHome, "aisthea_uploads/uploads/product");
out.println("<li>Uploads dir: " + uploadsDir.getAbsolutePath() + " / exists=" + uploadsDir.exists() + "</li>");
if (uploadsDir.exists() && uploadsDir.isDirectory()) {
    File[] files = uploadsDir.listFiles();
    if(files != null) {
        for(File f : files) {
            out.println("<li>File: " + f.getName() + " - " + f.length() + " bytes</li>");
        }
    }
}
%>
</ul>

<%@ page import="java.io.*,java.util.*,jakarta.servlet.http.Part" %>
<%@ page contentType="text/plain;charset=UTF-8" %>
<%
out.println("Method: " + request.getMethod());
if ("POST".equalsIgnoreCase(request.getMethod())) {
    out.println("Content-Type: " + request.getContentType());
    out.println("image_url_0: " + request.getParameter("image_url_0"));
    try {
        Collection<Part> parts = request.getParts();
        out.println("Parts: " + parts.size());
        for(Part p : parts) {
            out.println("Part Name: " + p.getName() + " Size: " + p.getSize());
        }
    } catch (Exception e) {
        out.println("Error reading parts: " + e.getMessage());
    }
}
%>

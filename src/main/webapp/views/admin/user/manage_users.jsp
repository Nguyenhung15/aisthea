<%@ page import="java.util.*, com.aisthea.fashion.dao.UserDAO, com.aisthea.fashion.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/views/admin/include/header_admin.jsp" %>
<%@ include file="/views/admin/include/sidebar_admin.jsp" %>

<div style="margin-left:240px;padding:30px;">
    <h2 style="color:#3e2723;">👥 Manage Users</h2>
    <hr style="border:1px solid #d7ccc8;margin:15px 0;">

    <table border="1" width="100%" cellpadding="10" cellspacing="0" style="border-collapse:collapse;">
        <thead style="background:#efebe9;color:#3e2723;">
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Gender</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Active</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="u" items="${users}">
                <tr>
                    <td>${u.userId}</td>
                    <td>${u.fullname}</td>
                    <td>${u.email}</td>
                    <td>${u.gender}</td>
                    <td>${u.phone}</td>
                    <td>${u.role}</td>
                    <td>${u.active ? "✅" : "❌"}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/user?action=edit&id=${u.userId}"
                           style="color:blue;text-decoration:none;font-weight:600;">✏️ Edit</a>
                        |
                        <a href="${pageContext.request.contextPath}/user?action=delete&id=${u.userId}"
                           style="color:red;text-decoration:none;font-weight:600;"
                           onclick="return confirm('Are you sure to delete this user?');">🗑️ Delete</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty users}">
                <tr><td colspan="8" style="text-align:center;">No users found.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>
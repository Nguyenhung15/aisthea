<%@ page import="com.aisthea.fashion.dao.UserDAO, com.aisthea.fashion.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/views/admin/include/header_admin.jsp" %>
<%@ include file="/views/admin/include/sidebar_admin.jsp" %>

<div style="margin-left:240px;padding:30px;">
    <h2>Edit User</h2>
    <hr style="margin:15px 0;">

    <c:if test="${not empty user}">
        <form action="${pageContext.request.contextPath}/user" method="post" style="display:grid;gap:10px;width:400px;">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${user.userId}">

            <label>Fullname:</label>
            <input type="text" name="fullname" value="${user.fullname}" required>

            <label>Email:</label>
            <input type="email" name="email" value="${user.email}" required>

            <label>Gender:</label>
            <input type="text" name="gender" value="${user.gender}">

            <label>Phone:</label>
            <input type="text" name="phone" value="${user.phone}">

            <label>Address:</label>
            <input type="text" name="address" value="${user.address}">

            <label>Role:</label>
            <select name="role">
                <option value="USER" ${"USER".equals(user.role) ? "selected" : ""}>USER</option>
                <option value="ADMIN" ${"ADMIN".equals(user.role) ? "selected" : ""}>ADMIN</option>
            </select>

            <label>Active:</label>
            <select name="active">
                <option value="1" ${user.active ? "selected" : ""}>Active</option>
                <option value="0" ${!user.active ? "selected" : ""}>Inactive</option>
            </select>

            <button type="submit" style="background:#3e2723;color:#fff;padding:8px 12px;border:none;border-radius:6px;">Save</button>
        </form>
    </c:if>
    <c:if test="${empty user}">
        <p style="color:red;">User not found.</p>
    </c:if>
</div>
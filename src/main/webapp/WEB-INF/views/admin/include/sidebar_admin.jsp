<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside style="width:220px;background:#efebe9;height:100vh;position:fixed;top:0;left:0;padding-top:70px;">
    <nav style="display:flex;flex-direction:column;">
        <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">📊 Dashboard</a>
        <a href="${pageContext.request.contextPath}/user?action=list" class="menu-item">👥 Manage Users</a>
        <a href="${pageContext.request.contextPath}/product?action=manage" class="menu-item">🛍️ Manage Products</a>
        <a href="${pageContext.request.contextPath}/category" class="menu-item">🏷️ Manage Categories</a>
        <a href="${pageContext.request.contextPath}/order?action=list" class="menu-item">📦 Manage Orders</a>
    </nav>
</aside>

<style>
    .menu-item {
        padding:12px 20px;
        color:#4e342e;
        font-weight:600;
        text-decoration:none;
    }
    .menu-item:hover {
        background:#d7ccc8;
        color:#3e2723;
    }
</style>
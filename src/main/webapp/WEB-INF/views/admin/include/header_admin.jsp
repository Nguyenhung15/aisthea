<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header style="background:#3e2723;color:#fff;padding:12px 24px;display:flex;justify-content:space-between;align-items:center;">
    <div class="left">
        <a href="${pageContext.request.contextPath}views/admin/dashboard.jsp" style="color:#fff;font-size:20px;font-weight:700;text-decoration:none;">
            AISTHEA ADMIN
        </a>
    </div>

    <div class="right" style="display:flex;align-items:center;gap:20px;">
        <span>👋 Xin chào, 
            <strong>
                <c:out value="${sessionScope.user != null ? sessionScope.user.fullname : 'Admin'}" />
            </strong>
        </span>

        <a href="${pageContext.request.contextPath}/logout"
           style="background:#a0522d;color:#fff;padding:8px 14px;border-radius:6px;text-decoration:none;font-weight:600;">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>
</header>

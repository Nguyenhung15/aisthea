<%@ page import="java.util.*, com.aisthea.fashion.dao.UserDAO, com.aisthea.fashion.model.User" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>
                <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>

                    <div style="margin-left:240px;padding:30px;">
                        <h2 style="color:#3e2723;">👥 Manage Users</h2>
                        <hr style="border:1px solid #d7ccc8;margin:15px 0;">

                        <%-- Success / error flash --%>
                            <c:if test="${not empty param.success}">
                                <div
                                    style="background:#e8f5e9;border-left:4px solid #43a047;padding:10px 16px;margin-bottom:14px;border-radius:4px;color:#2e7d32;">
                                    <c:choose>
                                        <c:when test="${param.success eq 'banned'}">✅ Tài khoản đã bị khóa thành công.
                                        </c:when>
                                        <c:when test="${param.success eq 'unbanned'}">✅ Tài khoản đã được mở khóa.
                                        </c:when>
                                        <c:otherwise>✅ Thao tác thành công.</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.error}">
                                <div
                                    style="background:#ffebee;border-left:4px solid #e53935;padding:10px 16px;margin-bottom:14px;border-radius:4px;color:#b71c1c;">
                                    ❌ Có lỗi xảy ra. Vui lòng thử lại.
                                </div>
                            </c:if>

                            <%-- Ban modal --%>
                                <div id="banModal"
                                    style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;align-items:center;justify-content:center;">
                                    <div
                                        style="background:#fff;border-radius:8px;padding:28px 32px;width:420px;box-shadow:0 8px 32px rgba(0,0,0,.18);">
                                        <h3 style="margin:0 0 14px;color:#b71c1c;">🔒 Khóa tài khoản</h3>
                                        <p style="margin:0 0 10px;color:#555;font-size:14px;">Nhập lý do khoá (<span
                                                id="banTargetName" style="font-weight:700;"></span>):</p>
                                        <textarea id="banReasonInput" rows="3"
                                            style="width:100%;border:1px solid #ccc;border-radius:4px;padding:8px;font-size:14px;resize:vertical;box-sizing:border-box;"
                                            placeholder="Ví dụ: Vi phạm điều khoản, spam..."></textarea>
                                        <div style="margin-top:16px;display:flex;gap:12px;justify-content:flex-end;">
                                            <button onclick="closeBanModal()"
                                                style="padding:8px 18px;border:1px solid #ccc;border-radius:4px;background:#f5f5f5;cursor:pointer;">Hủy</button>
                                            <button onclick="submitBan()"
                                                style="padding:8px 18px;border:none;border-radius:4px;background:#e53935;color:#fff;font-weight:700;cursor:pointer;">Xác
                                                nhận khóa</button>
                                        </div>
                                    </div>
                                </div>
                                <form id="banForm" method="post" action="${pageContext.request.contextPath}/user">
                                    <input type="hidden" name="action" value="ban">
                                    <input type="hidden" name="id" id="banUserId">
                                    <input type="hidden" name="banReason" id="banReasonHidden">
                                </form>

                                <table border="1" width="100%" cellpadding="10" cellspacing="0"
                                    style="border-collapse:collapse;">
                                    <thead style="background:#efebe9;color:#3e2723;">
                                        <tr>
                                            <th>ID</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Gender</th>
                                            <th>Phone</th>
                                            <th>Role</th>
                                            <th>Active</th>
                                            <th>Trạng thái</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="u" items="${users}">
                                            <tr style="${u.banned ? 'background:#fff8e1;' : ''}">
                                                <td>${u.userId}</td>
                                                <td>${u.fullname}</td>
                                                <td>${u.email}</td>
                                                <td>${u.gender}</td>
                                                <td>${u.phone}</td>
                                                <td>${u.role}</td>
                                                <td>${u.active ? "✅" : "❌"}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${u.banned}">
                                                            <span style="color:#b71c1c;font-weight:700;">🔒 Bị
                                                                khóa</span>
                                                            <c:if test="${not empty u.banReason}">
                                                                <br><small style="color:#888;">${u.banReason}</small>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color:#2e7d32;">✅ Hoạt động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="white-space:nowrap;">
                                                    <a href="${pageContext.request.contextPath}/user?action=edit&id=${u.userId}"
                                                        style="color:blue;text-decoration:none;font-weight:600;">✏️
                                                        Edit</a>
                                                    |
                                                    <c:choose>
                                                        <c:when test="${u.banned}">
                                                            <a href="${pageContext.request.contextPath}/user?action=unban&id=${u.userId}"
                                                                style="color:#2e7d32;text-decoration:none;font-weight:600;"
                                                                onclick="return confirm('Mở khóa tài khoản ${u.fullname}?');">🔓
                                                                Unban</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="javascript:void(0)"
                                                                onclick="openBanModal(${u.userId}, '${u.fullname}')"
                                                                style="color:#e65100;text-decoration:none;font-weight:600;">🔒
                                                                Ban</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    |
                                                    <a href="${pageContext.request.contextPath}/user?action=delete&id=${u.userId}"
                                                        style="color:red;text-decoration:none;font-weight:600;"
                                                        onclick="return confirm('Are you sure to delete this user?');">🗑️
                                                        Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty users}">
                                            <tr>
                                                <td colspan="9" style="text-align:center;">No users found.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                    </div>

                    <script>
                        function openBanModal(userId, name) {
                            document.getElementById('banUserId').value = userId;
                            document.getElementById('banTargetName').textContent = name;
                            document.getElementById('banReasonInput').value = '';
                            document.getElementById('banModal').style.display = 'flex';
                        }
                        function closeBanModal() {
                            document.getElementById('banModal').style.display = 'none';
                        }
                        function submitBan() {
                            const reason = document.getElementById('banReasonInput').value.trim();
                            if (!reason) { alert('Vui lòng nhập lý do khóa tài khoản!'); return; }
                            document.getElementById('banReasonHidden').value = reason;
                            document.getElementById('banForm').submit();
                        }
                        // Close modal when clicking outside
                        document.getElementById('banModal').addEventListener('click', function (e) {
                            if (e.target === this) closeBanModal();
                        });
                    </script>
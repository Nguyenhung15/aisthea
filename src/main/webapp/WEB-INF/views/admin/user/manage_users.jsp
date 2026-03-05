<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Customer Management — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <style>
                    /* Custom Modal Styles */
                    .lux-modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(15, 23, 42, 0.4);
                        backdrop-filter: blur(4px);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 2000;
                        opacity: 0;
                        visibility: hidden;
                        transition: all 0.3s ease;
                    }

                    .lux-modal-overlay.active {
                        opacity: 1;
                        visibility: visible;
                    }

                    .lux-modal {
                        background: #fff;
                        border-radius: 20px;
                        width: 400px;
                        padding: 32px;
                        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
                        transform: translateY(20px);
                        transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                        text-align: center;
                    }

                    .lux-modal-overlay.active .lux-modal {
                        transform: translateY(0);
                    }

                    .lux-modal__icon {
                        width: 64px;
                        height: 64px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: 0 auto 20px;
                        font-size: 24px;
                    }

                    .lux-modal__icon--warn {
                        background: #fff7ed;
                        color: #f97316;
                    }

                    .lux-modal__icon--success {
                        background: #f0fdf4;
                        color: #22c55e;
                    }

                    .lux-modal__title {
                        font-family: var(--font-serif);
                        font-size: 1.4rem;
                        margin-bottom: 12px;
                        color: var(--color-primary);
                    }

                    .lux-modal__text {
                        font-size: 0.9rem;
                        color: var(--color-text-secondary);
                        margin-bottom: 24px;
                        line-height: 1.5;
                    }

                    .lux-modal__actions {
                        display: flex;
                        gap: 12px;
                    }

                    .lux-modal__btn {
                        flex: 1;
                        padding: 12px;
                        border-radius: 30px;
                        border: none;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s;
                        font-size: 0.85rem;
                    }

                    .lux-modal__btn--cancel {
                        background: #f1f5f9;
                        color: #64748b;
                    }

                    .lux-modal__btn--confirm {
                        background: var(--color-primary);
                        color: #fff;
                    }

                    .lux-modal__btn--confirm:hover {
                        background: var(--color-primary-hover);
                        transform: translateY(-2px);
                    }
                </style>
            </head>

            <body class="luxury-admin">
                <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
                    <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

                        <main class="lux-main">
                            <div class="lux-content">

                                <!-- Page Header -->
                                <section class="lux-page-header">
                                    <div class="lux-page-header__text">
                                        <h1 class="lux-page-header__title">Customer Management</h1>
                                        <p class="lux-page-header__subtitle">View and manage user activity status and
                                            permissions.</p>
                                    </div>
                                </section>

                                <!-- Success / Error Messages -->
                                <c:set var="isBan" value="${sessionScope.actionName == 'banned'}" />
                                <c:set var="isUnban" value="${sessionScope.actionName == 'unbanned'}" />
                                <c:if test="${not empty sessionScope.successMsg}">
                                    <div
                                        style="background:${isBan ? '#fff7ed' : 'var(--color-success-bg)'}; border: 1px solid ${isBan ? '#fdba74' : 'rgba(34, 197, 94, 0.2)'}; color:${isBan ? '#9a3412' : 'var(--color-success-text)'}; padding:14px 20px; border-radius:var(--radius-md); margin-bottom:var(--space-lg); display:flex; align-items:center; gap:12px; font-weight:600; font-size:0.88rem; box-shadow:var(--shadow-sm);">
                                        <i class="fa-solid ${isBan ? 'fa-user-slash' : (isUnban ? 'fa-user-check' : 'fa-circle-check')}"
                                            style="font-size:1.1rem; opacity:0.9;"></i>
                                        <span>${sessionScope.successMsg}</span>
                                    </div>
                                    <c:remove var="successMsg" scope="session" />
                                    <c:remove var="actionName" scope="session" />
                                </c:if>

                                <c:if test="${not empty sessionScope.errorMsg}">
                                    <div
                                        style="background:#fef2f2; border: 1px solid rgba(220, 38, 38, 0.1); color:#dc2626; padding:14px 20px; border-radius:var(--radius-md); margin-bottom:var(--space-lg); display:flex; align-items:center; gap:12px; font-weight:600; font-size:0.88rem; box-shadow:var(--shadow-sm);">
                                        <i class="fa-solid fa-circle-exclamation"
                                            style="font-size:1.1rem; opacity:0.9;"></i>
                                        <span>${sessionScope.errorMsg}</span>
                                    </div>
                                    <c:remove var="errorMsg" scope="session" />
                                </c:if>

                                <!-- Users Table Card -->
                                <div
                                    style="background:var(--color-white);border-radius:var(--radius-xl);box-shadow:var(--shadow-card);overflow:hidden;">
                                    <div
                                        style="padding:var(--space-lg) var(--space-xl);border-bottom:1px solid var(--color-border-light);display:flex;justify-content:space-between;align-items:center;">
                                        <div>
                                            <h2
                                                style="font-family:var(--font-serif);font-size:1.3rem;font-weight:700;color:var(--color-primary);margin:0;">
                                                Customer Directory</h2>
                                            <p style="font-size:0.82rem;color:var(--color-text-muted);margin:4px 0 0;">
                                                Total registered member accounts</p>
                                        </div>
                                    </div>

                                    <table style="width:100%;border-collapse:collapse;">
                                        <thead>
                                            <tr style="background:var(--color-bg);">
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    ID</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    User</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Contact</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Role</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Status</th>
                                                <th
                                                    style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="u" items="${users}">
                                                <tr style="border-bottom:1px solid var(--color-border-light);transition:background 0.15s ease;"
                                                    onmouseover="this.style.background='var(--color-bg)'"
                                                    onmouseout="this.style.background='transparent'">
                                                    <td
                                                        style="padding:16px 20px;font-size:0.85rem;color:var(--color-text-muted);">
                                                        #${u.userId}</td>
                                                    <td style="padding:16px 20px;">
                                                        <div style="display:flex;align-items:center;gap:12px;">
                                                            <div
                                                                style="width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#667eea,#764ba2);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:0.8rem;flex-shrink:0;">
                                                                ${u.fullname.substring(0,1)}
                                                            </div>
                                                            <div>
                                                                <div
                                                                    style="font-weight:600;font-size:0.88rem;color:var(--color-text-primary);">
                                                                    ${u.fullname}</div>
                                                                <div
                                                                    style="font-size:0.78rem;color:var(--color-text-muted);">
                                                                    ${u.email}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="padding:16px 20px;">
                                                        <div
                                                            style="font-size:0.85rem;color:var(--color-text-secondary);">
                                                            ${u.phone}</div>
                                                        <div style="font-size:0.78rem;color:var(--color-text-muted);">
                                                            ${u.gender}</div>
                                                    </td>
                                                    <td style="padding:16px 20px;">
                                                        <span
                                                            style="display:inline-flex;align-items:center;gap:4px;padding:4px 12px;border-radius:var(--radius-full);font-size:0.75rem;font-weight:600;
                                                            ${u.role == 'ADMIN' ? 'background:rgba(124,58,237,0.1);color:#7c3aed;' : 'background:var(--color-bg);color:var(--color-text-secondary);'}">
                                                            <i class="fa-solid ${u.role == 'ADMIN' ? 'fa-shield-halved' : 'fa-user'}"
                                                                style="font-size:0.65rem;"></i>
                                                            ${u.role}
                                                        </span>
                                                    </td>
                                                    <td style="padding:16px 20px;">
                                                        <c:choose>
                                                            <c:when test="${u.banned}">
                                                                <span class="lux-badge lux-badge--danger"
                                                                    style="gap:6px;">
                                                                    <span
                                                                        style="width:6px;height:6px;border-radius:50%;background:#dc2626;"></span>
                                                                    Banned
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${u.active}">
                                                                <span class="lux-badge lux-badge--success"
                                                                    style="gap:6px;">
                                                                    <span
                                                                        style="width:6px;height:6px;border-radius:50%;background:var(--color-success);"></span>
                                                                    Active
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="lux-badge lux-badge--neutral"
                                                                    style="gap:6px;">
                                                                    <span
                                                                        style="width:6px;height:6px;border-radius:50%;background:var(--color-text-muted);"></span>
                                                                    Pending Activation
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:right;">
                                                        <div style="display:flex;gap:8px;justify-content:flex-end;">
                                                            <a href="${pageContext.request.contextPath}/user?action=edit&id=${u.userId}"
                                                                style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;"
                                                                title="Edit Profile">
                                                                <i class="fa-solid fa-pen-to-square"></i>
                                                            </a>
                                                            <button
                                                                onclick="confirmStatusToggle(${u.userId}, '${u.fullname}', ${u.banned})"
                                                                style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);border:none;cursor:pointer;transition:all 0.2s ease;"
                                                                title="${u.banned ? 'Unban Account' : 'Ban Account'}">
                                                                <i class="fa-solid ${u.banned ? 'fa-circle-check' : 'fa-ban'}"
                                                                    style="${u.banned ? 'color:var(--color-success);' : 'color:#dc2626;'}"></i>
                                                            </button>
                                                            <a href="${pageContext.request.contextPath}/user?action=delete&id=${u.userId}"
                                                                onclick="return confirm('Warning: Deleting a user cannot be undone. Are you sure?');"
                                                                style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;"
                                                                title="Delete User">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                            </div>
                        </main>

                        <!-- Custom Modal Overlay -->
                        <div id="luxModalOverlay" class="lux-modal-overlay" onclick="closeModal(event)">
                            <div class="lux-modal" onclick="event.stopPropagation()">
                                <div id="modalIcon" class="lux-modal__icon"></div>
                                <h3 id="modalTitle" class="lux-modal__title"></h3>
                                <p id="modalText" class="lux-modal__text"></p>
                                <div class="lux-modal__actions">
                                    <button class="lux-modal__btn lux-modal__btn--cancel"
                                        onclick="closeModal()">Cancel</button>
                                    <a id="modalConfirmBtn" href="#" class="lux-modal__btn lux-modal__btn--confirm"
                                        style="display:flex; align-items:center; justify-content:center; text-decoration:none;">Confirm</a>
                                </div>
                            </div>
                        </div>

                        <script>
                            function confirmStatusToggle(userId, fullname, isBanned) {
                                const overlay = document.getElementById('luxModalOverlay');
                                const icon = document.getElementById('modalIcon');
                                const title = document.getElementById('modalTitle');
                                const text = document.getElementById('modalText');
                                const confirmBtn = document.getElementById('modalConfirmBtn');

                                if (isBanned) {
                                    icon.innerHTML = '<i class="fa-solid fa-user-check"></i>';
                                    icon.className = 'lux-modal__icon lux-modal__icon--success';
                                    title.innerText = 'Unban this customer?';
                                    text.innerText = 'You are about to unban ' + fullname + '. They will be able to log into the system again.';
                                } else {
                                    icon.innerHTML = '<i class="fa-solid fa-user-slash"></i>';
                                    icon.className = 'lux-modal__icon lux-modal__icon--warn';
                                    title.innerText = 'Ban this customer?';
                                    text.innerText = 'You are about to ban account of ' + fullname + '. This user will not be able to log in until unbanned.';
                                }

                                confirmBtn.href = '${pageContext.request.contextPath}/user?action=toggleStatus&id=' + userId;
                                overlay.classList.add('active');
                            }

                            function closeModal() {
                                document.getElementById('luxModalOverlay').classList.remove('active');
                            }
                        </script>
            </body>

            </html>
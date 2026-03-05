<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Edit User — AISTHÉA Admin</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
            <style>
                .lux-form-card {
                    background: var(--color-white);
                    border-radius: var(--radius-xl);
                    box-shadow: var(--shadow-card);
                    padding: var(--space-xl) var(--space-2xl);
                    max-width: 640px;
                }

                .lux-form-card__title {
                    font-family: var(--font-serif);
                    font-size: 1.3rem;
                    font-weight: 700;
                    color: var(--color-primary);
                    margin-bottom: var(--space-xs);
                }

                .lux-form-card__subtitle {
                    font-size: 0.82rem;
                    color: var(--color-text-muted);
                    margin-bottom: var(--space-xl);
                    padding-bottom: var(--space-lg);
                    border-bottom: 1px solid var(--color-border-light);
                }

                .lux-form-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: var(--space-lg) var(--space-xl);
                }

                .lux-form-group {
                    display: flex;
                    flex-direction: column;
                    gap: 6px;
                }

                .lux-form-group.full-width {
                    grid-column: 1/-1;
                }

                .lux-form-label {
                    font-size: 0.78rem;
                    font-weight: 600;
                    color: var(--color-text-secondary);
                    text-transform: uppercase;
                    letter-spacing: 0.8px;
                }

                .lux-form-input,
                .lux-form-select {
                    width: 100%;
                    padding: 11px 16px;
                    border: 1.5px solid var(--color-border);
                    border-radius: var(--radius-md);
                    font-family: var(--font-sans);
                    font-size: 0.88rem;
                    color: var(--color-text-primary);
                    background: var(--color-white);
                    outline: none;
                    transition: border-color 0.2s ease, box-shadow 0.2s ease;
                }

                .lux-form-input:focus,
                .lux-form-select:focus {
                    border-color: var(--color-primary);
                    box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.08);
                }

                .lux-form-actions {
                    display: flex;
                    gap: var(--space-md);
                    margin-top: var(--space-xl);
                    padding-top: var(--space-lg);
                    border-top: 1px solid var(--color-border-light);
                }

                .lux-btn-secondary {
                    display: inline-flex;
                    align-items: center;
                    gap: var(--space-sm);
                    padding: 12px 28px;
                    background: var(--color-bg);
                    color: var(--color-text-secondary);
                    font-family: var(--font-sans);
                    font-size: 0.82rem;
                    font-weight: 600;
                    border: 1px solid var(--color-border);
                    border-radius: var(--radius-full);
                    cursor: pointer;
                    transition: all 0.2s ease;
                    text-decoration: none;
                }

                .lux-btn-secondary:hover {
                    background: var(--color-border);
                    color: var(--color-text-primary);
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
                                    <h1 class="lux-page-header__title">Edit User</h1>
                                    <p class="lux-page-header__subtitle">Update user profile information, role and
                                        account status.</p>
                                </div>
                                <div class="lux-page-header__actions">
                                    <a href="${pageContext.request.contextPath}/user?action=list"
                                        class="lux-btn-secondary">
                                        <i class="fa-solid fa-arrow-left"></i> Back to Users
                                    </a>
                                </div>
                            </section>

                            <c:if test="${not empty user}">
                                <div class="lux-form-card">
                                    <!-- User Avatar -->
                                    <div
                                        style="display:flex;align-items:center;gap:16px;margin-bottom:var(--space-xl);">
                                        <div
                                            style="width:56px;height:56px;border-radius:50%;background:linear-gradient(135deg,#667eea,#764ba2);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:1.2rem;">
                                            ${user.fullname.substring(0,1)}
                                        </div>
                                        <div>
                                            <h2 class="lux-form-card__title">${user.fullname}</h2>
                                            <p style="font-size:0.82rem;color:var(--color-text-muted);margin:0;">
                                                ${user.email}</p>
                                        </div>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/user" method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="${user.userId}">

                                        <div class="lux-form-grid">
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Full Name</label>
                                                <input type="text" name="fullname" value="${user.fullname}" required
                                                    class="lux-form-input">
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Email</label>
                                                <input type="email" name="email" value="${user.email}" required
                                                    class="lux-form-input">
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Gender</label>
                                                <select name="gender" class="lux-form-select">
                                                    <option value="" ${empty user.gender ? 'selected' : '' }>— Select —
                                                    </option>
                                                    <option value="Male" ${'Male'.equals(user.gender) ? 'selected' : ''
                                                        }>Male</option>
                                                    <option value="Female" ${'Female'.equals(user.gender) ? 'selected'
                                                        : '' }>Female</option>
                                                    <option value="Other" ${'Other'.equals(user.gender) ? 'selected'
                                                        : '' }>Other</option>
                                                </select>
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Phone</label>
                                                <input type="text" name="phone" value="${user.phone}"
                                                    class="lux-form-input">
                                            </div>
                                            <div class="lux-form-group full-width">
                                                <label class="lux-form-label">Address</label>
                                                <input type="text" name="address" value="${user.address}"
                                                    class="lux-form-input">
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Role</label>
                                                <select name="role" class="lux-form-select">
                                                    <option value="USER" ${"USER".equals(user.role) ? "selected" : "" }>
                                                        USER</option>
                                                    <option value="ADMIN" ${"ADMIN".equals(user.role) ? "selected" : ""
                                                        }>ADMIN</option>
                                                </select>
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Active (Email Verified)</label>
                                                <select name="active" class="lux-form-select">
                                                    <option value="1" ${user.active ? "selected" : "" }>Yes</option>
                                                    <option value="0" ${!user.active ? "selected" : "" }>No</option>
                                                </select>
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Account Banned</label>
                                                <select name="isBanned" class="lux-form-select">
                                                    <option value="1" ${user.banned ? "selected" : "" }>Yes, Ban this
                                                        user</option>
                                                    <option value="0" ${!user.banned ? "selected" : "" }>No, Active
                                                        account</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="lux-form-actions">
                                            <button type="submit" class="lux-btn-primary"><i
                                                    class="fa-solid fa-check"></i> Save Changes</button>
                                            <a href="${pageContext.request.contextPath}/user?action=list"
                                                class="lux-btn-secondary">Cancel</a>
                                        </div>
                                    </form>
                                </div>
                            </c:if>
                            <c:if test="${empty user}">
                                <div
                                    style="background:var(--color-white);border-radius:var(--radius-xl);padding:60px;text-align:center;box-shadow:var(--shadow-card);">
                                    <i class="fa-solid fa-user-slash"
                                        style="font-size:2.5rem;color:var(--color-text-muted);opacity:0.4;margin-bottom:16px;"></i>
                                    <p style="color:var(--color-text-muted);font-size:0.95rem;">User not found.</p>
                                    <a href="${pageContext.request.contextPath}/user?action=list"
                                        class="lux-btn-secondary" style="margin-top:16px;display:inline-flex;">
                                        <i class="fa-solid fa-arrow-left"></i> Back to Users
                                    </a>
                                </div>
                            </c:if>

                        </div>
                    </main>
        </body>

        </html>
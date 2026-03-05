<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Categories — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <style>
                    .parent-row {
                        background: rgba(26, 35, 50, 0.02);
                    }

                    .parent-row td:first-child {
                        position: relative;
                        padding-left: 28px;
                    }

                    .parent-row td:first-child::before {
                        content: '';
                        position: absolute;
                        left: 14px;
                        top: 50%;
                        transform: translateY(-50%);
                        width: 4px;
                        height: 24px;
                        background: var(--color-primary);
                        border-radius: 2px;
                    }

                    .gender-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        padding: 3px 10px;
                        border-radius: var(--radius-full);
                        font-size: 0.72rem;
                        font-weight: 600;
                    }

                    .gender-male {
                        background: #dbeafe;
                        color: #2563eb;
                    }

                    .gender-female {
                        background: #fce7f3;
                        color: #db2777;
                    }

                    .gender-other {
                        background: #f3f4f6;
                        color: #6b7280;
                    }

                    /* Delete Modal */
                    .modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(0, 0, 0, 0.5);
                        display: none;
                        align-items: center;
                        justify-content: center;
                        z-index: 1000;
                        backdrop-filter: blur(4px);
                    }

                    .modal-box {
                        background: var(--color-white);
                        border-radius: var(--radius-xl);
                        padding: var(--space-2xl);
                        width: 90%;
                        max-width: 420px;
                        box-shadow: var(--shadow-lg);
                        text-align: center;
                    }

                    .modal-box h3 {
                        font-family: var(--font-serif);
                        font-size: 1.3rem;
                        color: #dc2626;
                        margin-bottom: var(--space-sm);
                    }

                    .modal-box p {
                        font-size: 0.88rem;
                        color: var(--color-text-secondary);
                        margin-bottom: var(--space-lg);
                    }

                    .modal-actions {
                        display: flex;
                        gap: 12px;
                        justify-content: center;
                    }

                    .modal-btn {
                        padding: 10px 24px;
                        border: none;
                        border-radius: var(--radius-full);
                        font-weight: 600;
                        font-size: 0.85rem;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .btn-confirm-delete {
                        background: #dc2626;
                        color: #fff;
                    }

                    .btn-confirm-delete:hover {
                        background: #b91c1c;
                    }

                    .btn-cancel-delete {
                        background: var(--color-bg);
                        color: var(--color-text-secondary);
                        border: 1px solid var(--color-border);
                    }

                    .btn-cancel-delete:hover {
                        background: var(--color-border);
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
                                        <h1 class="lux-page-header__title">Category Management</h1>
                                        <p class="lux-page-header__subtitle">Organize your product catalog with parent
                                            and sub-categories.</p>
                                    </div>
                                    <div class="lux-page-header__actions">
                                        <a href="${pageContext.request.contextPath}/category?action=new"
                                            class="lux-btn-primary">
                                            <i class="fa-solid fa-plus"></i> Add Category
                                        </a>
                                    </div>
                                </section>

                                <!-- Error Message -->
                                <c:if test="${not empty errorMsg}">
                                    <div
                                        style="background:#fef2f2;color:#dc2626;padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                        <i class="fa-solid fa-circle-exclamation"
                                            style="margin-right:8px;"></i>${errorMsg}
                                    </div>
                                </c:if>

                                <!-- Category Table Card -->
                                <div
                                    style="background:var(--color-white);border-radius:var(--radius-xl);box-shadow:var(--shadow-card);overflow:hidden;">
                                    <div
                                        style="padding:var(--space-lg) var(--space-xl);border-bottom:1px solid var(--color-border-light);">
                                        <h2
                                            style="font-family:var(--font-serif);font-size:1.3rem;font-weight:700;color:var(--color-primary);margin:0;">
                                            All Categories</h2>
                                        <p style="font-size:0.82rem;color:var(--color-text-muted);margin:4px 0 0;">
                                            Parent categories are highlighted with a side indicator</p>
                                    </div>

                                    <table style="width:100%;border-collapse:collapse;">
                                        <thead>
                                            <tr style="background:var(--color-bg);">
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    ID</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Name</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Type</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Gender</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Parent</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Created</th>
                                                <th
                                                    style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="cat" items="${list}">
                                                <tr class="${empty cat.parentid ? 'parent-row' : ''}"
                                                    style="border-bottom:1px solid var(--color-border-light);transition:background 0.15s ease;"
                                                    onmouseover="this.style.background='var(--color-bg)'"
                                                    onmouseout="this.style.background='${empty cat.parentid ? 'rgba(26,35,50,0.02)' : 'transparent'}'">
                                                    <td
                                                        style="padding:14px 20px;font-size:0.85rem;color:var(--color-text-muted);">
                                                        ${cat.categoryid}</td>
                                                    <td style="padding:14px 20px;">
                                                        <span
                                                            style="font-weight:${empty cat.parentid ? '700' : '500'};font-size:0.88rem;color:var(--color-text-primary);">${cat.name}</span>
                                                        <c:if test="${not empty cat.indexName}">
                                                            <div
                                                                style="font-size:0.72rem;color:var(--color-text-muted);margin-top:2px;">
                                                                ${cat.indexName}</div>
                                                        </c:if>
                                                    </td>
                                                    <td
                                                        style="padding:14px 20px;font-size:0.85rem;color:var(--color-text-secondary);">
                                                        ${cat.type}</td>
                                                    <td style="padding:14px 20px;">
                                                        <c:choose>
                                                            <c:when test="${cat.genderid == 1}"><span
                                                                    class="gender-badge gender-male"><i
                                                                        class="fa-solid fa-mars"
                                                                        style="font-size:0.65rem;"></i> Nam</span>
                                                            </c:when>
                                                            <c:when test="${cat.genderid == 2}"><span
                                                                    class="gender-badge gender-female"><i
                                                                        class="fa-solid fa-venus"
                                                                        style="font-size:0.65rem;"></i> Nữ</span>
                                                            </c:when>
                                                            <c:when test="${cat.genderid == 3}"><span
                                                                    class="gender-badge gender-other"><i
                                                                        class="fa-solid fa-genderless"
                                                                        style="font-size:0.65rem;"></i> Khác</span>
                                                            </c:when>
                                                            <c:otherwise><span
                                                                    style="font-size:0.82rem;color:var(--color-text-muted);">—</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td
                                                        style="padding:14px 20px;font-size:0.85rem;color:var(--color-text-muted);">
                                                        ${empty cat.parentid ? '—' : cat.parentid}
                                                    </td>
                                                    <td
                                                        style="padding:14px 20px;font-size:0.82rem;color:var(--color-text-muted);">
                                                        <fmt:formatDate value="${cat.createdat}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td style="padding:14px 20px;text-align:right;">
                                                        <div style="display:flex;gap:8px;justify-content:flex-end;">
                                                            <a href="${pageContext.request.contextPath}/category?action=edit&id=${cat.categoryid}"
                                                                style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;font-size:0.82rem;"
                                                                onmouseover="this.style.background='var(--color-primary)';this.style.color='#fff';"
                                                                onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';"
                                                                title="Edit">
                                                                <i class="fa-solid fa-pen-to-square"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/category?action=delete&id=${cat.categoryid}"
                                                                class="link-delete"
                                                                data-category-name="<c:out value='${cat.name}' />"
                                                                style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;font-size:0.82rem;"
                                                                onmouseover="this.style.background='#fef2f2';this.style.color='#dc2626';"
                                                                onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';"
                                                                title="Delete">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty list}">
                                                <tr>
                                                    <td colspan="7"
                                                        style="padding:40px 20px;text-align:center;color:var(--color-text-muted);font-size:0.9rem;">
                                                        <i class="fa-solid fa-tags"
                                                            style="font-size:2rem;margin-bottom:12px;display:block;opacity:0.3;"></i>
                                                        No categories found.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                            </div>
                        </main>

                        <!-- Delete Confirmation Modal -->
                        <div id="deleteModal" class="modal-overlay">
                            <div class="modal-box">
                                <div
                                    style="width:56px;height:56px;margin:0 auto var(--space-lg);border-radius:50%;background:#fef2f2;display:flex;align-items:center;justify-content:center;">
                                    <i class="fa-solid fa-triangle-exclamation"
                                        style="font-size:1.4rem;color:#dc2626;"></i>
                                </div>
                                <h3>Confirm Delete</h3>
                                <p>Are you sure you want to delete <strong id="modalCategoryName"
                                        style="color:var(--color-primary);"></strong>?<br>
                                    <span style="font-size:0.78rem;color:var(--color-text-muted);">This action cannot be
                                        undone. Sub-categories may be affected.</span>
                                </p>
                                <div class="modal-actions">
                                    <button type="button" id="cancelDeleteBtn"
                                        class="modal-btn btn-cancel-delete">Cancel</button>
                                    <a href="#" id="confirmDeleteBtn" class="modal-btn btn-confirm-delete"><i
                                            class="fa-solid fa-trash-can"></i> Delete</a>
                                </div>
                            </div>
                        </div>

                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                const modal = document.getElementById('deleteModal');
                                const modalCategoryName = document.getElementById('modalCategoryName');
                                const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
                                const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
                                const deleteLinks = document.querySelectorAll('.link-delete');

                                deleteLinks.forEach(link => {
                                    link.addEventListener('click', function (event) {
                                        event.preventDefault();
                                        const deleteUrl = this.href;
                                        const categoryName = this.dataset.categoryName;
                                        modalCategoryName.textContent = categoryName;
                                        confirmDeleteBtn.href = deleteUrl;
                                        modal.style.display = 'flex';
                                    });
                                });

                                cancelDeleteBtn.addEventListener('click', function () { modal.style.display = 'none'; });
                                modal.addEventListener('click', function (event) { if (event.target === modal) modal.style.display = 'none'; });
                            });
                        </script>
            </body>

            </html>
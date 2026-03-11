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

                    /* ── Filter Bar ── */
                    .cat-filter-bar {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 12px;
                        align-items: center;
                        padding: 16px 0 0;
                    }

                    .cat-filter-bar__input {
                        font-family: var(--font-sans);
                        font-size: 0.82rem;
                        font-weight: 500;
                        color: var(--color-text-primary);
                        padding: 9px 16px 9px 38px;
                        border: 1px solid var(--color-border);
                        border-radius: var(--radius-full);
                        background: var(--color-bg);
                        outline: none;
                        transition: border-color 0.2s ease, box-shadow 0.2s ease;
                        min-width: 200px;
                    }

                    .cat-filter-bar__input:focus {
                        border-color: var(--color-primary);
                        box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.08);
                    }

                    .cat-filter-bar__input::placeholder {
                        color: var(--color-text-muted);
                    }

                    .cat-filter-bar__select {
                        font-family: var(--font-sans);
                        font-size: 0.82rem;
                        font-weight: 500;
                        color: var(--color-primary);
                        padding: 9px 36px 9px 16px;
                        border: 1.5px solid var(--color-primary);
                        border-radius: var(--radius-full);
                        background: var(--color-white);
                        cursor: pointer;
                        outline: none;
                        appearance: none;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%231a2332' viewBox='0 0 16 16'%3E%3Cpath d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E");
                        background-repeat: no-repeat;
                        background-position: right 14px center;
                        background-size: 12px;
                        transition: all 0.2s ease;
                        letter-spacing: 0.3px;
                    }

                    .cat-filter-bar__select:hover,
                    .cat-filter-bar__select:focus {
                        background-color: var(--color-primary);
                        color: var(--color-white);
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='white' viewBox='0 0 16 16'%3E%3Cpath d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E");
                    }

                    .cat-filter-bar__reset {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 9px 20px;
                        font-family: var(--font-sans);
                        font-size: 0.78rem;
                        font-weight: 600;
                        letter-spacing: 0.5px;
                        color: var(--color-text-secondary);
                        background: transparent;
                        border: 1px solid var(--color-border);
                        border-radius: var(--radius-full);
                        cursor: pointer;
                        transition: all 0.2s ease;
                    }

                    .cat-filter-bar__reset:hover {
                        background: var(--color-bg);
                        color: var(--color-primary);
                        border-color: var(--color-primary);
                    }

                    .cat-filter-bar__group {
                        position: relative;
                        display: inline-flex;
                        align-items: center;
                    }

                    .cat-filter-bar__icon {
                        position: absolute;
                        left: 14px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: var(--color-text-muted);
                        font-size: 0.78rem;
                        pointer-events: none;
                    }

                    .cat-filter-bar__count {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        min-width: 22px;
                        height: 22px;
                        padding: 0 6px;
                        font-size: 0.7rem;
                        font-weight: 700;
                        color: var(--color-white);
                        background: var(--color-primary);
                        border-radius: var(--radius-full);
                        margin-left: 8px;
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

                                    <!-- Header + Filter Bar -->
                                    <div style="padding:var(--space-xl);border-bottom:1px solid var(--color-border-light);">
                                        <div style="display:flex;justify-content:space-between;align-items:center;">
                                            <div>
                                                <h2 style="font-family:var(--font-serif);font-size:1.3rem;font-weight:700;color:var(--color-primary);margin:0;">All Categories</h2>
                                                <p style="font-size:0.82rem;color:var(--color-text-muted);margin:4px 0 0;">Parent categories are highlighted with a side indicator</p>
                                            </div>
                                            <span class="cat-filter-bar__count" id="catCount" title="Showing categories"></span>
                                        </div>

                                        <!-- Filter Bar -->
                                        <div class="cat-filter-bar">
                                            <span class="cat-filter-bar__group">
                                                <i class="fa-solid fa-magnifying-glass cat-filter-bar__icon"></i>
                                                <input type="text" id="filterCatName" class="cat-filter-bar__input" placeholder="Search category name...">
                                            </span>

                                            <select id="filterCatGender" class="cat-filter-bar__select">
                                                <option value="">All Genders</option>
                                                <option value="1">Nam</option>
                                                <option value="2">Nữ</option>
                                                <option value="3">Khác</option>
                                            </select>

                                            <select id="filterCatType" class="cat-filter-bar__select">
                                                <option value="">All Types</option>
                                                <option value="parent">Parent</option>
                                                <option value="sub">Sub-category</option>
                                            </select>

                                            <button type="button" id="btnCatReset" class="cat-filter-bar__reset">
                                                <i class="fa-solid fa-rotate-left"></i> Reset
                                            </button>
                                        </div>
                                    </div>

                                    <table style="width:100%;border-collapse:collapse;">
                                        <thead>
                                            <tr style="background:var(--color-bg);">
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">ID</th>
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">Name</th>
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">Type</th>
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">Gender</th>
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">Parent</th>
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">Created</th>
                                                <th style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="catTableBody">
                                            <c:forEach var="cat" items="${list}">
                                                <tr class="cat-row ${empty cat.parentid ? 'parent-row' : ''}"
                                                    data-name="${cat.name}"
                                                    data-gender="${cat.genderid}"
                                                    data-isparent="${empty cat.parentid ? 'parent' : 'sub'}"
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

                                    <!-- No results message -->
                                    <div id="catNoResults" style="display:none;padding:40px 20px;text-align:center;color:var(--color-text-muted);font-size:0.9rem;">
                                        <i class="fa-solid fa-tags" style="font-size:2rem;margin-bottom:12px;display:block;opacity:0.3;"></i>
                                        No categories match your filter criteria.
                                    </div>
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
                                var modal = document.getElementById('deleteModal');
                                var modalCategoryName = document.getElementById('modalCategoryName');
                                var confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
                                var cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
                                var deleteLinks = document.querySelectorAll('.link-delete');

                                deleteLinks.forEach(function(link) {
                                    link.addEventListener('click', function (event) {
                                        event.preventDefault();
                                        modalCategoryName.textContent = this.dataset.categoryName;
                                        confirmDeleteBtn.href = this.href;
                                        modal.style.display = 'flex';
                                    });
                                });

                                cancelDeleteBtn.addEventListener('click', function () { modal.style.display = 'none'; });
                                modal.addEventListener('click', function (event) { if (event.target === modal) modal.style.display = 'none'; });

                                // ── Category Filter JS ──
                                var filterName   = document.getElementById('filterCatName');
                                var filterGender = document.getElementById('filterCatGender');
                                var filterType   = document.getElementById('filterCatType');
                                var btnReset     = document.getElementById('btnCatReset');
                                var tbody        = document.getElementById('catTableBody');
                                var noResults    = document.getElementById('catNoResults');
                                var catCount     = document.getElementById('catCount');

                                var rows = tbody.querySelectorAll('tr.cat-row');

                                function applyFilters() {
                                    var fName   = filterName.value.trim().toLowerCase();
                                    var fGender = filterGender.value;
                                    var fType   = filterType.value;
                                    var visibleCount = 0;

                                    for (var i = 0; i < rows.length; i++) {
                                        var row = rows[i];
                                        var show = true;

                                        if (fName && (row.getAttribute('data-name') || '').toLowerCase().indexOf(fName) === -1) {
                                            show = false;
                                        }
                                        if (fGender && row.getAttribute('data-gender') !== fGender) {
                                            show = false;
                                        }
                                        if (fType && row.getAttribute('data-isparent') !== fType) {
                                            show = false;
                                        }

                                        row.style.display = show ? '' : 'none';
                                        if (show) visibleCount++;
                                    }

                                    noResults.style.display = (visibleCount === 0) ? 'block' : 'none';
                                    catCount.textContent = visibleCount;
                                }

                                filterName.addEventListener('input', applyFilters);
                                filterGender.addEventListener('change', applyFilters);
                                filterType.addEventListener('change', applyFilters);

                                btnReset.addEventListener('click', function() {
                                    filterName.value = '';
                                    filterGender.value = '';
                                    filterType.value = '';
                                    applyFilters();
                                });

                                applyFilters();
                            });
                        </script>
            </body>

            </html>
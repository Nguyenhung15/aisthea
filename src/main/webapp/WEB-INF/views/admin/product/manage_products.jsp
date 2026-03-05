<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Products — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <style>
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
                                        <h1 class="lux-page-header__title">Product Management</h1>
                                        <p class="lux-page-header__subtitle">Manage your product catalog, inventory and
                                            pricing.</p>
                                    </div>
                                    <div class="lux-page-header__actions">
                                        <a href="${pageContext.request.contextPath}/product?action=new"
                                            class="lux-btn-primary">
                                            <i class="fa-solid fa-plus"></i> Add Product
                                        </a>
                                    </div>
                                </section>

                                <!-- Search Bar -->
                                <div
                                    style="background:var(--color-white);border-radius:var(--radius-xl);box-shadow:var(--shadow-card);padding:var(--space-md) var(--space-xl);margin-bottom:var(--space-lg);">
                                    <form action="${pageContext.request.contextPath}/product" method="GET"
                                        style="display:flex;align-items:center;gap:12px;">
                                        <input type="hidden" name="action" value="manage">
                                        <div style="position:relative;flex:1;max-width:400px;">
                                            <i class="fa-solid fa-magnifying-glass"
                                                style="position:absolute;left:14px;top:50%;transform:translateY(-50%);color:var(--color-text-muted);font-size:0.85rem;"></i>
                                            <input type="text" name="searchName"
                                                value="<c:out value='${param.searchName}'/>"
                                                placeholder="Search products by name..."
                                                style="width:100%;padding:10px 16px 10px 40px;border:1.5px solid var(--color-border);border-radius:var(--radius-full);font-family:var(--font-sans);font-size:0.85rem;color:var(--color-text-primary);background:var(--color-bg);outline:none;">
                                        </div>
                                        <button type="submit" class="lux-btn-primary"
                                            style="padding:10px 24px;font-size:0.78rem;">
                                            Search
                                        </button>
                                        <c:if test="${not empty param.searchName}">
                                            <a href="${pageContext.request.contextPath}/product?action=manage"
                                                style="font-size:0.82rem;color:var(--color-text-muted);font-weight:500;white-space:nowrap;">
                                                <i class="fa-solid fa-xmark" style="margin-right:4px;"></i>Clear
                                            </a>
                                        </c:if>
                                    </form>
                                </div>

                                <!-- Products Table Card -->
                                <div
                                    style="background:var(--color-white);border-radius:var(--radius-xl);box-shadow:var(--shadow-card);overflow:hidden;">
                                    <table style="width:100%;border-collapse:collapse;">
                                        <thead>
                                            <tr style="background:var(--color-bg);">
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Product</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Category</th>
                                                <th
                                                    style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Price</th>
                                                <th
                                                    style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Stock</th>
                                                <th
                                                    style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${productList}">
                                                <tr style="border-bottom:1px solid var(--color-border-light);transition:background 0.15s ease;"
                                                    onmouseover="this.style.background='var(--color-bg)'"
                                                    onmouseout="this.style.background='transparent'">
                                                    <td style="padding:14px 20px;">
                                                        <div style="display:flex;align-items:center;gap:14px;">
                                                            <!-- Product Image -->
                                                            <c:set var="primaryImgUrl"
                                                                value="https://placehold.co/60x60/f0f2f5/9ca3af?text=N/A" />
                                                            <c:if test="${not empty p.images}">
                                                                <c:set var="foundPrimary" value="false" />
                                                                <c:forEach var="img" items="${p.images}">
                                                                    <c:if test="${img.primary and not foundPrimary}">
                                                                        <c:set var="primaryImgUrl"
                                                                            value="${img.imageUrl}" />
                                                                        <c:set var="foundPrimary" value="true" />
                                                                    </c:if>
                                                                </c:forEach>
                                                                <c:if
                                                                    test="${not foundPrimary and not empty p.images[0]}">
                                                                    <c:set var="primaryImgUrl"
                                                                        value="${p.images[0].imageUrl}" />
                                                                </c:if>
                                                            </c:if>
                                                            <img src="${primaryImgUrl}" alt="${p.name}"
                                                                style="width:52px;height:52px;object-fit:cover;border-radius:var(--radius-sm);border:1px solid var(--color-border-light);flex-shrink:0;"
                                                                onerror="this.src='https://placehold.co/60x60/f0f2f5/9ca3af?text=N/A'">
                                                            <div>
                                                                <div
                                                                    style="font-weight:600;font-size:0.88rem;color:var(--color-text-primary);max-width:280px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                                                    ${p.name}</div>
                                                                <div
                                                                    style="font-size:0.75rem;color:var(--color-text-muted);margin-top:2px;">
                                                                    ID: ${p.productId}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="padding:14px 20px;">
                                                        <span
                                                            style="display:inline-flex;align-items:center;gap:4px;padding:4px 10px;border-radius:var(--radius-full);font-size:0.75rem;font-weight:500;background:var(--color-bg);color:var(--color-text-secondary);">
                                                            ${p.category.name}
                                                        </span>
                                                    </td>
                                                    <td style="padding:14px 20px;text-align:right;">
                                                        <span
                                                            style="font-weight:700;font-size:0.92rem;color:var(--color-primary);">
                                                            <fmt:formatNumber value="${p.price}" type="currency"
                                                                currencyCode="VND" maxFractionDigits="0" />
                                                        </span>
                                                        <c:if test="${p.discount > 0}">
                                                            <div
                                                                style="font-size:0.72rem;color:#dc2626;font-weight:600;margin-top:2px;">
                                                                -${p.discount}%</div>
                                                        </c:if>
                                                    </td>
                                                    <td style="padding:14px 20px;text-align:center;">
                                                        <c:set var="totalStock" value="0" />
                                                        <c:forEach var="pcs" items="${p.colorSizes}">
                                                            <c:set var="totalStock" value="${totalStock + pcs.stock}" />
                                                        </c:forEach>
                                                        <span
                                                            class="lux-badge ${totalStock > 10 ? 'lux-badge--success' : totalStock > 0 ? 'lux-badge--warning' : 'lux-badge--danger'}">
                                                            ${totalStock}
                                                        </span>
                                                    </td>
                                                    <td style="padding:14px 20px;text-align:right;">
                                                        <div style="display:flex;gap:8px;justify-content:flex-end;">
                                                            <a href="${pageContext.request.contextPath}/product?action=edit&id=${p.productId}"
                                                                style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;font-size:0.82rem;"
                                                                onmouseover="this.style.background='var(--color-primary)';this.style.color='#fff';"
                                                                onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';"
                                                                title="Edit">
                                                                <i class="fa-solid fa-pen-to-square"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/product?action=delete&id=${p.productId}"
                                                                class="link-delete"
                                                                data-product-name="<c:out value='${p.name}' />"
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
                                            <c:if test="${empty productList}">
                                                <tr>
                                                    <td colspan="5"
                                                        style="padding:40px 20px;text-align:center;color:var(--color-text-muted);font-size:0.9rem;">
                                                        <i class="fa-solid fa-bag-shopping"
                                                            style="font-size:2rem;margin-bottom:12px;display:block;opacity:0.3;"></i>
                                                        No products found${not empty param.searchName ? ' matching your
                                                        search' : ''}.
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
                                <p>Are you sure you want to delete <strong id="modalProductName"
                                        style="color:var(--color-primary);"></strong>?<br>
                                    <span style="font-size:0.78rem;color:var(--color-text-muted);">This will permanently
                                        delete the product, including all images and inventory.</span>
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
                                const modalProductName = document.getElementById('modalProductName');
                                const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
                                const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
                                const deleteLinks = document.querySelectorAll('.link-delete');

                                deleteLinks.forEach(link => {
                                    link.addEventListener('click', function (event) {
                                        event.preventDefault();
                                        const deleteUrl = this.href;
                                        const productName = this.dataset.productName;
                                        modalProductName.textContent = productName;
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
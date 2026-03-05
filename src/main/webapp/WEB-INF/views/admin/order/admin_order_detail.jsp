<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Order #${order.orderid} — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <style>
                    .status-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 5px 14px;
                        border-radius: var(--radius-full);
                        font-size: 0.72rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .status-Pending {
                        background: #fef3c7;
                        color: #d97706;
                    }

                    .status-Processing {
                        background: #dbeafe;
                        color: #2563eb;
                    }

                    .status-Shipped {
                        background: #e0e7ff;
                        color: #4f46e5;
                    }

                    .status-Completed {
                        background: var(--color-success-bg);
                        color: var(--color-success-text);
                    }

                    .status-Cancelled {
                        background: #fef2f2;
                        color: #dc2626;
                    }

                    .detail-grid {
                        display: grid;
                        grid-template-columns: 1.6fr 1fr;
                        gap: var(--space-xl);
                        align-items: flex-start;
                    }

                    .detail-card {
                        background: var(--color-white);
                        border-radius: var(--radius-xl);
                        box-shadow: var(--shadow-card);
                        padding: var(--space-xl);
                    }

                    .detail-card__title {
                        font-family: var(--font-serif);
                        font-size: 1.1rem;
                        font-weight: 700;
                        color: var(--color-primary);
                        padding-bottom: var(--space-md);
                        margin-bottom: var(--space-lg);
                        border-bottom: 1px solid var(--color-border-light);
                    }

                    .info-row {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 10px 0;
                        border-bottom: 1px solid var(--color-border-light);
                    }

                    .info-row:last-child {
                        border-bottom: none;
                    }

                    .info-row__label {
                        font-size: 0.82rem;
                        font-weight: 600;
                        color: var(--color-text-muted);
                    }

                    .info-row__value {
                        font-size: 0.88rem;
                        color: var(--color-text-primary);
                        font-weight: 500;
                        text-align: right;
                    }

                    .product-item {
                        display: flex;
                        gap: 16px;
                        padding: 14px 0;
                        border-bottom: 1px solid var(--color-border-light);
                        align-items: center;
                    }

                    .product-item:last-child {
                        border-bottom: none;
                    }

                    .product-item img {
                        width: 64px;
                        height: 64px;
                        object-fit: cover;
                        border-radius: var(--radius-sm);
                        border: 1px solid var(--color-border-light);
                    }

                    .product-item__info {
                        flex: 1;
                    }

                    .product-item__name {
                        font-weight: 600;
                        font-size: 0.88rem;
                        color: var(--color-text-primary);
                    }

                    .product-item__variant {
                        font-size: 0.78rem;
                        color: var(--color-text-muted);
                        margin-top: 2px;
                    }

                    .product-item__price {
                        font-weight: 700;
                        font-size: 0.92rem;
                        color: var(--color-primary);
                        text-align: right;
                        white-space: nowrap;
                    }

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
                        transition: border-color 0.2s ease;
                    }

                    .lux-form-select:focus {
                        border-color: var(--color-primary);
                        box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.08);
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

                    @media(max-width:900px) {
                        .detail-grid {
                            grid-template-columns: 1fr;
                        }
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
                                        <h1 class="lux-page-header__title">Order #${order.orderid}</h1>
                                        <p class="lux-page-header__subtitle">
                                            Placed on
                                            <fmt:formatDate value="${order.createdat}" pattern="dd/MM/yyyy" /> at
                                            <fmt:formatDate value="${order.createdat}" pattern="HH:mm" />
                                            &nbsp;&middot;&nbsp;
                                            <span class="status-badge status-${order.status}">${order.status}</span>
                                        </p>
                                    </div>
                                    <div class="lux-page-header__actions">
                                        <a href="${pageContext.request.contextPath}/order?action=list"
                                            class="lux-btn-secondary">
                                            <i class="fa-solid fa-arrow-left"></i> Back to Orders
                                        </a>
                                    </div>
                                </section>

                                <!-- Success/Error -->
                                <c:if test="${param.update == 'success'}">
                                    <div
                                        style="background:var(--color-success-bg);color:var(--color-success-text);padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                        <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>Status updated
                                        successfully!
                                    </div>
                                </c:if>
                                <c:if test="${param.update == 'error'}">
                                    <div
                                        style="background:#fef2f2;color:#dc2626;padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                        <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>Error
                                        updating status.
                                    </div>
                                </c:if>

                                <div class="detail-grid">
                                    <!-- Left Column: Products + Shipping -->
                                    <div>
                                        <!-- Products -->
                                        <div class="detail-card" style="margin-bottom:var(--space-xl);">
                                            <h3 class="detail-card__title"><i class="fa-solid fa-bag-shopping"
                                                    style="margin-right:8px;font-size:0.9rem;"></i>Products</h3>
                                            <c:forEach var="item" items="${order.items}">
                                                <div class="product-item">
                                                    <img src="${item.imageUrl}"
                                                        onerror="this.src='https://placehold.co/100x100/f0f2f5/9ca3af?text=No+Image'"
                                                        alt="${item.productName}">
                                                    <div class="product-item__info">
                                                        <div class="product-item__name">${item.productName}</div>
                                                        <div class="product-item__variant">${item.color} / ${item.size}
                                                            &middot; Qty: ${item.quantity}</div>
                                                    </div>
                                                    <div class="product-item__price">
                                                        <fmt:formatNumber value="${item.price * item.quantity}"
                                                            type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <!-- Shipping Info -->
                                        <div class="detail-card">
                                            <h3 class="detail-card__title"><i class="fa-solid fa-truck"
                                                    style="margin-right:8px;font-size:0.9rem;"></i>Shipping Information
                                            </h3>
                                            <div class="info-row">
                                                <span class="info-row__label">Full Name</span>
                                                <span class="info-row__value">${order.fullname}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-row__label">Email</span>
                                                <span class="info-row__value">${order.email}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-row__label">Phone</span>
                                                <span class="info-row__value">${order.phone}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-row__label">Address</span>
                                                <span class="info-row__value"
                                                    style="max-width:280px;">${order.address}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Right Column: Summary + Status Update -->
                                    <div>
                                        <div class="detail-card" style="position:sticky;top:90px;">
                                            <h3 class="detail-card__title"><i class="fa-solid fa-receipt"
                                                    style="margin-right:8px;font-size:0.9rem;"></i>Order Summary</h3>

                                            <div class="info-row">
                                                <span class="info-row__label">Order Date</span>
                                                <span class="info-row__value">
                                                    <fmt:formatDate value="${order.createdat}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-row__label">Payment</span>
                                                <span class="info-row__value">${order.paymentMethod}</span>
                                            </div>
                                            <div class="info-row" style="border-bottom:none;">
                                                <span class="info-row__label"
                                                    style="font-size:0.92rem;color:var(--color-text-primary);">Total</span>
                                                <span
                                                    style="font-family:var(--font-serif);font-size:1.5rem;font-weight:700;color:var(--color-primary);">
                                                    <fmt:formatNumber value="${order.totalprice}" type="currency"
                                                        currencyCode="VND" maxFractionDigits="0" />
                                                </span>
                                            </div>

                                            <!-- Update Status -->
                                            <div
                                                style="margin-top:var(--space-xl);padding-top:var(--space-lg);border-top:1px solid var(--color-border-light);">
                                                <h4
                                                    style="font-size:0.78rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;margin-bottom:var(--space-md);">
                                                    Update Status</h4>
                                                <form action="${pageContext.request.contextPath}/order" method="POST"
                                                    style="display:flex;gap:10px;">
                                                    <input type="hidden" name="action" value="adminUpdateStatus">
                                                    <input type="hidden" name="orderId" value="${order.orderid}">
                                                    <select name="newStatus" class="lux-form-select" style="flex:1;">
                                                        <option value="Pending" ${order.status=='Pending' ? 'selected'
                                                            : '' }>Pending</option>
                                                        <option value="Processing" ${order.status=='Processing'
                                                            ? 'selected' : '' }>Processing</option>
                                                        <option value="Shipped" ${order.status=='Shipped' ? 'selected'
                                                            : '' }>Shipped</option>
                                                        <option value="Completed" ${order.status=='Completed'
                                                            ? 'selected' : '' }>Completed</option>
                                                        <option value="Cancelled" ${order.status=='Cancelled'
                                                            ? 'selected' : '' }>Cancelled</option>
                                                    </select>
                                                    <button type="submit" class="lux-btn-primary"
                                                        style="padding:11px 24px;"><i class="fa-solid fa-check"></i>
                                                        Save</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </main>
            </body>

            </html>
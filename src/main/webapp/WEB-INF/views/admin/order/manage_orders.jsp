<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Orders — AISTHÉA Admin</title>
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
                                        <h1 class="lux-page-header__title">Order Management</h1>
                                        <p class="lux-page-header__subtitle">Track, manage and update order statuses
                                            across the platform.</p>
                                    </div>
                                </section>

                                <!-- Success / Error Messages -->
                                <c:if test="${param.delete == 'success'}">
                                    <div
                                        style="background:var(--color-success-bg);color:var(--color-success-text);padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                        <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>Order deleted
                                        successfully.
                                    </div>
                                </c:if>

                                <!-- Orders Table Card -->
                                <div
                                    style="background:var(--color-white);border-radius:var(--radius-xl);box-shadow:var(--shadow-card);overflow:hidden;">
                                    <div
                                        style="padding:var(--space-lg) var(--space-xl);border-bottom:1px solid var(--color-border-light);display:flex;justify-content:space-between;align-items:center;">
                                        <div>
                                            <h2
                                                style="font-family:var(--font-serif);font-size:1.3rem;font-weight:700;color:var(--color-primary);margin:0;">
                                                All Orders</h2>
                                            <p style="font-size:0.82rem;color:var(--color-text-muted);margin:4px 0 0;">
                                                Complete order history and management</p>
                                        </div>
                                    </div>

                                    <table style="width:100%;border-collapse:collapse;">
                                        <thead>
                                            <tr style="background:var(--color-bg);">
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Order</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Customer</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Date</th>
                                                <th
                                                    style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Total</th>
                                                <th
                                                    style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Status</th>
                                                <th
                                                    style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${orderList}">
                                                <tr style="border-bottom:1px solid var(--color-border-light);transition:background 0.15s ease;"
                                                    onmouseover="this.style.background='var(--color-bg)'"
                                                    onmouseout="this.style.background='transparent'">
                                                    <td style="padding:16px 20px;">
                                                        <span
                                                            style="font-weight:700;font-size:0.88rem;color:var(--color-primary);">#${order.orderid}</span>
                                                    </td>
                                                    <td style="padding:16px 20px;">
                                                        <div
                                                            style="font-weight:600;font-size:0.88rem;color:var(--color-text-primary);">
                                                            ${order.fullname}</div>
                                                        <div
                                                            style="font-size:0.78rem;color:var(--color-text-muted);margin-top:2px;">
                                                            ${order.phone}</div>
                                                        <div
                                                            style="font-size:0.75rem;color:var(--color-text-muted);margin-top:1px;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                                            ${order.address}</div>
                                                    </td>
                                                    <td
                                                        style="padding:16px 20px;font-size:0.85rem;color:var(--color-text-secondary);">
                                                        <fmt:formatDate value="${order.createdat}"
                                                            pattern="dd/MM/yyyy" />
                                                        <div style="font-size:0.75rem;color:var(--color-text-muted);">
                                                            <fmt:formatDate value="${order.createdat}"
                                                                pattern="HH:mm" />
                                                        </div>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:right;">
                                                        <span
                                                            style="font-weight:700;font-size:0.92rem;color:var(--color-primary);">
                                                            <fmt:formatNumber value="${order.totalprice}"
                                                                type="currency" currencyCode="VND"
                                                                maxFractionDigits="0" />
                                                        </span>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:center;">
                                                        <span
                                                            class="status-badge status-${order.status}">${order.status}</span>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:right;">
                                                        <div style="display:flex;gap:8px;justify-content:flex-end;">
                                                            <a href="${pageContext.request.contextPath}/order?action=adminViewDetail&id=${order.orderid}"
                                                                style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;font-size:0.82rem;"
                                                                onmouseover="this.style.background='var(--color-primary)';this.style.color='#fff';"
                                                                onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';"
                                                                title="View Details">
                                                                <i class="fa-solid fa-eye"></i>
                                                            </a>
                                                            <c:if
                                                                test="${order.status == 'Cancelled' || order.status == 'Completed'}">
                                                                <a href="${pageContext.request.contextPath}/order?action=adminDelete&id=${order.orderid}"
                                                                    onclick="return confirm('Are you sure you want to permanently delete order #${order.orderid}?')"
                                                                    style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;font-size:0.82rem;"
                                                                    onmouseover="this.style.background='#fef2f2';this.style.color='#dc2626';"
                                                                    onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';"
                                                                    title="Delete">
                                                                    <i class="fa-solid fa-trash-can"></i>
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty orderList}">
                                                <tr>
                                                    <td colspan="6"
                                                        style="padding:40px 20px;text-align:center;color:var(--color-text-muted);font-size:0.9rem;">
                                                        <i class="fa-solid fa-box-open"
                                                            style="font-size:2rem;margin-bottom:12px;display:block;opacity:0.3;"></i>
                                                        No orders found.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                            </div>
                        </main>
            </body>

            </html>
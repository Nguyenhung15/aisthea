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

                    /* Clean white rows like Customer Directory */
                    .order-row {
                        background: #fff;
                        border-bottom: 1px solid var(--color-border-light);
                        transition: background 0.15s ease;
                        user-select: none;
                    }
                    .order-row:hover {
                        background: var(--color-bg) !important;
                    }

                    /* ── Filter Bar ── */
                    .order-filter-bar {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 12px;
                        align-items: center;
                        padding: 16px 0 0;
                    }

                    .order-filter-bar__label {
                        font-size: 0.72rem;
                        font-weight: 600;
                        color: var(--color-text-muted);
                        text-transform: uppercase;
                        letter-spacing: 1px;
                    }

                    .order-filter-bar__input {
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
                        min-width: 160px;
                    }

                    .order-filter-bar__input:focus {
                        border-color: var(--color-primary);
                        box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.08);
                    }

                    .order-filter-bar__input::placeholder {
                        color: var(--color-text-muted);
                    }

                    .order-filter-bar__select {
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

                    .order-filter-bar__select:hover,
                    .order-filter-bar__select:focus {
                        background-color: var(--color-primary);
                        color: var(--color-white);
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='white' viewBox='0 0 16 16'%3E%3Cpath d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E");
                    }

                    .order-filter-bar__date {
                        font-family: var(--font-sans);
                        font-size: 0.82rem;
                        font-weight: 500;
                        color: var(--color-text-primary);
                        padding: 9px 16px;
                        border: 1px solid var(--color-border);
                        border-radius: var(--radius-full);
                        background: var(--color-bg);
                        outline: none;
                        cursor: pointer;
                        transition: border-color 0.2s ease, box-shadow 0.2s ease;
                    }

                    .order-filter-bar__date:focus {
                        border-color: var(--color-primary);
                        box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.08);
                    }

                    .order-filter-bar__reset {
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

                    .order-filter-bar__reset:hover {
                        background: var(--color-bg);
                        color: var(--color-primary);
                        border-color: var(--color-primary);
                    }

                    .order-filter-bar__group {
                        position: relative;
                        display: inline-flex;
                        align-items: center;
                    }

                    .order-filter-bar__icon {
                        position: absolute;
                        left: 14px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: var(--color-text-muted);
                        font-size: 0.78rem;
                        pointer-events: none;
                    }

                    .order-filter-bar__count {
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

                                    <!-- Header + Filter Controls -->
                                    <div style="padding:var(--space-xl);border-bottom:1px solid var(--color-border-light);">
                                        <div style="display:flex;justify-content:space-between;align-items:center;">
                                            <div>
                                                <h2 style="font-family:var(--font-serif);font-size:1.3rem;font-weight:700;color:var(--color-primary);margin:0;">
                                                    All Orders</h2>
                                                <p style="font-size:0.82rem;color:var(--color-text-muted);margin:4px 0 0;">
                                                    Complete order history and management</p>
                                            </div>
                                            <span class="order-filter-bar__count" id="orderCount" title="Showing orders"></span>
                                        </div>

                                        <!-- Filter Bar -->
                                        <div class="order-filter-bar">
                                            <span class="order-filter-bar__group">
                                                <i class="fa-solid fa-magnifying-glass order-filter-bar__icon"></i>
                                                <input type="text" id="filterOrderId" class="order-filter-bar__input" placeholder="Search #ID">
                                            </span>

                                            <span class="order-filter-bar__group">
                                                <i class="fa-solid fa-user order-filter-bar__icon"></i>
                                                <input type="text" id="filterCustomer" class="order-filter-bar__input" placeholder="Customer name">
                                            </span>

                                            <select id="filterStatus" class="order-filter-bar__select">
                                                <option value="">All Statuses</option>
                                                <option value="Pending">Pending</option>
                                                <option value="Processing">Processing</option>
                                                <option value="Shipped">Shipped</option>
                                                <option value="Completed">Completed</option>

                                                <option value="Cancelled">Cancelled</option>
                                                <option value="RefundPending">Refund Pending</option>
                                            </select>

                                            <input type="date" id="filterDate" class="order-filter-bar__date">

                                            <button type="button" id="btnReset" class="order-filter-bar__reset">
                                                <i class="fa-solid fa-rotate-left"></i> Reset
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <table style="width:100%;border-collapse:collapse;">
                                        <thead>
                                            <tr style="background:var(--color-bg);">
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Order</th>
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Customer</th>
                                                <th style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Date</th>
                                                <th style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Total</th>
                                                <th style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Status</th>
                                                <th style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="orderTableBody">
                                            <c:forEach var="order" items="${orderList}">
                                                <tr class="order-row"
                                                    data-orderid="${order.orderid}"
                                                    data-customer="${order.fullname}"
                                                    data-status="${order.status}"
                                                    data-refundstatus="${order.refundStatus}"
                                                    data-date="<fmt:formatDate value='${order.createdat}' pattern='yyyy-MM-dd'/>">
                                                    <td style="padding:16px 20px;font-size:0.85rem;color:var(--color-text-muted);">
                                                        #${order.orderid}</td>
                                                    <td style="padding:16px 20px;">
                                                        <div style="display:flex;align-items:center;gap:12px;">
                                                            <div
                                                                style="width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#f59e0b,#d97706);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:0.8rem;flex-shrink:0;">
                                                                ${order.fullname.substring(0,1)}
                                                            </div>
                                                            <div>
                                                                <div
                                                                    style="font-weight:600;font-size:0.88rem;color:var(--color-text-primary);">
                                                                    ${order.fullname}</div>
                                                                <div
                                                                    style="font-size:0.78rem;color:var(--color-text-muted);">
                                                                    ${order.phone}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="padding:16px 20px;">
                                                        <div style="font-size:0.85rem;color:var(--color-text-secondary);">
                                                            <fmt:formatDate value="${order.createdat}" pattern="dd/MM/yyyy" />
                                                        </div>
                                                        <div style="font-size:0.75rem;color:var(--color-text-muted);">
                                                            <fmt:formatDate value="${order.createdat}" pattern="HH:mm" />
                                                        </div>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:right;">
                                                        <span style="font-weight:700;font-size:0.92rem;color:var(--color-primary);">
                                                            <fmt:formatNumber value="${order.totalprice}" type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                        </span>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:center;">
                                                        <c:choose>
                                                            <c:when test="${order.status == 'Completed'}">
                                                                <span class="lux-badge lux-badge--success" style="gap:6px;">
                                                                    <span style="width:6px;height:6px;border-radius:50%;background:var(--color-success);"></span>
                                                                    Completed
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'Pending'}">
                                                                <span class="lux-badge lux-badge--warning" style="gap:6px;background:#fef3c7;color:#d97706;">
                                                                    <span style="width:6px;height:6px;border-radius:50%;background:#f59e0b;"></span>
                                                                    Pending
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'Processing'}">
                                                                <span class="lux-badge" style="gap:6px;background:#dbeafe;color:#2563eb;">
                                                                    <span style="width:6px;height:6px;border-radius:50%;background:#3b82f6;"></span>
                                                                    Processing
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'Shipped'}">
                                                                <span class="lux-badge" style="gap:6px;background:#e0e7ff;color:#4f46e5;">
                                                                    <span style="width:6px;height:6px;border-radius:50%;background:#6366f1;"></span>
                                                                    Shipped
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'Cancelled'}">
                                                                <span class="lux-badge lux-badge--danger" style="gap:6px;">
                                                                    <span style="width:6px;height:6px;border-radius:50%;background:#dc2626;"></span>
                                                                    Cancelled
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="lux-badge lux-badge--neutral" style="gap:6px;">
                                                                    <span style="width:6px;height:6px;border-radius:50%;background:var(--color-text-muted);"></span>
                                                                    ${order.status}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <c:if test="${order.status eq 'Cancelled' and not empty order.refundStatus}">
                                                            <br>
                                                            <span style="display:inline-flex;align-items:center;gap:4px;margin-top:6px;font-size:0.65rem;font-weight:700;text-transform:uppercase;background:${order.refundStatus == 'Pending' ? '#fee2e2' : '#d1fae5'};color:${order.refundStatus == 'Pending' ? '#b91c1c' : '#065f46'};padding:3px 8px;border-radius:12px;">
                                                                <span style="width:5px;height:5px;border-radius:50%;background:${order.refundStatus == 'Pending' ? '#ef4444' : '#10b981'};"></span>
                                                                Refund: ${order.refundStatus}
                                                            </span>
                                                        </c:if>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:right;">
                                                        <div style="display:flex;gap:8px;justify-content:flex-end;">
                                                            <a href="${pageContext.request.contextPath}/order?action=adminViewDetail&id=${order.orderid}"
                                                                style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;"
                                                                title="View Details">
                                                                <i class="fa-solid fa-eye"></i>
                                                            </a>
                                                            <c:if test="${order.status == 'Cancelled' || order.status == 'Completed'}">
                                                                <a href="${pageContext.request.contextPath}/order?action=adminDelete&id=${order.orderid}"
                                                                    onclick="return confirm('Are you sure you want to permanently delete order #${order.orderid}?')"
                                                                    style="width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border-radius:var(--radius-sm);background:var(--color-bg);color:var(--color-text-secondary);transition:all 0.2s ease;"
                                                                    title="Delete">
                                                                    <i class="fa-solid fa-trash-can"></i>
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>

                                    <!-- No results message (shown/hidden by JS) -->
                                    <div id="noResultsMsg" style="display:none;padding:40px 20px;text-align:center;color:var(--color-text-muted);font-size:0.9rem;">
                                        <i class="fa-solid fa-box-open" style="font-size:2rem;margin-bottom:12px;display:block;opacity:0.3;"></i>
                                        No records match your search criteria.
                                    </div>
                                </div>

                            </div>
                        </main>

            <script>
            (function() {
                var filterOrderId  = document.getElementById('filterOrderId');
                var filterCustomer = document.getElementById('filterCustomer');
                var filterStatus   = document.getElementById('filterStatus');
                var filterDate     = document.getElementById('filterDate');
                var btnReset       = document.getElementById('btnReset');
                var tbody          = document.getElementById('orderTableBody');
                var noResultsMsg   = document.getElementById('noResultsMsg');
                var orderCount     = document.getElementById('orderCount');

                function applyFilters() {
                    var fId       = filterOrderId.value.trim().replace('#','');
                    var fCustomer = filterCustomer.value.trim().toLowerCase();
                    var fStatus   = filterStatus.value;
                    var fDate     = filterDate.value;

                    var rows = tbody.querySelectorAll('tr.order-row');
                    var visibleCount = 0;

                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        var show = true;

                        if (fId && row.getAttribute('data-orderid') !== fId) {
                            show = false;
                        }
                        if (fCustomer && (row.getAttribute('data-customer') || '').toLowerCase().indexOf(fCustomer) === -1) {
                            show = false;
                        }
                        if (fStatus) {
                            if (fStatus === 'RefundPending') {
                                if (row.getAttribute('data-status') !== 'Cancelled' || row.getAttribute('data-refundstatus') !== 'Pending') {
                                    show = false;
                                }
                            } else if (row.getAttribute('data-status') !== fStatus) {
                                show = false;
                            }
                        }
                        if (fDate && row.getAttribute('data-date') !== fDate) {
                            show = false;
                        }

                        row.style.display = show ? '' : 'none';
                        if (show) visibleCount++;
                    }

                    noResultsMsg.style.display = (visibleCount === 0) ? 'block' : 'none';
                    orderCount.textContent = visibleCount;
                }

                filterOrderId.addEventListener('input', applyFilters);
                filterCustomer.addEventListener('input', applyFilters);
                filterStatus.addEventListener('change', applyFilters);
                filterDate.addEventListener('change', applyFilters);

                btnReset.addEventListener('click', function() {
                    filterOrderId.value = '';
                    filterCustomer.value = '';
                    filterStatus.value = '';
                    filterDate.value = '';
                    applyFilters();
                });

                // Initial count on page load
                applyFilters();
            })();
            </script>
            </body>

            </html>
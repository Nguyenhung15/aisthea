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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
    <style>
        /* ── Stat Cards ── */
        .om-stats { display:flex; gap:14px; margin-bottom:24px; flex-wrap:wrap; }
        .om-stat { flex:1; min-width:140px; background:#fff; border-radius:14px; box-shadow:var(--shadow-card);
            padding:18px 20px; display:flex; align-items:center; gap:14px;
            transition:transform .2s,box-shadow .2s; }
        .om-stat:hover { transform:translateY(-2px); box-shadow:0 8px 24px rgba(0,0,0,.08); }
        .om-stat__icon { width:44px; height:44px; border-radius:11px; display:flex; align-items:center;
            justify-content:center; font-size:1rem; flex-shrink:0; }
        .om-stat__num { font-family:var(--font-serif); font-size:1.5rem; font-weight:700; color:var(--color-primary); line-height:1; }
        .om-stat__lbl { font-size:.72rem; font-weight:600; color:var(--color-text-muted); text-transform:uppercase; letter-spacing:.5px; margin-top:2px; }

        /* ── Tab System ── */
        .om-tabs { display:flex; gap:0; border-bottom:2px solid #f1f5f9; margin-bottom:0; }
        .om-tab { padding:14px 28px; font-size:.83rem; font-weight:600; color:var(--color-text-muted);
            cursor:pointer; border:none; background:none; border-bottom:2px solid transparent;
            margin-bottom:-2px; transition:all .2s; display:flex; align-items:center; gap:8px; }
        .om-tab:hover { color:var(--color-primary); }
        .om-tab.active { color:var(--color-primary); border-bottom-color:var(--color-primary); }
        .om-tab__badge { background:#f1f5f9; color:var(--color-text-muted); font-size:.68rem;
            font-weight:700; padding:2px 8px; border-radius:999px; }
        .om-tab.active .om-tab__badge { background:var(--color-primary); color:#fff; }

        /* ── Card & Toolbar ── */
        .om-card { background:#fff; border-radius:16px; box-shadow:var(--shadow-card); overflow:hidden; }
        .om-toolbar { padding:18px 24px; border-bottom:1px solid #f1f5f9; display:flex;
            flex-wrap:wrap; gap:10px; align-items:center; justify-content:space-between; min-height:69px; }
        .om-toolbar .t-left { display:flex; flex-wrap:wrap; gap:8px; align-items:center; }
        .om-toolbar .t-right { display:flex; gap:8px; align-items:center; }

        /* ── Bulk Bar (inside toolbar, replaces content) ── */
        .om-bulk { display:none; width:100%; justify-content:space-between; align-items:center; }
        .om-bulk.show { display:flex; animation:fadeIn .2s; }
        @keyframes fadeIn { from{opacity:0;transform:translateY(3px)} to{opacity:1;transform:translateY(0)} }
        .om-bulk .b-left { font-size:.84rem; font-weight:600; color:#1d4ed8; }
        .om-bulk .b-right { display:flex; gap:8px; align-items:center; }

        /* ── Filter inputs ── */
        .om-input { font-family:var(--font-sans); font-size:.82rem; font-weight:500; color:var(--color-text-primary);
            padding:8px 14px 8px 36px; border:1px solid var(--color-border); border-radius:999px;
            background:var(--color-bg); outline:none; transition:border-color .2s,box-shadow .2s; min-width:150px; }
        .om-input:focus { border-color:var(--color-primary); box-shadow:0 0 0 3px rgba(26,35,50,.08); }
        .om-input::placeholder { color:var(--color-text-muted); }
        .om-select { font-family:var(--font-sans); font-size:.82rem; font-weight:500; color:var(--color-primary);
            padding:8px 34px 8px 14px; border:1.5px solid var(--color-primary); border-radius:999px;
            background:#fff url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%231a2332' viewBox='0 0 16 16'%3E%3Cpath d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E") no-repeat right 12px center;
            appearance:none; cursor:pointer; outline:none; transition:all .2s; }
        .om-select:hover, .om-select:focus { background-color:var(--color-primary); color:#fff;
            background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='white' viewBox='0 0 16 16'%3E%3Cpath d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E"); }
        .om-icon-wrap { position:relative; display:inline-flex; align-items:center; }
        .om-icon-wrap i { position:absolute; left:12px; color:var(--color-text-muted); font-size:.75rem; pointer-events:none; }
        .om-btn-reset { display:inline-flex; align-items:center; gap:6px; width:34px; height:34px;
            justify-content:center; background:transparent; border:1px solid var(--color-border);
            border-radius:999px; cursor:pointer; color:var(--color-text-muted); font-size:.85rem; transition:all .2s; }
        .om-btn-reset:hover { background:var(--color-bg); color:var(--color-primary); border-color:var(--color-primary); }

        /* ── Action Buttons ── */
        .om-btn { display:inline-flex; align-items:center; gap:6px; padding:7px 14px;
            border:1px solid var(--color-border); border-radius:8px; font-family:var(--font-sans);
            font-size:.78rem; font-weight:600; cursor:pointer; transition:all .2s; background:#f8fafc; color:var(--color-text-secondary); }
        .om-btn:hover { background:var(--color-primary); color:#fff; border-color:var(--color-primary); }
        .om-btn.danger { background:#fef2f2; color:#dc2626; border-color:#fecaca; }
        .om-btn.danger:hover { background:#dc2626; color:#fff; border-color:#dc2626; }
        .om-btn.approve { background:#d1fae5; color:#065f46; border-color:#a7f3d0; }
        .om-btn.approve:hover { background:#10b981; color:#fff; border-color:#10b981; }
        .om-btn.reject { background:#fee2e2; color:#b91c1c; border-color:#fecaca; }
        .om-btn.reject:hover { background:#ef4444; color:#fff; border-color:#ef4444; }
        .om-btn.close-btn { background:transparent; border-color:#e2e8f0; color:var(--color-text-muted); padding:7px 10px; }
        .om-btn.close-btn:hover { background:#f1f5f9; color:var(--color-primary); border-color:var(--color-primary); }
        .om-count { display:inline-flex; align-items:center; justify-content:center; min-width:22px; height:22px;
            padding:0 6px; font-size:.7rem; font-weight:700; color:#fff; background:var(--color-primary);
            border-radius:999px; margin-left:4px; }

        /* ── Table ── */
        .om-table { width:100%; border-collapse:collapse; min-width:800px; }
        .om-table thead th { background:#f8fafc; padding:12px 18px; font-size:.68rem; font-weight:700;
            color:var(--color-text-muted); text-transform:uppercase; letter-spacing:.7px;
            border-bottom:1px solid #e2e8f0; white-space:nowrap; }
        .om-table tbody tr { border-bottom:1px solid #f1f5f9; transition:background .15s; }
        .om-table tbody tr:hover { background:var(--color-bg); }
        .om-table td { padding:15px 18px; font-size:.85rem; vertical-align:middle; }
        .om-table-wrap { overflow-x:auto; }

        /* ── Status Badges ── */
        .s-badge { display:inline-flex; align-items:center; gap:5px; padding:4px 12px;
            border-radius:999px; font-size:.7rem; font-weight:700; text-transform:uppercase; letter-spacing:.4px; }
        .s-dot { width:6px; height:6px; border-radius:50%; flex-shrink:0; }
        .s-pending { background:#fef3c7; color:#d97706; }
        .s-pending .s-dot { background:#f59e0b; }
        .s-processing { background:#dbeafe; color:#2563eb; }
        .s-processing .s-dot { background:#3b82f6; }
        .s-shipped { background:#e0e7ff; color:#4f46e5; }
        .s-shipped .s-dot { background:#6366f1; }
        .s-completed { background:var(--color-success-bg); color:var(--color-success-text); }
        .s-completed .s-dot { background:var(--color-success); }
        .s-cancelled { background:#fef2f2; color:#dc2626; }
        .s-cancelled .s-dot { background:#dc2626; }
        .s-return-pending { background:#fef3c7; color:#d97706; }
        .s-return-pending .s-dot { background:#f59e0b; }
        .s-approved { background:#d1fae5; color:#065f46; }
        .s-approved .s-dot { background:#10b981; }
        .s-rejected { background:#fee2e2; color:#b91c1c; }
        .s-rejected .s-dot { background:#ef4444; }

        /* ── Action icon buttons ── */
        .ai-btn { width:32px; height:32px; display:inline-flex; align-items:center; justify-content:center;
            border-radius:8px; border:none; background:#f3f4f6; color:#6b7280; cursor:pointer;
            transition:.18s; font-size:.8rem; text-decoration:none; }
        .ai-btn:hover { background:var(--color-primary); color:#fff; }
        .ai-btn.approve:hover { background:#10b981; color:#fff; }
        .ai-btn.reject:hover { background:#ef4444; color:#fff; }

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

        /* ── No results ── */
        .om-empty { padding:48px 20px; text-align:center; color:var(--color-text-muted); font-size:.9rem; }
        .om-empty i { font-size:2rem; opacity:.25; display:block; margin-bottom:12px; }


        /* ── Process Modal ── */
        .pm-overlay { display:none; position:fixed; inset:0; background:rgba(15,23,42,.45);
            backdrop-filter:blur(4px); z-index:999; justify-content:center; align-items:center; }
        .pm-overlay.open { display:flex; }
        .pm-modal { background:#fff; border-radius:16px; padding:30px; width:100%; max-width:460px;
            box-shadow:0 20px 60px rgba(0,0,0,.15); animation:modalIn .2s; }
        @keyframes modalIn { from{transform:scale(.95);opacity:0} to{transform:scale(1);opacity:1} }
        .pm-modal h3 { font-family:var(--font-serif); font-size:1.1rem; font-weight:700; margin:0 0 4px; }
        .pm-modal p { font-size:.82rem; color:var(--color-text-muted); margin:0 0 16px; }
        .pm-modal-info { background:#f8fafc; border-radius:10px; padding:14px 16px; margin-bottom:14px; font-size:.82rem; line-height:1.6; }
        .pm-modal-info-lbl { font-weight:600; font-size:.7rem; color:var(--color-text-muted); text-transform:uppercase; letter-spacing:.5px; }
        .pm-modal textarea { width:100%; box-sizing:border-box; border:1.5px solid #e2e8f0; border-radius:10px;
            padding:10px 14px; font-family:var(--font-sans); font-size:.88rem; outline:none; resize:vertical; transition:border-color .2s; }
        .pm-modal textarea:focus { border-color:var(--color-primary); }
        .pm-modal-actions { display:flex; gap:10px; margin-top:14px; }
        .pm-modal-btn { flex:1; padding:11px; border-radius:8px; font-weight:700; font-size:.82rem;
            cursor:pointer; transition:opacity .2s; border:none; }
        .pm-modal-btn:hover { opacity:.85; }
        .pm-modal-btn.cancel { background:#f1f5f9; color:var(--color-text-secondary); }

        /* ── Lightbox ── */
        #omLightbox { display:none; position:fixed; inset:0; background:rgba(0,0,0,.85); z-index:9999;
            justify-content:center; align-items:center; cursor:zoom-out; }
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
                    <p class="lux-page-header__subtitle">Track, process and resolve orders and return requests.</p>
                </div>
            </section>

            <!-- Flash messages -->
            <c:if test="${param.delete == 'success'}">
                <div style="background:var(--color-success-bg);color:var(--color-success-text);padding:14px 20px;border-radius:var(--radius-md);margin-bottom:20px;font-weight:600;font-size:.88rem;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>Order deleted successfully.
                </div>
            </c:if>
            <c:if test="${param.update == 'success'}">
                <div style="background:var(--color-success-bg);color:var(--color-success-text);padding:14px 20px;border-radius:var(--radius-md);margin-bottom:20px;font-weight:600;font-size:.88rem;">
                    <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>Return request processed successfully.
                </div>
            </c:if>

            <!-- Stat Cards -->
            <div class="om-stats">
                <div class="om-stat">
                    <div class="om-stat__icon" style="background:#dbeafe;color:#2563eb;">
                        <i class="fa-solid fa-bag-shopping"></i>
                    </div>
                    <div>
                        <div class="om-stat__num" id="statTotalOrders">0</div>
                        <div class="om-stat__lbl">Total Orders</div>
                    </div>
                </div>
                <div class="om-stat">
                    <div class="om-stat__icon" style="background:#fef3c7;color:#d97706;">
                        <i class="fa-solid fa-clock"></i>
                    </div>
                    <div>
                        <div class="om-stat__num" id="statPendingOrders">0</div>
                        <div class="om-stat__lbl">Pending</div>
                    </div>
                </div>
                <div class="om-stat">
                    <div class="om-stat__icon" style="background:var(--color-success-bg);color:var(--color-success);">
                        <i class="fa-solid fa-check-circle"></i>
                    </div>
                    <div>
                        <div class="om-stat__num" id="statCompletedOrders">0</div>
                        <div class="om-stat__lbl">Completed</div>
                    </div>
                </div>
                <div class="om-stat" id="statReturnCard">
                    <div class="om-stat__icon" style="background:#fee2e2;color:#dc2626;">
                        <i class="fa-solid fa-rotate-left"></i>
                    </div>
                    <div>
                        <div class="om-stat__num" id="statActiveReturns">0</div>
                        <div class="om-stat__lbl">Active Returns</div>
                    </div>
                </div>
            </div>

            <!-- Main Card -->
            <div class="om-card">

                <!-- Tab navigation -->
                <div style="padding:0 24px; border-bottom:2px solid #f1f5f9;">
                    <div class="om-tabs" style="border-bottom:none;">
                        <button class="om-tab active" id="tabOrders" onclick="switchTab('orders')">
                            <i class="fa-solid fa-receipt"></i> All Orders
                            <span class="om-tab__badge" id="tabOrdersBadge">0</span>
                        </button>
                        <button class="om-tab" id="tabReturns" onclick="switchTab('returns')">
                            <i class="fa-solid fa-rotate-left"></i> Return Requests
                            <span class="om-tab__badge" id="tabReturnsBadge">0</span>
                        </button>
                    </div>
                </div>

                <!-- ── TOOLBAR ── -->
                <div class="om-toolbar" id="mainToolbar">
                    <div id="defaultBar" style="display:flex;flex-wrap:wrap;width:100%;justify-content:space-between;row-gap:10px;">
                        <!-- Orders filters -->
                        <div class="t-left" id="ordersFilters">
                            <div class="om-icon-wrap">
                                <i class="fa-solid fa-magnifying-glass"></i>
                                <input type="text" id="filterOrderId" class="om-input" placeholder="Search #ID">
                            </div>
                            <div class="om-icon-wrap">
                                <i class="fa-solid fa-user"></i>
                                <input type="text" id="filterCustomer" class="om-input" placeholder="Customer name">
                            </div>
                            <select id="filterOrderStatus" class="om-select">
                                <option value="">All Statuses</option>
                                <option value="Pending">Pending</option>
                                <option value="Processing">Processing</option>
                                <option value="Shipped">Shipped</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                                <option value="RefundPending">Refund Pending</option>
                            </select>
                            <input type="date" id="filterDate" class="om-select" style="appearance:auto;">
                            <button class="om-btn-reset" title="Reset filters" id="btnResetOrders">
                                <i class="fa-solid fa-rotate-left"></i>
                            </button>
                        </div>
                        <!-- Returns filters -->
                        <div class="t-left" id="returnsFilters" style="display:none;">
                            <div class="om-icon-wrap">
                                <i class="fa-solid fa-magnifying-glass"></i>
                                <input type="text" id="filterReturnSearch" class="om-input" placeholder="Customer / Order ID">
                            </div>
                            <select id="filterReturnStatus" class="om-select">
                                <option value="">All Status</option>
                                <option value="Pending">Pending</option>
                                <option value="Approved">Approved</option>
                                <option value="Rejected">Rejected</option>
                            </select>
                            <button class="om-btn-reset" title="Reset filters" id="btnResetReturns">
                                <i class="fa-solid fa-rotate-left"></i>
                            </button>
                        </div>
                        <div class="t-right">
                            <span style="font-size:.78rem;color:var(--color-text-muted);" id="visibleCount"></span>
                        </div>
                    </div>

                    <!-- Bulk Actions Bar -->
                    <div class="om-bulk" id="bulkBar">
                        <div class="b-left"><span id="selCount">0</span> selected</div>
                        <div class="b-right" id="bulkActions"></div>
                    </div>
                </div>

                <!-- ══ ORDERS TABLE ══ -->
                <div id="ordersPanel" class="om-table-wrap">
                    <table class="om-table">
                        <thead>
                            <tr>
                                <th style="width:40px;text-align:center;"><input type="checkbox" id="chkAllOrders" onchange="toggleAll('orders')" style="cursor:pointer;"></th>
                                <th>Order</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th style="text-align:right;">Total</th>
                                <th style="text-align:center;">Status</th>
                                <th style="text-align:right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="orderTableBody">
                            <c:forEach var="order" items="${orderList}">
                                <tr class="order-row" data-id="${order.orderid}" data-customer="${order.fullname}"
                                    data-status="${order.status}" data-refundstatus="${order.refundStatus}"
                                    data-date="<fmt:formatDate value='${order.createdat}' pattern='yyyy-MM-dd'/>">
                                    <td style="text-align:center;">
                                        <input type="checkbox" class="row-chk" value="${order.orderid}" onchange="updateSelCount()" style="cursor:pointer;">
                                    </td>
                                    <td style="color:var(--color-text-muted);font-weight:600;">#${order.orderid}</td>
                                    <td>
                                        <div style="display:flex;align-items:center;gap:10px;">
                                            <div style="width:36px;height:36px;border-radius:50%;background:linear-gradient(135deg,#f59e0b,#d97706);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8rem;flex-shrink:0;">${order.fullname.substring(0,1)}</div>
                                            <div>
                                                <div style="font-weight:600;font-size:.87rem;color:var(--color-text-primary);">${order.fullname}</div>
                                                <div style="font-size:.76rem;color:var(--color-text-muted);">${order.phone}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-size:.84rem;color:var(--color-text-secondary);"><fmt:formatDate value="${order.createdat}" pattern="dd/MM/yyyy"/></div>
                                        <div style="font-size:.74rem;color:var(--color-text-muted);"><fmt:formatDate value="${order.createdat}" pattern="HH:mm"/></div>
                                    </td>
                                    <td style="text-align:right;font-weight:700;color:var(--color-primary);">
                                        <fmt:formatNumber value="${order.totalprice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                    </td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${order.status == 'Completed'}"><span class="s-badge s-completed"><span class="s-dot"></span>Completed</span></c:when>
                                            <c:when test="${order.status == 'Pending'}"><span class="s-badge s-pending"><span class="s-dot"></span>Pending</span></c:when>
                                            <c:when test="${order.status == 'Processing'}"><span class="s-badge s-processing"><span class="s-dot"></span>Processing</span></c:when>
                                            <c:when test="${order.status == 'Shipped'}"><span class="s-badge s-shipped"><span class="s-dot"></span>Shipped</span></c:when>
                                            <c:when test="${order.status == 'Cancelled'}"><span class="s-badge s-cancelled"><span class="s-dot"></span>Cancelled</span></c:when>
                                            <c:otherwise><span class="s-badge" style="background:#f1f5f9;color:var(--color-text-muted);">${order.status}</span></c:otherwise>
                                        </c:choose>
                                        <c:if test="${order.status eq 'Cancelled' and not empty order.refundStatus}">
                                            <br>
                                            <span style="display:inline-flex;align-items:center;gap:4px;margin-top:5px;font-size:.65rem;font-weight:700;text-transform:uppercase;background:${order.refundStatus == 'Pending' ? '#fee2e2' : '#d1fae5'};color:${order.refundStatus == 'Pending' ? '#b91c1c' : '#065f46'};padding:2px 7px;border-radius:10px;">
                                                Refund: ${order.refundStatus}
                                            </span>
                                        </c:if>
                                    </td>
                                    <td style="text-align:right;">
                                        <div style="display:flex;gap:6px;justify-content:flex-end;">
                                            <a href="${pageContext.request.contextPath}/order?action=adminViewDetail&id=${order.orderid}" class="ai-btn" title="View Details"><i class="fa-solid fa-eye"></i></a>
                                            <c:if test="${order.status == 'Cancelled' || order.status == 'Completed'}">
                                                <a href="${pageContext.request.contextPath}/order?action=adminDelete&id=${order.orderid}" class="ai-btn" title="Delete" style="background:#fef2f2;color:#dc2626;" onclick="return confirm('Permanently delete order #${order.orderid}?')"><i class="fa-solid fa-trash-can"></i></a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div id="noOrdersMsg" class="om-empty" style="display:none;">
                        <i class="fa-solid fa-box-open"></i>No records match your search.
                    </div>
                    <c:if test="${empty orderList}">
                        <div class="om-empty"><i class="fa-solid fa-inbox"></i>No orders found.</div>
                    </c:if>
                </div>

                <!-- ══ RETURNS TABLE ══ -->
                <div id="returnsPanel" class="om-table-wrap" style="display:none;">
                    <table class="om-table">
                        <thead>
                            <tr>
                                <th style="width:40px;text-align:center;"><input type="checkbox" id="chkAllReturns" onchange="toggleAll('returns')" style="cursor:pointer;"></th>
                                <th>Return ID</th>
                                <th>Order</th>
                                <th>Customer</th>
                                <th>Reason</th>
                                <th style="text-align:right;">Refund Amount</th>
                                <th style="text-align:center;">Status</th>
                                <th style="text-align:center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="returnTableBody">
                            <c:forEach var="rr" items="${returnRequests}">
                                <tr class="return-row" data-id="${rr.returnId}" data-orderid="${rr.orderId}"
                                    data-customer="${rr.customerName}" data-status="${rr.status}"
                                    data-reason="${rr.reasonType}" data-detail="${rr.reasonDetail}"
                                    data-evidence="${rr.evidenceUrls}" data-bank="${rr.bankName}"
                                    data-bankname="${rr.bankAccountName}" data-banknum="${rr.bankAccountNumber}">
                                    <td style="text-align:center;">
                                        <input type="checkbox" class="ret-chk" value="${rr.returnId}" onchange="updateSelCount()" style="cursor:pointer;">
                                    </td>
                                    <td style="font-weight:700;font-size:.82rem;color:var(--color-text-muted);">#${rr.returnId}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/order?action=adminViewDetail&id=${rr.orderId}"
                                           style="font-weight:700;color:var(--color-primary);text-decoration:none;">#${rr.orderId}</a>
                                    </td>
                                    <td>
                                        <div style="font-weight:600;font-size:.87rem;color:var(--color-text-primary);">${rr.customerName}</div>
                                        <div style="font-size:.75rem;color:var(--color-text-muted);margin-top:1px;">${rr.customerEmail}</div>
                                    </td>
                                    <td>
                                        <div style="font-size:.84rem;font-weight:600;color:var(--color-text-primary);max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${rr.reasonType}">${rr.reasonType}</div>
                                        <c:if test="${not empty rr.reasonDetail}">
                                            <div style="font-size:.74rem;color:var(--color-text-muted);max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${rr.reasonDetail}">${rr.reasonDetail}</div>
                                        </c:if>
                                    </td>
                                    <td style="text-align:right;font-weight:700;color:var(--color-primary);">
                                        <c:choose>
                                            <c:when test="${rr.refundAmount != null}"><fmt:formatNumber value="${rr.refundAmount}" type="currency" currencyCode="VND" maxFractionDigits="0"/></c:when>
                                            <c:otherwise><span style="color:var(--color-text-muted);font-weight:400;">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${rr.status == 'Pending'}"><span class="s-badge s-return-pending"><span class="s-dot"></span>Pending</span></c:when>
                                            <c:when test="${rr.status == 'Approved'}"><span class="s-badge s-approved"><span class="s-dot"></span>Approved</span></c:when>
                                            <c:when test="${rr.status == 'Rejected'}"><span class="s-badge s-rejected"><span class="s-dot"></span>Rejected</span></c:when>
                                            <c:otherwise><span class="s-badge" style="background:#f1f5f9;color:var(--color-text-muted);">${rr.status}</span></c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty rr.adminNote}">
                                            <div style="font-size:.7rem;color:var(--color-text-muted);margin-top:3px;max-width:110px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;margin:3px auto 0;" title="${rr.adminNote}">
                                                <i class="fa-solid fa-comment-dots" style="margin-right:2px;"></i>${rr.adminNote}
                                            </div>
                                        </c:if>
                                    </td>
                                    <td style="text-align:center;">
                                        <div style="display:flex;gap:6px;justify-content:center;">
                                            <c:if test="${rr.status == 'Pending'}">
                                                <button type="button" class="ai-btn approve" title="Approve" onclick="openProcessModal('Approved','${rr.returnId}','${rr.orderId}','${rr.customerName}','${rr.reasonType}')"><i class="fa-solid fa-check"></i></button>
                                                <button type="button" class="ai-btn reject" title="Reject"  onclick="openProcessModal('Rejected','${rr.returnId}','${rr.orderId}','${rr.customerName}','${rr.reasonType}')"><i class="fa-solid fa-xmark"></i></button>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/order?action=adminViewDetail&id=${rr.orderId}" class="ai-btn" title="View Order"><i class="fa-solid fa-eye"></i></a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div id="noReturnsMsg" class="om-empty" style="display:none;">
                        <i class="fa-solid fa-rotate-left"></i>No return requests match your search.
                    </div>
                    <c:if test="${empty returnRequests}">
                        <div class="om-empty"><i class="fa-solid fa-inbox"></i>No return requests yet.</div>
                    </c:if>
                </div>

            </div><!-- /om-card -->

        </div>
    </main>

    <!-- ══ Process Return Modal ══ -->
    <div id="processModal" class="pm-overlay">
        <div class="pm-modal">
            <h3 id="pmTitle"></h3>
            <p>Admin note will be sent to the customer.</p>
            <div class="pm-modal-info">
                <div style="display:flex;gap:20px;">
                    <div style="flex:1;"><div class="pm-modal-info-lbl">Customer</div><div id="pmCustomer" style="font-weight:500;margin-top:2px;"></div></div>
                    <div><div class="pm-modal-info-lbl">Order</div><div id="pmOrder" style="font-weight:500;margin-top:2px;"></div></div>
                </div>
                <div style="margin-top:10px;"><div class="pm-modal-info-lbl">Reason</div><div id="pmReason" style="font-weight:500;margin-top:2px;"></div></div>
                <div id="pmEvidenceWrap" style="margin-top:10px;">
                    <div class="pm-modal-info-lbl">Evidence</div>
                    <div id="pmEvidence" style="display:flex;flex-wrap:wrap;gap:6px;margin-top:6px;"></div>
                </div>
            </div>
            <form action="${pageContext.request.contextPath}/order" method="POST">
                <input type="hidden" name="action" value="processReturn">
                <input type="hidden" name="from" value="list">
                <input type="hidden" id="pmReturnId" name="returnId" value="">
                <input type="hidden" id="pmOrderId" name="orderId" value="">
                <input type="hidden" id="pmStatus" name="newStatus" value="">
                <label style="font-size:.76rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:.5px;display:block;margin-bottom:6px;">Admin note (optional)</label>
                <textarea name="adminNote" rows="3" placeholder="Leave a note for the customer..."></textarea>
                <div class="pm-modal-actions">
                    <button type="button" class="pm-modal-btn cancel" onclick="closeProcessModal()">Cancel</button>
                    <button type="submit" id="pmConfirmBtn" class="pm-modal-btn">Confirm</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Evidence Lightbox -->
    <div id="omLightbox" onclick="closeLightbox()">
        <button onclick="closeLightbox()" style="position:absolute;top:20px;right:24px;background:rgba(255,255,255,.15);border:none;color:#fff;width:40px;height:40px;border-radius:50%;font-size:20px;cursor:pointer;display:flex;align-items:center;justify-content:center;backdrop-filter:blur(4px);">&times;</button>
        <img id="omLbImg" src="" alt="" style="max-width:90vw;max-height:85vh;border-radius:12px;box-shadow:0 20px 60px rgba(0,0,0,.5);object-fit:contain;" onclick="event.stopPropagation()">
    </div>

<script>
var CTX = '${pageContext.request.contextPath}';
var currentTab = 'orders';

/* ── Tab Switch ── */
function switchTab(tab) {
    currentTab = tab;
    document.getElementById('tabOrders').classList.toggle('active', tab === 'orders');
    document.getElementById('tabReturns').classList.toggle('active', tab === 'returns');
    document.getElementById('ordersPanel').style.display = tab === 'orders' ? '' : 'none';
    document.getElementById('returnsPanel').style.display = tab === 'returns' ? '' : 'none';
    document.getElementById('ordersFilters').style.display = tab === 'orders' ? 'flex' : 'none';
    document.getElementById('returnsFilters').style.display = tab === 'returns' ? 'flex' : 'none';
    clearAllSelections();
    if (tab === 'orders') applyOrderFilters(); else applyReturnFilters();
}

/* ── Stat computation ── */
function computeStats() {
    var orders = document.querySelectorAll('tr.order-row');
    var total = orders.length, pending = 0, completed = 0;
    orders.forEach(function(r) {
        var s = r.getAttribute('data-status');
        if (s === 'Pending') pending++;
        if (s === 'Completed') completed++;
    });
    document.getElementById('statTotalOrders').textContent = total;
    document.getElementById('statPendingOrders').textContent = pending;
    document.getElementById('statCompletedOrders').textContent = completed;
    document.getElementById('tabOrdersBadge').textContent = total;

    var returns = document.querySelectorAll('tr.return-row');
    var activePending = 0;
    returns.forEach(function(r) { if (r.getAttribute('data-status') === 'Pending') activePending++; });
    document.getElementById('statActiveReturns').textContent = activePending;
    document.getElementById('tabReturnsBadge').textContent = returns.length;
}

/* ── Orders Filter ── */
function applyOrderFilters() {
    var fId = document.getElementById('filterOrderId').value.trim().replace('#','');
    var fCust = document.getElementById('filterCustomer').value.trim().toLowerCase();
    var fStatus = document.getElementById('filterOrderStatus').value;
    var fDate = document.getElementById('filterDate').value;
    var rows = document.querySelectorAll('tr.order-row');
    var visible = 0;
    rows.forEach(function(row) {
        var show = true;
        if (fId && row.getAttribute('data-id') !== fId) show = false;
        if (fCust && (row.getAttribute('data-customer')||'').toLowerCase().indexOf(fCust) === -1) show = false;
        if (fStatus) {
            if (fStatus === 'RefundPending') {
                if (row.getAttribute('data-status') !== 'Cancelled' || row.getAttribute('data-refundstatus') !== 'Pending') show = false;
            } else if (row.getAttribute('data-status') !== fStatus) show = false;
        }
        if (fDate && row.getAttribute('data-date') !== fDate) show = false;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });
    document.getElementById('noOrdersMsg').style.display = (visible === 0 && rows.length > 0) ? 'block' : 'none';
    document.getElementById('visibleCount').textContent = visible + ' / ' + rows.length + ' orders';
}

/* ── Returns Filter ── */
function applyReturnFilters() {
    var fSearch = document.getElementById('filterReturnSearch').value.trim().toLowerCase();
    var fStatus = document.getElementById('filterReturnStatus').value;
    var rows = document.querySelectorAll('tr.return-row');
    var visible = 0;
    rows.forEach(function(row) {
        var show = true;
        if (fSearch) {
            var cust = (row.getAttribute('data-customer')||'').toLowerCase();
            var oid = (row.getAttribute('data-orderid')||'');
            if (cust.indexOf(fSearch) === -1 && oid.indexOf(fSearch) === -1) show = false;
        }
        if (fStatus && row.getAttribute('data-status') !== fStatus) show = false;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });
    document.getElementById('noReturnsMsg').style.display = (visible === 0 && rows.length > 0) ? 'block' : 'none';
    document.getElementById('visibleCount').textContent = visible + ' / ' + rows.length + ' returns';
}

/* ── Selection & Bulk Bar ── */
function toggleAll(tab) {
    var chkClass = tab === 'orders' ? '.row-chk' : '.ret-chk';
    var src = document.getElementById(tab === 'orders' ? 'chkAllOrders' : 'chkAllReturns');
    document.querySelectorAll(chkClass).forEach(function(c) { c.checked = src.checked; });
    updateSelCount();
}

function updateSelCount() {
    var chkClass = currentTab === 'orders' ? '.row-chk:checked' : '.ret-chk:checked';
    var n = document.querySelectorAll(chkClass).length;
    document.getElementById('selCount').textContent = n;

    var bulk = document.getElementById('bulkBar');
    var defBar = document.getElementById('defaultBar');
    if (n > 0) {
        bulk.classList.add('show');
        defBar.style.display = 'none';
        renderBulkActions(currentTab);
    } else {
        bulk.classList.remove('show');
        defBar.style.display = 'flex';
    }

    var allChk = currentTab === 'orders' ? 'chkAllOrders' : 'chkAllReturns';
    if (!n) document.getElementById(allChk).checked = false;
}

function renderBulkActions(tab) {
    var container = document.getElementById('bulkActions');
    if (tab === 'orders') {
        container.innerHTML =
            '<button class="om-btn danger" onclick="bulkDeleteOrders()"><i class="fa-solid fa-trash-can"></i> Delete</button>' +
            '<button class="om-btn close-btn" onclick="clearAllSelections()"><i class="fa-solid fa-xmark"></i></button>';
    } else {
        container.innerHTML =
            '<button class="om-btn approve" onclick="bulkApproveReturns()"><i class="fa-solid fa-check"></i> Approve</button>' +
            '<button class="om-btn reject" onclick="bulkRejectReturns()"><i class="fa-solid fa-xmark"></i> Reject</button>' +
            '<button class="om-btn close-btn" onclick="clearAllSelections()"><i class="fa-solid fa-xmark"></i></button>';
    }
}

function clearAllSelections() {
    document.querySelectorAll('.row-chk, .ret-chk, #chkAllOrders, #chkAllReturns').forEach(function(c) { c.checked = false; });
    document.getElementById('bulkBar').classList.remove('show');
    document.getElementById('defaultBar').style.display = 'flex';
}

function getSelectedIds(selector) {
    return [...document.querySelectorAll(selector)].map(function(c) { return c.value; });
}

/* ── Bulk Order Delete ── */
function bulkDeleteOrders() {
    var ids = getSelectedIds('.row-chk:checked');
    if (!ids.length) return;
    if (!confirm('Delete ' + ids.length + ' selected order(s)? This cannot be undone.')) return;
    Promise.all(ids.map(function(id) {
        return fetch(CTX + '/order?action=adminDelete&id=' + id, { method:'GET' });
    })).then(function() { location.reload(); });
}

/* ── Bulk Return Actions ── */
function bulkApproveReturns() { bulkProcessReturns('Approved'); }
function bulkRejectReturns()  { bulkProcessReturns('Rejected'); }
function bulkProcessReturns(status) {
    var ids = getSelectedIds('.ret-chk:checked');
    if (!ids.length) return;
    if (!confirm(status + ' ' + ids.length + ' return(s)?')) return;
    var formData = new FormData();
    formData.append('action', 'processReturnBulk');
    formData.append('newStatus', status);
    ids.forEach(function(id) { formData.append('returnIds', id); });
    // Fallback: navigate to the first one with modal — or submit individual forms
    // For now use sequential fetch if backend supports it, else redirect
    Promise.all(ids.map(function(id) {
        var params = 'action=processReturn&returnId=' + id + '&newStatus=' + status + '&from=list&adminNote=Bulk+' + status;
        return fetch(CTX + '/order', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: params });
    })).then(function() { location.reload(); });
}

/* ── Process Return Modal (single) ── */
function openProcessModal(status, returnId, orderId, customer, reason) {
    document.getElementById('pmReturnId').value = returnId;
    document.getElementById('pmOrderId').value = orderId;
    document.getElementById('pmStatus').value = status;
    document.getElementById('pmCustomer').textContent = customer;
    document.getElementById('pmOrder').textContent = '#' + orderId;
    document.getElementById('pmReason').textContent = reason;

    var row = document.querySelector('tr[data-id="' + returnId + '"]');
    var evidStr = row ? row.getAttribute('data-evidence') : '';
    var evCont = document.getElementById('pmEvidence');
    var evWrap = document.getElementById('pmEvidenceWrap');
    evCont.innerHTML = '';
    if (evidStr && evidStr.trim()) {
        evWrap.style.display = 'block';
        evidStr.split(',').forEach(function(url) {
            url = url.trim(); if (!url) return;
            var img = document.createElement('img');
            img.src = CTX + '/uploads/' + url;
            img.style.cssText = 'width:58px;height:58px;object-fit:cover;border-radius:6px;border:1px solid #e2e8f0;cursor:pointer;transition:opacity .2s;';
            img.onmouseover = function() { this.style.opacity = '.7'; };
            img.onmouseout  = function() { this.style.opacity = '1'; };
            img.onclick = (function(src) { return function() { openLightbox(src); }; })(CTX + '/uploads/' + url);
            evCont.appendChild(img);
        });
    } else { evWrap.style.display = 'none'; }

    var title = document.getElementById('pmTitle');
    var btn   = document.getElementById('pmConfirmBtn');
    if (status === 'Approved') {
        title.textContent = 'Approve Return Request';
        title.style.color = '#065f46';
        btn.style.background = '#10b981';
        btn.style.color = '#fff';
        btn.textContent = '✓ Approve';
    } else {
        title.textContent = 'Reject Return Request';
        title.style.color = '#b91c1c';
        btn.style.background = '#ef4444';
        btn.style.color = '#fff';
        btn.textContent = '✕ Reject';
    }
    document.getElementById('processModal').classList.add('open');
}

function closeProcessModal() { document.getElementById('processModal').classList.remove('open'); }
document.getElementById('processModal').addEventListener('click', function(e) { if (e.target === this) closeProcessModal(); });

/* ── Lightbox ── */
function openLightbox(src) {
    document.getElementById('omLbImg').src = src;
    var lb = document.getElementById('omLightbox');
    lb.style.display = 'flex';
    document.body.style.overflow = 'hidden';
}
function closeLightbox() {
    document.getElementById('omLightbox').style.display = 'none';
    document.body.style.overflow = '';
}

/* ── Event Bindings ── */
document.getElementById('filterOrderId').addEventListener('input', applyOrderFilters);
document.getElementById('filterCustomer').addEventListener('input', applyOrderFilters);
document.getElementById('filterOrderStatus').addEventListener('change', applyOrderFilters);
document.getElementById('filterDate').addEventListener('change', applyOrderFilters);
document.getElementById('btnResetOrders').addEventListener('click', function() {
    ['filterOrderId','filterCustomer'].forEach(function(id) { document.getElementById(id).value = ''; });
    document.getElementById('filterOrderStatus').value = '';
    document.getElementById('filterDate').value = '';
    applyOrderFilters();
});
document.getElementById('filterReturnSearch').addEventListener('input', applyReturnFilters);
document.getElementById('filterReturnStatus').addEventListener('change', applyReturnFilters);
document.getElementById('btnResetReturns').addEventListener('click', function() {
    document.getElementById('filterReturnSearch').value = '';
    document.getElementById('filterReturnStatus').value = '';
    applyReturnFilters();
});
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') { closeProcessModal(); closeLightbox(); }
});

/* ── Init: auto-switch tab based on URL params ── */
(function() {
    var params = new URLSearchParams(window.location.search);
    // If redirected from processReturn (update=success/error), open Returns tab
    if (params.get('update')) {
        switchTab('returns');
    } else {
        computeStats();
        applyOrderFilters();
    }
    // Clean flash params from URL without reload
    if (params.get('update') || params.get('delete')) {
        var clean = new URL(window.location.href);
        clean.searchParams.delete('update');
        clean.searchParams.delete('delete');
        window.history.replaceState({}, '', clean.toString());
    }
})();
</script>
</body>
</html>
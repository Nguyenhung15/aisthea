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

                    .status-ReturnApproved {
                        background: #ecfdf5;
                        color: #059669;
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

                                    <%-- Return Request Panel (admin view) --%>
                                    <c:if test="${not empty returnRequest}">
                                        <c:set var="rBorder" value="#f59e0b" />
                                        <c:if test="${returnRequest.status == 'Approved'}"><c:set var="rBorder" value="#10b981" /></c:if>
                                        <c:if test="${returnRequest.status == 'Rejected'}"><c:set var="rBorder" value="#ef4444" /></c:if>
                                        <c:set var="rBadgeBg" value="#fef3c7" />
                                        <c:set var="rBadgeColor" value="#d97706" />
                                        <c:if test="${returnRequest.status == 'Approved'}"><c:set var="rBadgeBg" value="#d1fae5"/><c:set var="rBadgeColor" value="#065f46"/></c:if>
                                        <c:if test="${returnRequest.status == 'Rejected'}"><c:set var="rBadgeBg" value="#fee2e2"/><c:set var="rBadgeColor" value="#b91c1c"/></c:if>

                                        <div class="detail-card" style="margin-top:var(--space-xl);border-left:4px solid ${rBorder};">
                                            <h3 class="detail-card__title">
                                                <i class="fa-solid fa-rotate-left" style="margin-right:8px;font-size:0.9rem;"></i>Yêu Cầu Hoàn Trả
                                                <span style="float:right;font-size:0.7rem;padding:3px 10px;border-radius:99px;font-weight:700;background:${rBadgeBg};color:${rBadgeColor};">
                                                    ${returnRequest.status}
                                                </span>
                                            </h3>
                                            <div class="info-row">
                                                <span class="info-row__label">Lý do</span>
                                                <span class="info-row__value">${returnRequest.reasonType}</span>
                                            </div>
                                            <c:if test="${not empty returnRequest.reasonDetail}">
                                                <div class="info-row">
                                                    <span class="info-row__label">Chi tiết</span>
                                                    <span class="info-row__value" style="max-width:280px;">${returnRequest.reasonDetail}</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty returnRequest.evidenceUrls}">
                                                <div class="info-row">
                                                    <span class="info-row__label">Bằng chứng</span>
                                                    <a href="${returnRequest.evidenceUrls}" target="_blank" class="info-row__value" style="color:#0288D1;text-decoration:underline;">Xem link</a>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty returnRequest.bankName}">
                                                <div class="info-row"><span class="info-row__label">Ngân hàng</span><span class="info-row__value">${returnRequest.bankName}</span></div>
                                                <div class="info-row"><span class="info-row__label">Tên TK</span><span class="info-row__value">${returnRequest.bankAccountName}</span></div>
                                                <div class="info-row"><span class="info-row__label">Số TK</span><span class="info-row__value" style="font-weight:700;letter-spacing:1px;">${returnRequest.bankAccountNumber}</span></div>
                                            </c:if>
                                            <div class="info-row">
                                                <span class="info-row__label">Hoàn tiền</span>
                                                <span class="info-row__value" style="font-weight:700;color:#0288D1;">
                                                    <fmt:formatNumber value="${returnRequest.refundAmount}" type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                </span>
                                            </div>
                                            <div class="info-row" style="border-bottom:none;">
                                                <span class="info-row__label">Ngày gửi</span>
                                                <span class="info-row__value" style="font-size:0.78rem;">
                                                    <fmt:formatDate value="${returnRequest.createdAt}" pattern="HH:mm dd/MM/yyyy" />
                                                </span>
                                            </div>
                                            <c:if test="${returnRequest.status == 'Pending'}">
                                                <div style="margin-top:var(--space-md);padding-top:var(--space-md);border-top:1px solid var(--color-border-light);display:flex;gap:10px;">
                                                    <button onclick="openReturnDecision('Approved')" style="flex:1;padding:10px;border:none;border-radius:8px;background:#10b981;color:#fff;font-weight:700;font-size:0.8rem;cursor:pointer;">
                                                        <i class="fa-solid fa-check" style="margin-right:6px;"></i>Chấp nhận
                                                    </button>
                                                    <button onclick="openReturnDecision('Rejected')" style="flex:1;padding:10px;border:none;border-radius:8px;background:#ef4444;color:#fff;font-weight:700;font-size:0.8rem;cursor:pointer;">
                                                        <i class="fa-solid fa-xmark" style="margin-right:6px;"></i>Từ chối
                                                    </button>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty returnRequest.adminNote}">
                                                <div style="margin-top:10px;padding:10px;background:#f8fafc;border-radius:8px;font-size:0.82rem;color:#64748b;">
                                                    <strong>Ghi chú admin:</strong> ${returnRequest.adminNote}
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:if>

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
                                            
                                            <div class="info-row">
                                                <span class="info-row__label">Subtotal</span>
                                                <span class="info-row__value">
                                                    <fmt:formatNumber value="${order.totalprice + (order.discountAmount != null ? order.discountAmount : 0)}" type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                </span>
                                            </div>
                                            
                                            <c:if test="${not empty order.voucher}">
                                                <div class="info-row">
                                                    <span class="info-row__label">Voucher 
                                                        <span style="font-size:0.7rem; background:#e0f2fe; color:#0284c7; padding:2px 6px; border-radius:4px; margin-left:4px;">${order.voucher.code} <c:if test="${order.voucher.discountType eq 'PERCENT'}">(${order.voucher.discountValue}%)</c:if></span>
                                                    </span>
                                                    <span class="info-row__value" style="color:#10b981;">
                                                        - <fmt:formatNumber value="${order.discountAmount}" type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                    </span>
                                                </div>
                                            </c:if>

                                            <div class="info-row" style="border-bottom:none;">
                                                <span class="info-row__label"
                                                    style="font-size:0.92rem;color:var(--color-text-primary);">Total</span>
                                                <span
                                                    style="font-family:var(--font-serif);font-size:1.5rem;font-weight:700;color:var(--color-primary);">
                                                    <fmt:formatNumber value="${order.totalprice}" type="currency"
                                                        currencyCode="VND" maxFractionDigits="0" />
                                                </span>
                                            </div>

                                            <c:if test="${order.status eq 'Cancelled' and not empty order.cancelReason}">
                                                <div style="margin-top:var(--space-md);padding:14px;background:#fef2f2;border:1px solid #fecaca;border-radius:var(--radius-md);">
                                                    <h4 style="font-size:0.75rem;font-weight:700;color:#dc2626;text-transform:uppercase;margin-bottom:4px;">Lý do Hủy</h4>
                                                    <p style="font-size:0.85rem;color:#7f1d1d;line-height:1.4;word-wrap:break-word;">${order.cancelReason}</p>
                                                    <c:if test="${not empty order.refundStatus}">
                                                        <div style="margin-top:8px; display:flex; align-items:center; gap:10px;">
                                                            <div style="font-size:0.75rem;font-weight:600;display:inline-block;padding:3px 8px;border-radius:4px;background:${order.refundStatus == 'Pending' ? '#fee2e2' : '#d1fae5'};color:${order.refundStatus == 'Pending' ? '#b91c1c' : '#065f46'};">
                                                                Refund: ${order.refundStatus}
                                                            </div>
                                                            <c:if test="${order.refundStatus == 'Pending'}">
                                                                <form action="${pageContext.request.contextPath}/order" method="POST" style="margin:0;">
                                                                    <input type="hidden" name="action" value="adminMarkRefunded">
                                                                    <input type="hidden" name="orderId" value="${order.orderid}">
                                                                    <button type="submit" onclick="return confirm('Xác nhận Đã hoàn tiền cho khách hàng?');" style="background:#dc2626;color:white;border:none;border-radius:4px;padding:3px 10px;font-size:0.75rem;cursor:pointer;font-weight:600;transition:opacity 0.2s;" onmouseover="this.style.opacity='0.8'" onmouseout="this.style.opacity='1'">
                                                                        Xác nhận Hoàn Tiền
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:if>

                                            <!-- Update Status -->
                                            <div
                                                style="margin-top:var(--space-xl);padding-top:var(--space-lg);border-top:1px solid var(--color-border-light);">
                                                <h4
                                                    style="font-size:0.78rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;margin-bottom:var(--space-md);">
                                                    Update Status</h4>
                                                <form id="updateStatusForm" action="${pageContext.request.contextPath}/order" method="POST"
                                                    style="display:flex;gap:10px;">
                                                    <input type="hidden" name="action" value="adminUpdateStatus">
                                                    <input type="hidden" name="orderId" value="${order.orderid}">
                                                    <select name="newStatus" id="newStatusSelect" class="lux-form-select" style="flex:1;" onchange="toggleCancelReason()">
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
                                                <div id="adminCancelReasonBox" style="margin-top:10px; display:none;">
                                                    <input type="text" name="cancelReason" form="updateStatusForm" placeholder="Nhập lý do hủy (bắt buộc nếu Cancel)" class="lux-form-select" style="border-color:#fca5a5; background:#fff2f2;" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </main>

                        <%-- Return decision modal --%>
                        <div id="returnDecisionModal" style="display:none;position:fixed;inset:0;background:rgba(15,23,42,.45);backdrop-filter:blur(4px);z-index:999;justify-content:center;align-items:center;">
                            <div style="background:#fff;border-radius:16px;padding:32px;width:100%;max-width:440px;box-shadow:0 20px 60px rgba(0,0,0,.15);">
                                <h3 id="returnDecisionTitle" style="font-size:1.1rem;font-weight:700;margin-bottom:8px;">Xử lý yêu cầu hoàn trả</h3>
                                <p style="font-size:0.85rem;color:#64748b;margin-bottom:16px;">Ghi chú sẽ được gửi đến khách hàng qua thông báo.</p>
                                <form action="${pageContext.request.contextPath}/order" method="POST">
                                    <input type="hidden" name="action" value="processReturn">
                                    <input type="hidden" name="returnId" value="${returnRequest.returnId}">
                                    <input type="hidden" name="orderId" value="${order.orderid}">
                                    <input type="hidden" id="returnDecisionStatus" name="newStatus" value="">
                                    <textarea name="adminNote" rows="3"
                                        style="width:100%;border:1.5px solid #e2e8f0;border-radius:10px;padding:10px 14px;font-size:0.88rem;outline:none;resize:vertical;box-sizing:border-box;"
                                        placeholder="Nhập ghi chú cho khách hàng (tuỳ chọn)..."></textarea>
                                    <div style="display:flex;gap:10px;margin-top:16px;">
                                        <button type="button" onclick="document.getElementById('returnDecisionModal').style.display='none'"
                                            style="flex:1;padding:10px;border:1px solid #e2e8f0;border-radius:8px;background:#f1f5f9;font-weight:600;font-size:0.82rem;cursor:pointer;">Huỷ</button>
                                        <button type="submit" id="returnDecisionBtn"
                                            style="flex:1;padding:10px;border:none;border-radius:8px;color:#fff;font-weight:700;font-size:0.82rem;cursor:pointer;">Xác nhận</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <script>
                            function toggleCancelReason() {
                                var val = document.getElementById('newStatusSelect').value;
                                document.getElementById('adminCancelReasonBox').style.display = (val === 'Cancelled') ? 'block' : 'none';
                            }
                            window.onload = toggleCancelReason;

                            function openReturnDecision(status) {
                                var modal = document.getElementById('returnDecisionModal');
                                var title = document.getElementById('returnDecisionTitle');
                                var btn   = document.getElementById('returnDecisionBtn');
                                document.getElementById('returnDecisionStatus').value = status;
                                if (status === 'Approved') {
                                    title.textContent = 'Chấp nhận yêu cầu hoàn trả';
                                    btn.style.background = '#10b981';
                                    btn.textContent = 'Xác nhận Chấp nhận';
                                } else {
                                    title.textContent = 'Từ chối yêu cầu hoàn trả';
                                    btn.style.background = '#ef4444';
                                    btn.textContent = 'Xác nhận Từ chối';
                                }
                                modal.style.display = 'flex';
                            }
                        </script>
            </body>

            </html>
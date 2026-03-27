<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Return Requests — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <style>
                    /* ── Return Status Badges ── */
                    .return-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 5px 14px;
                        border-radius: 999px;
                        font-size: 0.72rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .return-badge--Pending {
                        background: #fef3c7;
                        color: #d97706;
                    }

                    .return-badge--Approved {
                        background: #d1fae5;
                        color: #065f46;
                    }

                    .return-badge--Rejected {
                        background: #fee2e2;
                        color: #b91c1c;
                    }

                    /* ── Filter Bar ── */
                    .return-filter-bar {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 12px;
                        align-items: center;
                        padding: 16px 0 0;
                    }

                    .return-filter-bar__select {
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

                    .return-filter-bar__select:hover,
                    .return-filter-bar__select:focus {
                        background-color: var(--color-primary);
                        color: var(--color-white);
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='white' viewBox='0 0 16 16'%3E%3Cpath d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E");
                    }

                    .return-filter-bar__input {
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
                        min-width: 180px;
                    }

                    .return-filter-bar__input:focus {
                        border-color: var(--color-primary);
                        box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.08);
                    }

                    .return-filter-bar__input::placeholder {
                        color: var(--color-text-muted);
                    }

                    .return-filter-bar__group {
                        position: relative;
                        display: inline-flex;
                        align-items: center;
                    }

                    .return-filter-bar__icon {
                        position: absolute;
                        left: 14px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: var(--color-text-muted);
                        font-size: 0.78rem;
                        pointer-events: none;
                    }

                    .return-filter-bar__reset {
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

                    .return-filter-bar__reset:hover {
                        background: var(--color-bg);
                        color: var(--color-primary);
                        border-color: var(--color-primary);
                    }

                    .return-filter-bar__count {
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

                    /* ── Summary Stats ── */
                    .return-stats {
                        display: flex;
                        gap: 16px;
                        margin-bottom: var(--space-xl);
                    }

                    .return-stat-card {
                        flex: 1;
                        background: var(--color-white);
                        border-radius: var(--radius-xl);
                        box-shadow: var(--shadow-card);
                        padding: 20px 24px;
                        display: flex;
                        align-items: center;
                        gap: 16px;
                        transition: transform 0.2s ease, box-shadow 0.2s ease;
                    }

                    .return-stat-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
                    }

                    .return-stat-card__icon {
                        width: 48px;
                        height: 48px;
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.1rem;
                        flex-shrink: 0;
                    }

                    .return-stat-card__number {
                        font-family: var(--font-serif);
                        font-size: 1.6rem;
                        font-weight: 700;
                        color: var(--color-primary);
                        line-height: 1;
                    }

                    .return-stat-card__label {
                        font-size: 0.75rem;
                        font-weight: 600;
                        color: var(--color-text-muted);
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        margin-top: 2px;
                    }

                    /* ── Reason text truncate ── */
                    .reason-text {
                        max-width: 200px;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    /* ── Action buttons ── */
                    .action-btn {
                        width: 30px;
                        height: 30px;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 6px;
                        border: none;
                        cursor: pointer;
                        font-size: 0.75rem;
                        transition: all 0.2s ease;
                    }

                    .action-btn--approve {
                        background: #d1fae5;
                        color: #065f46;
                    }
                    .action-btn--approve:hover {
                        background: #10b981;
                        color: #fff;
                    }

                    .action-btn--reject {
                        background: #fee2e2;
                        color: #b91c1c;
                    }
                    .action-btn--reject:hover {
                        background: #ef4444;
                        color: #fff;
                    }

                    .action-btn--view {
                        background: var(--color-bg);
                        color: var(--color-text-secondary);
                    }
                    .action-btn--view:hover {
                        background: var(--color-primary);
                        color: #fff;
                    }

                    /* ── Modal ── */
                    .return-modal-overlay {
                        display: none;
                        position: fixed;
                        inset: 0;
                        background: rgba(15, 23, 42, 0.45);
                        backdrop-filter: blur(4px);
                        z-index: 999;
                        justify-content: center;
                        align-items: center;
                    }

                    .return-modal {
                        background: #fff;
                        border-radius: 16px;
                        padding: 32px;
                        width: 100%;
                        max-width: 480px;
                        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
                        animation: modalIn 0.2s ease;
                    }

                    @keyframes modalIn {
                        from { transform: scale(0.95); opacity:0; }
                        to   { transform: scale(1); opacity:1; }
                    }

                    .return-modal__title {
                        font-family: var(--font-serif);
                        font-size: 1.15rem;
                        font-weight: 700;
                        color: var(--color-primary);
                        margin-bottom: 6px;
                    }

                    .return-modal__subtitle {
                        font-size: 0.82rem;
                        color: var(--color-text-muted);
                        margin-bottom: 20px;
                    }

                    .return-modal__info {
                        background: #f8fafc;
                        border-radius: 10px;
                        padding: 14px 16px;
                        margin-bottom: 16px;
                        font-size: 0.82rem;
                        line-height: 1.6;
                    }

                    .return-modal__info-label {
                        font-weight: 600;
                        color: var(--color-text-muted);
                        font-size: 0.72rem;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .return-modal__info-value {
                        color: var(--color-text-primary);
                        font-weight: 500;
                    }

                    .return-modal textarea {
                        width: 100%;
                        border: 1.5px solid #e2e8f0;
                        border-radius: 10px;
                        padding: 10px 14px;
                        font-family: var(--font-sans);
                        font-size: 0.88rem;
                        outline: none;
                        resize: vertical;
                        box-sizing: border-box;
                        transition: border-color 0.2s;
                    }

                    .return-modal textarea:focus {
                        border-color: var(--color-primary);
                    }

                    .return-modal__actions {
                        display: flex;
                        gap: 10px;
                        margin-top: 16px;
                    }

                    .return-modal__btn {
                        flex: 1;
                        padding: 11px;
                        border-radius: 8px;
                        font-weight: 700;
                        font-size: 0.82rem;
                        cursor: pointer;
                        transition: opacity 0.2s;
                    }

                    .return-modal__btn:hover {
                        opacity: 0.85;
                    }

                    .return-modal__btn--cancel {
                        border: 1px solid #e2e8f0;
                        background: #f1f5f9;
                        color: var(--color-text-secondary);
                    }

                    .return-modal__btn--confirm {
                        border: none;
                        color: #fff;
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
                                        <h1 class="lux-page-header__title">Return Requests</h1>
                                        <p class="lux-page-header__subtitle">Quản lý tất cả yêu cầu hoàn trả / hoàn
                                            tiền từ khách hàng.</p>
                                    </div>
                                </section>

                                <!-- Success / Error Messages -->
                                <c:if test="${param.update == 'success'}">
                                    <div
                                        style="background:var(--color-success-bg);color:var(--color-success-text);padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                        <i class="fa-solid fa-circle-check" style="margin-right:8px;"></i>Xử lý yêu cầu
                                        hoàn trả thành công!
                                    </div>
                                </c:if>
                                <c:if test="${param.update == 'error'}">
                                    <div
                                        style="background:#fef2f2;color:#dc2626;padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                        <i class="fa-solid fa-circle-exclamation"
                                            style="margin-right:8px;"></i>Đã xảy ra lỗi khi xử lý yêu cầu.
                                    </div>
                                </c:if>

                                <!-- Summary Stats -->
                                <div class="return-stats">
                                    <div class="return-stat-card">
                                        <div class="return-stat-card__icon"
                                            style="background:#fef3c7;color:#d97706;">
                                            <i class="fa-solid fa-clock"></i>
                                        </div>
                                        <div>
                                            <div class="return-stat-card__number" id="statPending">0</div>
                                            <div class="return-stat-card__label">Đang chờ</div>
                                        </div>
                                    </div>
                                    <div class="return-stat-card">
                                        <div class="return-stat-card__icon"
                                            style="background:#d1fae5;color:#065f46;">
                                            <i class="fa-solid fa-check-circle"></i>
                                        </div>
                                        <div>
                                            <div class="return-stat-card__number" id="statApproved">0</div>
                                            <div class="return-stat-card__label">Đã chấp nhận</div>
                                        </div>
                                    </div>
                                    <div class="return-stat-card">
                                        <div class="return-stat-card__icon"
                                            style="background:#fee2e2;color:#b91c1c;">
                                            <i class="fa-solid fa-times-circle"></i>
                                        </div>
                                        <div>
                                            <div class="return-stat-card__number" id="statRejected">0</div>
                                            <div class="return-stat-card__label">Đã từ chối</div>
                                        </div>
                                    </div>
                                    <div class="return-stat-card">
                                        <div class="return-stat-card__icon"
                                            style="background:#ede9fe;color:#7c3aed;">
                                            <i class="fa-solid fa-rotate-left"></i>
                                        </div>
                                        <div>
                                            <div class="return-stat-card__number" id="statTotal">0</div>
                                            <div class="return-stat-card__label">Tổng yêu cầu</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Table Card -->
                                <div
                                    style="background:var(--color-white);border-radius:var(--radius-xl);box-shadow:var(--shadow-card);overflow:hidden;">

                                    <!-- Header + Filter -->
                                    <div
                                        style="padding:var(--space-xl);border-bottom:1px solid var(--color-border-light);">
                                        <div style="display:flex;justify-content:space-between;align-items:center;">
                                            <div>
                                                <h2
                                                    style="font-family:var(--font-serif);font-size:1.3rem;font-weight:700;color:var(--color-primary);margin:0;">
                                                    Tất cả yêu cầu hoàn trả</h2>
                                                <p style="font-size:0.82rem;color:var(--color-text-muted);margin:4px 0 0;">
                                                    Xem xét và xử lý yêu cầu hoàn trả từ khách hàng</p>
                                            </div>
                                            <span class="return-filter-bar__count" id="returnCount"
                                                title="Showing returns"></span>
                                        </div>

                                        <!-- Filter Bar -->
                                        <div class="return-filter-bar">
                                            <span class="return-filter-bar__group">
                                                <i class="fa-solid fa-magnifying-glass return-filter-bar__icon"></i>
                                                <input type="text" id="filterSearch" class="return-filter-bar__input"
                                                    placeholder="Tìm theo tên KH hoặc mã đơn...">
                                            </span>

                                            <select id="filterStatus" class="return-filter-bar__select">
                                                <option value="">Tất cả trạng thái</option>
                                                <option value="Pending">Đang chờ</option>
                                                <option value="Approved">Đã chấp nhận</option>
                                                <option value="Rejected">Đã từ chối</option>
                                            </select>

                                            <button type="button" id="btnReset" class="return-filter-bar__reset">
                                                <i class="fa-solid fa-rotate-left"></i> Reset
                                            </button>
                                        </div>
                                    </div>

                                    <table style="width:100%;border-collapse:collapse;">
                                        <thead>
                                            <tr style="background:var(--color-bg);">
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    #ID</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Đơn hàng</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Khách hàng</th>
                                                <th
                                                    style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Lý do</th>
                                                <th
                                                    style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Hoàn tiền</th>
                                                <th
                                                    style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Ngày gửi</th>
                                                <th
                                                    style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Trạng thái</th>
                                                <th
                                                    style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                    Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody id="returnTableBody">
                                            <c:forEach var="rr" items="${returnRequests}">
                                                <tr class="return-row" data-status="${rr.status}"
                                                    data-orderid="${rr.orderId}"
                                                    data-returnid="${rr.returnId}"
                                                    data-customer="${rr.customerName}"
                                                    data-reason="${rr.reasonType}"
                                                    data-detail="${rr.reasonDetail}"
                                                    data-evidence="${rr.evidenceUrls}"
                                                    data-bank="${rr.bankName}"
                                                    data-bankname="${rr.bankAccountName}"
                                                    data-banknum="${rr.bankAccountNumber}"
                                                    style="border-bottom:1px solid var(--color-border-light);transition:background 0.15s ease;user-select:none;"
                                                    onmouseover="this.style.background='var(--color-bg)'"
                                                    onmouseout="this.style.background='transparent'">
                                                    <td style="padding:16px 20px;">
                                                        <span
                                                            style="font-weight:700;font-size:0.82rem;color:var(--color-text-muted);">#${rr.returnId}</span>
                                                    </td>
                                                    <td style="padding:16px 20px;">
                                                        <span style="font-weight:700;font-size:0.88rem;color:var(--color-primary);">#${rr.orderId}</span>
                                                    </td>
                                                    <td style="padding:16px 20px;">
                                                        <div
                                                            style="font-weight:600;font-size:0.88rem;color:var(--color-text-primary);">
                                                            ${rr.customerName}</div>
                                                        <div
                                                            style="font-size:0.75rem;color:var(--color-text-muted);margin-top:2px;">
                                                            ${rr.customerEmail}</div>
                                                    </td>
                                                    <td style="padding:16px 20px;">
                                                        <div class="reason-text"
                                                            style="font-size:0.85rem;color:var(--color-text-primary);font-weight:600;"
                                                            title="${rr.reasonType}">${rr.reasonType}</div>
                                                        <c:if test="${not empty rr.reasonDetail}">
                                                            <div class="reason-text"
                                                                style="font-size:0.75rem;color:var(--color-text-muted);margin-top:2px;"
                                                                title="${rr.reasonDetail}">${rr.reasonDetail}</div>
                                                        </c:if>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:right;">
                                                        <span
                                                            style="font-weight:700;font-size:0.92rem;color:var(--color-primary);">
                                                            <c:if test="${rr.refundAmount != null}">
                                                                <fmt:formatNumber value="${rr.refundAmount}"
                                                                    type="currency" currencyCode="VND"
                                                                    maxFractionDigits="0" />
                                                            </c:if>
                                                            <c:if test="${rr.refundAmount == null}">
                                                                <span
                                                                    style="color:var(--color-text-muted);font-weight:400;">—</span>
                                                            </c:if>
                                                        </span>
                                                    </td>
                                                    <td
                                                        style="padding:16px 20px;text-align:center;font-size:0.85rem;color:var(--color-text-secondary);">
                                                        <fmt:formatDate value="${rr.createdAt}"
                                                            pattern="dd/MM/yyyy" />
                                                        <div
                                                            style="font-size:0.75rem;color:var(--color-text-muted);">
                                                            <fmt:formatDate value="${rr.createdAt}"
                                                                pattern="HH:mm" />
                                                        </div>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:center;">
                                                        <span
                                                            class="return-badge return-badge--${rr.status}">${rr.status}</span>
                                                        <c:if test="${not empty rr.adminNote}">
                                                            <div style="font-size:0.7rem;color:var(--color-text-muted);margin-top:4px;max-width:120px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;margin-left:auto;margin-right:auto;"
                                                                title="${rr.adminNote}">
                                                                <i class="fa-solid fa-comment-dots" style="margin-right:3px;"></i>${rr.adminNote}
                                                            </div>
                                                        </c:if>
                                                    </td>
                                                    <td style="padding:16px 20px;text-align:center;">
                                                        <div style="display:flex;gap:6px;justify-content:center;">
                                                            <%-- Approve / Reject buttons only for Pending --%>
                                                            <c:if test="${rr.status == 'Pending'}">
                                                                <button type="button" class="action-btn action-btn--approve"
                                                                    title="Chấp nhận"
                                                                    onclick="openModal('Approved', '${rr.returnId}', '${rr.orderId}', '${rr.customerName}', '${rr.reasonType}')">
                                                                    <i class="fa-solid fa-check"></i>
                                                                </button>
                                                                <button type="button" class="action-btn action-btn--reject"
                                                                    title="Từ chối"
                                                                    onclick="openModal('Rejected', '${rr.returnId}', '${rr.orderId}', '${rr.customerName}', '${rr.reasonType}')">
                                                                    <i class="fa-solid fa-xmark"></i>
                                                                </button>
                                                            </c:if>
                                                            <a href="${pageContext.request.contextPath}/order?action=adminViewDetail&id=${rr.orderId}"
                                                                class="action-btn action-btn--view"
                                                                title="Xem chi tiết đơn hàng">
                                                                <i class="fa-solid fa-eye"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>

                                    <!-- No results message -->
                                    <div id="noResultsMsg"
                                        style="display:none;padding:40px 20px;text-align:center;color:var(--color-text-muted);font-size:0.9rem;">
                                        <i class="fa-solid fa-rotate-left"
                                            style="font-size:2rem;margin-bottom:12px;display:block;opacity:0.3;"></i>
                                        Không có yêu cầu hoàn trả nào phù hợp.
                                    </div>

                                    <!-- Empty state -->
                                    <c:if test="${empty returnRequests}">
                                        <div
                                            style="padding:60px 20px;text-align:center;color:var(--color-text-muted);">
                                            <i class="fa-solid fa-inbox"
                                                style="font-size:2.5rem;margin-bottom:16px;display:block;opacity:0.2;"></i>
                                            <p style="font-size:0.95rem;margin:0;">Chưa có yêu cầu hoàn trả nào.</p>
                                            <p style="font-size:0.82rem;margin-top:4px;">Khi khách hàng gửi yêu cầu
                                                hoàn trả, chúng sẽ xuất hiện ở đây.</p>
                                        </div>
                                    </c:if>
                                </div>

                            </div>
                        </main>

            <%-- ═══ Process Return Modal ═══ --%>
            <div id="returnModal" class="return-modal-overlay">
                <div class="return-modal">
                    <h3 id="modalTitle" class="return-modal__title"></h3>
                    <p class="return-modal__subtitle">Ghi chú sẽ được gửi đến khách hàng qua thông báo.</p>

                    <!-- Request info summary -->
                    <div class="return-modal__info">
                        <div style="display:flex;gap:20px;">
                            <div style="flex:1;">
                                <div class="return-modal__info-label">Khách hàng</div>
                                <div class="return-modal__info-value" id="modalCustomer"></div>
                            </div>
                            <div>
                                <div class="return-modal__info-label">Đơn hàng</div>
                                <div class="return-modal__info-value" id="modalOrder"></div>
                            </div>
                        </div>
                        <div style="margin-top:8px;" id="modalEvidenceWrap">
                            <div class="return-modal__info-label">Bằng chứng</div>
                            <div id="modalEvidence" style="display:flex;flex-wrap:wrap;gap:6px;margin-top:6px;"></div>
                        </div>
                        <div style="margin-top:8px;">
                            <div class="return-modal__info-label">Lý do</div>
                            <div class="return-modal__info-value" id="modalReason"></div>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/order" method="POST">
                        <input type="hidden" name="action" value="processReturn">
                        <input type="hidden" name="from" value="list">
                        <input type="hidden" id="modalReturnId" name="returnId" value="">
                        <input type="hidden" id="modalOrderId" name="orderId" value="">
                        <input type="hidden" id="modalStatus" name="newStatus" value="">

                        <label style="font-size:0.78rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:0.5px;display:block;margin-bottom:6px;">
                            Ghi chú admin
                        </label>
                        <textarea name="adminNote" rows="3"
                            placeholder="Nhập ghi chú cho khách hàng (tuỳ chọn)..."></textarea>

                        <div class="return-modal__actions">
                            <button type="button" class="return-modal__btn return-modal__btn--cancel"
                                onclick="closeModal()">Huỷ</button>
                            <button type="submit" id="modalConfirmBtn"
                                class="return-modal__btn return-modal__btn--confirm">Xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
            // ─── Modal Logic ────────────────────────────────────────────────────
            function openModal(status, returnId, orderId, customerName, reason) {
                document.getElementById('modalReturnId').value = returnId;
                document.getElementById('modalOrderId').value = orderId;
                document.getElementById('modalStatus').value = status;
                document.getElementById('modalCustomer').textContent = customerName;
                document.getElementById('modalOrder').textContent = '#' + orderId;
                document.getElementById('modalReason').textContent = reason;

                // Populate evidence thumbnails
                var row = document.querySelector('tr[data-returnid="' + returnId + '"]');
                var evidenceStr = row ? row.getAttribute('data-evidence') : '';
                var evContainer = document.getElementById('modalEvidence');
                var evWrap = document.getElementById('modalEvidenceWrap');
                evContainer.innerHTML = '';
                if (evidenceStr && evidenceStr.trim()) {
                    evWrap.style.display = 'block';
                    var ctxPath = '${pageContext.request.contextPath}';
                    evidenceStr.split(',').forEach(function(url) {
                        url = url.trim();
                        if (!url) return;
                        var img = document.createElement('img');
                        img.src = ctxPath + '/uploads/' + url;
                        img.alt = 'Evidence';
                        img.style.cssText = 'width:60px;height:60px;object-fit:cover;border-radius:6px;border:1px solid #e2e8f0;cursor:pointer;transition:opacity 0.2s;';
                        img.onmouseover = function() { this.style.opacity='0.7'; };
                        img.onmouseout = function() { this.style.opacity='1'; };
                        (function(imgSrc) {
                            img.onclick = function() { openLightbox(imgSrc); };
                        })(ctxPath + '/uploads/' + url);
                        evContainer.appendChild(img);
                    });
                } else {
                    evWrap.style.display = 'none';
                }

                var title = document.getElementById('modalTitle');
                var btn   = document.getElementById('modalConfirmBtn');

                if (status === 'Approved') {
                    title.textContent = 'Chấp nhận yêu cầu hoàn trả';
                    title.style.color = '#065f46';
                    btn.style.background = '#10b981';
                    btn.textContent = '✓ Chấp nhận';
                } else {
                    title.textContent = 'Từ chối yêu cầu hoàn trả';
                    title.style.color = '#b91c1c';
                    btn.style.background = '#ef4444';
                    btn.textContent = '✕ Từ chối';
                }

                document.getElementById('returnModal').style.display = 'flex';
            }

            function closeModal() {
                document.getElementById('returnModal').style.display = 'none';
            }

            // Close modal on backdrop click
            document.getElementById('returnModal').addEventListener('click', function(e) {
                if (e.target === this) closeModal();
            });

            // ─── Filter Logic ───────────────────────────────────────────────────
            (function() {
                var filterSearch = document.getElementById('filterSearch');
                var filterStatus = document.getElementById('filterStatus');
                var btnReset     = document.getElementById('btnReset');
                var tbody        = document.getElementById('returnTableBody');
                var noResultsMsg = document.getElementById('noResultsMsg');
                var returnCount  = document.getElementById('returnCount');

                var statPending  = document.getElementById('statPending');
                var statApproved = document.getElementById('statApproved');
                var statRejected = document.getElementById('statRejected');
                var statTotal    = document.getElementById('statTotal');

                function countStats() {
                    var rows = tbody.querySelectorAll('tr.return-row');
                    var pending = 0, approved = 0, rejected = 0;
                    for (var i = 0; i < rows.length; i++) {
                        var s = rows[i].getAttribute('data-status');
                        if (s === 'Pending') pending++;
                        else if (s === 'Approved') approved++;
                        else if (s === 'Rejected') rejected++;
                    }
                    statPending.textContent = pending;
                    statApproved.textContent = approved;
                    statRejected.textContent = rejected;
                    statTotal.textContent = rows.length;
                }

                function applyFilters() {
                    var fSearch = filterSearch.value.trim().toLowerCase();
                    var fStatus = filterStatus.value;
                    var rows = tbody.querySelectorAll('tr.return-row');
                    var visibleCount = 0;

                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        var show = true;

                        if (fSearch) {
                            var customer = (row.getAttribute('data-customer') || '').toLowerCase();
                            var orderId = (row.getAttribute('data-orderid') || '');
                            if (customer.indexOf(fSearch) === -1 && orderId.indexOf(fSearch) === -1) {
                                show = false;
                            }
                        }
                        if (fStatus && row.getAttribute('data-status') !== fStatus) {
                            show = false;
                        }

                        row.style.display = show ? '' : 'none';
                        if (show) visibleCount++;
                    }

                    noResultsMsg.style.display = (visibleCount === 0 && rows.length > 0) ? 'block' : 'none';
                    returnCount.textContent = visibleCount;
                }

                filterSearch.addEventListener('input', applyFilters);
                filterStatus.addEventListener('change', applyFilters);

                btnReset.addEventListener('click', function() {
                    filterSearch.value = '';
                    filterStatus.value = '';
                    applyFilters();
                });

                countStats();
                applyFilters();
            })();
            </script>

            <%-- ══════ LIGHTBOX OVERLAY ══════ --%>
            <div id="evidenceLightbox" onclick="closeLightbox()" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.85);z-index:9999;justify-content:center;align-items:center;cursor:zoom-out;">
                <button onclick="closeLightbox()" style="position:absolute;top:20px;right:24px;background:rgba(255,255,255,0.15);border:none;color:#fff;width:40px;height:40px;border-radius:50%;font-size:20px;cursor:pointer;display:flex;align-items:center;justify-content:center;backdrop-filter:blur(4px);transition:background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.3)'" onmouseout="this.style.background='rgba(255,255,255,0.15)'">&times;</button>
                <img id="lightboxImg" src="" alt="Evidence" style="display:none;max-width:90vw;max-height:85vh;border-radius:12px;box-shadow:0 20px 60px rgba(0,0,0,0.5);object-fit:contain;" onclick="event.stopPropagation()">
            </div>
            <script>
                function openLightbox(src) {
                    var lb = document.getElementById('evidenceLightbox');
                    var img = document.getElementById('lightboxImg');
                    img.src = src;
                    img.style.display = 'block';
                    lb.style.display = 'flex';
                    document.body.style.overflow = 'hidden';
                }
                function closeLightbox() {
                    var lb = document.getElementById('evidenceLightbox');
                    lb.style.display = 'none';
                    document.body.style.overflow = '';
                }
                document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeLightbox(); });
            </script>
            </body>

            </html>

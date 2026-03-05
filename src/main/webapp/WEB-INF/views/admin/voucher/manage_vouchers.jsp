<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Vouchers — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <style>
                    .voucher-type-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 5px;
                        padding: 4px 12px;
                        border-radius: var(--radius-full);
                        font-size: 0.72rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .badge-percent {
                        background: #dbeafe;
                        color: #1d4ed8;
                    }

                    .badge-fixed {
                        background: #d1fae5;
                        color: #065f46;
                    }

                    .voucher-status-badge {
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

                    .badge-active {
                        background: var(--color-success-bg);
                        color: var(--color-success-text);
                    }

                    .badge-inactive {
                        background: #f1f5f9;
                        color: #64748b;
                    }

                    .badge-expired {
                        background: #fef3c7;
                        color: #d97706;
                    }

                    .stat-cards {
                        display: grid;
                        grid-template-columns: repeat(4, 1fr);
                        gap: var(--space-lg);
                        margin-bottom: var(--space-xl);
                    }

                    .stat-card {
                        background: var(--color-white);
                        border-radius: var(--radius-xl);
                        box-shadow: var(--shadow-card);
                        padding: var(--space-xl);
                        display: flex;
                        align-items: center;
                        gap: var(--space-lg);
                    }

                    .stat-card__icon {
                        width: 52px;
                        height: 52px;
                        border-radius: var(--radius-lg);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.3rem;
                        flex-shrink: 0;
                    }

                    .stat-card__label {
                        font-size: 0.75rem;
                        color: var(--color-text-muted);
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        font-weight: 600;
                    }

                    .stat-card__value {
                        font-size: 1.6rem;
                        font-weight: 800;
                        color: var(--color-primary);
                        line-height: 1.1;
                        margin-top: 4px;
                    }

                    .action-btn {
                        width: 34px;
                        height: 34px;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: var(--radius-sm);
                        background: var(--color-bg);
                        color: var(--color-text-secondary);
                        transition: all 0.2s ease;
                        font-size: 0.82rem;
                        text-decoration: none;
                        border: none;
                        cursor: pointer;
                    }

                    .action-btn:hover {
                        background: var(--color-primary);
                        color: #fff;
                    }

                    .action-btn.danger:hover {
                        background: #fef2f2;
                        color: #dc2626;
                    }

                    .action-btn.success:hover {
                        background: #f0fdf4;
                        color: #16a34a;
                    }

                    .action-btn.warning:hover {
                        background: #fff7ed;
                        color: #ea580c;
                    }

                    .progress-bar {
                        height: 6px;
                        border-radius: 99px;
                        background: var(--color-bg);
                        overflow: hidden;
                        margin-top: 6px;
                        width: 100px;
                    }

                    .progress-bar__fill {
                        height: 100%;
                        background: var(--color-primary);
                        border-radius: 99px;
                        transition: width 0.3s;
                    }

                    .progress-bar__fill.full {
                        background: #dc2626;
                    }
                </style>
            </head>

            <body class="luxury-admin">
                <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
                    <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

                        <main class="lux-main">
                            <div class="lux-content">

                                <%-- ── Page Header ────────────────────────────────────────── --%>
                                    <section class="lux-page-header">
                                        <div class="lux-page-header__text">
                                            <h1 class="lux-page-header__title">Voucher Management</h1>
                                            <p class="lux-page-header__subtitle">Tạo và quản lý mã giảm giá cho khách
                                                hàng.</p>
                                        </div>
                                        <div class="lux-page-header__actions">
                                            <a href="${pageContext.request.contextPath}/voucher?action=add"
                                                style="display:inline-flex;align-items:center;gap:8px;padding:11px 22px;background:var(--color-primary);color:#fff;border-radius:var(--radius-md);font-size:0.85rem;font-weight:700;text-decoration:none;letter-spacing:0.3px;transition:all 0.2s ease;box-shadow:0 4px 12px rgba(26,35,50,0.15);"
                                                onmouseover="this.style.opacity='0.88'"
                                                onmouseout="this.style.opacity='1'">
                                                <i class="fa-solid fa-plus"></i> Thêm Voucher
                                            </a>
                                        </div>
                                    </section>

                                    <%-- ── Flash Messages ────────────────────────────────────── --%>
                                        <c:if test="${not empty param.success}">
                                            <div
                                                style="background:var(--color-success-bg);color:var(--color-success-text);padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                                <i class="fa-solid fa-circle-check"
                                                    style="margin-right:8px;"></i>Voucher đã được lưu thành công!
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty param.deleted}">
                                            <div
                                                style="background:#fef3c7;color:#d97706;padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                                <i class="fa-solid fa-trash-can" style="margin-right:8px;"></i>Đã xoá
                                                voucher thành công.
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty param.error}">
                                            <div
                                                style="background:#fef2f2;color:#dc2626;padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                                <i class="fa-solid fa-circle-exclamation"
                                                    style="margin-right:8px;"></i>Có lỗi xảy ra. Vui lòng thử lại.
                                            </div>
                                        </c:if>

                                        <%-- ── Stat Cards ─────────────────────────────────────────── --%>
                                            <div class="stat-cards">
                                                <div class="stat-card">
                                                    <div class="stat-card__icon"
                                                        style="background:#ede9fe;color:#7c3aed;"><i
                                                            class="fa-solid fa-ticket"></i></div>
                                                    <div>
                                                        <div class="stat-card__label">Tổng Voucher</div>
                                                        <div class="stat-card__value">${vouchers.size()}</div>
                                                    </div>
                                                </div>
                                                <div class="stat-card">
                                                    <div class="stat-card__icon"
                                                        style="background:var(--color-success-bg);color:var(--color-success-text);">
                                                        <i class="fa-solid fa-circle-check"></i></div>
                                                    <div>
                                                        <div class="stat-card__label">Đang hoạt động</div>
                                                        <div class="stat-card__value">
                                                            <c:set var="activeCount" value="0" />
                                                            <c:forEach var="v" items="${vouchers}">
                                                                <c:if test="${v.active and v.usable}">
                                                                    <c:set var="activeCount"
                                                                        value="${activeCount + 1}" />
                                                                </c:if>
                                                            </c:forEach>
                                                            ${activeCount}
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="stat-card">
                                                    <div class="stat-card__icon"
                                                        style="background:#fef3c7;color:#d97706;"><i
                                                            class="fa-solid fa-clock-rotate-left"></i></div>
                                                    <div>
                                                        <div class="stat-card__label">Hết hạn / Tắt</div>
                                                        <div class="stat-card__value">${vouchers.size() - activeCount}
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="stat-card">
                                                    <div class="stat-card__icon"
                                                        style="background:#dbeafe;color:#1d4ed8;"><i
                                                            class="fa-solid fa-fire-flame-curved"></i></div>
                                                    <div>
                                                        <div class="stat-card__label">Lượt dùng</div>
                                                        <div class="stat-card__value">
                                                            <c:set var="totalUsed" value="0" />
                                                            <c:forEach var="v" items="${vouchers}">
                                                                <c:set var="totalUsed"
                                                                    value="${totalUsed + v.usedCount}" />
                                                            </c:forEach>
                                                            ${totalUsed}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <%-- ── Table Card ─────────────────────────────────────────── --%>
                                                <div
                                                    style="background:var(--color-white);border-radius:var(--radius-xl);box-shadow:var(--shadow-card);overflow:hidden;">

                                                    <%-- Card Header --%>
                                                        <div
                                                            style="padding:var(--space-lg) var(--space-xl);border-bottom:1px solid var(--color-border-light);display:flex;justify-content:space-between;align-items:center;">
                                                            <div>
                                                                <h2
                                                                    style="font-family:var(--font-serif);font-size:1.3rem;font-weight:700;color:var(--color-primary);margin:0;">
                                                                    Tất cả Voucher</h2>
                                                                <p
                                                                    style="font-size:0.82rem;color:var(--color-text-muted);margin:4px 0 0;">
                                                                    Quản lý toàn bộ mã giảm giá trong hệ thống</p>
                                                            </div>
                                                            <div style="display:flex;align-items:center;gap:10px;">
                                                                <span
                                                                    style="font-size:0.8rem;color:var(--color-text-muted);">
                                                                    <i class="fa-solid fa-list"
                                                                        style="margin-right:4px;"></i>${vouchers.size()}
                                                                    voucher
                                                                </span>
                                                            </div>
                                                        </div>

                                                        <%-- Table --%>
                                                            <table style="width:100%;border-collapse:collapse;">
                                                                <thead>
                                                                    <tr style="background:var(--color-bg);">
                                                                        <th
                                                                            style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                                            Mã / Mô tả</th>
                                                                        <th
                                                                            style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                                            Loại</th>
                                                                        <th
                                                                            style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                                            Giá trị</th>
                                                                        <th
                                                                            style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                                            Đơn tối thiểu</th>
                                                                        <th
                                                                            style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                                            Lượt dùng</th>
                                                                        <th
                                                                            style="padding:14px 20px;text-align:left;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                                            Hạn dùng</th>
                                                                        <th
                                                                            style="padding:14px 20px;text-align:center;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                                            Trạng thái</th>
                                                                        <th
                                                                            style="padding:14px 20px;text-align:right;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;">
                                                                            Hành động</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="v" items="${vouchers}">
                                                                        <%-- Tính % đã dùng --%>
                                                                            <c:set var="usedPct" value="0" />
                                                                            <c:if test="${v.usageLimit > 0}">
                                                                                <c:set var="usedPct"
                                                                                    value="${v.usedCount * 100 / v.usageLimit}" />
                                                                            </c:if>

                                                                            <tr style="border-bottom:1px solid var(--color-border-light);transition:background 0.15s ease;${!v.active ? 'opacity:0.6;' : ''}"
                                                                                onmouseover="this.style.background='var(--color-bg)'"
                                                                                onmouseout="this.style.background='transparent'">

                                                                                <%-- Mã / Mô tả --%>
                                                                                    <td style="padding:16px 20px;">
                                                                                        <div
                                                                                            style="font-weight:700;font-size:0.9rem;color:var(--color-primary);letter-spacing:1px;font-family:monospace;">
                                                                                            ${v.code}
                                                                                        </div>
                                                                                        <div
                                                                                            style="font-size:0.78rem;color:var(--color-text-muted);margin-top:3px;">
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${not empty v.description}">
                                                                                                    ${v.description}
                                                                                                </c:when>
                                                                                                <c:otherwise><em>Chưa có
                                                                                                        mô tả</em>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </div>
                                                                                    </td>

                                                                                    <%-- Loại --%>
                                                                                        <td
                                                                                            style="padding:16px 20px;text-align:center;">
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${v.discountType eq 'PERCENT'}">
                                                                                                    <span
                                                                                                        class="voucher-type-badge badge-percent"><i
                                                                                                            class="fa-solid fa-percent"
                                                                                                            style="font-size:0.65rem;"></i>
                                                                                                        Phần trăm</span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="voucher-type-badge badge-fixed"><i
                                                                                                            class="fa-solid fa-Vietnamese-dong-sign"
                                                                                                            style="font-size:0.65rem;"></i>
                                                                                                        Cố định</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>

                                                                                        <%-- Giá trị --%>
                                                                                            <td
                                                                                                style="padding:16px 20px;text-align:right;">
                                                                                                <span
                                                                                                    style="font-weight:700;font-size:0.95rem;color:var(--color-primary);">
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${v.discountType eq 'PERCENT'}">
                                                                                                            ${v.discountValue}<span
                                                                                                                style="font-size:0.78rem;color:var(--color-text-muted);">%</span>
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <fmt:formatNumber
                                                                                                                value="${v.discountValue}"
                                                                                                                type="currency"
                                                                                                                currencyCode="VND"
                                                                                                                maxFractionDigits="0" />
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </span>
                                                                                                <c:if
                                                                                                    test="${v.discountType eq 'PERCENT' and not empty v.maxDiscountAmount}">
                                                                                                    <div
                                                                                                        style="font-size:0.72rem;color:var(--color-text-muted);margin-top:2px;">
                                                                                                        Tối đa
                                                                                                        <fmt:formatNumber
                                                                                                            value="${v.maxDiscountAmount}"
                                                                                                            type="currency"
                                                                                                            currencyCode="VND"
                                                                                                            maxFractionDigits="0" />
                                                                                                    </div>
                                                                                                </c:if>
                                                                                            </td>

                                                                                            <%-- Đơn tối thiểu --%>
                                                                                                <td
                                                                                                    style="padding:16px 20px;text-align:right;font-size:0.85rem;color:var(--color-text-secondary);">
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${empty v.minOrderValue}">
                                                                                                            <span
                                                                                                                style="color:var(--color-text-muted);">—</span>
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <fmt:formatNumber
                                                                                                                value="${v.minOrderValue}"
                                                                                                                type="currency"
                                                                                                                currencyCode="VND"
                                                                                                                maxFractionDigits="0" />
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </td>

                                                                                                <%-- Lượt dùng +
                                                                                                    progress --%>
                                                                                                    <td
                                                                                                        style="padding:16px 20px;text-align:center;">
                                                                                                        <div
                                                                                                            style="font-size:0.85rem;font-weight:600;color:var(--color-text-primary);">
                                                                                                            ${v.usedCount}
                                                                                                            <span
                                                                                                                style="color:var(--color-text-muted);font-weight:400;">/
                                                                                                                ${v.usageLimit
                                                                                                                < 0 ? '∞'
                                                                                                                    :
                                                                                                                    v.usageLimit}</span>
                                                                                                        </div>
                                                                                                        <c:if
                                                                                                            test="${v.usageLimit > 0}">
                                                                                                            <div class="progress-bar"
                                                                                                                style="margin:6px auto 0;width:80px;">
                                                                                                                <div class="progress-bar__fill ${usedPct >= 90 ? 'full' : ''}"
                                                                                                                    style="width:${usedPct > 100 ? 100 : usedPct}%;">
                                                                                                                </div>
                                                                                                            </div>
                                                                                                        </c:if>
                                                                                                    </td>

                                                                                                    <%-- Hạn dùng --%>
                                                                                                        <td
                                                                                                            style="padding:16px 20px;">
                                                                                                            <c:choose>
                                                                                                                <c:when
                                                                                                                    test="${empty v.endDate}">
                                                                                                                    <span
                                                                                                                        style="font-size:0.82rem;color:var(--color-text-muted);">Không
                                                                                                                        giới
                                                                                                                        hạn</span>
                                                                                                                </c:when>
                                                                                                                <c:otherwise>
                                                                                                                    <div
                                                                                                                        style="font-size:0.82rem;font-weight:600;color:var(--color-text-primary);">
                                                                                                                        <fmt:formatDate
                                                                                                                            value="${v.endDate}"
                                                                                                                            pattern="dd/MM/yyyy" />
                                                                                                                    </div>
                                                                                                                    <div
                                                                                                                        style="font-size:0.72rem;color:var(--color-text-muted);">
                                                                                                                        <fmt:formatDate
                                                                                                                            value="${v.endDate}"
                                                                                                                            pattern="HH:mm" />
                                                                                                                    </div>
                                                                                                                </c:otherwise>
                                                                                                            </c:choose>
                                                                                                        </td>

                                                                                                        <%-- Trạng thái
                                                                                                            --%>
                                                                                                            <td
                                                                                                                style="padding:16px 20px;text-align:center;">
                                                                                                                <c:choose>
                                                                                                                    <c:when
                                                                                                                        test="${v.active and v.usable}">
                                                                                                                        <span
                                                                                                                            class="voucher-status-badge badge-active"><i
                                                                                                                                class="fa-solid fa-circle"
                                                                                                                                style="font-size:0.5rem;"></i>
                                                                                                                            Đang
                                                                                                                            mở</span>
                                                                                                                    </c:when>
                                                                                                                    <c:when
                                                                                                                        test="${v.active and !v.usable}">
                                                                                                                        <span
                                                                                                                            class="voucher-status-badge badge-expired"><i
                                                                                                                                class="fa-solid fa-clock"
                                                                                                                                style="font-size:0.65rem;"></i>
                                                                                                                            Hết
                                                                                                                            hạn</span>
                                                                                                                    </c:when>
                                                                                                                    <c:otherwise>
                                                                                                                        <span
                                                                                                                            class="voucher-status-badge badge-inactive"><i
                                                                                                                                class="fa-solid fa-ban"
                                                                                                                                style="font-size:0.65rem;"></i>
                                                                                                                            Đã
                                                                                                                            tắt</span>
                                                                                                                    </c:otherwise>
                                                                                                                </c:choose>
                                                                                                            </td>

                                                                                                            <%-- Hành
                                                                                                                động
                                                                                                                --%>
                                                                                                                <td
                                                                                                                    style="padding:16px 20px;text-align:right;">
                                                                                                                    <div
                                                                                                                        style="display:flex;gap:6px;justify-content:flex-end;">
                                                                                                                        <%-- Edit
                                                                                                                            --%>
                                                                                                                            <a href="${pageContext.request.contextPath}/voucher?action=edit&id=${v.voucherId}"
                                                                                                                                class="action-btn"
                                                                                                                                title="Chỉnh sửa"
                                                                                                                                onmouseover="this.style.background='var(--color-primary)';this.style.color='#fff';"
                                                                                                                                onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';">
                                                                                                                                <i
                                                                                                                                    class="fa-solid fa-pen-to-square"></i>
                                                                                                                            </a>

                                                                                                                            <%-- Toggle
                                                                                                                                --%>
                                                                                                                                <c:choose>
                                                                                                                                    <c:when
                                                                                                                                        test="${v.active}">
                                                                                                                                        <a href="${pageContext.request.contextPath}/voucher?action=toggle&id=${v.voucherId}&active=0"
                                                                                                                                            class="action-btn warning"
                                                                                                                                            title="Tắt voucher"
                                                                                                                                            onmouseover="this.style.background='#fff7ed';this.style.color='#ea580c';"
                                                                                                                                            onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';">
                                                                                                                                            <i
                                                                                                                                                class="fa-solid fa-toggle-on"></i>
                                                                                                                                        </a>
                                                                                                                                    </c:when>
                                                                                                                                    <c:otherwise>
                                                                                                                                        <a href="${pageContext.request.contextPath}/voucher?action=toggle&id=${v.voucherId}&active=1"
                                                                                                                                            class="action-btn success"
                                                                                                                                            title="Bật voucher"
                                                                                                                                            onmouseover="this.style.background='#f0fdf4';this.style.color='#16a34a';"
                                                                                                                                            onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';">
                                                                                                                                            <i
                                                                                                                                                class="fa-solid fa-toggle-off"></i>
                                                                                                                                        </a>
                                                                                                                                    </c:otherwise>
                                                                                                                                </c:choose>

                                                                                                                                <%-- Delete
                                                                                                                                    --%>
                                                                                                                                    <a href="${pageContext.request.contextPath}/voucher?action=delete&id=${v.voucherId}"
                                                                                                                                        class="action-btn danger"
                                                                                                                                        title="Xoá voucher"
                                                                                                                                        onclick="return confirm('Xoá voucher \'${v.code}\'? Hành động này không thể hoàn tác.')"
                                                                                                                                        onmouseover="this.style.background='#fef2f2';this.style.color='#dc2626';"
                                                                                                                                        onmouseout="this.style.background='var(--color-bg)';this.style.color='var(--color-text-secondary)';">
                                                                                                                                        <i
                                                                                                                                            class="fa-solid fa-trash-can"></i>
                                                                                                                                    </a>
                                                                                                                    </div>
                                                                                                                </td>
                                                                            </tr>
                                                                    </c:forEach>

                                                                    <c:if test="${empty vouchers}">
                                                                        <tr>
                                                                            <td colspan="8"
                                                                                style="padding:60px 20px;text-align:center;color:var(--color-text-muted);font-size:0.9rem;">
                                                                                <i class="fa-solid fa-ticket"
                                                                                    style="font-size:2.5rem;margin-bottom:16px;display:block;opacity:0.2;"></i>
                                                                                <div
                                                                                    style="font-weight:600;margin-bottom:8px;">
                                                                                    Chưa có voucher nào</div>
                                                                                <div style="font-size:0.82rem;">Bắt đầu
                                                                                    bằng cách tạo voucher đầu tiên cho
                                                                                    khách hàng.</div>
                                                                                <a href="${pageContext.request.contextPath}/voucher?action=add"
                                                                                    style="display:inline-flex;align-items:center;gap:8px;margin-top:20px;padding:10px 22px;background:var(--color-primary);color:#fff;border-radius:var(--radius-md);font-size:0.82rem;font-weight:700;text-decoration:none;">
                                                                                    <i class="fa-solid fa-plus"></i> Tạo
                                                                                    Voucher đầu tiên
                                                                                </a>
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
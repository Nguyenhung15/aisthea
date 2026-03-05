<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${empty voucher ? 'Thêm Voucher' : 'Sửa Voucher'} — AISTHÉA Admin</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
            <style>
                .form-card {
                    background: var(--color-white);
                    border-radius: var(--radius-xl);
                    box-shadow: var(--shadow-card);
                    overflow: hidden;
                }

                .form-card__header {
                    padding: var(--space-lg) var(--space-xl);
                    border-bottom: 1px solid var(--color-border-light);
                    display: flex;
                    align-items: center;
                    gap: 14px;
                }

                .form-card__header-icon {
                    width: 42px;
                    height: 42px;
                    border-radius: var(--radius-md);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.1rem;
                    flex-shrink: 0;
                }

                .form-card__body {
                    padding: var(--space-xl);
                }

                .form-card__section {
                    margin-bottom: var(--space-xl);
                }

                .form-card__section-title {
                    font-size: 0.72rem;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 1.5px;
                    color: var(--color-text-muted);
                    margin-bottom: var(--space-lg);
                    padding-bottom: 10px;
                    border-bottom: 1px solid var(--color-border-light);
                }

                .form-grid-2 {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: var(--space-lg);
                }

                .form-grid-3 {
                    display: grid;
                    grid-template-columns: 1fr 1fr 1fr;
                    gap: var(--space-lg);
                }

                .form-group {
                    display: flex;
                    flex-direction: column;
                    gap: 6px;
                }

                .form-group--full {
                    grid-column: 1 / -1;
                }

                .form-label {
                    font-size: 0.78rem;
                    font-weight: 600;
                    color: var(--color-text-secondary);
                    letter-spacing: 0.3px;
                }

                .form-label span.required {
                    color: #dc2626;
                    margin-left: 3px;
                }

                .form-label span.hint {
                    font-weight: 400;
                    color: var(--color-text-muted);
                    font-size: 0.72rem;
                }

                .form-input,
                .form-select,
                .form-textarea {
                    width: 100%;
                    padding: 10px 14px;
                    border: 1.5px solid var(--color-border-light);
                    border-radius: var(--radius-md);
                    font-family: var(--font-body);
                    font-size: 0.88rem;
                    color: var(--color-text-primary);
                    background: var(--color-white);
                    transition: border-color 0.2s, box-shadow 0.2s;
                    outline: none;
                    box-sizing: border-box;
                }

                .form-input:focus,
                .form-select:focus,
                .form-textarea:focus {
                    border-color: var(--color-primary);
                    box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.07);
                }

                .form-input.code-input {
                    font-family: monospace;
                    font-size: 1rem;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 2px;
                }

                .form-input-prefix {
                    display: flex;
                    align-items: center;
                    border: 1.5px solid var(--color-border-light);
                    border-radius: var(--radius-md);
                    overflow: hidden;
                    transition: border-color 0.2s, box-shadow 0.2s;
                }

                .form-input-prefix:focus-within {
                    border-color: var(--color-primary);
                    box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.07);
                }

                .form-input-prefix__addon {
                    padding: 10px 14px;
                    background: var(--color-bg);
                    font-size: 0.82rem;
                    font-weight: 600;
                    color: var(--color-text-muted);
                    border-right: 1px solid var(--color-border-light);
                    white-space: nowrap;
                }

                .form-input-prefix .form-input {
                    border: none !important;
                    box-shadow: none !important;
                    border-radius: 0 !important;
                }

                /* Radio type selector */
                .type-selector {
                    display: flex;
                    gap: var(--space-md);
                }

                .type-option {
                    flex: 1;
                    position: relative;
                }

                .type-option input[type="radio"] {
                    position: absolute;
                    opacity: 0;
                }

                .type-option__label {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: 10px;
                    padding: 20px;
                    border: 2px solid var(--color-border-light);
                    border-radius: var(--radius-lg);
                    cursor: pointer;
                    transition: all 0.2s ease;
                    background: var(--color-bg);
                    text-align: center;
                }

                .type-option__label:hover {
                    border-color: var(--color-primary);
                    background: var(--color-white);
                }

                .type-option input:checked+.type-option__label {
                    border-color: var(--color-primary);
                    background: var(--color-white);
                    box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.07);
                }

                .type-option__icon {
                    width: 44px;
                    height: 44px;
                    border-radius: var(--radius-md);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.2rem;
                }

                .type-option__title {
                    font-size: 0.88rem;
                    font-weight: 700;
                    color: var(--color-text-primary);
                }

                .type-option__desc {
                    font-size: 0.72rem;
                    color: var(--color-text-muted);
                }

                /* Toggle switch */
                .toggle-wrap {
                    display: flex;
                    align-items: center;
                    gap: 14px;
                    padding: 16px;
                    background: var(--color-bg);
                    border-radius: var(--radius-md);
                }

                .toggle-switch {
                    position: relative;
                    display: inline-block;
                    width: 46px;
                    height: 26px;
                    flex-shrink: 0;
                }

                .toggle-switch input {
                    opacity: 0;
                    width: 0;
                    height: 0;
                }

                .toggle-slider {
                    position: absolute;
                    inset: 0;
                    cursor: pointer;
                    background: #cbd5e1;
                    border-radius: 99px;
                    transition: background 0.3s;
                }

                .toggle-slider::before {
                    content: '';
                    position: absolute;
                    width: 20px;
                    height: 20px;
                    left: 3px;
                    bottom: 3px;
                    background: #fff;
                    border-radius: 50%;
                    transition: transform 0.3s;
                    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.2);
                }

                .toggle-switch input:checked+.toggle-slider {
                    background: var(--color-primary);
                }

                .toggle-switch input:checked+.toggle-slider::before {
                    transform: translateX(20px);
                }

                .toggle-text {
                    font-size: 0.85rem;
                    font-weight: 600;
                    color: var(--color-text-primary);
                }

                .toggle-sub {
                    font-size: 0.75rem;
                    color: var(--color-text-muted);
                }

                /* Preview card */
                .preview-card {
                    background: linear-gradient(135deg, var(--color-primary) 0%, #374151 100%);
                    border-radius: var(--radius-xl);
                    padding: 28px 32px;
                    color: #fff;
                    position: sticky;
                    top: 100px;
                }

                .preview-card__label {
                    font-size: 0.68rem;
                    letter-spacing: 2px;
                    text-transform: uppercase;
                    opacity: 0.6;
                }

                .preview-card__code {
                    font-size: 2rem;
                    font-weight: 800;
                    letter-spacing: 4px;
                    font-family: monospace;
                    margin: 8px 0 4px;
                    word-break: break-all;
                }

                .preview-card__desc {
                    font-size: 0.85rem;
                    opacity: 0.75;
                    margin-bottom: 20px;
                }

                .preview-card__divider {
                    height: 1px;
                    background: rgba(255, 255, 255, 0.15);
                    margin: 20px 0;
                }

                .preview-card__row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 10px;
                    font-size: 0.82rem;
                }

                .preview-card__row-label {
                    opacity: 0.65;
                }

                .preview-card__row-value {
                    font-weight: 700;
                }

                /* Buttons */
                .btn-primary {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    padding: 12px 28px;
                    background: var(--color-primary);
                    color: #fff;
                    border: none;
                    border-radius: var(--radius-md);
                    font-size: 0.88rem;
                    font-weight: 700;
                    cursor: pointer;
                    transition: all 0.2s;
                    letter-spacing: 0.3px;
                }

                .btn-primary:hover {
                    opacity: 0.88;
                    transform: translateY(-1px);
                    box-shadow: 0 4px 12px rgba(26, 35, 50, 0.2);
                }

                .btn-secondary {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    padding: 12px 24px;
                    background: transparent;
                    color: var(--color-text-secondary);
                    border: 1.5px solid var(--color-border-light);
                    border-radius: var(--radius-md);
                    font-size: 0.88rem;
                    font-weight: 600;
                    cursor: pointer;
                    text-decoration: none;
                    transition: all 0.2s;
                }

                .btn-secondary:hover {
                    background: var(--color-bg);
                    border-color: var(--color-text-muted);
                }
            </style>
        </head>

        <body class="luxury-admin">
            <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
                <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

                    <main class="lux-main">
                        <div class="lux-content">

                            <%-- ── Breadcrumb / Page Header ───────────────────────────── --%>
                                <section class="lux-page-header">
                                    <div class="lux-page-header__text">
                                        <div
                                            style="display:flex;align-items:center;gap:8px;margin-bottom:6px;font-size:0.8rem;color:var(--color-text-muted);">
                                            <a href="${pageContext.request.contextPath}/voucher?action=list"
                                                style="color:var(--color-text-muted);text-decoration:none;transition:color 0.2s;"
                                                onmouseover="this.style.color='var(--color-primary)'"
                                                onmouseout="this.style.color='var(--color-text-muted)'">
                                                <i class="fa-solid fa-ticket" style="margin-right:4px;"></i>Vouchers
                                            </a>
                                            <i class="fa-solid fa-chevron-right" style="font-size:0.65rem;"></i>
                                            <span>${empty voucher ? 'Tạo mới' : 'Chỉnh sửa'}</span>
                                        </div>
                                        <h1 class="lux-page-header__title">${empty voucher ? 'Tạo Voucher mới' : 'Chỉnh
                                            sửa Voucher'}</h1>
                                        <p class="lux-page-header__subtitle">
                                            <c:choose>
                                                <c:when test="${empty voucher}">Điền thông tin để tạo mã giảm giá mới
                                                    cho khách hàng.</c:when>
                                                <c:otherwise>Cập nhật thông tin cho voucher
                                                    <strong>${voucher.code}</strong>.</c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </section>

                                <%-- ── Main Layout: Form + Preview ───────────────────────── --%>
                                    <div
                                        style="display:grid;grid-template-columns:1fr 300px;gap:var(--space-xl);align-items:start;">

                                        <%-- LEFT: Form --%>
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/voucher?action=save"
                                                id="voucherForm">
                                                <c:if test="${not empty voucher}">
                                                    <input type="hidden" name="voucherId" value="${voucher.voucherId}">
                                                </c:if>

                                                <%-- ── Card 1: Thông tin cơ bản ─────────────────────── --%>
                                                    <div class="form-card" style="margin-bottom:var(--space-lg);">
                                                        <div class="form-card__header">
                                                            <div class="form-card__header-icon"
                                                                style="background:#ede9fe;color:#7c3aed;">
                                                                <i class="fa-solid fa-tag"></i>
                                                            </div>
                                                            <div>
                                                                <div
                                                                    style="font-family:var(--font-serif);font-size:1.05rem;font-weight:700;color:var(--color-primary);">
                                                                    Thông tin cơ bản</div>
                                                                <div
                                                                    style="font-size:0.78rem;color:var(--color-text-muted);margin-top:2px;">
                                                                    Mã voucher và mô tả</div>
                                                            </div>
                                                        </div>
                                                        <div class="form-card__body">
                                                            <div class="form-grid-2">
                                                                <div class="form-group">
                                                                    <label class="form-label">Mã Voucher <span
                                                                            class="required">*</span></label>
                                                                    <input type="text" name="code" id="codeInput"
                                                                        class="form-input code-input"
                                                                        value="${voucher.code}" required maxlength="50"
                                                                        placeholder="VD: SUMMER25"
                                                                        oninput="updatePreview()">
                                                                    <span
                                                                        style="font-size:0.72rem;color:var(--color-text-muted);">Tự
                                                                        động chuyển thành chữ HOA</span>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label class="form-label">Mô tả <span
                                                                            class="hint">(hiển thị cho khách
                                                                            hàng)</span></label>
                                                                    <input type="text" name="description" id="descInput"
                                                                        class="form-input"
                                                                        value="${voucher.description}" maxlength="255"
                                                                        placeholder="VD: Giảm 25% dịp hè 2026"
                                                                        oninput="updatePreview()">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <%-- ── Card 2: Loại & Giá trị ───────────────────────── --%>
                                                        <div class="form-card" style="margin-bottom:var(--space-lg);">
                                                            <div class="form-card__header">
                                                                <div class="form-card__header-icon"
                                                                    style="background:#d1fae5;color:#065f46;">
                                                                    <i class="fa-solid fa-percent"></i>
                                                                </div>
                                                                <div>
                                                                    <div
                                                                        style="font-family:var(--font-serif);font-size:1.05rem;font-weight:700;color:var(--color-primary);">
                                                                        Loại & Giá trị giảm</div>
                                                                    <div
                                                                        style="font-size:0.78rem;color:var(--color-text-muted);margin-top:2px;">
                                                                        Cách tính giảm giá</div>
                                                                </div>
                                                            </div>
                                                            <div class="form-card__body">

                                                                <%-- Type selector --%>
                                                                    <div class="form-group"
                                                                        style="margin-bottom:var(--space-lg);">
                                                                        <label class="form-label">Loại giảm giá <span
                                                                                class="required">*</span></label>
                                                                        <div class="type-selector">
                                                                            <div class="type-option">
                                                                                <input type="radio" name="discountType"
                                                                                    id="typePercent" value="PERCENT"
                                                                                    ${empty voucher or
                                                                                    voucher.discountType eq 'PERCENT'
                                                                                    ? 'checked' : '' }
                                                                                    onchange="handleTypeChange()">
                                                                                <label for="typePercent"
                                                                                    class="type-option__label">
                                                                                    <div class="type-option__icon"
                                                                                        style="background:#dbeafe;color:#1d4ed8;">
                                                                                        <i
                                                                                            class="fa-solid fa-percent"></i>
                                                                                    </div>
                                                                                    <div class="type-option__title">Phần
                                                                                        trăm (%)</div>
                                                                                    <div class="type-option__desc">Giảm
                                                                                        theo % tổng đơn hàng</div>
                                                                                </label>
                                                                            </div>
                                                                            <div class="type-option">
                                                                                <input type="radio" name="discountType"
                                                                                    id="typeFixed" value="FIXED"
                                                                                    ${voucher.discountType eq 'FIXED'
                                                                                    ? 'checked' : '' }
                                                                                    onchange="handleTypeChange()">
                                                                                <label for="typeFixed"
                                                                                    class="type-option__label">
                                                                                    <div class="type-option__icon"
                                                                                        style="background:#d1fae5;color:#065f46;">
                                                                                        <i
                                                                                            class="fa-solid fa-money-bill-wave"></i>
                                                                                    </div>
                                                                                    <div class="type-option__title">Số
                                                                                        tiền cố định (₫)</div>
                                                                                    <div class="type-option__desc">Giảm
                                                                                        trực tiếp số tiền cố định</div>
                                                                                </label>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <div class="form-grid-2">
                                                                        <%-- Giá trị giảm --%>
                                                                            <div class="form-group">
                                                                                <label class="form-label"
                                                                                    id="discountValueLabel">Giá trị giảm
                                                                                    (%) <span
                                                                                        class="required">*</span></label>
                                                                                <div class="form-input-prefix">
                                                                                    <span
                                                                                        class="form-input-prefix__addon"
                                                                                        id="discountUnit">%</span>
                                                                                    <input type="number"
                                                                                        name="discountValue"
                                                                                        id="discountValueInput"
                                                                                        class="form-input"
                                                                                        value="${voucher.discountValue}"
                                                                                        required min="0" step="0.01"
                                                                                        placeholder="VD: 20"
                                                                                        oninput="updatePreview()">
                                                                                </div>
                                                                            </div>

                                                                            <%-- Trần giảm tối đa (chỉ cho PERCENT) --%>
                                                                                <div class="form-group"
                                                                                    id="maxDiscountWrap">
                                                                                    <label class="form-label">Giảm tối
                                                                                        đa (₫) <span class="hint">(chỉ
                                                                                            áp dụng cho
                                                                                            %)</span></label>
                                                                                    <div class="form-input-prefix">
                                                                                        <span
                                                                                            class="form-input-prefix__addon">₫</span>
                                                                                        <input type="number"
                                                                                            name="maxDiscountAmount"
                                                                                            id="maxDiscountInput"
                                                                                            class="form-input"
                                                                                            value="${voucher.maxDiscountAmount}"
                                                                                            min="0"
                                                                                            placeholder="Để trống = không giới hạn">
                                                                                    </div>
                                                                                </div>
                                                                    </div>

                                                                    <%-- Đơn tối thiểu --%>
                                                                        <div class="form-group"
                                                                            style="margin-top:var(--space-lg);">
                                                                            <label class="form-label">Giá trị đơn hàng
                                                                                tối thiểu (₫) <span class="hint">(để
                                                                                    trống = không yêu
                                                                                    cầu)</span></label>
                                                                            <div class="form-input-prefix">
                                                                                <span class="form-input-prefix__addon">₫
                                                                                    ≥</span>
                                                                                <input type="number"
                                                                                    name="minOrderValue"
                                                                                    class="form-input"
                                                                                    value="${voucher.minOrderValue}"
                                                                                    min="0" placeholder="VD: 500000">
                                                                            </div>
                                                                        </div>
                                                            </div>
                                                        </div>

                                                        <%-- ── Card 3: Giới hạn & Thời gian ─────────────────── --%>
                                                            <div class="form-card"
                                                                style="margin-bottom:var(--space-lg);">
                                                                <div class="form-card__header">
                                                                    <div class="form-card__header-icon"
                                                                        style="background:#fef3c7;color:#d97706;">
                                                                        <i class="fa-solid fa-clock"></i>
                                                                    </div>
                                                                    <div>
                                                                        <div
                                                                            style="font-family:var(--font-serif);font-size:1.05rem;font-weight:700;color:var(--color-primary);">
                                                                            Giới hạn & Thời hạn</div>
                                                                        <div
                                                                            style="font-size:0.78rem;color:var(--color-text-muted);margin-top:2px;">
                                                                            Số lần dùng và khoảng thời gian hiệu lực
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-card__body">
                                                                    <div class="form-grid-3">
                                                                        <div class="form-group">
                                                                            <label class="form-label">Giới hạn lượt dùng
                                                                                <span class="hint">(-1 = vô
                                                                                    hạn)</span></label>
                                                                            <input type="number" name="usageLimit"
                                                                                class="form-input"
                                                                                value="${empty voucher ? '-1' : voucher.usageLimit}"
                                                                                placeholder="-1">
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label">Ngày bắt
                                                                                đầu</label>
                                                                            <input type="datetime-local"
                                                                                name="startDate" class="form-input"
                                                                                value="${not empty voucher.startDate ? voucher.startDate : ''}">
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label">Ngày kết
                                                                                thúc</label>
                                                                            <input type="datetime-local" name="endDate"
                                                                                class="form-input"
                                                                                value="${not empty voucher.endDate ? voucher.endDate : ''}">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <%-- ── Card 4: Trạng thái ──────────────────────────────
                                                                --%>
                                                                <div class="form-card"
                                                                    style="margin-bottom:var(--space-xl);">
                                                                    <div class="form-card__header">
                                                                        <div class="form-card__header-icon"
                                                                            style="background:var(--color-success-bg);color:var(--color-success-text);">
                                                                            <i class="fa-solid fa-toggle-on"></i>
                                                                        </div>
                                                                        <div>
                                                                            <div
                                                                                style="font-family:var(--font-serif);font-size:1.05rem;font-weight:700;color:var(--color-primary);">
                                                                                Trạng thái</div>
                                                                            <div
                                                                                style="font-size:0.78rem;color:var(--color-text-muted);margin-top:2px;">
                                                                                Kích hoạt ngay sau khi lưu</div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-card__body">
                                                                        <div class="toggle-wrap">
                                                                            <label class="toggle-switch">
                                                                                <input type="checkbox" name="isActive"
                                                                                    value="1" id="activeToggle" ${empty
                                                                                    voucher or voucher.active
                                                                                    ? 'checked' : '' }
                                                                                    onchange="updatePreview()">
                                                                                <span class="toggle-slider"></span>
                                                                            </label>
                                                                            <div>
                                                                                <div class="toggle-text"
                                                                                    id="toggleText">${empty voucher or
                                                                                    voucher.active ? 'Đang kích hoạt' :
                                                                                    'Đã tắt'}</div>
                                                                                <div class="toggle-sub">Voucher ${empty
                                                                                    voucher or voucher.active ? 'sẽ hiển
                                                                                    thị và dùng được ngay khi lưu' : 'sẽ
                                                                                    không hiển thị với khách hàng'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <%-- ── Action Buttons
                                                                    ──────────────────────────────────── --%>
                                                                    <div
                                                                        style="display:flex;gap:12px;align-items:center;">
                                                                        <button type="submit" class="btn-primary">
                                                                            <i class="fa-solid fa-floppy-disk"></i>
                                                                            ${empty voucher ? 'Tạo Voucher' : 'Lưu thay
                                                                            đổi'}
                                                                        </button>
                                                                        <a href="${pageContext.request.contextPath}/voucher?action=list"
                                                                            class="btn-secondary">
                                                                            <i class="fa-solid fa-arrow-left"></i> Huỷ
                                                                            bỏ
                                                                        </a>
                                                                        <c:if test="${not empty voucher}">
                                                                            <span
                                                                                style="font-size:0.75rem;color:var(--color-text-muted);margin-left:auto;">
                                                                                ID: #${voucher.voucherId} · Đã dùng:
                                                                                ${voucher.usedCount} lần
                                                                            </span>
                                                                        </c:if>
                                                                    </div>
                                            </form>

                                            <%-- RIGHT: Live Preview ───────────────────────────────── --%>
                                                <div>
                                                    <div class="preview-card" id="previewCard">
                                                        <div class="preview-card__label">Preview Voucher</div>
                                                        <div class="preview-card__code" id="previewCode">${not empty
                                                            voucher.code ? voucher.code : 'MÃCODE'}</div>
                                                        <div class="preview-card__desc" id="previewDesc">${not empty
                                                            voucher.description ? voucher.description : 'Mô tả voucher
                                                            sẽ hiển thị ở đây'}</div>

                                                        <div
                                                            style="background:rgba(255,255,255,0.12);border-radius:var(--radius-md);padding:16px;">
                                                            <div class="preview-card__row">
                                                                <span class="preview-card__row-label">Giảm giá</span>
                                                                <span class="preview-card__row-value"
                                                                    id="previewDiscount">
                                                                    ${not empty voucher.discountValue ?
                                                                    voucher.discountValue : '—'}
                                                                    ${voucher.discountType eq 'FIXED' ? ' ₫' : '%'}
                                                                </span>
                                                            </div>
                                                            <div class="preview-card__row" id="previewMinRow"
                                                                style="${empty voucher.minOrderValue ? 'display:none;' : ''}">
                                                                <span class="preview-card__row-label">Đơn tối
                                                                    thiểu</span>
                                                                <span class="preview-card__row-value"
                                                                    id="previewMin"></span>
                                                            </div>
                                                        </div>

                                                        <div class="preview-card__divider"></div>
                                                        <div
                                                            style="display:flex;align-items:center;justify-content:space-between;">
                                                            <span style="font-size:0.72rem;opacity:0.6;">Trạng
                                                                thái</span>
                                                            <span id="previewStatus"
                                                                style="font-size:0.82rem;font-weight:700;padding:4px 12px;border-radius:99px;background:rgba(255,255,255,0.15);">
                                                                ${empty voucher or voucher.active ? '✅ Active' : '⛔
                                                                Inactive'}
                                                            </span>
                                                        </div>
                                                    </div>

                                                    <div
                                                        style="margin-top:var(--space-lg);padding:16px;background:var(--color-white);border-radius:var(--radius-lg);box-shadow:var(--shadow-card);">
                                                        <div
                                                            style="font-size:0.72rem;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--color-text-muted);margin-bottom:12px;">
                                                            <i class="fa-solid fa-circle-info"
                                                                style="margin-right:4px;"></i> Hướng dẫn
                                                        </div>
                                                        <ul
                                                            style="list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:10px;">
                                                            <li
                                                                style="font-size:0.78rem;color:var(--color-text-secondary);display:flex;gap:8px;align-items:flex-start;">
                                                                <i class="fa-solid fa-percent"
                                                                    style="color:#1d4ed8;margin-top:2px;flex-shrink:0;"></i>
                                                                <span><strong>Phần trăm:</strong> Giảm X% tổng đơn. Có
                                                                    thể đặt trần giảm tối đa.</span>
                                                            </li>
                                                            <li
                                                                style="font-size:0.78rem;color:var(--color-text-secondary);display:flex;gap:8px;align-items:flex-start;">
                                                                <i class="fa-solid fa-money-bill"
                                                                    style="color:#065f46;margin-top:2px;flex-shrink:0;"></i>
                                                                <span><strong>Cố định:</strong> Trừ thẳng số tiền vào
                                                                    tổng đơn hàng.</span>
                                                            </li>
                                                            <li
                                                                style="font-size:0.78rem;color:var(--color-text-secondary);display:flex;gap:8px;align-items:flex-start;">
                                                                <i class="fa-solid fa-minus"
                                                                    style="color:#d97706;margin-top:2px;flex-shrink:0;"></i>
                                                                <span><strong>Giới hạn -1</strong> nghĩa là không giới
                                                                    hạn số lần dùng.</span>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>

                                    </div><%-- end grid --%>

                        </div>
                    </main>

                    <script>
                        function handleTypeChange() {
                            const isPercent = document.getElementById('typePercent').checked;
                            document.getElementById('discountValueLabel').innerHTML =
                                (isPercent ? 'Giá trị giảm (%)' : 'Số tiền giảm (₫)') + ' <span style="color:#dc2626;">*</span>';
                            document.getElementById('discountUnit').textContent = isPercent ? '%' : '₫';
                            document.getElementById('maxDiscountWrap').style.display = isPercent ? '' : 'none';
                            updatePreview();
                        }

                        function updatePreview() {
                            const code = document.getElementById('codeInput').value.toUpperCase() || 'MÃCODE';
                            const desc = document.getElementById('descInput').value || 'Mô tả voucher sẽ hiển thị ở đây';
                            const val = document.getElementById('discountValueInput').value;
                            const isPercent = document.getElementById('typePercent').checked;
                            const active = document.getElementById('activeToggle').checked;

                            document.getElementById('previewCode').textContent = code;
                            document.getElementById('previewDesc').textContent = desc;
                            document.getElementById('previewDiscount').textContent = val ? (val + (isPercent ? '%' : ' ₫')) : '—';
                            document.getElementById('previewStatus').textContent = active ? '✅ Active' : '⛔ Inactive';
                            document.getElementById('toggleText').textContent = active ? 'Đang kích hoạt' : 'Đã tắt';

                            const minInput = document.querySelector('input[name="minOrderValue"]');
                            if (minInput && minInput.value) {
                                document.getElementById('previewMinRow').style.display = '';
                                document.getElementById('previewMin').textContent = Number(minInput.value).toLocaleString('vi-VN') + ' ₫';
                            } else {
                                document.getElementById('previewMinRow').style.display = 'none';
                            }
                        }

                        // Keep code UPPERCASE while typing
                        document.getElementById('codeInput').addEventListener('input', function () {
                            const pos = this.selectionStart;
                            this.value = this.value.toUpperCase();
                            this.setSelectionRange(pos, pos);
                        });

                        // Init
                        handleTypeChange();
                        document.querySelector('input[name="minOrderValue"]').addEventListener('input', updatePreview);
                    </script>
        </body>

        </html>
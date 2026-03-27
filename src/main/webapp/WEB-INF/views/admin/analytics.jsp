<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Analytics — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>

                <style>
                    /* ===== Analytics Page Styles ===== */
                    .analytics-kpi-grid {
                        display: grid;
                        grid-template-columns: repeat(4, 1fr);
                        gap: 24px;
                        margin-bottom: 32px;
                    }

                    .analytics-kpi-card {
                        background: #fff;
                        border-radius: 20px;
                        padding: 28px;
                        box-shadow: 0 8px 32px rgba(15, 27, 45, 0.06);
                        transition: transform 0.25s ease, box-shadow 0.25s ease;
                    }

                    .analytics-kpi-card:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 12px 40px rgba(15, 27, 45, 0.1);
                    }

                    .analytics-kpi-card__icon {
                        width: 44px;
                        height: 44px;
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.1rem;
                        margin-bottom: 16px;
                    }

                    .analytics-kpi-card__icon--revenue {
                        background: rgba(34, 197, 94, 0.1);
                        color: #16a34a;
                    }

                    .analytics-kpi-card__icon--month {
                        background: rgba(59, 130, 246, 0.1);
                        color: #2563eb;
                    }

                    .analytics-kpi-card__icon--today {
                        background: rgba(168, 85, 247, 0.1);
                        color: #9333ea;
                    }

                    .analytics-kpi-card__icon--growth {
                        background: rgba(245, 158, 11, 0.1);
                        color: #d97706;
                    }

                    .analytics-kpi-card__label {
                        font-family: 'Inter', sans-serif;
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        color: #8896a6;
                        margin-bottom: 8px;
                    }

                    .analytics-kpi-card__value {
                        font-family: 'Inter', sans-serif;
                        font-size: 1.75rem;
                        font-weight: 700;
                        color: #0f1b2d;
                        line-height: 1.2;
                    }

                    .analytics-kpi-card__change {
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        margin-top: 10px;
                        font-size: 0.78rem;
                        font-weight: 600;
                        padding: 3px 10px;
                        border-radius: 20px;
                    }

                    .analytics-kpi-card__change--up {
                        background: rgba(34, 197, 94, 0.1);
                        color: #16a34a;
                    }

                    .analytics-kpi-card__change--down {
                        background: rgba(220, 38, 38, 0.1);
                        color: #dc2626;
                    }

                    .analytics-kpi-card__change--neutral {
                        background: rgba(107, 114, 128, 0.1);
                        color: #6b7280;
                    }

                    /* Charts grid */
                    .analytics-charts-grid {
                        display: grid;
                        grid-template-columns: 1.4fr 1fr;
                        gap: 24px;
                        margin-bottom: 32px;
                    }

                    .analytics-chart-card {
                        background: #fff;
                        border-radius: 20px;
                        padding: 28px;
                        box-shadow: 0 8px 32px rgba(15, 27, 45, 0.06);
                    }

                    .analytics-chart-card__header {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-start;
                        margin-bottom: 24px;
                    }

                    .analytics-chart-card__title {
                        font-family: 'Playfair Display', serif;
                        font-size: 1.15rem;
                        font-weight: 700;
                        color: #0f1b2d;
                    }

                    .analytics-chart-card__subtitle {
                        font-family: 'Inter', sans-serif;
                        font-size: 0.78rem;
                        color: #8896a6;
                        margin-top: 4px;
                    }

                    .analytics-chart-wrap {
                        position: relative;
                        width: 100%;
                        height: 280px;
                    }

                    .analytics-chart-wrap canvas {
                        width: 100% !important;
                        height: 100% !important;
                    }

                    /* Rankings & Tables */
                    .analytics-bottom-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 24px;
                        margin-bottom: 32px;
                    }

                    .analytics-rank-card {
                        background: #fff;
                        border-radius: 20px;
                        padding: 28px;
                        box-shadow: 0 8px 32px rgba(15, 27, 45, 0.06);
                    }

                    .analytics-rank-card__title {
                        font-family: 'Playfair Display', serif;
                        font-size: 1.15rem;
                        font-weight: 700;
                        color: #0f1b2d;
                        margin-bottom: 20px;
                    }

                    .analytics-rank-item {
                        display: flex;
                        align-items: center;
                        gap: 14px;
                        padding: 14px 0;
                        border-bottom: 1px solid #f1f3f5;
                    }

                    .analytics-rank-item:last-child {
                        border-bottom: none;
                    }

                    .analytics-rank-num {
                        width: 32px;
                        height: 32px;
                        border-radius: 10px;
                        background: #f1f3f5;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-family: 'Inter', sans-serif;
                        font-size: 0.8rem;
                        font-weight: 700;
                        color: #0f1b2d;
                        flex-shrink: 0;
                    }

                    .analytics-rank-num--gold {
                        background: #fef3c7;
                        color: #b45309;
                    }

                    .analytics-rank-num--silver {
                        background: #f1f5f9;
                        color: #475569;
                    }

                    .analytics-rank-num--bronze {
                        background: #fed7aa;
                        color: #c2410c;
                    }

                    .analytics-rank-info {
                        flex: 1;
                        min-width: 0;
                    }

                    .analytics-rank-name {
                        font-family: 'Inter', sans-serif;
                        font-size: 0.88rem;
                        font-weight: 600;
                        color: #0f1b2d;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .analytics-rank-meta {
                        font-family: 'Inter', sans-serif;
                        font-size: 0.75rem;
                        color: #8896a6;
                        margin-top: 2px;
                    }

                    .analytics-rank-value {
                        font-family: 'Inter', sans-serif;
                        font-size: 0.88rem;
                        font-weight: 700;
                        color: #0f1b2d;
                        flex-shrink: 0;
                    }

                    /* Low stock alert */
                    .analytics-alert-row {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 12px 0;
                        border-bottom: 1px solid #f1f3f5;
                    }

                    .analytics-alert-row:last-child {
                        border-bottom: none;
                    }

                    .analytics-stock-badge {
                        display: inline-block;
                        padding: 3px 10px;
                        border-radius: 20px;
                        font-size: 0.72rem;
                        font-weight: 700;
                        flex-shrink: 0;
                    }

                    .analytics-stock-badge--critical {
                        background: #fef2f2;
                        color: #dc2626;
                    }

                    .analytics-stock-badge--warning {
                        background: #fffbeb;
                        color: #d97706;
                    }

                    /* Customer insights */
                    .analytics-customer-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr 2fr;
                        gap: 24px;
                        margin-bottom: 32px;
                    }

                    .analytics-stat-card {
                        background: #fff;
                        border-radius: 20px;
                        padding: 28px;
                        box-shadow: 0 8px 32px rgba(15, 27, 45, 0.06);
                        display: flex;
                        flex-direction: column;
                        justify-content: center;
                    }

                    .analytics-customer-table {
                        width: 100%;
                        border-collapse: collapse;
                        font-family: 'Inter', sans-serif;
                    }

                    .analytics-customer-table thead th {
                        font-size: 0.72rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        color: #8896a6;
                        padding: 10px 12px;
                        text-align: left;
                        border-bottom: 1px solid #f1f3f5;
                    }

                    .analytics-customer-table tbody td {
                        padding: 12px;
                        font-size: 0.85rem;
                        color: #0f1b2d;
                        border-bottom: 1px solid #f8f9fa;
                    }

                    .analytics-customer-table tbody tr:last-child td {
                        border-bottom: none;
                    }

                    /* Empty state */
                    .analytics-empty {
                        text-align: center;
                        padding: 40px 20px;
                        color: #8896a6;
                        font-style: italic;
                        font-size: 0.9rem;
                    }

                    .analytics-empty i {
                        display: block;
                        font-size: 2rem;
                        margin-bottom: 12px;
                        opacity: 0.4;
                    }

                    /* Error state */
                    .analytics-error {
                        background: #fef2f2;
                        border: 1px solid #fecaca;
                        border-radius: 16px;
                        padding: 20px 28px;
                        margin-bottom: 24px;
                        color: #991b1b;
                        font-size: 0.88rem;
                    }

                    /* Responsive */
                    @media (max-width: 1200px) {
                        .analytics-kpi-grid {
                            grid-template-columns: repeat(2, 1fr);
                        }

                        .analytics-charts-grid,
                        .analytics-bottom-grid {
                            grid-template-columns: 1fr;
                        }

                        .analytics-customer-grid {
                            grid-template-columns: 1fr 1fr;
                        }
                    }

                    @media (max-width: 768px) {
                        .analytics-kpi-grid {
                            grid-template-columns: 1fr;
                        }

                        .analytics-customer-grid {
                            grid-template-columns: 1fr;
                        }
                    }
                    /* Filter Bar */
                    .analytics-filter-bar {
                        background: #fff;
                        border-radius: 20px;
                        padding: 20px 28px;
                        margin-bottom: 32px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        background: #fff;
                        padding: 16px 24px;
                        border-radius: 16px;
                        margin-bottom: 30px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
                        border: 1px solid rgba(0, 0, 0, 0.05);
                        flex-wrap: wrap;
                        gap: 20px;
                    }

                    .filter-controls {
                        display: flex;
                        align-items: center;
                        gap: 24px;
                        flex-wrap: wrap;
                    }

                    .filter-group {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .filter-group label {
                        font-family: 'Inter', sans-serif;
                        font-weight: 600;
                        font-size: 0.85rem;
                        color: #64748b;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .filter-btns-wrapper {
                        display: flex;
                        background: #f1f5f9;
                        padding: 4px;
                        border-radius: 12px;
                        gap: 2px;
                    }

                    .filter-btn {
                        border: none;
                        background: transparent;
                        padding: 8px 16px;
                        border-radius: 10px;
                        font-family: 'Inter', sans-serif;
                        font-weight: 600;
                        font-size: 0.8rem;
                        color: #64748b;
                        cursor: pointer;
                        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                    }

                    .filter-btn:hover {
                        color: #0f172a;
                    }

                    .filter-btn.active {
                        background: #fff;
                        color: #0f172a;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                    }

                    .picker-group input, .picker-group select {
                        padding: 8px 14px;
                        border-radius: 10px;
                        border: 1px solid #e2e8f0;
                        font-family: 'Inter', sans-serif;
                        font-size: 0.85rem;
                        color: #0f172a;
                        background: #fff;
                        transition: all 0.2s ease;
                        cursor: pointer;
                        outline: none;
                    }

                    .picker-group input:focus, .picker-group select:focus {
                        border-color: #3b82f6;
                        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                    }

                    .clear-filter {
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        padding: 8px 16px;
                        border-radius: 10px;
                        font-family: 'Inter', sans-serif;
                        font-size: 0.8rem;
                        font-weight: 600;
                        color: #64748b;
                        text-decoration: none;
                        transition: all 0.2s ease;
                        background: #f8fafc;
                        border: 1px solid #e2e8f0;
                    }

                    .clear-filter i {
                        font-size: 0.9rem;
                        color: #94a3b8;
                    }

                    .clear-filter:hover {
                        background: #fff;
                        color: #ef4444;
                        border-color: #fca5a5;
                        box-shadow: 0 2px 8px rgba(239, 68, 68, 0.08);
                    }

                    .clear-filter:hover i {
                        color: #ef4444;
                    }

                    .hidden {
                        display: none !important;
                    }
                </style>
            </head>

            <body class="luxury-admin">
                <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
                    <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

                        <main class="lux-main">
                            <div class="lux-content">

                                <!-- ========== PAGE HEADER ========== -->
                                <section class="lux-page-header">
                                    <div class="lux-page-header__text">
                                        <h1 class="lux-page-header__title">Sales<br>Analytics</h1>
                                        <p class="lux-page-header__subtitle">
                                            Comprehensive overview of revenue performance, order trends, product
                                            insights,
                                            and customer behavior across all channels.
                                        </p>
                                    </div>
                                </section>

                                 <!-- ========== FILTER BAR ========== -->
                                 <section class="analytics-filter-bar">
                                    <div class="filter-controls">
                                        <div class="filter-group">
                                            <label><i class="fa-solid fa-calendar-days" style="margin-right:8px;"></i> View By</label>
                                            <div class="filter-btns-wrapper">
                                                <button type="button" class="filter-btn ${filterType == 'YEAR' ? 'active' : ''}" onclick="setFilterType('YEAR')">Yearly</button>
                                                <button type="button" class="filter-btn ${filterType == 'MONTH' ? 'active' : ''}" onclick="setFilterType('MONTH')">Monthly</button>
                                                <button type="button" class="filter-btn ${filterType == 'DAY' ? 'active' : ''}" onclick="setFilterType('DAY')">Daily</button>
                                            </div>
                                        </div>
                                        
                                        <div class="filter-group">
                                            <form action="${pageContext.request.contextPath}/admin/analytics" method="get" id="filterForm" style="display:flex; align-items:center; gap:16px;">
                                                <input type="hidden" name="type" id="filterTypeInput" value="${filterType}">
                                                
                                                <div id="picker-YEAR" class="picker-group ${filterType == 'YEAR' ? '' : 'hidden'}">
                                                    <select name="value" onchange="this.form.submit()" ${filterType == 'YEAR' ? '' : 'disabled'}>
                                                        <option value="">Select Year</option>
                                                        <c:forEach var="y" begin="2023" end="2026">
                                                            <c:set var="yStr" value="${y}" />
                                                            <option value="${y}" ${filterType == 'YEAR' and filterValue == yStr ? 'selected' : ''}>${y}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                
                                                <div id="picker-MONTH" class="picker-group ${filterType == 'MONTH' ? '' : 'hidden'}">
                                                    <input type="month" name="value" value="${filterValue}" onchange="this.form.submit()" ${filterType == 'MONTH' ? '' : 'disabled'}>
                                                </div>
                                                
                                                <div id="picker-DAY" class="picker-group ${filterType == 'DAY' ? '' : 'hidden'}">
                                                    <input type="date" name="value" value="${filterValue}" onchange="this.form.submit()" ${filterType == 'DAY' ? '' : 'disabled'}>
                                                </div>
                                                
                                                <c:if test="${not empty filterType}">
                                                    <a href="${pageContext.request.contextPath}/admin/analytics" class="clear-filter">
                                                        <i class="fa-solid fa-rotate-left"></i> Reset Filter
                                                    </a>
                                                </c:if>
                                            </form>
                                        </div>
                                    </div>

                                    <div class="filter-status">
                                        <c:if test="${not empty filterType}">
                                            <span style="font-size: 0.8rem; color: #94a3b8; font-weight: 500;">
                                                Showing data for: <strong style="color: #334155;">${filterValue}</strong>
                                            </span>
                                        </c:if>
                                    </div>
                                 </section>

                                 <!-- Error Message -->
                                <c:if test="${not empty error}">
                                    <div class="analytics-error">
                                        <i class="fa-solid fa-triangle-exclamation"></i> ${error}
                                    </div>
                                </c:if>

                                <!-- ========== SECTION A: Revenue KPI Cards ========== -->
                                <section class="analytics-kpi-grid">
                                    <!-- Total Revenue -->
                                    <div class="analytics-kpi-card">
                                        <div class="analytics-kpi-card__icon analytics-kpi-card__icon--revenue">
                                            <i class="fa-solid fa-wallet"></i>
                                        </div>
                                        <div class="analytics-kpi-card__label">
                                            <c:choose>
                                                <c:when test="${not empty filterType}">Revenue (${filterValue})</c:when>
                                                <c:otherwise>Total Revenue (All Time)</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="analytics-kpi-card__value">
                                            $
                                            <fmt:formatNumber value="${totalRevenue}" type="number"
                                                maxFractionDigits="0" groupingUsed="true" />
                                        </div>
                                        <div class="analytics-kpi-card__change ${revenueGrowth >= 0 ? 'analytics-kpi-card__change--positive' : 'analytics-kpi-card__change--negative'}">
                                            <c:choose>
                                                <c:when test="${not empty filterType and filterType != 'YEAR'}">
                                                    <i class="fa-solid ${revenueGrowth >= 0 ? 'fa-arrow-trend-up' : 'fa-arrow-trend-down'}"></i> 
                                                    ${revenueGrowth < 0 ? -revenueGrowth : revenueGrowth}% vs last period
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-solid fa-chart-simple"></i> Completed Orders only
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Total Orders -->
                                    <div class="analytics-kpi-card">
                                        <div class="analytics-kpi-card__icon analytics-kpi-card__icon--orders">
                                            <i class="fa-solid fa-cart-shopping"></i>
                                        </div>
                                        <div class="analytics-kpi-card__label">
                                            <c:choose>
                                                <c:when test="${not empty filterType}">Total Orders (${filterValue})</c:when>
                                                <c:otherwise>Total Orders (All Time)</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="analytics-kpi-card__value">
                                            <fmt:formatNumber value="${totalOrders}" type="number" groupingUsed="true" />
                                        </div>
                                        <div class="analytics-kpi-card__change analytics-kpi-card__change--neutral">
                                            <i class="fa-solid fa-box"></i> Across all categories
                                        </div>
                                    </div>

                                    <!-- Completed Orders -->
                                    <div class="analytics-kpi-card">
                                        <div class="analytics-kpi-card__icon analytics-kpi-card__icon--shipping">
                                            <i class="fa-solid fa-circle-check"></i>
                                        </div>
                                        <div class="analytics-kpi-card__label">
                                            <c:choose>
                                                <c:when test="${not empty filterType}">Completed (${filterValue})</c:when>
                                                <c:otherwise>Completed (All Time)</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="analytics-kpi-card__value">
                                            <fmt:formatNumber value="${completedOrders}" type="number" groupingUsed="true" />
                                        </div>
                                        <div class="analytics-kpi-card__change analytics-kpi-card__change--positive">
                                            <i class="fa-solid fa-star"></i> 
                                            <c:if test="${totalOrders > 0}">
                                                <fmt:formatNumber value="${(completedOrders / totalOrders) * 100}" maxFractionDigits="1" />% Success Rate
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- Customers -->
                                    <div class="analytics-kpi-card">
                                        <div class="analytics-kpi-card__icon analytics-kpi-card__icon--customers">
                                            <i class="fa-solid fa-users"></i>
                                        </div>
                                        <div class="analytics-kpi-card__label">
                                            <c:choose>
                                                <c:when test="${not empty filterType}">Customers (${filterValue})</c:when>
                                                <c:otherwise>Total Customers (All Time)</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="analytics-kpi-card__value">
                                            <fmt:formatNumber value="${totalCustomersInPeriod}" type="number" groupingUsed="true" />
                                        </div>
                                        <div class="analytics-kpi-card__change analytics-kpi-card__change--neutral">
                                            <i class="fa-solid fa-user-plus"></i> ${newCustomers} new this month / ${totalCustomers} lifetime
                                        </div>
                                    </div>
                                </section>

                                <!-- ========== SECTION B: Charts ========== -->
                                <section class="analytics-charts-grid">
                                    <!-- Revenue Line Chart (12 months) -->
                                    <div class="analytics-chart-card">
                                        <div class="analytics-chart-card__header">
                                            <div>
                                                 <div class="analytics-chart-card__title">Revenue Trend</div>
                                                 <div class="analytics-chart-card__subtitle">${chartSubtitle}</div>
                                            </div>
                                        </div>
                                        <div class="analytics-chart-wrap">
                                            <canvas id="revenueChart"></canvas>
                                        </div>
                                    </div>

                                    <!-- Orders Bar Chart (7 days) -->
                                    <div class="analytics-chart-card">
                                        <div class="analytics-chart-card__header">
                                            <div>
                                                 <div class="analytics-chart-card__title">Orders Volume</div>
                                                 <div class="analytics-chart-card__subtitle">${chartSubtitle}</div>
                                            </div>
                                        </div>
                                        <div class="analytics-chart-wrap">
                                            <canvas id="ordersChart"></canvas>
                                        </div>
                                    </div>
                                </section>

                                <!-- ========== SECTION C: Order Status + Top Products ========== -->
                                <section class="analytics-bottom-grid">
                                    <!-- Order Status Pie Chart -->
                                    <div class="analytics-chart-card">
                                        <div class="analytics-chart-card__header">
                                            <div>
                                                <div class="analytics-chart-card__title">Order Status</div>
                                                <div class="analytics-chart-card__subtitle">Distribution of order
                                                    statuses</div>
                                            </div>
                                        </div>
                                        <div class="analytics-chart-wrap"
                                            style="height:260px; max-width:320px; margin:0 auto;">
                                            <canvas id="statusChart"></canvas>
                                        </div>
                                    </div>

                                    <!-- Top Selling Products -->
                                    <div class="analytics-rank-card">
                                        <div class="analytics-rank-card__title">Top Selling Products</div>
                                        <c:choose>
                                            <c:when test="${not empty topProducts}">
                                                <c:forEach var="prod" items="${topProducts}" varStatus="idx">
                                                    <div class="analytics-rank-item">
                                                        <div
                                                            class="analytics-rank-num ${idx.index == 0 ? 'analytics-rank-num--gold' : (idx.index == 1 ? 'analytics-rank-num--silver' : (idx.index == 2 ? 'analytics-rank-num--bronze' : ''))}">
                                                            ${idx.index + 1}
                                                        </div>
                                                        <div class="analytics-rank-info">
                                                            <div class="analytics-rank-name">${prod.name}</div>
                                                            <div class="analytics-rank-meta">${prod.totalQty} units sold
                                                            </div>
                                                        </div>
                                                        <div class="analytics-rank-value">
                                                            $
                                                            <fmt:formatNumber value="${prod.totalRevenue}" type="number"
                                                                maxFractionDigits="0" groupingUsed="true" />
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="analytics-empty">
                                                    <i class="fa-solid fa-box-open"></i>
                                                    No sales data available yet.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </section>

                                <!-- ========== SECTION: Low Stock Alert ========== -->
                                <c:if test="${not empty lowStockProducts}">
                                    <section class="analytics-bottom-grid" style="margin-bottom:32px;">
                                        <div class="analytics-rank-card" style="grid-column: 1 / -1;">
                                            <div class="analytics-rank-card__title">
                                                <i class="fa-solid fa-triangle-exclamation"
                                                    style="color:#d97706;margin-right:8px;"></i>
                                                Low Stock Alert
                                            </div>
                                            <c:forEach var="item" items="${lowStockProducts}">
                                                <div class="analytics-alert-row">
                                                    <span
                                                        class="analytics-stock-badge ${item.stock < 3 ? 'analytics-stock-badge--critical' : 'analytics-stock-badge--warning'}">
                                                        ${item.stock} left
                                                    </span>
                                                    <div class="analytics-rank-info">
                                                        <div class="analytics-rank-name">${item.productName}</div>
                                                        <div class="analytics-rank-meta">${item.color} / ${item.size}
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </section>
                                </c:if>

                                <!-- ========== SECTION D: Customer Insights ========== -->
                                <section class="analytics-customer-grid">
                                    <!-- New Customers Card -->
                                    <div class="analytics-stat-card">
                                        <div class="analytics-kpi-card__icon analytics-kpi-card__icon--month"
                                            style="margin-bottom:12px;">
                                            <i class="fa-solid fa-user-plus"></i>
                                        </div>
                                        <div class="analytics-kpi-card__label">New This Month</div>
                                        <div class="analytics-kpi-card__value">${newCustomers}</div>
                                        <div class="analytics-kpi-card__change analytics-kpi-card__change--neutral"
                                            style="margin-top:8px;">
                                            <i class="fa-solid fa-calendar"></i> Registered users
                                        </div>
                                    </div>

                                    <!-- Total Customers Card -->
                                    <div class="analytics-stat-card">
                                        <div class="analytics-kpi-card__icon analytics-kpi-card__icon--revenue"
                                            style="margin-bottom:12px;">
                                            <i class="fa-solid fa-users"></i>
                                        </div>
                                        <div class="analytics-kpi-card__label">Total Customers</div>
                                        <div class="analytics-kpi-card__value">${totalCustomers}</div>
                                        <div class="analytics-kpi-card__change analytics-kpi-card__change--neutral"
                                            style="margin-top:8px;">
                                            <i class="fa-solid fa-database"></i> All time
                                        </div>
                                    </div>

                                    <!-- Top Customers Table -->
                                    <div class="analytics-rank-card">
                                        <div class="analytics-rank-card__title">Top Customers by Spending</div>
                                        <c:choose>
                                            <c:when test="${not empty topCustomers}">
                                                <table class="analytics-customer-table">
                                                    <thead>
                                                        <tr>
                                                            <th>#</th>
                                                            <th>Customer</th>
                                                            <th>Orders</th>
                                                            <th>Total Spent</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="cust" items="${topCustomers}" varStatus="idx">
                                                            <tr>
                                                                <td style="font-weight:700;color:#8896a6;">${idx.index +
                                                                    1}</td>
                                                                <td>
                                                                    <div style="font-weight:600;">${cust.fullname}</div>
                                                                    <div style="font-size:0.75rem;color:#8896a6;">
                                                                        ${cust.email}</div>
                                                                </td>
                                                                <td>${cust.orderCount}</td>
                                                                <td style="font-weight:700;">
                                                                    $
                                                                    <fmt:formatNumber value="${cust.totalSpent}"
                                                                        type="number" maxFractionDigits="0"
                                                                        groupingUsed="true" />
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="analytics-empty">
                                                    <i class="fa-solid fa-user-group"></i>
                                                    No customer data available yet.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </section>

                            </div>
                        </main>

                        <!-- Chart data from server via data attributes -->
                        <div id="chartData" style="display:none" 
                            data-revenue-labels='${revenueLabels}'
                            data-revenue-data='${revenueData}' 
                            data-order-labels='${orderLabels}'
                            data-order-data='${orderData}' 
                            data-status-labels='${orderStatusLabels}'
                            data-status-data='${orderStatusData}'>
                        </div>
                        <script>
                            function setFilterType(type) {
                                document.getElementById('filterTypeInput').value = type;
                                // Hide all pickers
                                document.getElementById('picker-YEAR').classList.add('hidden');
                                document.getElementById('picker-MONTH').classList.add('hidden');
                                document.getElementById('picker-DAY').classList.add('hidden');

                                // Disable all inputs inside pickers
                                document.querySelector('#picker-YEAR select').disabled = true;
                                document.querySelector('#picker-MONTH input').disabled = true;
                                document.querySelector('#picker-DAY input').disabled = true;

                                // Show selected picker & enable its input
                                document.getElementById('picker-' + type).classList.remove('hidden');
                                document.querySelector('#picker-' + type + ' input, #picker-' + type + ' select').disabled = false;
                                
                                // Highlight active button
                                document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
                                event.target.classList.add('active');
                            }

                            document.addEventListener("DOMContentLoaded", function () {
                                // Redefine chart titles and tooltips based on current filter context...

                                // --- Read chart data from hidden element ---
                                var cd = document.getElementById('chartData');
                                var revenueLabels = JSON.parse(cd.getAttribute('data-revenue-labels') || '[]');
                                var revenueData = JSON.parse(cd.getAttribute('data-revenue-data') || '[]');
                                var orderLabels = JSON.parse(cd.getAttribute('data-order-labels') || '[]');
                                var orderData = JSON.parse(cd.getAttribute('data-order-data') || '[]');
                                var statusLabels = JSON.parse(cd.getAttribute('data-status-labels') || '[]');
                                var statusData = JSON.parse(cd.getAttribute('data-status-data') || '[]');

                                // --- Color palette matching AISTHEA luxury theme ---
                                var NAVY = '#0f1b2d';
                                var NAVY_LIGHT = 'rgba(15, 27, 45, 0.08)';
                                var ACCENT_GREEN = '#16a34a';
                                var ACCENT_BLUE = '#2563eb';
                                var ACCENT_AMBER = '#d97706';
                                var ACCENT_RED = '#dc2626';
                                var ACCENT_PURPLE = '#9333ea';
                                var GRID_COLOR = 'rgba(0,0,0,0.04)';

                                Chart.defaults.font.family = "'Inter', sans-serif";
                                Chart.defaults.color = '#8896a6';

                                // ===== Revenue Line Chart =====
                                var revenueCtx = document.getElementById('revenueChart');
                                if (revenueCtx) {

                                    new Chart(revenueCtx, {
                                        type: 'line',
                                        data: {
                                            labels: revenueLabels,
                                            datasets: [{
                                                label: 'Revenue',
                                                data: revenueData,
                                                borderColor: NAVY,
                                                backgroundColor: function (context) {
                                                    const ctx = context.chart.ctx;
                                                    const gradient = ctx.createLinearGradient(0, 0, 0, 280);
                                                    gradient.addColorStop(0, 'rgba(15, 27, 45, 0.15)');
                                                    gradient.addColorStop(1, 'rgba(15, 27, 45, 0.0)');
                                                    return gradient;
                                                },
                                                borderWidth: 2.5,
                                                fill: true,
                                                tension: 0.4,
                                                pointRadius: 4,
                                                pointHoverRadius: 7,
                                                pointBackgroundColor: '#fff',
                                                pointBorderColor: NAVY,
                                                pointBorderWidth: 2
                                            }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: { display: false },
                                                tooltip: {
                                                    backgroundColor: NAVY,
                                                    titleFont: { size: 12, weight: '600' },
                                                    bodyFont: { size: 13 },
                                                    padding: 14,
                                                    cornerRadius: 12,
                                                    displayColors: false,
                                                    callbacks: {
                                                        label: function (ctx) {
                                                            return '$' + ctx.parsed.y.toLocaleString();
                                                        }
                                                    }
                                                }
                                            },
                                            scales: {
                                                x: {
                                                    grid: { display: false },
                                                    ticks: { font: { size: 11 } }
                                                },
                                                y: {
                                                    grid: { color: GRID_COLOR },
                                                    border: { display: false },
                                                    ticks: {
                                                        font: { size: 11 },
                                                        callback: function (val) {
                                                            if (val >= 1000000) return '$' + (val / 1000000).toFixed(1) + 'M';
                                                            if (val >= 1000) return '$' + (val / 1000).toFixed(0) + 'k';
                                                            return '$' + val;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });
                                }

                                // ===== Orders Bar Chart =====
                                var ordersCtx = document.getElementById('ordersChart');
                                if (ordersCtx) {

                                    new Chart(ordersCtx, {
                                        type: 'bar',
                                        data: {
                                            labels: orderLabels,
                                            datasets: [{
                                                label: 'Orders',
                                                data: orderData,
                                                backgroundColor: function (context) {
                                                    const maxVal = Math.max(...orderData);
                                                    return context.raw === maxVal ? NAVY : 'rgba(15, 27, 45, 0.18)';
                                                },
                                                borderRadius: 8,
                                                borderSkipped: false,
                                                barPercentage: 0.6,
                                                categoryPercentage: 0.7
                                            }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: { display: false },
                                                tooltip: {
                                                    backgroundColor: NAVY,
                                                    titleFont: { size: 12, weight: '600' },
                                                    bodyFont: { size: 13 },
                                                    padding: 14,
                                                    cornerRadius: 12,
                                                    displayColors: false
                                                }
                                            },
                                            scales: {
                                                x: {
                                                    grid: { display: false },
                                                    ticks: { font: { size: 11 } }
                                                },
                                                y: {
                                                    grid: { color: GRID_COLOR },
                                                    border: { display: false },
                                                    ticks: {
                                                        font: { size: 11 },
                                                        stepSize: 1
                                                    },
                                                    beginAtZero: true
                                                }
                                            }
                                        }
                                    });
                                }

                                // ===== Order Status Pie Chart =====
                                var statusCtx = document.getElementById('statusChart');
                                if (statusCtx) {

                                    const statusColors = statusLabels.map(label => {
                                        const l = label.toLowerCase();
                                        if (l === 'completed') return ACCENT_GREEN;
                                        if (l === 'pending') return ACCENT_AMBER;
                                        if (l === 'cancelled') return ACCENT_RED;
                                        if (l === 'shipped') return ACCENT_BLUE;
                                        return ACCENT_PURPLE;
                                    });

                                    new Chart(statusCtx, {
                                        type: 'doughnut',
                                        data: {
                                            labels: statusLabels,
                                            datasets: [{
                                                data: statusData,
                                                backgroundColor: statusColors,
                                                borderWidth: 0,
                                                hoverOffset: 8
                                            }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            cutout: '65%',
                                            plugins: {
                                                legend: {
                                                    position: 'bottom',
                                                    labels: {
                                                        usePointStyle: true,
                                                        pointStyle: 'circle',
                                                        padding: 16,
                                                        font: { size: 12, weight: '500' }
                                                    }
                                                },
                                                tooltip: {
                                                    backgroundColor: NAVY,
                                                    titleFont: { size: 12, weight: '600' },
                                                    bodyFont: { size: 13 },
                                                    padding: 14,
                                                    cornerRadius: 12,
                                                    displayColors: true,
                                                    callbacks: {
                                                        label: function (ctx) {
                                                            const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
                                                            const pct = total > 0 ? ((ctx.parsed / total) * 100).toFixed(1) : 0;
                                                            return ctx.label + ': ' + ctx.parsed + ' (' + pct + '%)';
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });
                                }

                            });
                        </script>

            </body>

            </html>
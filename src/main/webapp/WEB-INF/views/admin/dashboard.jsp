<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
            </head>

            <body class="luxury-admin">

                <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
                    <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

                        <main class="lux-main">
                            <div class="lux-content">

                                <!-- ========== PAGE HEADER ========== -->
                                <section class="lux-page-header">
                                    <div class="lux-page-header__text">
                                        <h1 class="lux-page-header__title">Admin Dashboard<br>Overview</h1>
                                        <p class="lux-page-header__subtitle">
                                            Monitor revenue performance, customer activity, product inventory,
                                            and order management in real time.
                                        </p>
                                    </div>
                                    <div class="lux-page-header__actions">
                                        <a href="${pageContext.request.contextPath}/admin/analytics"
                                            class="lux-btn-primary" style="text-decoration:none;">View Full Report</a>
                                    </div>
                                </section>

                                <!-- ========== KPI CARDS ========== -->
                                <section class="lux-kpi-grid">
                                    <!-- Total Revenue (Completed Orders) -->
                                    <div class="lux-kpi-card">
                                        <div class="lux-kpi-card__header">
                                            <span class="lux-kpi-card__label">Total Revenue (Completed)</span>
                                            <div class="lux-kpi-card__icon">
                                                <i class="fa-solid fa-wallet"></i>
                                            </div>
                                        </div>
                                        <div class="lux-kpi-card__value">
                                            <c:choose>
                                                <c:when test="${not empty totalRevenue}">
                                                    <fmt:formatNumber value="${totalRevenue}" type="number"
                                                        maxFractionDigits="0" groupingUsed="true" />
                                                </c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="lux-kpi-card__growth">
                                            <c:choose>
                                                <c:when test="${revenueGrowth > 0}">
                                                    <i class="fa-solid fa-arrow-trend-up"></i>
                                                    +${revenueGrowth}% vs last month
                                                </c:when>
                                                <c:when test="${revenueGrowth < 0}">
                                                    <i class="fa-solid fa-arrow-trend-down" style="color:#dc2626;"></i>
                                                    <span style="color:#dc2626;">${revenueGrowth}% vs last month</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-solid fa-equals"></i>
                                                    No change vs last month
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Total Orders -->
                                    <div class="lux-kpi-card">
                                        <div class="lux-kpi-card__header">
                                            <span class="lux-kpi-card__label">Total Orders</span>
                                            <div class="lux-kpi-card__icon">
                                                <i class="fa-solid fa-bag-shopping"></i>
                                            </div>
                                        </div>
                                        <div class="lux-kpi-card__value">
                                            <c:choose>
                                                <c:when test="${not empty totalOrders}">${totalOrders}</c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="lux-kpi-card__growth">
                                            <i class="fa-solid fa-chart-simple"></i>
                                            All time
                                        </div>
                                    </div>

                                    <!-- Total Customers -->
                                    <div class="lux-kpi-card">
                                        <div class="lux-kpi-card__header">
                                            <span class="lux-kpi-card__label">Total Customers</span>
                                            <div class="lux-kpi-card__icon">
                                                <i class="fa-solid fa-user-plus"></i>
                                            </div>
                                        </div>
                                        <div class="lux-kpi-card__value">
                                            <c:choose>
                                                <c:when test="${not empty totalUsers}">${totalUsers}</c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="lux-kpi-card__growth">
                                            <i class="fa-solid fa-users"></i>
                                            Registered users
                                        </div>
                                    </div>

                                    <!-- Total Products -->
                                    <div class="lux-kpi-card">
                                        <div class="lux-kpi-card__header">
                                            <span class="lux-kpi-card__label">Total Products</span>
                                            <div class="lux-kpi-card__icon">
                                                <i class="fa-solid fa-box"></i>
                                            </div>
                                        </div>
                                        <div class="lux-kpi-card__value">
                                            <c:choose>
                                                <c:when test="${not empty totalProducts}">${totalProducts}</c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="lux-kpi-card__growth">
                                            <i class="fa-solid fa-boxes-stacked"></i>
                                            In catalog
                                        </div>
                                    </div>

                                    <!-- Active Online Users -->
                                    <div class="lux-kpi-card">
                                        <div class="lux-kpi-card__header">
                                            <span class="lux-kpi-card__label">Active Online Users</span>
                                            <div class="lux-kpi-card__icon">
                                                <i class="fa-solid fa-user-group"></i>
                                            </div>
                                        </div>
                                        <div class="lux-kpi-card__value">
                                            <c:choose>
                                                <c:when test="${not empty onlineUsers}">${onlineUsers.size()}</c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="lux-kpi-card__growth">
                                            <i class="fa-solid fa-circle" style="color:#22c55e;font-size:0.5rem;"></i>
                                            Currently active
                                        </div>
                                    </div>
                                </section>

                                <!-- ========== BOTTOM GRID: Revenue Summary + Sales Analytics ========== -->
                                <section class="lux-bottom-grid">

                                    <!-- Performance Overview -->
                                    <div class="lux-perf-section">
                                        <h2 class="lux-perf-section__title">Performance Overview</h2>

                                        <div class="lux-perf-grid">
                                            <!-- Left: Revenue Card -->
                                            <div class="lux-perf-revenue-card">
                                                <div class="lux-perf-revenue-card__upper">
                                                    <div class="lux-perf-revenue-card__label">Total Revenue</div>
                                                    <div class="lux-perf-revenue-card__amount">
                                                        <fmt:formatNumber value="${totalRevenue}" type="number"
                                                            maxFractionDigits="0" groupingUsed="true" />
                                                    </div>
                                                    <div class="lux-perf-revenue-card__sub">
                                                        <c:choose>
                                                            <c:when test="${revenueGrowth > 0}">+${revenueGrowth}% vs
                                                                last month</c:when>
                                                            <c:when test="${revenueGrowth < 0}">${revenueGrowth}% vs
                                                                last month</c:when>
                                                            <c:otherwise>No change vs last month</c:otherwise>
                                                        </c:choose>
                                                        <span class="lux-perf-revenue-card__dot">&bull;</span>
                                                        <em>Compared to previous period</em>
                                                    </div>
                                                </div>

                                                <div class="lux-perf-revenue-card__divider"></div>

                                                <div class="lux-perf-revenue-card__metrics">
                                                    <div class="lux-perf-metric">
                                                        <div class="lux-perf-metric__label">Today</div>
                                                        <div class="lux-perf-metric__value">
                                                            <fmt:formatNumber value="${revenueToday}" type="number"
                                                                maxFractionDigits="0" groupingUsed="true" />
                                                        </div>
                                                    </div>
                                                    <div class="lux-perf-metric">
                                                        <div class="lux-perf-metric__label">This Week</div>
                                                        <div class="lux-perf-metric__value">
                                                            <fmt:formatNumber value="${revenueThisWeek}" type="number"
                                                                maxFractionDigits="0" groupingUsed="true" />
                                                        </div>
                                                    </div>
                                                    <div class="lux-perf-metric">
                                                        <div class="lux-perf-metric__label">This Month</div>
                                                        <div class="lux-perf-metric__value">
                                                            <fmt:formatNumber value="${revenueThisMonth}" type="number"
                                                                maxFractionDigits="0" groupingUsed="true" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Right: Top Selling Product -->
                                            <div class="lux-perf-topseller-card">
                                                <div class="lux-perf-topseller-card__icon">
                                                    <i class="fa-solid fa-trophy"></i>
                                                </div>
                                                <div class="lux-perf-topseller-card__title">Top Selling Product</div>
                                                <div class="lux-perf-topseller-card__name">
                                                    <c:choose>
                                                        <c:when test="${topProduct != null && topProduct != '—'}">
                                                            ${topProduct}</c:when>
                                                        <c:otherwise><em>No completed orders yet.</em></c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="lux-perf-topseller-card__footnote">Ranking resets every
                                                    Monday at 00:00</div>
                                            </div>
                                        </div>
                                    </div>


                                    <!-- Sales Analytics (now with real Chart.js) -->
                                    <div class="lux-analytics">
                                        <div class="lux-analytics__header">
                                            <div>
                                                <div class="lux-analytics__title">Sales Analytics</div>
                                                <div class="lux-analytics__subtitle" id="chartSubtitle">Revenue over
                                                    last 7 days</div>
                                            </div>
                                            <select id="periodSelect" class="lux-analytics__period-select">
                                                <option value="weekly" selected>Weekly</option>
                                                <option value="monthly">Monthly</option>
                                                <option value="yearly">Yearly</option>
                                            </select>
                                        </div>

                                        <div class="lux-chart">
                                            <div class="lux-chart__highlight">
                                                <span class="lux-chart__highlight-value" id="chartTotal">
                                                    <fmt:formatNumber value="${revenueThisWeek}" type="number"
                                                        maxFractionDigits="0" groupingUsed="true" />
                                                </span>
                                            </div>
                                            <div style="position:relative;height:200px;">
                                                <canvas id="salesChart"></canvas>
                                            </div>
                                        </div>
                                    </div>

                                </section>

                            </div>
                        </main>

                        <!-- Chart data from server -->
                        <div id="dashChartData" style="display:none" data-labels='${chartLabels}'
                            data-values='${chartData}'>
                        </div>

                        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                var NAVY = '#0f1b2d';
                                var GRID_COLOR = 'rgba(0,0,0,0.04)';
                                var contextPath = '${pageContext.request.contextPath}';

                                Chart.defaults.font.family = "'Inter', sans-serif";
                                Chart.defaults.color = '#8896a6';

                                // Read initial data from hidden element
                                var cd = document.getElementById('dashChartData');
                                var initLabels = JSON.parse(cd.getAttribute('data-labels') || '[]');
                                var initData = JSON.parse(cd.getAttribute('data-values') || '[]');

                                // Create chart
                                var salesCtx = document.getElementById('salesChart');
                                var salesChart = new Chart(salesCtx, {
                                    type: 'bar',
                                    data: {
                                        labels: initLabels,
                                        datasets: [{
                                            label: 'Revenue',
                                            data: initData,
                                            backgroundColor: function (context) {
                                                if (!context.dataset.data || context.dataset.data.length === 0) return NAVY;
                                                var maxVal = Math.max.apply(null, context.dataset.data);
                                                return context.raw === maxVal ? NAVY : 'rgba(15, 27, 45, 0.15)';
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
                                                displayColors: false,
                                                callbacks: {
                                                    label: function (ctx) {
                                                        return ctx.parsed.y.toLocaleString();
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
                                                        if (val >= 1000000) return (val / 1000000).toFixed(1) + 'M';
                                                        if (val >= 1000) return (val / 1000).toFixed(0) + 'k';
                                                        return val;
                                                    }
                                                },
                                                beginAtZero: true
                                            }
                                        }
                                    }
                                });

                                // Dropdown period switching via AJAX
                                var subtitles = {
                                    'weekly': 'Revenue over last 7 days',
                                    'monthly': 'Revenue over last 30 days',
                                    'yearly': 'Monthly revenue over last 12 months'
                                };

                                document.getElementById('periodSelect').addEventListener('change', function () {
                                    var period = this.value;
                                    document.getElementById('chartSubtitle').textContent = subtitles[period] || '';

                                    fetch(contextPath + '/dashboard', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: 'period=' + encodeURIComponent(period)
                                    })
                                        .then(function (res) { return res.json(); })
                                        .then(function (data) {
                                            salesChart.data.labels = data.labels;
                                            salesChart.data.datasets[0].data = data.data;
                                            salesChart.update();
                                            document.getElementById('chartTotal').textContent = data.total;
                                        })
                                        .catch(function (err) {
                                            console.error('Error fetching chart data:', err);
                                        });
                                });
                            });
                        </script>

            </body>

            </html>
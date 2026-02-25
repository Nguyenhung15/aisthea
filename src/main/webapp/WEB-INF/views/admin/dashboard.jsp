<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/views/admin/include/header_admin.jsp" %>
<%@ include file="/views/admin/include/sidebar_admin.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background-color: #f9f9f9;
                font-family: "Segoe UI", sans-serif;
            }
            .content-container {
                margin-left: 240px;
                padding: 30px;
            }
            h2 {
                color: #3e2723;
            }
            hr {
                border: 1px solid #d7ccc8;
                margin: 15px 0 25px 0;
            }

            /* === LƯỚI THỐNG KÊ (STAT GRID) === */
            .stat-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 25px;
                margin-bottom: 30px;
            }
            .stat-card {
                background: #fff;
                color: #4e342e;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                display: flex;
                align-items: center;
                gap: 20px;
                overflow: hidden;
            }
            .stat-card .icon {
                font-size: 2.5rem;
                padding: 15px;
                border-radius: 50%;
                flex-shrink: 0;
            }
            .stat-card .info {
                flex: 1;
                min-width: 0;
            }

            /* === SỬA LỖI FONT CHỮ TẠI ĐÂY === */
            .stat-card .info strong {
                font-size: 1.5rem; /* Giảm từ 1.75rem xuống 1.5rem */
                color: #3e2723;
                display: block;
                overflow-wrap: break-word;
                word-break: break-word;
                white-space: nowrap; /* Giữ tiền và 'đ' trên 1 dòng */
            }
            /* ================================ */

            .stat-card .info span {
                font-size: 0.9rem;
                font-weight: 600;
                color: #795548;
            }

            .stat-card.green .icon {
                background: #e8f5e9;
                color: #4CAF50;
            }
            .stat-card.blue .icon {
                background: #e3f2fd;
                color: #2196F3;
            }
            .stat-card.orange .icon {
                background: #fff3e0;
                color: #FF9800;
            }
            .stat-card.purple .icon {
                background: #ede7f6;
                color: #673AB7;
            }
            .stat-card.red .icon {
                background: #dcedc8;
                color: #8bc34a;
            }

            /* === LƯỚI NỘI DUNG (TABLES) === */
            .main-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 25px;
            }
            .data-card {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            .data-card h3 {
                font-size: 1.1rem;
                color: #4e342e;
                margin: 0;
                padding: 20px;
                border-bottom: 1px solid #eee;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                table-layout: fixed;
            }
            th, td {
                padding: 12px 20px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            th {
                background-color: #fbfaf9;
                font-weight: 700;
                font-size: 13px;
            }
            tr:last-child td {
                border-bottom: none;
            }

            .data-card table th:nth-child(1),
            .data-card table td:nth-child(1) {
                width: 10%;
                white-space: nowrap;
            }
            .data-card table th:nth-child(2),
            .data-card table td:nth-child(2) {
                width: 35%;
                word-break: break-word;
            }
            .data-card table th:nth-child(3),
            .data-card table td:nth-child(3) {
                width: 30%;
                white-space: nowrap;
            }
            .data-card table th:nth-child(4),
            .data-card table td:nth-child(4) {
                width: 25%;
                white-space: nowrap;
            }

            .status {
                padding: 5px 10px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 12px;
                display: inline-block;
            }
            .status-Pending {
                background-color: #fff8e1;
                color: #f57f17;
            }
            .status-Shipped {
                background-color: #e3f2fd;
                color: #2196F3;
            }
            .status-Completed {
                background-color: #e8f5e9;
                color: #4CAF50;
            }

            .user-list {
                padding: 0;
                margin: 0;
            }
            .user-list li {
                list-style: none;
                padding: 12px 20px;
                border-bottom: 1px solid #eee;
                font-weight: 600;
                display: flex;
                align-items: center;
                position: relative;
            }
            .user-list li:last-child {
                border-bottom: none;
            }
            .user-list .icon-user {
                color: #616161;
                font-size: 1.2rem;
                margin-right: 10px;
                position: relative;
            }
            .user-list .icon-user::after {
                content: '';
                position: absolute;
                bottom: 0px;
                right: -3px;
                width: 8px;
                height: 8px;
                background-color: #4CAF50;
                border-radius: 50%;
                border: 1.5px solid #fff;
            }
            .user-list li.empty-message {
                color: #888;
                font-style: italic;
                justify-content: center;
            }

            /* CSS cho Form Lọc (nếu bạn có dùng) */
            .filter-bar {
                margin-bottom: 25px;
                display: flex;
                justify-content: flex-end;
                align-items: center;
            }
            .filter-form {
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .filter-form label {
                font-weight: 600;
                color: #5d4037;
                font-size: 14px;
            }
            .filter-form select, .filter-form button {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                background: #fff;
            }
            .filter-form button {
                background: #5d4037;
                color: #fff;
                font-weight: 600;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="content-container">
            <h2>📊 Dashboard</h2>
            <hr>

            <%-- Form Lọc (Nếu bạn có dùng) --%>
            <%-- 
            <div class="filter-bar">
                <form action="${pageContext.request.contextPath}/dashboard" method="GET" class="filter-form">
                    <label for="timeRange">Hiển thị thống kê theo:</label>
                    <select name="timeRange" id="timeRange">
                        <option value="all" ${empty param.timeRange || param.timeRange == 'all' ? 'selected' : ''}>Toàn thời gian</option>
                        <option value="today" ${param.timeRange == 'today' ? 'selected' : ''}>Hôm nay</option>
                        <option value="week" ${param.timeRange == 'week' ? 'selected' : ''}>Tuần này</option>
                        <option value="month" ${param.timeRange == 'month' ? 'selected' : ''}>Tháng này</option>
                    </select>
                    <button type="submit">Lọc</button>
                </form>
            </div>
            --%>

            <div class="stat-grid">
                <div class="stat-card green">
                    <div class="icon"><i class="fa-solid fa-dollar-sign"></i></div>
                    <div class="info">
                        <strong><fmt:formatNumber value="${totalRevenue}" type="currency" currencyCode="VND" maxFractionDigits="0"/></strong>
                        <span>Tổng Doanh Thu (Completed)</span>
                    </div>
                </div>

                <div class="stat-card blue">
                    <div class="icon"><i class="fa-solid fa-users"></i></div>
                    <div class="info">
                        <strong>${totalUsers}</strong>
                        <span>Tổng số Khách hàng</span>
                    </div>
                </div>

                <div class="stat-card orange">
                    <div class="icon"><i class="fa-solid fa-box"></i></div>
                    <div class="info">
                        <strong>${totalProducts}</strong>
                        <span>Tổng số Sản phẩm</span>
                    </div>
                </div>

                <div class="stat-card purple">
                    <div class="icon"><i class="fa-solid fa-receipt"></i></div>
                    <div class="info">
                        <strong>${totalOrders}</strong>
                        <span>Tổng số Đơn hàng</span>
                    </div>
                </div>

                <div class="stat-card red">
                    <div class="icon"><i class="fa-solid fa-user-group"></i></div> 
                    <div class="info">
                        <strong>${onlineUsers.size()}</strong>
                        <span>Users Đang Đăng Nhập</span>
                    </div>
                </div>
            </div>

            <div class="main-grid">

                <div class="data-card">
                    <h3>Đơn hàng Mới nhất</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Khách hàng</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td><strong>#${order.orderid}</strong></td>
                                    <td>${order.fullname}</td>
                                    <td><fmt:formatNumber value="${order.totalprice}" type="currency" currencyCode="VND" maxFractionDigits="0"/></td>
                                    <td><span class="status status-${order.status}">${order.status}</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentOrders}">
                                <tr><td colspan="4" style="text-align:center; padding: 20px;">Chưa có đơn hàng nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="data-card">
                    <h3>Users Đang Online</h3>
                    <ul class="user-list">
                        <c:forEach var="username" items="${onlineUsers}">
                            <li>
                                <i class="fa-solid fa-circle-user icon-user"></i>
                                ${username}
                            </li>
                        </c:forEach>
                        <c:if test="${empty onlineUsers}">
                            <li class="empty-message">Không có ai đang đăng nhập.</li>
                            </c:if>
                    </ul>
                </div>

            </div>
        </div>
    </body>
</html>
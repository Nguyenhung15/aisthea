<%-- /views/admin/manage_orders.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/views/admin/include/header_admin.jsp" %>
<%@ include file="/views/admin/include/sidebar_admin.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng</title>
    <%-- (Copy toàn bộ <style>...</style> của bạn từ lần trước vào đây) --%>
    <style>
        body { background-color: #f9f9f9; font-family: "Segoe UI", sans-serif; }
        .content-container { margin-left:240px; padding:30px; }
        h2 { color:#3e2723; } hr { border:1px solid #d7ccc8; margin:15px 0 25px 0; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; font-size: 14px; }
        th, td { padding: 14px 18px; text-align: left; border-bottom: 1px solid #eee; vertical-align: middle; }
        th { background-color: #f5f5f5; color: #4e342e; font-weight: 700; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #fdfdfd; }
        .action-links a { text-decoration: none; margin-right: 12px; font-weight: 600; padding: 4px 8px; border-radius: 4px; transition: all 0.2s; }
        .action-links .link-detail { color: #0277bd; background-color: #e3f2fd; }
        .action-links .link-detail:hover { background-color: #b3e5fc; }
        .action-links .link-cancel { color: #c62828; background-color: #ffebee; }
        .action-links .link-cancel:hover { background-color: #ffcdd2; }
        .status { padding: 5px 12px; border-radius: 20px; font-weight: 700; font-size: 12px; display: inline-block; text-transform: uppercase; }
        .status-Pending { background-color: #fff8e1; color: #f57f17; }
        /* (Thêm các status CSS khác...) */
    </style>
</head>
<body>
    <div class="content-container">
        <h2>📦 Quản lý Đơn hàng</h2>
        <hr>
        <%-- (Hiển thị thông báo thành công/lỗi) --%>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>Thông tin Giao hàng</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orderList}">
                    <tr>
                        <td><strong>#${order.orderid}</strong></td>
                        <td>${order.fullname}</td>
                        <td>
                            ${order.phone}<br>
                            <span style="color: #555; font-size: 13px;">${order.address}</span>
                        </td>
                        <td>
                            <fmt:formatDate value="${order.createdat}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td>
                            <fmt:formatNumber value="${order.totalprice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                        </td>
                        <td>
                            <span class="status status-${order.status}">${order.status}</span>
                        </td>
                        
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/order?action=adminViewDetail&id=${order.orderid}" class="link-detail">
                                Xem chi tiết
                            </a>
                            
                            <%-- Chỉ cho phép Xóa đơn hàng đã Hủy hoặc Hoàn tất --%>
                            <c:if test="${order.status == 'Cancelled' || order.status == 'Completed'}">
                                <a href="${pageContext.request.contextPath}/order?action=adminDelete&id=${order.orderid}" class="link-cancel"
                                   onclick="return confirm('Bạn có chắc chắn muốn XÓA vĩnh viễn đơn hàng #${order.orderid}?')">
                                    Xóa
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
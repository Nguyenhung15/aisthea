<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/views/admin/include/header_admin.jsp" %>
<%@ include file="/views/admin/include/sidebar_admin.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Đơn hàng #${order.orderid}</title>
    <style>
        body { background-color: #f9f9f9; font-family: "Segoe UI", sans-serif; }
        .content-container { margin-left:240px; padding:30px; }
        h2 { color:#3e2723; } hr { border:1px solid #d7ccc8; margin:15px 0 25px 0; }
        
        .grid-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 25px;
            align-items: flex-start;
        }
        .card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 25px;
        }
        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #4e342e;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        
        .product-item {
            display: flex;
            gap: 15px;
            padding-bottom: 15px;
            margin-bottom: 15px;
            border-bottom: 1px solid #f5f5f5;
        }
        .product-item:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
        .product-item img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #eee;
        }
        .product-info { flex-grow: 1; }
        
        /* === SỬA LỖI HIỂN THỊ TẠI ĐÂY === */
        .product-info .name { 
            font-weight: 600; 
            color: #333; 
            display: block; /* Đảm bảo tên sp nằm trên 1 dòng riêng */
        }
        .product-info .sku { 
            font-size: 13px; 
            color: #777; 
            display: block; /* Đảm bảo phân loại nằm trên 1 dòng riêng */
        }
        /* ============================== */
        
        .product-price { text-align: right; font-weight: 600; }

        .info-grid { display: grid; grid-template-columns: 100px 1fr; gap: 10px; }
        .info-grid span:first-child { font-weight: 600; color: #5d4037; }
        
        .form-update { display: flex; gap: 10px; margin-top: 15px; }
        .form-update select {
            flex-grow: 1;
            padding: 9px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }
        .btn-save {
            background:#3e2723; color:#fff; padding:10px 15px;
            border:none; border-radius:6px; cursor: pointer;
            font-size: 14px; font-weight: 600;
        }
        .btn-back {
             background:#f5f5f5; color:#333; padding:10px 15px;
             border:1px solid #ddd; border-radius:6px; cursor: pointer;
             font-size: 14px; font-weight: 600; text-decoration: none;
             display: inline-block; margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="content-container">
        <h2>Chi tiết Đơn hàng #${order.orderid}</h2>
        <hr>

        <c:if test="${param.update == 'success'}">
            <div style="background: #e8f5e9; color: #2e7d32; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-weight: 600;">
                Cập nhật trạng thái thành công!
            </div>
        </c:if>
        <c:if test="${param.update == 'error'}">
             <div style="background: #ffebee; color: #c62828; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-weight: 600;">
                Có lỗi xảy ra khi cập nhật.
            </div>
        </c:if>

        <div class="grid-container">
            
            <div class="card">
                <h3 class="card-title">Danh sách sản phẩm</h3>
                <c:forEach var="item" items="${order.items}">
                    <div class="product-item">
                        <img src="${item.imageUrl}" onerror="this.src='https://placehold.co/100x100/eee/ccc?text=No+Image'">
                        <div class="product-info">
                            
                            <span class="name">${item.productName}</span>
                            <span class="sku">Phân loại: ${item.color} / ${item.size}</span>
                            <span class="sku">SL: ${item.quantity}</span>
                            </div>
                        <div class="product-price">
                            <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                        </div>
                    </div>
                </c:forEach>
                
                <h3 class="card-title" style="margin-top: 30px;">Thông tin Giao hàng</h3>
                <div class="info-grid">
                    <span>Họ tên:</span>     <span>${order.fullname}</span>
                    <span>Email:</span>    <span>${order.email}</span>
                    <span>SĐT:</span>      <span>${order.phone}</span>
                    <span>Địa chỉ:</span>   <span>${order.address}</span>
                </div>
            </div>

            <div class="card" style="position: sticky; top: 90px;">
                <h3 class="card-title">Tóm tắt</h3>
                <div class="info-grid">
                    <span>Ngày đặt:</span>
                    <span><fmt:formatDate value="${order.createdat}" pattern="dd/MM/yyyy HH:mm"/></span>
                    
                    <span>Tổng tiền:</span>
                    <span style="font-weight: 700; font-size: 1.2rem;">
                        <fmt:formatNumber value="${order.totalprice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                    </span>

                    <span>Thanh toán:</span>
                    <span>${order.paymentMethod}</span>
                </div>
                
                <h3 class="card-title" style="margin-top: 30px;">Cập nhật Trạng thái</h3>
                
                <form action="${pageContext.request.contextPath}/order" method="POST" class="form-update">
                    <input type="hidden" name="action" value="adminUpdateStatus">
                    <input type="hidden" name="orderId" value="${order.orderid}">
                    
                    <select name="newStatus">
                        <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Đang chờ (Pending)</option>
                        <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Đang xử lý (Processing)</option>
                        <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Đang giao (Shipped)</option>
                        <option value="Completed" ${order.status == 'Completed' ? 'selected' : ''}>Hoàn tất (Completed)</option>
                        <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Đã hủy (Cancelled)</option>
                    </select>
                    
                    <button type="submit" class="btn-save">Lưu</button>
                </form>
                
                <a href="${pageContext.request.contextPath}/order?action=list" class="btn-back">
                    Quay lại Danh sách
                </a>
            </div>
            
        </div>
    </div>
</body>
</html>
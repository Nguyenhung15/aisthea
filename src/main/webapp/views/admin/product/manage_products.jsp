<%@ page import="java.util.*, com.aisthea.fashion.dao.UserDAO, com.aisthea.fashion.model.User" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý Sản phẩm</title>
                    <!-- FontAwesome -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                    <style>
                        /* (Giữ nguyên toàn bộ CSS cũ của bạn: .content-container, .top-bar-container, .search-container, .product-table ...) */
                        body {
                            background-color: #f9f9f9;
                            font-family: "Segoe UI", sans-serif;
                            margin: 0;
                            padding: 0;
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
                            margin: 15px 0;
                        }

                        .btn-add {
                            display: inline-block;
                            padding: 10px 15px;
                            background: #3e2723;
                            color: #fff;
                            text-decoration: none;
                            border-radius: 6px;
                            font-weight: 600;
                        }

                        .top-bar-container {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 20px;
                            gap: 20px;
                        }

                        .search-container {
                            background: white;
                            border-radius: 12px;
                            padding: 15px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                        }

                        .search-form {
                            display: flex;
                            align-items: center;
                            gap: 15px;
                        }

                        .search-input {
                            width: 350px;
                            padding: 9px 12px;
                            border: 1px solid #ccc;
                            border-radius: 6px;
                            font-size: 14px;
                            box-sizing: border-box;
                        }

                        .search-btn {
                            background: #5d4037;
                            color: #fff;
                            padding: 9px 15px;
                            border: none;
                            border-radius: 6px;
                            cursor: pointer;
                            font-size: 14px;
                            font-weight: 600;
                        }

                        .search-clear {
                            color: #c62828;
                            font-weight: 600;
                            font-size: 14px;
                            text-decoration: none;
                            white-space: nowrap;
                        }

                        .product-table {
                            border: 1px solid #ccc;
                            width: 100%;
                            cellpadding: 10;
                            cellspacing: 0;
                            border-collapse: collapse;
                            background: #fff;
                            border-radius: 12px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                            overflow: hidden;
                        }

                        .product-table thead {
                            background: #efebe9;
                            color: #3e2723;
                        }

                        .product-table th,
                        .product-table td {
                            padding: 12px 15px;
                            text-align: left;
                            border-bottom: 1px solid #eee;
                        }

                        .product-table tr:last-child td {
                            border-bottom: none;
                        }

                        .product-table td {
                            vertical-align: middle;
                        }

                        /* === CSS CHO MODAL XÁC NHẬN XÓA === */
                        .modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            right: 0;
                            bottom: 0;
                            background: rgba(0, 0, 0, 0.6);
                            display: none;
                            /* Ẩn mặc định */
                            align-items: center;
                            justify-content: center;
                            z-index: 1000;
                        }

                        .modal-box {
                            background: #fff;
                            border-radius: 12px;
                            padding: 30px;
                            width: 90%;
                            max-width: 450px;
                            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
                            text-align: center;
                        }

                        .modal-box h3 {
                            margin-top: 0;
                            font-size: 1.5rem;
                            color: #c62828;
                            /* Màu đỏ */
                        }

                        .modal-box p {
                            font-size: 1rem;
                            color: #444;
                            margin-bottom: 25px;
                        }

                        .modal-actions {
                            display: flex;
                            gap: 15px;
                            justify-content: center;
                        }

                        .modal-btn {
                            padding: 10px 20px;
                            border: none;
                            border-radius: 6px;
                            font-weight: 600;
                            font-size: 15px;
                            cursor: pointer;
                            min-width: 100px;
                        }

                        .btn-confirm-delete {
                            background-color: #c62828;
                            color: white;
                            text-decoration: none;
                            /* Dùng cho thẻ <a> */
                        }

                        .btn-cancel-delete {
                            background-color: #f1f1f1;
                            color: #333;
                        }

                        /* ================================= */
                    </style>
                </head>

                <body>

                    <%@ include file="/views/admin/include/header_admin.jsp" %>
                        <%@ include file="/views/admin/include/sidebar_admin.jsp" %>

                            <div class="content-container">
                                <h2>🛍️ Manage Products</h2>
                                <hr style="margin-bottom: 20px;">

                                <div class="top-bar-container">
                                    <a href="${pageContext.request.contextPath}/product?action=new" class="btn-add">
                                        + Add New Product
                                    </a>
                                    <div class="search-container">
                                        <form action="${pageContext.request.contextPath}/product" method="GET"
                                            class="search-form">
                                            <input type="hidden" name="action" value="manage">
                                            <input type="text" name="searchName" class="search-input"
                                                value="<c:out value='${param.searchName}'/>"
                                                placeholder="Tìm kiếm theo tên sản phẩm...">
                                            <button type="submit" class="search-btn">
                                                <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                                            </button>
                                            <c:if test="${not empty param.searchName}">
                                                <a href="${pageContext.request.contextPath}/product?action=manage"
                                                    class="search-clear">
                                                    Xóa tìm kiếm
                                                </a>
                                            </c:if>
                                        </form>
                                    </div>
                                </div>

                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Image</th>
                                            <th>Name</th>
                                            <th>Category</th>
                                            <th>Price</th>
                                            <th>Stock (Total)</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${productList}">
                                            <tr>
                                                <td>${p.productId}</td>
                                                <td>
                                                    <c:set var="primaryImgUrl"
                                                        value="https://placehold.co/80x80/eee/ccc?text=N/A" />
                                                    <c:if test="${not empty p.images}">
                                                        <c:set var="foundPrimary" value="false" />
                                                        <c:forEach var="img" items="${p.images}">
                                                            <c:if test="${img.primary and not foundPrimary}">
                                                                <c:set var="primaryImgUrl" value="${img.imageUrl}" />
                                                                <c:set var="foundPrimary" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:if test="${not foundPrimary and not empty p.images[0]}">
                                                            <c:set var="primaryImgUrl"
                                                                value="${p.images[0].imageUrl}" />
                                                        </c:if>
                                                    </c:if>
                                                    <img src="${primaryImgUrl}" alt="${p.name}"
                                                        style="width:60px;height:60px;object-fit:cover;border-radius:4px;">
                                                </td>
                                                <td>${p.name}</td>
                                                <td>${p.category.name}</td>
                                                <td>
                                                    <fmt:formatNumber value="${p.price}" type="currency"
                                                        currencyCode="VND" maxFractionDigits="0" />
                                                </td>
                                                <td>
                                                    <c:set var="totalStock" value="0" />
                                                    <c:forEach var="pcs" items="${p.colorSizes}">
                                                        <c:set var="totalStock" value="${totalStock + pcs.stock}" />
                                                    </c:forEach>
                                                    ${totalStock}
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/product?action=edit&id=${p.productId}"
                                                        style="color:blue;text-decoration:none;font-weight:600;">✏️
                                                        Edit</a>
                                                    |

                                                    <a href="${pageContext.request.contextPath}/product?action=delete&id=${p.productId}"
                                                        class="link-delete" <%-- Thêm class "link-delete" --%>
                                                        style="color:red;text-decoration:none;font-weight:600;"
                                                        data-product-name="
                                                        <c:out value='${p.name}' />"> <%-- Thêm tên sản phẩm --%>
                                                            🗑️ Delete
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty productList}">
                                            <tr>
                                                <td colspan="8" style="text-align:center; padding: 20px;">
                                                    Không tìm thấy sản phẩm nào${not empty param.searchName ? ' khớp với
                                                    tìm kiếm' : ''}.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <div id="deleteModal" class="modal-overlay">
                                <div class="modal-box">
                                    <h3>Xác nhận Xóa</h3>
                                    <p>Bạn có chắc chắn muốn xóa sản phẩm <br>
                                        <strong id="modalProductName" style="color: #3e2723;"></strong>?
                                    </p>
                                    <p style="font-size: 13px; color: #777;">Thao tác này sẽ xóa vĩnh viễn sản phẩm, bao
                                        gồm tất cả hình ảnh và tồn kho liên quan.</p>

                                    <div class="modal-actions">
                                        <button type="button" id="cancelDeleteBtn"
                                            class="modal-btn btn-cancel-delete">Hủy bỏ</button>

                                        <a href="#" id="confirmDeleteBtn" class="modal-btn btn-confirm-delete">Đồng ý
                                            Xóa</a>
                                    </div>
                                </div>
                            </div>

                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    // 1. Lấy các element của Modal
                                    const modal = document.getElementById('deleteModal');
                                    const modalProductName = document.getElementById('modalProductName');
                                    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
                                    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
                                    const deleteLinks = document.querySelectorAll('.link-delete');

                                    deleteLinks.forEach(link => {
                                        link.addEventListener('click', function (event) {
                                            event.preventDefault();
                                            const deleteUrl = this.href;
                                            const productName = this.dataset.productName;
                                            modalProductName.textContent = productName;
                                            confirmDeleteBtn.href = deleteUrl;
                                            modal.style.display = 'flex';
                                        });
                                    });

                                    cancelDeleteBtn.addEventListener('click', function () {
                                        modal.style.display = 'none';
                                    });

                                    modal.addEventListener('click', function (event) {
                                        if (event.target === modal) {
                                            modal.style.display = 'none';
                                        }
                                    });
                                });
                            </script>
                </body>

                </html>
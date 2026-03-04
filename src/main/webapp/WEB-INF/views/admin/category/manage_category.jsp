<%@ page import="java.util.*, com.aisthea.fashion.dao.UserDAO, com.aisthea.fashion.model.User" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>
                    <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>

                        <head>
                            <title>Quản lý Danh mục</title>
                            <style>
                                /* === CSS CƠ BẢN (Từ file của bạn) === */
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
                                    margin: 15px 0;
                                }

                                .btn-add {
                                    display: inline-block;
                                    padding: 10px 15px;
                                    background: #3e2723;
                                    color: #fff;
                                    text-decoration: none;
                                    border-radius: 6px;
                                    margin-bottom: 15px;
                                    font-weight: 600;
                                }

                                .category-table {
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

                                .category-table thead {
                                    background: #efebe9;
                                    color: #3e2723;
                                }

                                .category-table th,
                                .category-table td {
                                    padding: 12px 15px;
                                    text-align: left;
                                    border-bottom: 1px solid #eee;
                                    vertical-align: middle;
                                }

                                .category-table tr:last-child td {
                                    border-bottom: none;
                                }

                                .category-table tr:hover {
                                    background-color: #fdfdfd;
                                }

                                .highlight td {
                                    font-weight: bold;
                                    color: #3e2723;
                                    background-color: #f5f5f5;
                                    /* Thêm nền nhạt cho dễ phân biệt */
                                }

                                /* === CSS CHO MODAL XÁC NHẬN XÓA (MỚI) === */
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

                        <div class="content-container">
                            <h2>🏷️ Manage Categories</h2>
                            <hr>

                            <c:if test="${not empty errorMsg}">
                                <p style="color:red;">${errorMsg}</p>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/category?action=new" class="btn-add">
                                + Thêm danh mục mới
                            </a>

                            <table class="category-table">
                                <thead style="background:#efebe9;color:#3e2723;">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên danh mục</th>
                                        <th>Loại</th>
                                        <th>Giới tính</th>
                                        <th>Danh mục cha (Index)</th>
                                        <th>Index Name</th>
                                        <th>Ngày tạo</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cat" items="${list}">
                                        <%-- Sửa lại logic highlight (vì ${empty cat.parentid} cũng đúng khi parentid là
                                            chuỗi rỗng) --%>
                                            <tr class="${empty cat.parentid ? 'highlight' : ''}">
                                                <td>${cat.categoryid}</td>
                                                <td>${cat.name}</td>
                                                <td>${cat.type}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${cat.genderid == 1}">Nam</c:when>
                                                        <c:when test="${cat.genderid == 2}">Nữ</c:when>
                                                        <c:when test="${cat.genderid == 3}">Khác</c:when>
                                                        <c:otherwise>Không xác định</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${cat.parentid}</td>
                                                <td>${cat.indexName}</td>
                                                <td>
                                                    <fmt:formatDate value="${cat.createdat}" pattern="dd-MM-yyyy" />
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/category?action=edit&id=${cat.categoryid}"
                                                        style="color:blue;text-decoration:none;font-weight:600;">✏️
                                                        Sửa</a> |

                                                    <a href="${pageContext.request.contextPath}/category?action=delete&id=${cat.categoryid}"
                                                        class="link-delete" <%-- Thêm class "link-delete" --%>
                                                        style="color:red;text-decoration:none;font-weight:600;"
                                                        data-category-name="
                                                        <c:out value='${cat.name}' />"> <%-- Thêm tên danh mục --%>
                                                            🗑️ Xóa
                                                    </a>
                                                </td>
                                            </tr>
                                    </c:forEach>
                                    <c:if test="${empty list}">
                                        <tr>
                                            <td colspan="8" style="text-align:center;">No categories found.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <div id="deleteModal" class="modal-overlay">
                            <div class="modal-box">
                                <h3>Xác nhận Xóa</h3>
                                <p>Bạn có chắc chắn muốn xóa danh mục <br>
                                    <strong id="modalCategoryName" style="color: #3e2723;"></strong>?
                                </p>
                                <p style="font-size: 13px; color: #777;">
                                    Cảnh báo: Nếu đây là danh mục cha, các sản phẩm thuộc danh mục con của nó có thể bị
                                    ảnh hưởng.
                                </p>

                                <div class="modal-actions">
                                    <button type="button" id="cancelDeleteBtn" class="modal-btn btn-cancel-delete">Hủy
                                        bỏ</button>
                                    <a href="#" id="confirmDeleteBtn" class="modal-btn btn-confirm-delete">Đồng ý
                                        Xóa</a>
                                </div>
                            </div>
                        </div>

                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                // 1. Lấy các element của Modal
                                const modal = document.getElementById('deleteModal');
                                const modalCategoryName = document.getElementById('modalCategoryName');
                                const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
                                const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

                                // 2. Lấy TẤT CẢ các link xóa
                                const deleteLinks = document.querySelectorAll('.link-delete');

                                // 3. Gán sự kiện click cho từng link xóa
                                deleteLinks.forEach(link => {
                                    link.addEventListener('click', function (event) {
                                        // Ngăn chặn link chạy ngay lập tức
                                        event.preventDefault();

                                        // Lấy thông tin từ link
                                        const deleteUrl = this.href;
                                        const categoryName = this.dataset.categoryName;

                                        // Cập nhật Modal
                                        modalCategoryName.textContent = categoryName;
                                        confirmDeleteBtn.href = deleteUrl; // Gán link xóa vào nút "Đồng ý"

                                        // Hiển thị Modal
                                        modal.style.display = 'flex';
                                    });
                                });

                                // 4. Gán sự kiện cho nút "Hủy bỏ"
                                cancelDeleteBtn.addEventListener('click', function () {
                                    modal.style.display = 'none';
                                });

                                // 5. Gán sự kiện click bên ngoài để đóng modal
                                modal.addEventListener('click', function (event) {
                                    if (event.target === modal) {
                                        modal.style.display = 'none';
                                    }
                                });
                            });
                        </script>
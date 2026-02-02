<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/views/admin/include/header_admin.jsp" %>
<%@ include file="/views/admin/include/sidebar_admin.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title><c:out value="${empty product ? 'Thêm sản phẩm mới' : 'Sửa sản phẩm'}" /></title>
        <style>
            body {
                background-color: #f9f9f9;
                font-family: "Segoe UI", sans-serif;
            }
            .form-container {
                margin-left:240px;
                padding:30px;
            }
            h2 {
                color:#3e2723;
            }
            hr {
                border:1px solid #d7ccc8;
                margin:15px 0;
            }

            form {
                display: flex;
                flex-direction: column;
                gap: 20px;
                max-width: 900px;
            }
            .form-section {
                background: white;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .form-section h5 {
                font-size: 1.1rem;
                color: #4e342e;
                margin-top: 0;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .form-group {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px 20px;
            }
            .form-grid-full {
                grid-column: 1 / -1;
            }
            label {
                font-weight: 600;
                color: #5d4037;
            }
            input[type="text"], input[type="email"], input[type="number"],
            textarea, select {
                width: 100%;
                padding: 9px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box;
            }
            textarea {
                min-height: 80px;
            }

            .image-row, .stock-row {
                display: grid;
                gap: 10px;
                align-items: center;
                margin-bottom: 8px;
            }
            .image-row {
                grid-template-columns: 3fr 1fr 100px 30px;
            }
            .stock-row {
                grid-template-columns: 1fr 1fr 1fr 30px;
            }
            .remove-btn {
                color: red;
                cursor: pointer;
                font-weight: bold;
                font-size: 20px;
                text-align: center;
            }
            .add-btn {
                background: #f5f5f5;
                border: 1px dashed #ccc;
                color: #333;
                padding: 8px;
                border-radius: 6px;
                cursor: pointer;
                text-align: center;
                font-weight: 600;
            }
            .add-btn:hover {
                background: #eee;
            }

            .btn-actions {
                display: flex;
                gap: 10px;
                margin-top: 10px;
            }
            .btn-save {
                background:#3e2723;
                color:#fff;
                padding:10px 15px;
                border:none;
                border-radius:6px;
                cursor: pointer;
                font-size: 15px;
                font-weight: 600;
            }
            .btn-cancel {
                background:#9e9e9e;
                color:#fff;
                padding:10px 15px;
                border:none;
                border-radius:6px;
                cursor: pointer;
                font-size: 15px;
                font-weight: 600;
                text-decoration: none;
            }
        </style>
    </head>
    <body>

        <div class="form-container">
            <h2><c:out value="${empty product ? 'Thêm sản phẩm mới' : 'Sửa sản phẩm'}" /></h2>
            <hr>

            <c:if test="${not empty error}">
                <div style="background: #ffebee; color: #c62828; padding: 15px; border-radius: 8px; border: 1px solid #c62828; margin-bottom: 20px; font-weight: 600;">
                    <strong>Lỗi!</strong> ${error}
                </div>
            </c:if>
            <c:set var="actionUrl" value="${pageContext.request.contextPath}/product?action=insert" />
            <c:if test="${not empty product}">
                <c:set var="actionUrl" value="${pageContext.request.contextPath}/product?action=update" />
            </c:if>

            <form action="${actionUrl}" method="post">
                <%-- Đặt hidden input "id" ở đây --%>
                <c:if test="${not empty product}">
                    <input type="hidden" name="id" value="${product.productId}">
                </c:if>

                <div class="form-section">
                    <h5>Thông tin cơ bản</h5>
                    <div class="form-grid">
                        <div class="form-group form-grid-full">
                            <label>Tên sản phẩm</label>
                            <input type="text" name="name" value="${product.name}" required>
                        </div>
                        <div class="form-group form-grid-full">
                            <label>Mô tả</label>
                            <textarea name="description">${product.description}</textarea>
                        </div>
                        <div class="form-group">
                            <label>Giá</label>
                            <input type="number" name="price" step="1000" value="${product.price}" required>
                        </div>
                        <div class="form-group">
                            <label>Thương hiệu</label>
                            <input type="text" name="brand" value="${product.brand}">
                        </div>
                        <div class="form-group">
                            <label>Giảm giá (%)</label>
                            <input type="number" name="discount" min="0" max="100" value="${product.discount}" step="1">
                        </div>
                        <div class="form-group">
                            <label>Giới tính</label>
                            <select id="genderid" name="genderid" required>
                                <option value="">-- Chọn giới tính --</option>
                                <option value="1" ${product.category.genderid == 1 ? 'selected' : ''}>Nam</option>
                                <option value="2" ${product.category.genderid == 2 ? 'selected' : ''}>Nữ</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h5>Danh mục sản phẩm</h5>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Danh mục cha</label>
                            <select id="parentCategorySelect" name="parentCategory" required>
                                <option value="">-- Vui lòng chọn Giới tính trước --</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Danh mục con</label>
                            <select id="childCategorySelect" name="categoryid" required>
                                <option value="">-- Vui lòng chọn Danh mục cha trước --</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h5>Ảnh sản phẩm</h5>
                    <div id="imageContainer">
                        <c:forEach var="image" items="${product.images}" varStatus="loop">
                            <div class="image-row">
                                <input type="text" name="image_url" value="${image.imageUrl}" required>
                                <input type="text" name="image_color" value="${image.color}">
                                <label class="radio-label">
                                    <%-- Sửa: value nên là index để JS dễ xử lý --%>
                                    <input type="radio" name="image_isprimary" value="${loop.index}" ${image.primary ? 'checked' : ''}>
                                    Ảnh chính
                                </label>
                                <span class="remove-btn">X</span>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="add-btn" id="addImageBtn">+ Thêm ảnh</div>
                </div>

                <div class="form-section">
                    <h5>Màu sắc, Kích thước & Tồn kho</h5>
                    <div id="stockContainer">
                        <c:forEach var="stock" items="${product.colorSizes}">
                            <div class="stock-row">
                                <input type="text" name="stock_color" value="${stock.color}" required>
                                <input type="text" name="stock_size" value="${stock.size}" required>
                                <input type="number" name="stock_stock" value="${stock.stock}" min="0" required>
                                <span class="remove-btn">X</span>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="add-btn" id="addStockBtn">+ Thêm dòng</div>
                </div>

                <div class="btn-actions">
                    <button type="submit" class="btn-save">Lưu sản phẩm</button>
                    <a href="${pageContext.request.contextPath}/product?action=manage" class="btn-cancel">Hủy</a>
                </div>
            </form>
        </div>

        <select id="categoryDataSource" style="display: none;">
            <c:forEach var="cat" items="${allCategories}">
                <option value="${cat.categoryid}" 
                        data-gender-id="${cat.genderid}"
                        data-parent-id="${cat.parentid}"
                        data-index-name="${cat.indexName}">
                    ${cat.name}
                </option>
            </c:forEach>
        </select>

        <%-- === SCRIPT ĐÃ SỬA LỖI HOÀN TOÀN === --%>
        <script>
            document.addEventListener("DOMContentLoaded", function () {

                // --- 1. Lấy Elements ---
                const genderSelect = document.getElementById("genderid");
                const parentSelect = document.getElementById("parentCategorySelect");
                const childSelect = document.getElementById("childCategorySelect");
                const allCategoryOptions = Array.from(document.querySelectorAll("#categoryDataSource option"));

                // --- 2. Các hàm xử lý Danh mục ---

                // Tải danh mục cha (Logic gốc của bạn - đã đúng)
                function populateParentSelect(selectedGenderId) {
                    resetSelect(parentSelect, "Chọn danh mục cha");
                    resetSelect(childSelect, "Vui lòng chọn Danh mục cha trước");
                    if (!selectedGenderId)
                        return;

                    allCategoryOptions.forEach(option => {
                        const optionGenderId = option.dataset.genderId;
                        const optionParentId = option.dataset.parentId;
                        const isParentCategory = !optionParentId || optionParentId === '0' || optionParentId === 'null' || optionParentId === '';

                        if (optionGenderId === selectedGenderId && isParentCategory) {
                            parentSelect.appendChild(option.cloneNode(true));
                        }
                    });
                }

                // Tải danh mục con (Logic mới bạn yêu cầu: thêm genderId)
                function populateChildSelect() {
                    resetSelect(childSelect, "Chọn danh mục con");

                    const selectedGenderId = genderSelect.value;
                    const selectedParentOption = parentSelect.options[parentSelect.selectedIndex];

                    // Phải chọn cả 2 thì mới lọc
                    if (!selectedGenderId || !selectedParentOption || !selectedParentOption.value) {
                        return;
                    }

                    const selectedParentIndexName = selectedParentOption.dataset.indexName;
                    if (!selectedParentIndexName)
                        return;

                    allCategoryOptions.forEach(option => {
                        const optionGenderId = option.dataset.genderId;
                        const optionParentId = option.dataset.parentId;

                        // Lọc theo CẢ 2 điều kiện
                        if (optionGenderId === selectedGenderId && optionParentId === selectedParentIndexName) {
                            childSelect.appendChild(option.cloneNode(true));
                        }
                    });
                }

                // Hàm helper
                function resetSelect(selectElement, defaultText) {
                    selectElement.innerHTML = `<option value=''>-- ${defaultText} --</option>`;
                }

                // --- 3. Gán Event Listeners ---
                genderSelect.addEventListener("change", function () {
                    populateParentSelect(genderSelect.value);
                });

                parentSelect.addEventListener("change", function () {
                    populateChildSelect();
                });


                // --- 4. Xử lý Tồn kho (Thêm required) ---
                const stockContainer = document.getElementById("stockContainer");
                const addStockBtn = document.getElementById("addStockBtn");
                addStockBtn.addEventListener("click", function () {
                    const stockRow = document.createElement("div");
                    stockRow.className = "stock-row";
                    stockRow.innerHTML = `
                        <input type="text" name="stock_color" placeholder="Màu sắc (VD: 'Đen')" required>
                        <input type="text" name="stock_size" placeholder="Size (VD: 'M')" required>
                        <input type="number" name="stock_stock" placeholder="Tồn kho" min="0" required>
                        <span class="remove-btn">X</span>
                    `;
                    stockContainer.appendChild(stockRow);
                });

                stockContainer.addEventListener("click", function (e) {
                    if (e.target.classList.contains("remove-btn")) {
                        e.target.parentElement.remove();
                    }
                });

                // --- 5. Xử lý Ảnh (Sửa lỗi 'checked' và 'remove') ---
                const imageContainer = document.getElementById("imageContainer");
                const addImageBtn = document.getElementById("addImageBtn");
                let imageRowIndex = imageContainer.querySelectorAll('.image-row').length;

                addImageBtn.addEventListener("click", function () {
                    const rowIndex = imageRowIndex++;
                    const imageRow = document.createElement("div");
                    imageRow.className = "image-row";

                    // Kiểm tra xem đã có ảnh nào chưa
                    const isFirstImage = imageContainer.querySelectorAll('input[type="radio"]').length === 0;

                    // Sửa lỗi: Bỏ dấu \
                    imageRow.innerHTML = `
                        <input type="text" name="image_url" placeholder="Dán URL ảnh vào đây" required>
                        <input type="text" name="image_color" placeholder="Màu (VD: 'Trắng')">
                        <label class="radio-label">
                            <input type="radio" name="image_isprimary" value="${rowIndex}" ${isFirstImage ? 'checked' : ''}>
                            Ảnh chính
                        </label>
                        <span class="remove-btn">X</span>
                    `;
                    imageContainer.appendChild(imageRow);
                });

                imageContainer.addEventListener("click", function (e) {
                    if (e.target.classList.contains("remove-btn")) {
                        const rowToRemove = e.target.parentElement;
                        const radio = rowToRemove.querySelector('input[type="radio"]');

                        let wasChecked = false;
                        if (radio) {
                            wasChecked = radio.checked;
                        }

                        // Xóa hàng
                        rowToRemove.remove();

                        // Nếu hàng bị xóa là "Ảnh chính"
                        if (wasChecked) {
                            // Chọn radio đầu tiên còn lại (nếu có)
                            const firstRadio = imageContainer.querySelector('input[type="radio"]');
                            if (firstRadio) {
                                firstRadio.checked = true;
                            }
                        }
                    }
                });


                // --- 6. [ĐÃ SỬA] LOGIC KHI SỬA SẢN PHẨM ---

                // Kiểm tra chặt chẽ hơn
                const isEditMode = ${not empty product && not empty product.category};

                if (isEditMode) {
                    const genderId = "${product.category.genderid}";
                    const parentId = "${empty parentCategory ? '' : parentCategory.categoryid}";
                    const childId = "${product.category.categoryid}";

                    if (genderId) {
                        // BƯỚC 1: Set giá trị cho select Giới tính
                        // (Quan trọng: Phải làm điều này trước, thay vì chỉ dựa vào JSTL)
                        genderSelect.value = genderId;

                        // BƯỚC 2: Tải danh mục cha dựa trên giới tính đã chọn
                        populateParentSelect(genderId);

                        // BƯỚC 3: Chọn đúng danh mục cha
                        if (parentId) {
                            // TH: Sản phẩm thuộc danh mục con
                            parentSelect.value = parentId;
                        } else {
                            // TH: Sản phẩm thuộc danh mục cha
                            parentSelect.value = childId;
                        }

                        // BƯỚC 4: Tải danh mục con dựa trên cha đã chọn
                        populateChildSelect();

                        // BƯỚC 5: Chọn đúng danh mục con (nếu có)
                        if (parentId) {
                            childSelect.value = childId;
                        }
                    }
                }

            });
        </script>
    </body>
</html>
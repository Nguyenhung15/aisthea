<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/views/admin/include/header_admin.jsp" %>
<%@ include file="/views/admin/include/sidebar_admin.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <c:choose>
            <c:when test="${not empty category}">
                <title>Chỉnh sửa danh mục</title>
            </c:when>
            <c:otherwise>
                <title>Thêm danh mục mới</title>
            </c:otherwise>
        </c:choose>
        <style>
            body { background-color: #f9f9f9; font-family: "Segoe UI", sans-serif; }
            .form-container { margin-left:240px; padding:30px; }
            h2 { color:#3e2723; }
            hr { border:1px solid #d7ccc8; margin:15px 0; }
            
            form {
                display: grid;
                gap: 15px;
                width: 700px;
                background: #fff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px 20px;
            }
            .form-group {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }
            label { font-weight: 600; color: #5d4037; }
            input[type="text"], input[type="email"],
            textarea, select {
                width: 100%;
                padding: 9px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box; 
            }
            select:disabled {
                background-color: #e9ecef;
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
                width: 120px;
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
                width: 80px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        
        <div class="form-container">

            <c:choose>
                <c:when test="${not empty category}">
                    <h2>Chỉnh sửa danh mục</h2>
                </c:when>
                <c:otherwise>
                    <h2>Thêm danh mục mới</h2>
                </c:otherwise>
            </c:choose>
            <hr>

            <c:if test="${not empty errorMsg}">
                <p style="color:red;">${errorMsg}</p>
            </c:if>

            <form action="category" method="post">
                <c:choose>
                    <c:when test="${not empty category}">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="id" value="<c:out value='${category.categoryid}' />" />
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="insert" />
                    </c:otherwise>
                </c:choose>

                <div class="form-group">
                    <label for="name">Tên danh mục (*)</label>
                    <input type="text" id="name" name="name" 
                           value="<c:out value='${category.name}' />" required>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="type">Loại (Type)</label>
                        <input type="text" id="type" name="type"
                               value="<c:out value='${category.type}' />">
                    </div>

                    <div class="form-group">
                        <label for="indexName">Index Name ("index_name")</label>
                        <input type="text" id="indexName" name="indexName"
                               value="<c:out value='${category.indexName}' />">
                    </div>

                    <div class="form-group">
                        <label for="genderid">Giới tính (*)</label>
                        <select id="genderid" name="genderid" required
                                data-selected-gender="${category.genderid}"
                                data-selected-parent="${category.parentid}">
                            <option value="">-- Chọn giới tính --</option>
                            <option value="1" ${category.genderid == 1 ? 'selected' : ''}>Nam</option>
                            <option value="2" ${category.genderid == 2 ? 'selected' : ''}>Nữ</option>
                            <option value="3" ${category.genderid == 3 ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="parentid">Danh mục cha</label>
                        <select id="parentid" name="parentid">
                            <option value="">-- Bỏ trống (nếu đây là Danh mục cha) --</option>
                        </select>
                    </div>
                </div>

                <div style="margin-top: 10px;">
                    <button type="submit" class="btn-save">Lưu lại</button>
                    <a href="category" class="btn-cancel">Hủy bỏ</a>
                </div>
            </form>
        </div>

        <select id="categoryDataSource" style="display: none;">
            <c:forEach var="cat" items="${allCategories}">
                <option value="${cat.indexName}" 
                        data-category-id="${cat.categoryid}"
                        data-gender-id="${cat.genderid}"
                        data-parent-id="${cat.parentid}"
                        data-index-name="${cat.indexName}">
                    ${cat.name}
                </option>
            </c:forEach>
        </select>

        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const genderSelect = document.getElementById("genderid");
                const parentSelect = document.getElementById("parentid"); 
                const allCategoryOptions = Array.from(document.querySelectorAll("#categoryDataSource option"));

                function resetSelect(selectElement, defaultText) {
                    selectElement.innerHTML = `<option value=''>-- ${defaultText} --</option>`;
                }

                function populateParentSelect(selectedGenderId) {
                    resetSelect(parentSelect, "Bỏ trống (nếu đây là Danh mục cha)");

                    const currentCategoryIdInput = document.querySelector("input[name='id']");
                    const currentCategoryId = currentCategoryIdInput ? currentCategoryIdInput.value : null;

                    if (!selectedGenderId) {
                        parentSelect.disabled = true;
                        return;
                    }

                    parentSelect.disabled = false;

                    allCategoryOptions.forEach(option => {
                        const optionGenderId = option.dataset.genderId;
                        const optionParentId = option.dataset.parentId;
                        const optionCatId = option.dataset.categoryId;

                        const isParentCategory = !optionParentId || optionParentId === '0' || optionParentId === 'null' || optionParentId === '';

                        if (optionGenderId === selectedGenderId && isParentCategory && optionCatId !== currentCategoryId) {
                            parentSelect.appendChild(option.cloneNode(true));
                        }
                    });
                }


                genderSelect.addEventListener("change", function () {
                    populateParentSelect(genderSelect.value);
                });

                const isEditMode = ${not empty category};

                if (isEditMode) {
                    const genderId = genderSelect.dataset.selectedGender;
                    const parentIndexNameToSelect = genderSelect.dataset.selectedParent;

                    if (genderId) {
                        populateParentSelect(genderId);
                    }

                    if (parentIndexNameToSelect) {
                        parentSelect.value = parentIndexNameToSelect;
                    }
                } else {
                    populateParentSelect(genderSelect.value);
                }

            });
        </script>
    </body>
</html>
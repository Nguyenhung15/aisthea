<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <c:out value="${empty product ? 'Add Product' : 'Edit Product'}" /> — AISTHÉA Admin
                </title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <style>
                    .lux-form-section {
                        background: var(--color-white);
                        border-radius: var(--radius-xl);
                        box-shadow: var(--shadow-card);
                        padding: var(--space-xl) var(--space-2xl);
                        margin-bottom: var(--space-lg);
                        max-width: 900px;
                    }

                    .lux-form-section__title {
                        font-family: var(--font-serif);
                        font-size: 1.1rem;
                        font-weight: 700;
                        color: var(--color-primary);
                        margin-bottom: var(--space-lg);
                        padding-bottom: var(--space-md);
                        border-bottom: 1px solid var(--color-border-light);
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .lux-form-section__title i {
                        font-size: 0.9rem;
                        color: var(--color-text-muted);
                    }

                    .lux-form-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: var(--space-lg) var(--space-xl);
                    }

                    .lux-form-group {
                        display: flex;
                        flex-direction: column;
                        gap: 6px;
                    }

                    .lux-form-group.full-width {
                        grid-column: 1/-1;
                    }

                    .lux-form-label {
                        font-size: 0.78rem;
                        font-weight: 600;
                        color: var(--color-text-secondary);
                        text-transform: uppercase;
                        letter-spacing: 0.8px;
                    }

                    .lux-form-label .required {
                        color: #dc2626;
                    }

                    .lux-form-input,
                    .lux-form-select,
                    .lux-form-textarea {
                        width: 100%;
                        padding: 11px 16px;
                        border: 1.5px solid var(--color-border);
                        border-radius: var(--radius-md);
                        font-family: var(--font-sans);
                        font-size: 0.88rem;
                        color: var(--color-text-primary);
                        background: var(--color-white);
                        outline: none;
                        transition: border-color 0.2s ease, box-shadow 0.2s ease;
                        box-sizing: border-box;
                    }

                    .lux-form-textarea {
                        min-height: 100px;
                        resize: vertical;
                    }

                    .lux-form-input:focus,
                    .lux-form-select:focus,
                    .lux-form-textarea:focus {
                        border-color: var(--color-primary);
                        box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.08);
                    }

                    .lux-form-actions {
                        display: flex;
                        gap: var(--space-md);
                        max-width: 900px;
                    }

                    .lux-btn-secondary {
                        display: inline-flex;
                        align-items: center;
                        gap: var(--space-sm);
                        padding: 12px 28px;
                        background: var(--color-bg);
                        color: var(--color-text-secondary);
                        font-family: var(--font-sans);
                        font-size: 0.82rem;
                        font-weight: 600;
                        border: 1px solid var(--color-border);
                        border-radius: var(--radius-full);
                        cursor: pointer;
                        transition: all 0.2s ease;
                        text-decoration: none;
                    }

                    .lux-btn-secondary:hover {
                        background: var(--color-border);
                        color: var(--color-text-primary);
                    }

                    /* Dynamic rows */
                    .dynamic-row {
                        display: grid;
                        gap: 12px;
                        align-items: center;
                        margin-bottom: 10px;
                        padding: 12px 16px;
                        border: 1px solid var(--color-border-light);
                        border-radius: var(--radius-md);
                        transition: border-color 0.2s ease;
                    }

                    .dynamic-row:hover {
                        border-color: var(--color-border);
                    }

                    .image-row {
                        grid-template-columns: 3fr 1.5fr auto 36px;
                    }

                    .stock-row {
                        grid-template-columns: 1fr 1fr 1fr 36px;
                    }

                    .dynamic-row input {
                        padding: 9px 12px;
                        border: 1.5px solid var(--color-border);
                        border-radius: var(--radius-sm);
                        font-family: var(--font-sans);
                        font-size: 0.85rem;
                        outline: none;
                        box-sizing: border-box;
                    }

                    .dynamic-row input:focus {
                        border-color: var(--color-primary);
                    }

                    .radio-label {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                        font-size: 0.82rem;
                        color: var(--color-text-secondary);
                        white-space: nowrap;
                    }

                    .remove-btn {
                        width: 32px;
                        height: 32px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: var(--radius-sm);
                        background: var(--color-bg);
                        color: var(--color-text-muted);
                        cursor: pointer;
                        transition: all 0.2s ease;
                        font-size: 0.8rem;
                    }

                    .remove-btn:hover {
                        background: #fef2f2;
                        color: #dc2626;
                    }

                    .add-row-btn {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 8px;
                        background: var(--color-bg);
                        border: 1.5px dashed var(--color-border);
                        color: var(--color-text-secondary);
                        padding: 11px;
                        border-radius: var(--radius-md);
                        cursor: pointer;
                        font-weight: 600;
                        font-size: 0.85rem;
                        transition: all 0.2s ease;
                    }

                    .add-row-btn:hover {
                        background: var(--color-border-light);
                        border-color: var(--color-text-muted);
                        color: var(--color-text-primary);
                    }
                </style>
            </head>

            <body class="luxury-admin">
                <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
                    <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

                        <main class="lux-main">
                            <div class="lux-content">

                                <!-- Page Header -->
                                <section class="lux-page-header">
                                    <div class="lux-page-header__text">
                                        <h1 class="lux-page-header__title">
                                            <c:out value="${empty product ? 'New Product' : 'Edit Product'}" />
                                        </h1>
                                        <p class="lux-page-header__subtitle">
                                            <c:choose>
                                                <c:when test="${not empty product}">Update product details, images and
                                                    inventory.</c:when>
                                                <c:otherwise>Add a new product to your catalog.</c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div class="lux-page-header__actions">
                                        <a href="${pageContext.request.contextPath}/product?action=manage"
                                            class="lux-btn-secondary">
                                            <i class="fa-solid fa-arrow-left"></i> Back to Products
                                        </a>
                                    </div>
                                </section>

                                <!-- Error Message -->
                                <c:if test="${not empty error}">
                                    <div
                                        style="background:#fef2f2;color:#dc2626;padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;max-width:900px;">
                                        <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>${error}
                                    </div>
                                </c:if>

                                <c:set var="actionUrl"
                                    value="${pageContext.request.contextPath}/product?action=insert" />
                                <c:if test="${not empty product}">
                                    <c:set var="actionUrl"
                                        value="${pageContext.request.contextPath}/product?action=update" />
                                </c:if>

                                <form action="${actionUrl}" method="post">
                                    <c:if test="${not empty product}">
                                        <input type="hidden" name="id" value="${product.productId}">
                                    </c:if>

                                    <!-- Section 1: Basic Info -->
                                    <div class="lux-form-section">
                                        <h3 class="lux-form-section__title"><i class="fa-solid fa-circle-info"></i>
                                            Basic Information</h3>
                                        <div class="lux-form-grid">
                                            <div class="lux-form-group full-width">
                                                <label class="lux-form-label">Product Name <span
                                                        class="required">*</span></label>
                                                <input type="text" name="name" value="${product.name}" required
                                                    class="lux-form-input" placeholder="Enter product name">
                                            </div>
                                            <div class="lux-form-group full-width">
                                                <label class="lux-form-label">Description</label>
                                                <textarea name="description" class="lux-form-textarea"
                                                    placeholder="Enter product description">${product.description}</textarea>
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Price (VND) <span
                                                        class="required">*</span></label>
                                                <input type="number" name="price" step="1000" value="${product.price}"
                                                    required class="lux-form-input" placeholder="0">
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Brand</label>
                                                <input type="text" name="brand" value="${product.brand}"
                                                    class="lux-form-input" placeholder="e.g. AISTHÉA">
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Discount (%)</label>
                                                <input type="number" name="discount" min="0" max="100"
                                                    value="${product.discount}" step="1" class="lux-form-input"
                                                    placeholder="0">
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Gender <span
                                                        class="required">*</span></label>
                                                <select id="genderid" name="genderid" required class="lux-form-select">
                                                    <option value="">— Select Gender —</option>
                                                    <option value="1" ${product.category.genderid==1 ? 'selected' : ''
                                                        }>Nam</option>
                                                    <option value="2" ${product.category.genderid==2 ? 'selected' : ''
                                                        }>Nữ</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Section 2: Category -->
                                    <div class="lux-form-section">
                                        <h3 class="lux-form-section__title"><i class="fa-solid fa-tags"></i> Category
                                        </h3>
                                        <div class="lux-form-grid">
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Parent Category <span
                                                        class="required">*</span></label>
                                                <select id="parentCategorySelect" name="parentCategory" required
                                                    class="lux-form-select">
                                                    <option value="">— Select gender first —</option>
                                                </select>
                                            </div>
                                            <div class="lux-form-group">
                                                <label class="lux-form-label">Sub Category <span
                                                        class="required">*</span></label>
                                                <select id="childCategorySelect" name="categoryid" required
                                                    class="lux-form-select">
                                                    <option value="">— Select parent first —</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Section 3: Images -->
                                    <div class="lux-form-section">
                                        <h3 class="lux-form-section__title"><i class="fa-solid fa-images"></i> Product
                                            Images</h3>
                                        <div id="imageContainer">
                                            <c:forEach var="image" items="${product.images}" varStatus="loop">
                                                <div class="dynamic-row image-row">
                                                    <input type="text" name="image_url" value="${image.imageUrl}"
                                                        placeholder="Image URL" required>
                                                    <input type="text" name="image_color" value="${image.color}"
                                                        placeholder="Color">
                                                    <label class="radio-label">
                                                        <input type="radio" name="image_isprimary" value="${loop.index}"
                                                            ${image.primary ? 'checked' : '' }>
                                                        Primary
                                                    </label>
                                                    <span class="remove-btn"><i class="fa-solid fa-xmark"></i></span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div class="add-row-btn" id="addImageBtn"><i class="fa-solid fa-plus"></i> Add
                                            Image</div>
                                    </div>

                                    <!-- Section 4: Stock -->
                                    <div class="lux-form-section">
                                        <h3 class="lux-form-section__title"><i class="fa-solid fa-warehouse"></i> Color,
                                            Size & Stock</h3>
                                        <div
                                            style="display:grid;grid-template-columns:1fr 1fr 1fr 36px;gap:12px;padding:0 16px 8px;margin-bottom:4px;">
                                            <span class="lux-form-label">Color</span>
                                            <span class="lux-form-label">Size</span>
                                            <span class="lux-form-label">Stock</span>
                                            <span></span>
                                        </div>
                                        <div id="stockContainer">
                                            <c:forEach var="stock" items="${product.colorSizes}">
                                                <div class="dynamic-row stock-row">
                                                    <input type="text" name="stock_color" value="${stock.color}"
                                                        placeholder="Color" required>
                                                    <input type="text" name="stock_size" value="${stock.size}"
                                                        placeholder="Size" required>
                                                    <input type="number" name="stock_stock" value="${stock.stock}"
                                                        min="0" placeholder="0" required>
                                                    <span class="remove-btn"><i class="fa-solid fa-xmark"></i></span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div class="add-row-btn" id="addStockBtn"><i class="fa-solid fa-plus"></i> Add
                                            Variant</div>
                                    </div>

                                    <!-- Actions -->
                                    <div class="lux-form-actions">
                                        <button type="submit" class="lux-btn-primary">
                                            <i class="fa-solid fa-check"></i>
                                            <c:out value="${empty product ? 'Create Product' : 'Save Changes'}" />
                                        </button>
                                        <a href="${pageContext.request.contextPath}/product?action=manage"
                                            class="lux-btn-secondary">Cancel</a>
                                    </div>
                                </form>

                            </div>
                        </main>

                        <!-- Hidden category data source -->
                        <select id="categoryDataSource" style="display:none;">
                            <c:forEach var="cat" items="${allCategories}">
                                <option value="${cat.categoryid}" data-gender-id="${cat.genderid}"
                                    data-parent-id="${cat.parentid}" data-index-name="${cat.indexName}">
                                    ${cat.name}
                                </option>
                            </c:forEach>
                        </select>

                        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                const genderSelect = document.getElementById("genderid");
                                const parentSelect = document.getElementById("parentCategorySelect");
                                const childSelect = document.getElementById("childCategorySelect");
                                const allCategoryOptions = Array.from(document.querySelectorAll("#categoryDataSource option"));

                                function resetSelect(selectElement, defaultText) {
                                    selectElement.innerHTML = "<option value=''>— " + defaultText + " —</option>";
                                }

                                function populateParentSelect(selectedGenderId) {
                                    resetSelect(parentSelect, "Select parent category");
                                    resetSelect(childSelect, "Select parent first");
                                    if (!selectedGenderId) return;

                                    allCategoryOptions.forEach(option => {
                                        const optionGenderId = option.dataset.genderId;
                                        const optionParentId = option.dataset.parentId;
                                        const isParentCategory = !optionParentId || optionParentId === '0' || optionParentId === 'null' || optionParentId === '';
                                        if (optionGenderId === selectedGenderId && isParentCategory) {
                                            parentSelect.appendChild(option.cloneNode(true));
                                        }
                                    });
                                }

                                function populateChildSelect() {
                                    resetSelect(childSelect, "Select sub category");
                                    const selectedGenderId = genderSelect.value;
                                    const selectedParentOption = parentSelect.options[parentSelect.selectedIndex];
                                    if (!selectedGenderId || !selectedParentOption || !selectedParentOption.value) return;

                                    const selectedParentIndexName = selectedParentOption.dataset.indexName;
                                    if (!selectedParentIndexName) return;

                                    allCategoryOptions.forEach(option => {
                                        const optionGenderId = option.dataset.genderId;
                                        const optionParentId = option.dataset.parentId;
                                        if (optionGenderId === selectedGenderId && optionParentId === selectedParentIndexName) {
                                            childSelect.appendChild(option.cloneNode(true));
                                        }
                                    });
                                }

                                genderSelect.addEventListener("change", function () { populateParentSelect(genderSelect.value); });
                                parentSelect.addEventListener("change", function () { populateChildSelect(); });

                                // Stock rows
                                const stockContainer = document.getElementById("stockContainer");
                                document.getElementById("addStockBtn").addEventListener("click", function () {
                                    const row = document.createElement("div");
                                    row.className = "dynamic-row stock-row";
                                    row.innerHTML = '<input type="text" name="stock_color" placeholder="Color" required><input type="text" name="stock_size" placeholder="Size" required><input type="number" name="stock_stock" placeholder="0" min="0" required><span class="remove-btn"><i class="fa-solid fa-xmark"></i></span>';
                                    stockContainer.appendChild(row);
                                });
                                stockContainer.addEventListener("click", function (e) {
                                    if (e.target.classList.contains("remove-btn") || e.target.closest(".remove-btn")) {
                                        (e.target.closest(".dynamic-row") || e.target.parentElement).remove();
                                    }
                                });

                                // Image rows
                                const imageContainer = document.getElementById("imageContainer");
                                let imageRowIndex = imageContainer.querySelectorAll('.dynamic-row').length;
                                document.getElementById("addImageBtn").addEventListener("click", function () {
                                    const idx = imageRowIndex++;
                                    const isFirst = imageContainer.querySelectorAll('input[type="radio"]').length === 0;
                                    const row = document.createElement("div");
                                    row.className = "dynamic-row image-row";
                                    row.innerHTML = '<input type="text" name="image_url" placeholder="Paste image URL" required><input type="text" name="image_color" placeholder="Color"><label class="radio-label"><input type="radio" name="image_isprimary" value="' + idx + '"' + (isFirst ? ' checked' : '') + '> Primary</label><span class="remove-btn"><i class="fa-solid fa-xmark"></i></span>';
                                    imageContainer.appendChild(row);
                                });
                                imageContainer.addEventListener("click", function (e) {
                                    if (e.target.classList.contains("remove-btn") || e.target.closest(".remove-btn")) {
                                        const rowToRemove = e.target.closest(".dynamic-row") || e.target.parentElement;
                                        const radio = rowToRemove.querySelector('input[type="radio"]');
                                        const wasChecked = radio ? radio.checked : false;
                                        rowToRemove.remove();
                                        if (wasChecked) {
                                            const firstRadio = imageContainer.querySelector('input[type="radio"]');
                                            if (firstRadio) firstRadio.checked = true;
                                        }
                                    }
                                });

                                // Edit mode: restore category selections
                                const isEditMode = ${ not empty product && not empty product.category
                            };
                            if (isEditMode) {
                                const genderId = "${product.category.genderid}";
                                const parentId = "${empty parentCategory ? '' : parentCategory.categoryid}";
                                const childId = "${product.category.categoryid}";

                                if (genderId) {
                                    genderSelect.value = genderId;
                                    populateParentSelect(genderId);
                                    if (parentId) {
                                        parentSelect.value = parentId;
                                    } else {
                                        parentSelect.value = childId;
                                    }
                                    populateChildSelect();
                                    if (parentId) {
                                        childSelect.value = childId;
                                    }
                                }
                            }
        });
                        </script>
            </body>

            </html>
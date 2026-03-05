<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>
                <c:choose>
                    <c:when test="${not empty category}">Edit Category</c:when>
                    <c:otherwise>Add Category</c:otherwise>
                </c:choose> — AISTHÉA Admin
            </title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
            <style>
                .lux-form-card {
                    background: var(--color-white);
                    border-radius: var(--radius-xl);
                    box-shadow: var(--shadow-card);
                    padding: var(--space-xl) var(--space-2xl);
                    max-width: 700px;
                }

                .lux-form-card__title {
                    font-family: var(--font-serif);
                    font-size: 1.3rem;
                    font-weight: 700;
                    color: var(--color-primary);
                    margin-bottom: var(--space-xs);
                }

                .lux-form-card__subtitle {
                    font-size: 0.82rem;
                    color: var(--color-text-muted);
                    margin-bottom: var(--space-xl);
                    padding-bottom: var(--space-lg);
                    border-bottom: 1px solid var(--color-border-light);
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
                .lux-form-select {
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

                .lux-form-input:focus,
                .lux-form-select:focus {
                    border-color: var(--color-primary);
                    box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.08);
                }

                .lux-form-select:disabled {
                    background: #f9fafb;
                    color: var(--color-text-muted);
                }

                .lux-form-actions {
                    display: flex;
                    gap: var(--space-md);
                    margin-top: var(--space-xl);
                    padding-top: var(--space-lg);
                    border-top: 1px solid var(--color-border-light);
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
                                        <c:choose>
                                            <c:when test="${not empty category}">Edit Category</c:when>
                                            <c:otherwise>New Category</c:otherwise>
                                        </c:choose>
                                    </h1>
                                    <p class="lux-page-header__subtitle">
                                        <c:choose>
                                            <c:when test="${not empty category}">Update category details and hierarchy.
                                            </c:when>
                                            <c:otherwise>Create a new product category for your catalog.</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="lux-page-header__actions">
                                    <a href="${pageContext.request.contextPath}/category" class="lux-btn-secondary">
                                        <i class="fa-solid fa-arrow-left"></i> Back to Categories
                                    </a>
                                </div>
                            </section>

                            <!-- Error Message -->
                            <c:if test="${not empty errorMsg}">
                                <div
                                    style="background:#fef2f2;color:#dc2626;padding:14px 20px;border-radius:var(--radius-md);margin-bottom:var(--space-lg);font-weight:600;font-size:0.88rem;">
                                    <i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>${errorMsg}
                                </div>
                            </c:if>

                            <div class="lux-form-card">
                                <h2 class="lux-form-card__title">
                                    <i class="fa-solid fa-tag" style="margin-right:8px;font-size:1rem;"></i>
                                    Category Details
                                </h2>
                                <p class="lux-form-card__subtitle">Fill in the fields below. Required fields are marked
                                    with <span style="color:#dc2626;">*</span></p>

                                <form action="category" method="post">
                                    <c:choose>
                                        <c:when test="${not empty category}">
                                            <input type="hidden" name="action" value="update" />
                                            <input type="hidden" name="id"
                                                value="<c:out value='${category.categoryid}' />" />
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="action" value="insert" />
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="lux-form-group full-width" style="margin-bottom:var(--space-lg);">
                                        <label class="lux-form-label">Category Name <span
                                                class="required">*</span></label>
                                        <input type="text" id="name" name="name"
                                            value="<c:out value='${category.name}' />" required class="lux-form-input"
                                            placeholder="e.g. Áo khoác, Quần jeans...">
                                    </div>

                                    <div class="lux-form-grid">
                                        <div class="lux-form-group">
                                            <label class="lux-form-label">Type</label>
                                            <input type="text" id="type" name="type"
                                                value="<c:out value='${category.type}' />" class="lux-form-input"
                                                placeholder="e.g. Clothing">
                                        </div>
                                        <div class="lux-form-group">
                                            <label class="lux-form-label">Index Name</label>
                                            <input type="text" id="indexName" name="indexName"
                                                value="<c:out value='${category.indexName}' />" class="lux-form-input"
                                                placeholder="e.g. ao-khoac">
                                        </div>
                                        <div class="lux-form-group">
                                            <label class="lux-form-label">Gender <span class="required">*</span></label>
                                            <select id="genderid" name="genderid" required class="lux-form-select"
                                                data-selected-gender="${category.genderid}"
                                                data-selected-parent="${category.parentid}">
                                                <option value="">— Select Gender —</option>
                                                <option value="1" ${category.genderid==1 ? 'selected' : '' }>Nam
                                                </option>
                                                <option value="2" ${category.genderid==2 ? 'selected' : '' }>Nữ</option>
                                                <option value="3" ${category.genderid==3 ? 'selected' : '' }>Khác
                                                </option>
                                            </select>
                                        </div>
                                        <div class="lux-form-group">
                                            <label class="lux-form-label">Parent Category</label>
                                            <select id="parentid" name="parentid" class="lux-form-select">
                                                <option value="">— None (this is a parent) —</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="lux-form-actions">
                                        <button type="submit" class="lux-btn-primary">
                                            <i class="fa-solid fa-check"></i>
                                            <c:choose>
                                                <c:when test="${not empty category}">Save Changes</c:when>
                                                <c:otherwise>Create Category</c:otherwise>
                                            </c:choose>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/category"
                                            class="lux-btn-secondary">Cancel</a>
                                    </div>
                                </form>
                            </div>

                        </div>
                    </main>

                    <!-- Hidden data source for parent category JS -->
                    <select id="categoryDataSource" style="display:none;">
                        <c:forEach var="cat" items="${allCategories}">
                            <option value="${cat.indexName}" data-category-id="${cat.categoryid}"
                                data-gender-id="${cat.genderid}" data-parent-id="${cat.parentid}"
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
                                selectElement.innerHTML = "<option value=''>— " + defaultText + " —</option>";
                            }

                            function populateParentSelect(selectedGenderId) {
                                resetSelect(parentSelect, "None (this is a parent)");

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

                            const isEditMode = ${ not empty category };

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
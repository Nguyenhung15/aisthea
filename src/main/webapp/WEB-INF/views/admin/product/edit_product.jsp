<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${empty product ? 'Add Product' : 'Edit Product'}" /> — AISTHÉA Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
    <style>
        /* ══════════════════════════════════════
           LAYOUT
        ══════════════════════════════════════ */
        .ep-wrapper {
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 24px;
            align-items: start;
            max-width: 1200px;
        }

        .ep-main { display: flex; flex-direction: column; gap: 20px; }
        .ep-sidebar { display: flex; flex-direction: column; gap: 20px; position: sticky; top: 24px; }

        /* ══════════════════════════════════════
           CARDS
        ══════════════════════════════════════ */
        .ep-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,.06), 0 4px 16px rgba(0,0,0,.05);
            overflow: hidden;
        }

        .ep-card__header {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 18px 24px;
            border-bottom: 1px solid #f1f5f9;
        }

        .ep-card__header-icon {
            width: 32px; height: 32px;
            display: flex; align-items: center; justify-content: center;
            background: #f1f5f9;
            border-radius: 8px;
            font-size: 0.8rem;
            color: #64748b;
        }

        .ep-card__title {
            font-family: 'Playfair Display', serif;
            font-size: 0.95rem;
            font-weight: 700;
            color: #1a2332;
            margin: 0;
        }

        .ep-card__body { padding: 24px; }

        /* ══════════════════════════════════════
           FORM ELEMENTS
        ══════════════════════════════════════ */
        .ep-form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .ep-form-grid .full { grid-column: 1 / -1; }

        .ep-field { display: flex; flex-direction: column; gap: 6px; }

        .ep-label {
            font-size: 0.72rem;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .ep-label .req { color: #ef4444; }

        .ep-input,
        .ep-select,
        .ep-textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            color: #1e293b;
            background: #fff;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box;
        }

        .ep-textarea { min-height: 110px; resize: vertical; }

        .ep-input:focus,
        .ep-select:focus,
        .ep-textarea:focus {
            border-color: #1a2332;
            box-shadow: 0 0 0 3px rgba(26,35,50,.08);
        }

        /* ══════════════════════════════════════
           BUTTONS
        ══════════════════════════════════════ */
        .ep-btn-primary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 28px;
            background: #1a2332;
            color: #fff;
            font-family: 'Inter', sans-serif;
            font-size: 0.82rem;
            font-weight: 600;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(26,35,50,.2);
            text-decoration: none;
        }

        .ep-btn-primary:hover {
            background: #000;
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(26,35,50,.25);
        }

        .ep-btn-secondary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 28px;
            background: #f8fafc;
            color: #64748b;
            font-family: 'Inter', sans-serif;
            font-size: 0.82rem;
            font-weight: 600;
            border: 1.5px solid #e2e8f0;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }

        .ep-btn-secondary:hover {
            background: #e2e8f0;
            color: #1e293b;
        }

        .ep-btn-ghost {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            background: #f8fafc;
            color: #64748b;
            font-size: 0.78rem;
            font-weight: 600;
            border: 1.5px dashed #cbd5e1;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'Inter', sans-serif;
        }

        .ep-btn-ghost:hover {
            background: #f1f5f9;
            border-color: #94a3b8;
            color: #1e293b;
        }

        /* ══════════════════════════════════════
           IMAGE ROWS
        ══════════════════════════════════════ */
        .img-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            border: 1.5px solid #f1f5f9;
            border-radius: 12px;
            margin-bottom: 10px;
            background: #fafafa;
            transition: border-color 0.2s;
        }

        .img-row:hover { border-color: #e2e8f0; background: #fff; }

        .img-thumb {
            width: 54px;
            height: 64px;
            border-radius: 8px;
            border: 1.5px solid #e2e8f0;
            overflow: hidden;
            flex-shrink: 0;
            background: #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: #cbd5e1;
        }

        .img-thumb img {
            width: 100%; height: 100%; object-fit: cover;
            display: none;
            transition: transform 0.2s;
        }

        .img-thumb:hover img { transform: scale(1.08); }

        .img-row-fields { flex: 1; display: flex; flex-direction: column; gap: 8px; }

        .img-row-url-wrap { display: flex; gap: 8px; align-items: center; }

        .img-row-meta { display: flex; gap: 10px; align-items: center; }

        .img-row-color { width: 130px; }

        .img-row-actions { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }

        /* upload tab pill */
        .url-toggle {
            display: flex;
            background: #f1f5f9;
            border-radius: 8px;
            padding: 2px;
            flex-shrink: 0;
        }

        .url-toggle button {
            padding: 4px 10px;
            border: none;
            background: transparent;
            border-radius: 6px;
            font-size: 0.72rem;
            font-weight: 600;
            color: #94a3b8;
            cursor: pointer;
            transition: all 0.15s;
            font-family: 'Inter', sans-serif;
        }

        .url-toggle button.active {
            background: #fff;
            color: #1e293b;
            box-shadow: 0 1px 3px rgba(0,0,0,.1);
        }

        /* ══════════════════════════════════════
           STOCK/VARIANT ROWS
        ══════════════════════════════════════ */
        .stock-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 32px;
            gap: 10px;
            align-items: center;
            padding: 10px 12px;
            border: 1.5px solid #f1f5f9;
            border-radius: 10px;
            margin-bottom: 8px;
            background: #fafafa;
            transition: border-color 0.2s;
        }

        .stock-row:hover { border-color: #e2e8f0; background: #fff; }

        .stock-row input {
            padding: 8px 11px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.83rem;
            outline: none;
            box-sizing: border-box;
            width: 100%;
            transition: border-color 0.2s;
        }

        /* Color & Size columns should be uppercase */
        .stock-row input[name="stock_color"],
        .stock-row input[name="stock_size"] {
            text-transform: uppercase;
        }

        .stock-row input:focus { border-color: #1a2332; }

        /* ══════════════════════════════════════
           VARIANT GENERATOR
        ══════════════════════════════════════ */
        .variant-gen {
            background: linear-gradient(135deg, #f8fafc 0%, #f0f4ff 100%);
            border: 1.5px solid #e0e7ff;
            border-radius: 12px;
            padding: 18px;
            margin-bottom: 20px;
        }

        .variant-gen__header {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.75rem;
            font-weight: 700;
            color: #4f46e5;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            margin-bottom: 14px;
        }

        .variant-gen__grid {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 12px;
            align-items: end;
        }

        .variant-gen__hint {
            font-size: 0.7rem;
            color: #94a3b8;
            margin-top: 10px;
        }

        /* ══════════════════════════════════════
           REMOVE BTN
        ══════════════════════════════════════ */
        .remove-btn {
            width: 30px; height: 30px;
            display: flex; align-items: center; justify-content: center;
            border-radius: 7px;
            background: #f8fafc;
            color: #94a3b8;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.75rem;
            flex-shrink: 0;
            border: 1px solid #e2e8f0;
        }

        .remove-btn:hover { background: #fef2f2; color: #ef4444; border-color: #fecaca; }

        /* ══════════════════════════════════════
           RADIO LABEL
        ══════════════════════════════════════ */
        .ep-radio-label {
            display: flex; align-items: center; gap: 5px;
            font-size: 0.78rem;
            color: #64748b;
            white-space: nowrap;
            cursor: pointer;
        }

        /* ══════════════════════════════════════
           ACTIONS BAR
        ══════════════════════════════════════ */
        .ep-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        /* ══════════════════════════════════════
           BADGE TAG (color swatch)
        ══════════════════════════════════════ */
        .stock-col-header {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 32px;
            gap: 10px;
            padding: 0 12px 8px;
        }

        .stock-col-header span {
            font-size: 0.7rem;
            font-weight: 700;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
    </style>
</head>
<body class="luxury-admin">
<%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
<%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

<main class="lux-main">
    <div class="lux-content">

        <!-- Page Header -->
        <section class="lux-page-header" style="margin-bottom: 24px;">
            <div class="lux-page-header__text">
                <h1 class="lux-page-header__title">
                    <c:out value="${empty product ? 'New Product' : 'Edit Product'}" />
                </h1>
                <p class="lux-page-header__subtitle">
                    <c:choose>
                        <c:when test="${not empty product}">Update product details, images and inventory.</c:when>
                        <c:otherwise>Add a new product to your AISTHÉA catalog.</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div class="lux-page-header__actions">
                <a href="${pageContext.request.contextPath}/product?action=manage" class="ep-btn-secondary">
                    <i class="fa-solid fa-arrow-left"></i> Back to Products
                </a>
            </div>
        </section>

        <!-- Error -->
        <c:if test="${not empty error}">
            <div style="background:#fef2f2;color:#dc2626;padding:14px 20px;border-radius:10px;margin-bottom:20px;font-weight:600;font-size:0.875rem;max-width:1200px;display:flex;align-items:center;gap:10px;">
                <i class="fa-solid fa-circle-exclamation"></i>${error}
            </div>
        </c:if>

        <%-- isEdit = product exists AND has a persisted ID (edit mode vs insert-error mode) --%>
        <c:set var="isEdit" value="${not empty product and product.productId > 0}" />
        <c:set var="actionUrl" value="${pageContext.request.contextPath}/product?action=${isEdit ? 'update' : 'insert'}" />

        <form action="${actionUrl}" method="post" enctype="multipart/form-data" id="productForm">
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${product.productId}">
            </c:if>
            <%-- JS syncs childCategorySelect value here before submit; pre-fill for edit mode --%>
            <input type="hidden" name="categoryid_backup" id="categoryid_backup"
                   value="<c:out value='${isEdit ? product.category.categoryid : ""}' />">

            <div class="ep-wrapper">

                <!-- ═══ LEFT COLUMN ═══ -->
                <div class="ep-main">

                    <!-- Section 1: Basic Info -->
                    <div class="ep-card">
                        <div class="ep-card__header">
                            <div class="ep-card__header-icon"><i class="fa-solid fa-circle-info"></i></div>
                            <h3 class="ep-card__title">Basic Information</h3>
                        </div>
                        <div class="ep-card__body">
                            <div class="ep-form-grid">
                                <div class="ep-field full">
                                    <label class="ep-label">Product Name <span class="req">*</span></label>
                                    <input type="text" name="name"
                                           value="<c:out value='${not empty product.name ? product.name : param.name}' />"
                                           required class="ep-input" placeholder="e.g. Classic Fitted Blazer">
                                </div>
                                <div class="ep-field full">
                                    <label class="ep-label">Description</label>
                                    <textarea name="description" class="ep-textarea"
                                              placeholder="Describe the product — material, fit, occasion..."><c:out value='${not empty product.description ? product.description : param.description}' /></textarea>
                                </div>
                                <div class="ep-field">
                                    <label class="ep-label">Price (VND) <span class="req">*</span></label>
                                    <input type="number" name="price" step="1000"
                                           value="<c:out value='${not empty product.price ? product.price : param.price}' />"
                                           required class="ep-input" placeholder="0">
                                </div>
                                <div class="ep-field">
                                    <label class="ep-label">Brand</label>
                                    <input type="text" name="brand"
                                           value="<c:out value='${not empty product.brand ? product.brand : (not empty param.brand ? param.brand : \"AISTHÉA\")}' />"
                                           class="ep-input" placeholder="e.g. AISTHÉA">
                                </div>
                                <div class="ep-field">
                                    <label class="ep-label">Discount (%)</label>
                                    <input type="number" name="discount" min="0" max="100" step="1"
                                           value="<c:out value='${not empty product.discount ? product.discount : param.discount}' />"
                                           class="ep-input" placeholder="0">
                                </div>
                                <div class="ep-field">
                                    <label class="ep-label">Weight (kg)</label>
                                    <input type="number" name="weight" step="0.1" min="0.1"
                                           value="<c:out value='${not empty product.weight ? product.weight : 0.5}' />"
                                           class="ep-input" placeholder="0.5" required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Section 3: Images -->
                    <div class="ep-card">
                        <div class="ep-card__header">
                            <div class="ep-card__header-icon"><i class="fa-solid fa-images"></i></div>
                            <h3 class="ep-card__title">Product Images</h3>
                        </div>
                        <div class="ep-card__body">
                            <div id="imageContainer">
                                <c:forEach var="image" items="${product.images}" varStatus="loop">
                                    <div class="img-row">
                                        <div class="img-thumb" id="thumb_${loop.index}">
                                            <i class="fa-regular fa-image"></i>
                                            <c:set var="resolvedUrl" value="${image.imageUrl}" />
                                            <c:if test="${not empty resolvedUrl and not fn:startsWith(resolvedUrl, 'http') and not fn:startsWith(resolvedUrl, '/')}">
                                                <c:set var="resolvedUrl" value="${pageContext.request.contextPath}/uploads/${resolvedUrl}" />
                                            </c:if>
                                            <img id="thumbImg_${loop.index}" src="${resolvedUrl}" alt="" onerror="this.style.display='none'" onload="this.style.display='block'; this.closest('.img-thumb').querySelector('i').style.display='none'">
                                        </div>
                                        <div class="img-row-fields">
                                            <input type="hidden" name="image_index" value="${loop.index}">
                                            <div class="img-row-url-wrap">
                                                <!-- URL tab -->
                                                <div class="url-toggle" role="tablist">
                                                    <button type="button" class="active" onclick="switchTab(this,'url','${loop.index}')">URL</button>
                                                    <button type="button" onclick="switchTab(this,'file','${loop.index}')">Upload</button>
                                                </div>
                                                <input type="text" name="image_url" id="urlInput_${loop.index}" value="${image.imageUrl}"
                                                       class="ep-input" placeholder="Paste image URL…"
                                                       oninput="previewFromUrl(this, '${loop.index}')">
                                                <input type="file" name="image_file_${loop.index}" id="fileInput_${loop.index}" accept="image/*"
                                                       style="display:none;" onchange="previewFromFile(this,'${loop.index}')">
                                            </div>
                                            <div class="img-row-meta">
                                                <input type="text" name="image_color" value="${image.color}" class="ep-input img-row-color" placeholder="Color name">
                                                <label class="ep-radio-label">
                                                    <input type="radio" name="image_isprimary" value="${loop.index}" ${image.primary ? 'checked' : ''}> Main photo
                                                </label>
                                            </div>
                                        </div>
                                        <div class="img-row-actions">
                                            <span class="remove-btn" onclick="this.closest('.img-row').remove(); reindexPrimary();">
                                                <i class="fa-solid fa-xmark"></i>
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <div style="display:flex; gap:10px; margin-top:4px;">
                                <button type="button" class="ep-btn-ghost" id="addImageBtn">
                                    <i class="fa-solid fa-link"></i> Add via URL
                                </button>
                                <button type="button" class="ep-btn-ghost" id="addFileBtn">
                                    <i class="fa-solid fa-arrow-up-from-bracket"></i> Upload from Device
                                </button>
                            </div>
                            <p style="font-size:0.7rem;color:#94a3b8;margin-top:8px;">
                                <i class="fa-solid fa-circle-info" style="margin-right:3px;"></i>
                                Recommended: square images, min 600×600 px, JPG or PNG.
                            </p>
                        </div>
                    </div>

                    <!-- Section 4: Inventory & Variants -->
                    <div class="ep-card">
                        <div class="ep-card__header">
                            <div class="ep-card__header-icon"><i class="fa-solid fa-warehouse"></i></div>
                            <h3 class="ep-card__title">Inventory &amp; Variants</h3>
                        </div>
                        <div class="ep-card__body">

                            <!-- Bulk Generator -->
                            <div class="variant-gen">
                                <div class="variant-gen__header">
                                    <i class="fa-solid fa-wand-magic-sparkles"></i> Bulk Variant Generator
                                </div>
                                <div class="variant-gen__grid">
                                    <div class="ep-field">
                                        <label class="ep-label">Colors <span style="text-transform:none;letter-spacing:0;font-weight:400;">(comma separated)</span></label>
                                        <input type="text" id="bulkColors" class="ep-input" placeholder="Black, White, Navy Blue">
                                    </div>
                                    <div class="ep-field">
                                        <label class="ep-label">Sizes <span style="text-transform:none;letter-spacing:0;font-weight:400;">(comma separated)</span></label>
                                        <input type="text" id="bulkSizes" class="ep-input" placeholder="XS, S, M, L, XL">
                                    </div>
                                    <button type="button" id="applyMatrixBtn" class="ep-btn-primary" style="border-radius:10px;padding:10px 20px;">
                                        <i class="fa-solid fa-table-cells"></i> Generate
                                    </button>
                                </div>
                                <p class="variant-gen__hint">
                                    <i class="fa-solid fa-lightbulb"></i>
                                    Enter colors and sizes → click Generate to auto-create all combinations. You can still edit each row manually.
                                </p>
                            </div>

                            <!-- Column headers -->
                            <div class="stock-col-header">
                                <span>Color</span>
                                <span>Size</span>
                                <span>Stock</span>
                                <span></span>
                            </div>

                            <div id="stockContainer">
                                <c:forEach var="stock" items="${product.colorSizes}">
                                    <div class="stock-row">
                                        <input type="text" name="stock_color" value="${stock.color}" placeholder="Color" required style="font-weight:700;" onblur="this.value = this.value.toUpperCase();">
                                        <input type="text" name="stock_size" value="${stock.size}" placeholder="Size" required style="font-weight:700;" onblur="this.value = this.value.toUpperCase();">
                                        <input type="number" name="stock_stock" value="${stock.stock}" min="0" placeholder="0" required>
                                        <span class="remove-btn" onclick="this.closest('.stock-row').remove()">
                                            <i class="fa-solid fa-xmark"></i>
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>

                            <button type="button" class="ep-btn-ghost" id="addStockBtn" style="margin-top:4px;width:100%;justify-content:center;">
                                <i class="fa-solid fa-plus"></i> Add Row Manually
                            </button>
                        </div>
                    </div>

                </div><!-- end ep-main -->

                <!-- ═══ RIGHT SIDEBAR ═══ -->
                <div class="ep-sidebar">

                    <!-- Publish status card -->
                    <div class="ep-card">
                        <div class="ep-card__header">
                            <div class="ep-card__header-icon"><i class="fa-solid fa-rocket"></i></div>
                            <h3 class="ep-card__title">Publish</h3>
                        </div>
                        <div class="ep-card__body">
                            <div class="ep-actions" style="flex-direction:column;">
                                <button type="submit" class="ep-btn-primary" style="width:100%;justify-content:center;">
                                    <i class="fa-solid fa-check"></i>
                                    <c:out value="${empty product ? 'Publish Product' : 'Save Changes'}" />
                                </button>
                                <a href="${pageContext.request.contextPath}/product?action=manage" class="ep-btn-secondary" style="width:100%;justify-content:center;box-sizing:border-box;">
                                    Discard
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Gender -->
                    <div class="ep-card">
                        <div class="ep-card__header">
                            <div class="ep-card__header-icon"><i class="fa-solid fa-venus-mars"></i></div>
                            <h3 class="ep-card__title">Gender</h3>
                        </div>
                        <div class="ep-card__body">
                            <div class="ep-field">
                                <select id="genderid" name="genderid" required class="ep-select">
                                    <option value="">— Select Gender —</option>
                                    <option value="1" ${product.category.genderid==1 ? 'selected' : ''}>Nam</option>
                                    <option value="2" ${product.category.genderid==2 ? 'selected' : ''}>Nữ</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Category -->
                    <div class="ep-card">
                        <div class="ep-card__header">
                            <div class="ep-card__header-icon"><i class="fa-solid fa-tags"></i></div>
                            <h3 class="ep-card__title">Category</h3>
                        </div>
                        <div class="ep-card__body" style="display:flex;flex-direction:column;gap:14px;">
                            <div class="ep-field">
                                <label class="ep-label">Parent Category <span class="req">*</span></label>
                                <select id="parentCategorySelect" name="parentCategory" required class="ep-select">
                                    <option value="">— Select gender first —</option>
                                </select>
                            </div>
                            <div class="ep-field">
                                <label class="ep-label">Sub Category <span class="req">*</span></label>
                                <select id="childCategorySelect" name="categoryid" class="ep-select">
                                    <option value="">— Select parent first —</option>
                                </select>
                                <div id="categoryError" style="display:none;color:#ef4444;font-size:0.75rem;margin-top:4px;font-weight:600;">
                                    <i class="fa-solid fa-circle-exclamation"></i> Please select a sub category.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bestseller Toggle -->
                    <div class="ep-card">
                        <div class="ep-card__header">
                            <div class="ep-card__header-icon"><i class="fa-solid fa-star"></i></div>
                            <h3 class="ep-card__title">Bestseller</h3>
                        </div>
                        <div class="ep-card__body">
                            <label style="display:flex;align-items:center;gap:10px;cursor:pointer;font-size:0.85rem;color:#cbd5e1;">
                                <!-- hidden input ensures false is sent when checkbox is unchecked -->
                                <input type="hidden" name="bestseller" value="false">
                                <input type="checkbox" name="bestseller" value="true"
                                       ${product.bestseller ? 'checked' : ''}
                                       style="width:18px;height:18px;accent-color:#9B774E;cursor:pointer;">
                                Mark as Bestseller
                            </label>
                        </div>
                    </div>

                </div><!-- end ep-sidebar -->



            </div><!-- end ep-wrapper -->

        </form>

    </div>
</main>

<!-- Hidden category data source -->
<select id="categoryDataSource" style="display:none;">
    <c:forEach var="cat" items="${allCategories}">
        <option value="${cat.categoryid}"
                data-gender-id="${cat.genderid}"
                data-parent-id="${cat.parentid}"
                data-index-name="${cat.indexName}">
            ${cat.name}
        </option>
    </c:forEach>
</select>

<!-- Edit-mode data (safe injection) -->
<div id="editMeta"
     data-is-edit="<c:out value='${not empty product}' />"
     data-gender-id="<c:out value='${product.category.genderid}' />"
     data-parent-id="<c:out value='${empty parentCategory ? \"\" : parentCategory.categoryid}' />"
     data-child-id="<c:out value='${product.category.categoryid}' />"
     style="display:none;"></div>

<script>
/* ═══════════════════════════════════════════════
   IMAGE PREVIEW HELPERS
═══════════════════════════════════════════════ */
function getThumb(idx) { return document.getElementById('thumbImg_' + idx); }
function getIcon(idx) {
    var el = document.getElementById('thumb_' + idx);
    return el ? el.querySelector('i') : null;
}

function showThumbImg(idx) {
    var img = getThumb(idx);
    var ico = getIcon(idx);
    if (img) img.style.display = 'block';
    if (ico) ico.style.display = 'none';
}

function hideThumbImg(idx) {
    var img = getThumb(idx);
    var ico = getIcon(idx);
    if (img) img.style.display = 'none';
    if (ico) ico.style.display = '';
}

function previewFromUrl(input, idx) {
    var img = getThumb(idx);
    if (!img) return;
    img.src = input.value;
    img.onload = function () { showThumbImg(idx); };
    img.onerror = function () { hideThumbImg(idx); };
}

function previewFromFile(input, idx) {
    if (!input.files || !input.files[0]) return;
    var reader = new FileReader();
    reader.onload = function (e) {
        var img = getThumb(idx);
        if (!img) return;
        img.src = e.target.result;
        img.style.display = 'block';
        showThumbImg(idx);
        // also fill URL field with a placeholder so server knows there's a file
        var urlInput = document.getElementById('urlInput_' + idx);
        if (urlInput) urlInput.value = '';
    };
    reader.readAsDataURL(input.files[0]);
}

function switchTab(btn, mode, idx) {
    var toggle = btn.closest('.url-toggle');
    toggle.querySelectorAll('button').forEach(function(b){ b.classList.remove('active'); });
    btn.classList.add('active');

    var urlInput = document.getElementById('urlInput_' + idx);
    var fileInput = document.getElementById('fileInput_' + idx);

    if (mode === 'url') {
        if (urlInput) { urlInput.style.display = ''; urlInput.focus(); }
        if (fileInput) fileInput.style.display = 'none';
    } else {
        if (urlInput) urlInput.style.display = 'none';
        if (fileInput) { fileInput.style.display = ''; fileInput.click(); }
    }
}

function reindexPrimary() {
    var radios = document.querySelectorAll('#imageContainer input[type="radio"][name="image_isprimary"]');
    if (radios.length > 0) {
        var anyChecked = Array.from(radios).some(function(r){ return r.checked; });
        if (!anyChecked) radios[0].checked = true;
    }
}

/* ═══════════════════════════════════════════════
   ADD IMAGE ROW — URL mode
═══════════════════════════════════════════════ */
var imgIdx = 0;
function createImageRow(idx, mode) {
    var row = document.createElement('div');
    row.className = 'img-row';
    var isFirst = document.querySelectorAll('#imageContainer input[type="radio"]').length === 0;
    var checkedAttr = isFirst ? 'checked' : '';

    row.innerHTML =
        '<div class="img-thumb" id="thumb_' + idx + '">' +
            '<i class="fa-regular fa-image"></i>' +
            '<img id="thumbImg_' + idx + '" src="" alt="" style="display:none;">' +
        '</div>' +
        '<div class="img-row-fields">' +
            '<input type="hidden" name="image_index" value="' + idx + '">' +
            '<div class="img-row-url-wrap">' +
                '<div class="url-toggle" role="tablist">' +
                    '<button type="button" class="' + (mode==='url' ? 'active' : '') + '" onclick="switchTab(this,\'url\',' + idx + ')">URL</button>' +
                    '<button type="button" class="' + (mode==='file' ? 'active' : '') + '" onclick="switchTab(this,\'file\',' + idx + ')">Upload</button>' +
                '</div>' +
                '<input type="text" name="image_url" id="urlInput_' + idx + '" class="ep-input" placeholder="Paste image URL…" ' +
                    (mode==='file' ? 'style="display:none;"' : '') +
                    ' oninput="previewFromUrl(this,' + idx + ')">' +
                '<input type="file" name="image_file_' + idx + '" id="fileInput_' + idx + '" accept="image/*" style="display:none;" onchange="previewFromFile(this,' + idx + ')">' +
            '</div>' +
            '<div class="img-row-meta">' +
                '<input type="text" name="image_color" class="ep-input img-row-color" placeholder="Color name">' +
                '<label class="ep-radio-label">' +
                    '<input type="radio" name="image_isprimary" value="' + idx + '" ' + checkedAttr + '> Main photo' +
                '</label>' +
            '</div>' +
        '</div>' +
        '<div class="img-row-actions">' +
            '<span class="remove-btn" onclick="this.closest(\'.img-row\').remove(); reindexPrimary();">' +
                '<i class="fa-solid fa-xmark"></i>' +
            '</span>' +
        '</div>';

    document.getElementById('imageContainer').appendChild(row);

    if (mode === 'file' && !window._suppressFileClick) {
        setTimeout(function() {
            var fi = document.getElementById('fileInput_' + idx);
            if (fi) fi.click();
        }, 50);
    }
}

/* ═══════════════════════════════════════════════
   VARIANT GENERATOR — no template literals to avoid JSP conflict
═══════════════════════════════════════════════ */
function generateMatrix() {
    var colorsStr = document.getElementById('bulkColors').value.trim();
    var sizesStr  = document.getElementById('bulkSizes').value.trim();

    if (!colorsStr || !sizesStr) {
        document.getElementById('bulkColors').focus();
        document.getElementById('bulkColors').style.borderColor = '#ef4444';
        setTimeout(function(){ document.getElementById('bulkColors').style.borderColor = ''; }, 1500);
        return;
    }

    var colors = colorsStr.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s !== ''; });
    var sizes  = sizesStr.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s !== ''; });
    var container = document.getElementById('stockContainer');

    for (var ci = 0; ci < colors.length; ci++) {
        for (var si = 0; si < sizes.length; si++) {
            var row = document.createElement('div');
            row.className = 'stock-row';

            var cInput = document.createElement('input');
            cInput.type = 'text'; cInput.name = 'stock_color';
            cInput.value = colors[ci].toUpperCase(); cInput.placeholder = 'Color'; cInput.required = true;
            cInput.style.fontWeight = '700';

            var sInput = document.createElement('input');
            sInput.type = 'text'; sInput.name = 'stock_size';
            sInput.value = sizes[si].toUpperCase(); sInput.placeholder = 'Size'; sInput.required = true;
            sInput.style.fontWeight = '700';

            var qInput = document.createElement('input');
            qInput.type = 'number'; qInput.name = 'stock_stock';
            qInput.value = '0'; qInput.min = '0'; qInput.placeholder = '0'; qInput.required = true;

            var rmBtn = document.createElement('span');
            rmBtn.className = 'remove-btn';
            rmBtn.innerHTML = '<i class="fa-solid fa-xmark"></i>';
            rmBtn.onclick = function(){ this.closest('.stock-row').remove(); };

            row.appendChild(cInput);
            row.appendChild(sInput);
            row.appendChild(qInput);
            row.appendChild(rmBtn);
            container.appendChild(row);
        }
    }

    document.getElementById('bulkColors').value = '';
    document.getElementById('bulkSizes').value = '';

    // flash success
    var btn = document.getElementById('applyMatrixBtn');
    var orig = btn.innerHTML;
    btn.innerHTML = '<i class="fa-solid fa-check"></i> Generated!';
    btn.style.background = '#16a34a';
    setTimeout(function(){
        btn.innerHTML = orig;
        btn.style.background = '';
    }, 1800);
}

/* ═══════════════════════════════════════════════
   CATEGORY CASCADE
═══════════════════════════════════════════════ */
document.addEventListener('DOMContentLoaded', function () {
    var genderSelect = document.getElementById('genderid');
    var parentSelect = document.getElementById('parentCategorySelect');
    var childSelect  = document.getElementById('childCategorySelect');
    var allOpts = Array.from(document.querySelectorAll('#categoryDataSource option'));

    function reset(sel, txt) { sel.innerHTML = "<option value=''>— " + txt + " —</option>"; }

    function fillParent(gid) {
        reset(parentSelect, 'Select parent category');
        reset(childSelect, 'Select parent first');
        if (!gid) return;
        allOpts.forEach(function(o) {
            var pid = o.dataset.parentId;
            if (o.dataset.genderId === gid && (!pid || pid === '0' || pid === 'null' || pid === '')) {
                parentSelect.appendChild(o.cloneNode(true));
            }
        });
    }

    function fillChild() {
        reset(childSelect, 'Select sub category');
        var gid = genderSelect.value;
        var pOpt = parentSelect.options[parentSelect.selectedIndex];
        if (!gid || !pOpt || !pOpt.value) return;
        var pidxName = pOpt.dataset.indexName;
        if (!pidxName) return;
        var count = 0;
        allOpts.forEach(function(o) {
            if (o.dataset.genderId === gid && o.dataset.parentId === pidxName) {
                childSelect.appendChild(o.cloneNode(true));
                count++;
            }
        });
        // If no children found, the parent IS the leaf category — use it directly
        if (count === 0) {
            var autoOpt = document.createElement('option');
            autoOpt.value = pOpt.value;
            autoOpt.textContent = pOpt.textContent.trim();
            autoOpt.selected = true;
            childSelect.appendChild(autoOpt);
        }
        // ALWAYS auto-select the first real option (index 1, since 0 is the placeholder)
        if (childSelect.options.length > 1) {
            childSelect.selectedIndex = 1;
        }
        // Hide category error if shown
        document.getElementById('categoryError').style.display = 'none';
    }

    genderSelect.addEventListener('change', function(){ fillParent(this.value); });
    parentSelect.addEventListener('change', fillChild);

    // Sync childSelect → show/hide error
    childSelect.addEventListener('change', function() {
        if (this.value) {
            document.getElementById('categoryError').style.display = 'none';
        }
    });

    /* ── INITIAL STATE FOR EDIT / ERROR ROLLBACK ── */
    var initGenderId = "<c:out value='${not empty product ? product.category.genderid : param.genderid}' />";
    var initParentId = "<c:out value='${not empty parentCategory ? parentCategory.indexName : (not empty product ? product.category.parentid : \"\")}' />";
    var initChildId  = "<c:out value='${not empty product ? product.category.categoryid : (not empty error ? product.category.categoryid : \"\")}' />";

    if (initGenderId) {
        genderSelect.value = initGenderId;
        fillParent(initGenderId);
        if (initParentId) {
            // Find parent option with data-index-name matching initParentId
            for (var i = 0; i < parentSelect.options.length; i++) {
                if (parentSelect.options[i].dataset.indexName === initParentId) {
                    parentSelect.selectedIndex = i;
                    break;
                }
            }
            fillChild();
            if (initChildId) {
                childSelect.value = initChildId;
            }
        }
    }

    /* ── FORM SUBMIT GUARD ── */
    document.getElementById('productForm').addEventListener('submit', function(e) {
        // Prevent empty file inputs from sending to avoid Tomcat FileCountLimit exceeded error 
        var fileInputs = this.querySelectorAll('input[type="file"]');
        fileInputs.forEach(function(fi) {
            if (!fi.value) {
                fi.disabled = true;
            }
        });
        
        var catVal = childSelect.value;
        // Fallback: if child is empty but parent has a value, use parent's value
        if ((!catVal || catVal === '') && parentSelect.value) {
            var fallbackOpt = document.createElement('option');
            fallbackOpt.value = parentSelect.value;
            fallbackOpt.textContent = 'Auto';
            fallbackOpt.selected = true;
            childSelect.appendChild(fallbackOpt);
            catVal = parentSelect.value;
        }
        if (!catVal || catVal === '') {
            e.preventDefault();
            document.getElementById('categoryError').style.display = 'block';
            childSelect.scrollIntoView({ behavior: 'smooth', block: 'center' });
            childSelect.focus();
            
            // Re-enable file inputs if form submission is prevented
            fileInputs.forEach(function(fi) { fi.disabled = false; });
        } else {
            document.getElementById('categoryid_backup').value = catVal;
        }
    });

    /* ── ADD STOCK ROW ── */
    document.getElementById('addStockBtn').addEventListener('click', function () {
        var row = document.createElement('div');
        row.className = 'stock-row';

        var ci = document.createElement('input'); ci.type='text'; ci.name='stock_color'; ci.placeholder='Color'; ci.required=true; ci.style.fontWeight = '700';
        var si = document.createElement('input'); si.type='text'; si.name='stock_size'; si.placeholder='Size'; si.required=true; si.style.fontWeight = '700';
        
        // ensure manual typing also becomes uppercase on blur
        ci.onblur = function() { this.value = this.value.toUpperCase(); };
        si.onblur = function() { this.value = this.value.toUpperCase(); };

        var qi = document.createElement('input'); qi.type='number'; qi.name='stock_stock'; qi.value='0'; qi.min='0'; qi.placeholder='0'; qi.required=true;
        var rb = document.createElement('span'); rb.className='remove-btn';
        rb.innerHTML='<i class="fa-solid fa-xmark"></i>';
        rb.onclick=function(){ this.closest('.stock-row').remove(); };

        row.appendChild(ci); row.appendChild(si); row.appendChild(qi); row.appendChild(rb);
        document.getElementById('stockContainer').appendChild(row);
        ci.focus();
    });

    /* ── ADD IMAGE BUTTONS ── */
    // track max idx from server-rendered rows
    var existingRows = document.querySelectorAll('#imageContainer .img-row');
    imgIdx = existingRows.length;

    document.getElementById('addImageBtn').addEventListener('click', function () {
        createImageRow(imgIdx++, 'url');
    });

    // Hidden input to allow selecting multiple files at once
    var bulkUploadInp = document.createElement('input');
    bulkUploadInp.type = 'file';
    bulkUploadInp.multiple = true;
    bulkUploadInp.accept = 'image/*';
    bulkUploadInp.style.display = 'none';
    document.body.appendChild(bulkUploadInp);

    bulkUploadInp.addEventListener('change', function(e) {
        if (!this.files.length) return;
        window._suppressFileClick = true; // Prevent individual dialog popups
        
        var filesArr = Array.from(this.files);
        filesArr.sort(function(a, b) {
            return a.name.localeCompare(b.name);
        });
        
        filesArr.forEach(function(file) {
            createImageRow(imgIdx, 'file');
            var newFileInp = document.getElementById('fileInput_' + imgIdx);
            if (newFileInp) {
                var dt = new DataTransfer();
                dt.items.add(file);
                newFileInp.files = dt.files;
                
                var reader = new FileReader();
                let currentIdx = imgIdx;
                reader.onload = function(evt) {
                    var img = document.getElementById('thumbImg_' + currentIdx);
                    if (img) {
                        img.src = evt.target.result;
                        img.style.display = 'block';
                        var icon = document.querySelector('#thumb_' + currentIdx + ' i');
                        if (icon) icon.style.display = 'none';
                    }
                };
                reader.readAsDataURL(file);
            }
            imgIdx++;
        });
        window._suppressFileClick = false;
        this.value = ''; // Reset for next time
    });

    document.getElementById('addFileBtn').addEventListener('click', function (e) {
        e.preventDefault();
        bulkUploadInp.click();
    });

    /* ── GENERATE MATRIX BTN ── */
    document.getElementById('applyMatrixBtn').addEventListener('click', generateMatrix);

    /* ── EDIT MODE RESTORE ── */
    var meta = document.getElementById('editMeta');
    if (meta && meta.dataset.isEdit === 'true') {
        var gid = String(meta.dataset.genderId || '').trim();
        var pid = String(meta.dataset.parentId || '').trim();
        var cid = String(meta.dataset.childId || '').trim();

        if (gid && gid !== '0' && gid !== '') {
            // Step 1: set gender
            genderSelect.value = gid;

            // Step 2: populate parents
            fillParent(gid);

            // Step 3: set parent
            // parentSelect now has options — find by value
            var parentFound = false;
            if (pid) {
                for (var i = 0; i < parentSelect.options.length; i++) {
                    if (String(parentSelect.options[i].value) === pid) {
                        parentSelect.selectedIndex = i;
                        parentFound = true;
                        break;
                    }
                }
            }
            // fallback: parent might be the child itself (direct category with no parent)
            if (!parentFound && cid) {
                for (var i = 0; i < parentSelect.options.length; i++) {
                    if (String(parentSelect.options[i].value) === cid) {
                        parentSelect.selectedIndex = i;
                        break;
                    }
                }
            }

            // Step 4: populate children then select
            fillChild();

            if (pid && cid) {
                for (var i = 0; i < childSelect.options.length; i++) {
                    if (String(childSelect.options[i].value) === cid) {
                        childSelect.selectedIndex = i;
                        break;
                    }
                }
            }
        }
    }

    /* ── INIT EXISTING THUMB IMAGES ── */
    document.querySelectorAll('#imageContainer .img-thumb img').forEach(function(img) {
        if (img.complete && img.naturalWidth > 0) {
            img.style.display = 'block';
            var ico = img.closest('.img-thumb').querySelector('i');
            if (ico) ico.style.display = 'none';
        }
    });

    /* ── AVOID TOMCAT PART COUNT LIMIT (FileCountLimitExceededException) ── */
    var form = document.getElementById('productForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            // 1. Pack Variants: COLOR|SIZE|STOCK;COLOR|SIZE|STOCK...
            var vArr = [];
            document.querySelectorAll('.stock-row').forEach(function(row) {
                var c = row.querySelector('[name="stock_color"]');
                var s = row.querySelector('[name="stock_size"]');
                var stk = row.querySelector('[name="stock_stock"]');
                if (c && s && stk && c.value.trim() && s.value.trim()) {
                    vArr.push(c.value.trim() + '|' + s.value.trim() + '|' + stk.value.trim());
                }
                if(c) c.removeAttribute('name');
                if(s) s.removeAttribute('name');
                if(stk) stk.removeAttribute('name');
            });
            var vInput = document.createElement('input');
            vInput.type = 'hidden';
            vInput.name = 'variants_combined';
            vInput.value = vArr.join(';');
            this.appendChild(vInput);

            // 2. Pack Image Info: URL|COLOR|INDEX;URL|COLOR|INDEX...
            var iArr = [];
            document.querySelectorAll('.img-row').forEach(function(row) {
                var url = row.querySelector('[name="image_url"]');
                var clr = row.querySelector('[name="image_color"]');
                var idx = row.querySelector('[name="image_index"]');
                if (url && idx) {
                    var cVal = (clr && clr.value) ? clr.value.trim() : '';
                    iArr.push(url.value.trim() + '|' + cVal + '|' + idx.value);
                }
                if(url) url.removeAttribute('name');
                if(clr) clr.removeAttribute('name');
                if(idx) idx.removeAttribute('name');
                // The `<input type="file" name="image_file_X">` MUST KEEP ITS NAME
                // The `<input type="radio" name="image_isprimary">` MUST KEEP ITS NAME to know primary index
            });
            var iInput = document.createElement('input');
            iInput.type = 'hidden';
            iInput.name = 'images_combined';
            iInput.value = iArr.join(';');
            this.appendChild(iInput);
        });
    }
});
</script>

</body>
</html>
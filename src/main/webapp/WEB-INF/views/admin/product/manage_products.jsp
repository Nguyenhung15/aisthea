<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products — AISTHÉA Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
    <style>
        /* ══ Overlay / Modal ══ */
        .mp-overlay { position:fixed;inset:0;background:rgba(0,0,0,.48);display:none;align-items:center;justify-content:center;z-index:1000;backdrop-filter:blur(4px); }
        .mp-overlay.open { display:flex; }
        .mp-modal { background:#fff;border-radius:16px;padding:28px 32px;width:90%;max-width:520px;box-shadow:0 24px 64px rgba(0,0,0,.2);animation:fadeUp .2s ease; }
        @keyframes fadeUp { from{opacity:0;transform:translateY(-10px)} to{opacity:1;transform:translateY(0)} }
        .mp-modal h3 { margin:0 0 4px;font-family:var(--font-serif);font-size:1.1rem;color:var(--color-primary); }
        .mp-modal .sub { margin:0 0 20px;font-size:.8rem;color:#9ca3af; }

        /* ══ Container Overrides (Window Scroll Mode) ══ */
        .lux-main { min-height: 100vh; display: block; overflow: visible; }
        .lux-content { display: block; overflow: visible; padding-bottom: 40px; max-width: 1400px; margin: 0 auto; width: 100%; }
        .lux-page-header { margin-bottom: 20px !important; }
        .ls-card { margin-bottom: 20px !important; }
        .pm-card { background:#fff; border-radius:16px; box-shadow:0 2px 12px rgba(0,0,0,.06); overflow:visible; }

        /* ══ Toolbar (Sticky Masked) ══ */
        .pm-toolbar {
            display:flex;flex-wrap:wrap;gap:10px;align-items:center;
            padding:16px 24px;background:#fff;
            border-bottom: 1px solid #f1f5f9;
            border-radius: 16px 16px 0 0;
            position: sticky; top: 72px; z-index: 100;
        }
        .pm-toolbar .left  { display:flex;align-items:center;gap:10px;flex:1;min-width:320px; }
        .pm-toolbar .right { display:flex;align-items:center;gap:8px;flex-shrink:0; }
        .pm-meta { font-size:.78rem;color:#9ca3af;white-space:nowrap; }
        .pm-meta strong { color:var(--color-primary);font-weight:600; }

        .pm-search-wrap { position:relative;display:flex;align-items:center; }
        .pm-search-wrap i { position:absolute;left:12px;color:#9ca3af;font-size:.8rem;pointer-events:none; }
        .pm-search { padding:8px 14px 8px 34px;border:1px solid #e2e8f0;border-radius:8px;
                     font-size:.82rem;outline:none;background:#f8fafc;transition:.2s;width:200px; }
        .pm-search:focus { border-color:var(--color-primary);background:#fff;box-shadow:0 0 0 3px rgba(26,35,50,.07);width:260px; }

        .pm-select { padding:8px 32px 8px 12px;border:1px solid #e2e8f0;border-radius:8px;font-size:.82rem;
                     outline:none;cursor:pointer;appearance:none;background:#f8fafc url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%236b7280' viewBox='0 0 16 16'%3E%3Cpath d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E") no-repeat right 10px center;
                     transition:.2s; max-width: 150px; }
        .pm-select:hover { border-color:var(--color-primary); }

        .pm-btn { display:inline-flex;align-items:center;justify-content:center;gap:6px;padding:8px 16px;border:none;border-radius:8px;
                  font-size:.82rem;font-weight:600;cursor:pointer;transition:.18s; }
        .pm-btn.primary { background:var(--color-primary);color:#fff; }
        .pm-btn.primary:hover { background:#2d3748; }
        .pm-btn.ghost { background:#f3f4f6;color:#374151;border:1px solid #e5e7eb; }
        .pm-btn.ghost:hover { background:#e9edf0; }
        .pm-btn.danger { background:#fee2e2;color:#dc2626; }
        .pm-btn.danger:hover { background:#fecaca; }
        .pm-btn.success { background:#d1fae5;color:#059669; }
        .pm-btn.success:hover { background:#a7f3d0; }

        /* Price Edit */
        .price-wrap { display:inline-flex; align-items:center; gap:6px; position:relative; group; cursor: pointer; }
        .price-edit-btn { opacity:0; color:#9ca3af; font-size:.75rem; transition:.2s; }
        .price-wrap:hover .price-edit-btn { opacity:1; color:var(--color-primary); }
        .price-input { width:100px; padding:4px 8px; border:1px solid var(--color-primary); border-radius:4px; font-size:.85rem; outline:none; text-align:right; font-weight:700; }

        /* Sort arrow badge */
        .sort-th { cursor:pointer;user-select:none; }
        .sort-th:hover { color:var(--color-primary); }

        /* ══ Table ══ */
        .pm-table-container { background: #fff; border-bottom-left-radius: 16px; border-bottom-right-radius: 16px; }
        .pm-table { width:100%; border-collapse:collapse; min-width: 900px; }
        .pm-table thead th { 
            position: sticky; top: 140px; z-index: 10; background:#f8fafc; 
            box-shadow: inset 0 -1px 0 #e2e8f0; 
            padding:11px 16px; font-size:.68rem; font-weight:700; color:#9ca3af; 
            text-transform:uppercase; letter-spacing:.7px; 
        }
        .pm-table tbody tr { border-bottom:1px solid #f1f5f9; transition:background .12s; }
        .pm-table tbody tr:hover { background:#fafafa; }
        .pm-table td { padding:11px 16px; vertical-align:middle; }

        /* ══ Thumbnail ══ */
        .pm-thumb { width:46px;height:46px;object-fit:cover;border-radius:8px;border:1px solid #e5e7eb;cursor:zoom-in;transition:.2s; }
        .pm-thumb:hover { transform:scale(1.06);box-shadow:0 4px 14px rgba(0,0,0,.15); }

        /* ══ Status badge ══ */
        .status-badge { display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:.72rem;font-weight:700; }
        .status-badge.active { background:#d1fae5;color:#065f46; }
        .status-badge.hidden { background:#f3f4f6;color:#9ca3af; }

        /* ══ Stock badge ══ */
        .stk { display:inline-block;padding:2px 10px;border-radius:20px;font-size:.74rem;font-weight:700; }
        .stk.ok   { background:#d1fae5;color:#065f46; }
        .stk.warn { background:#fef3c7;color:#92400e; }
        .stk.low  { background:#fee2e2;color:#991b1b; }
        .stk.zero { background:#e5e7eb;color:#6b7280; }

        /* ══ Toggle switch ══ */
        .toggle-wrap { position:relative;display:inline-block;width:38px;height:20px;cursor:pointer; }
        .toggle-wrap input { opacity:0;width:0;height:0;position:absolute; }
        .toggle-track { position:absolute;inset:0;border-radius:20px;transition:.2s; }
        .toggle-thumb { position:absolute;height:14px;width:14px;left:3px;bottom:3px;background:#fff;border-radius:50%;transition:.2s; }

        /* ══ Action icons ══ */
        .ai { width:30px;height:30px;display:inline-flex;align-items:center;justify-content:center;border-radius:7px;border:none;background:#f3f4f6;color:#6b7280;cursor:pointer;transition:.18s;font-size:.8rem;text-decoration:none; }
        .ai:hover { transform:translateY(-1px);box-shadow:0 3px 8px rgba(0,0,0,.12); }
        .ai.e:hover { background:#eff6ff;color:#2563eb; }
        .ai.s:hover { background:#f0fdf4;color:#059669; }
        .ai.d:hover { background:#fef2f2;color:#dc2626; }

        /* ══ Bulk bar ══ */
        .bulk-bar { display:none;justify-content:space-between;width:100%;align-items:center;flex-wrap:wrap; }
        .bulk-bar.show { display:flex; animation:fadeIn .2s; }
        @keyframes fadeIn { from{opacity:0;transform:translateY(3px)} to{opacity:1;transform:translateY(0)} }
        .bulk-bar .left { display:flex; align-items:center; gap:8px; }
        .bulk-bar .right { display:flex; align-items:center; gap:8px; }

        /* ══ Quick Stock modal ══ */
        .qs-row { display:flex;align-items:center;gap:10px;padding:10px 0;border-bottom:1px solid #f3f4f6; }
        .qs-row:last-child { border-bottom:none; }
        .qs-color-dot { width:12px;height:12px;border-radius:50%;border:1px solid rgba(0,0,0,.15);flex-shrink:0; }
        .qs-label { flex:1;min-width:0; }
        .qs-label .cc { font-weight:600;font-size:.85rem;color:#111827; }
        .qs-label .sz { font-size:.75rem;color:#9ca3af;margin-top:1px; }
        .qs-curr { min-width:48px;text-align:center; }
        .qs-input { width:72px;padding:6px 8px;border:1px solid #d1d5db;border-radius:8px;text-align:center;font-size:.84rem;transition:.2s; }
        .qs-input:focus { border-color:var(--color-primary);outline:none;box-shadow:0 0 0 2px rgba(26,35,50,.07); }

        /* ══ Low Stock - grouped design ══ */
        .ls-card { background:#fff;border-radius:12px;padding:16px 20px;border-left:3px solid #f59e0b;box-shadow:0 1px 8px rgba(0,0,0,.05);margin-bottom:20px; }
        .ls-header { display:flex;align-items:center;justify-content:space-between;margin-bottom:12px; }
        .ls-products { display:flex;flex-wrap:wrap;gap:8px; }
        .ls-product-chip {
            display:inline-flex;align-items:center;gap:8px;padding:8px 12px;
            background:#fffbeb;border:1px solid #fde68a;border-radius:10px;cursor:pointer;transition:.15s;
        }
        .ls-product-chip:hover { background:#fef3c7;border-color:#f59e0b;box-shadow:0 2px 8px rgba(245,158,11,.2); }
        .ls-product-chip .name { font-weight:600;font-size:.82rem;color:#92400e;max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap; }
        .ls-product-chip .info { font-size:.74rem;color:#b45309; }
        .ls-product-chip .cnt { background:#f59e0b;color:#fff;border-radius:10px;padding:1px 7px;font-size:.7rem;font-weight:700; }

        /* ══ del modal ══ */
        .del-icon-wrap { width:52px;height:52px;border-radius:50%;background:#fef2f2;display:flex;align-items:center;justify-content:center;margin:0 auto 16px; }

        /* ══ Pagination ══ */
        .pag { display:flex;gap:5px;align-items:center; }
        .pag a, .pag span { display:inline-block;padding:6px 12px;border:1px solid #e2e8f0;border-radius:7px;font-size:.8rem;text-decoration:none;color:#374151;transition:.15s; }
        .pag a:hover { border-color:var(--color-primary);color:var(--color-primary); }
        .pag .cur { background:var(--color-primary);border-color:var(--color-primary);color:#fff; }
        .pag .dots { border:none;color:#9ca3af; }

        /* ══ Toast ══ */
        #mp-toast { position:fixed;bottom:24px;right:24px;z-index:9999;display:none;
                    align-items:center;gap:10px;padding:12px 20px;border-radius:10px;
                    font-size:.84rem;font-weight:500;box-shadow:0 8px 24px rgba(0,0,0,.15);
                    animation:toastIn .22s ease; }
        @keyframes toastIn { from{opacity:0;transform:translateY(8px)} to{opacity:1;transform:translateY(0)} }
        #mp-toast.ok  { background:#ecfdf5;color:#065f46;border:1px solid #a7f3d0; }
        #mp-toast.err { background:#fef2f2;color:#991b1b;border:1px solid #fca5a5; }
        #mp-toast.war { background:#fffbeb;color:#92400e;border:1px solid #fde68a; }

        /* ══ Empty state ══ */
        .empty-state { padding:60px 20px;text-align:center;color:#9ca3af; }
        .empty-state i { font-size:3rem;margin-bottom:14px;display:block;opacity:.2; }

        /* ══ Lightbox ══ */
        #lightbox img { max-width:90%;max-height:88%;border-radius:10px;box-shadow:0 20px 60px rgba(0,0,0,.5); }
    </style>
</head>
<body class="luxury-admin">
<%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
<%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

<main class="lux-main">
<div class="lux-content">

    <%-- ── Page header ── --%>
    <section class="lux-page-header" style="margin-bottom:20px;">
        <div class="lux-page-header__text">
            <h1 class="lux-page-header__title">Product Management</h1>
            <p class="lux-page-header__subtitle">Manage catalog, inventory and pricing.</p>
        </div>
        <div class="lux-page-header__actions">
            <a href="${pageContext.request.contextPath}/product?action=new" class="lux-btn-primary">
                <i class="fa-solid fa-plus"></i> Add Product
            </a>
        </div>
    </section>

    <%-- ── Error alert ── --%>
    <c:if test="${not empty param.error}">
        <div style="display:flex;align-items:center;gap:12px;padding:12px 18px;margin-bottom:16px;background:#fef2f2;border:1px solid #fca5a5;border-radius:10px;color:#b91c1c;font-size:.86rem;">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span>
                <c:choose>
                    <c:when test="${param.error == 'not_found'}">Sản phẩm không tồn tại.</c:when>
                    <c:when test="${param.error == 'invalid_id'}">ID sản phẩm không hợp lệ.</c:when>
                    <c:otherwise>Đã xảy ra lỗi. Vui lòng thử lại.</c:otherwise>
                </c:choose>
            </span>
            <button onclick="this.parentElement.style.display='none'" style="margin-left:auto;background:none;border:none;cursor:pointer;font-size:1rem;color:#b91c1c;"><i class="fa-solid fa-xmark"></i></button>
        </div>
    </c:if>

    <%-- ══════════════════════════════════════════
         LOW STOCK ALERTS — Grouped by product
    ══════════════════════════════════════════ --%>
    <c:set var="hasLowStock" value="${not empty lowStockList}"/>

    <div class="ls-card">
        <div class="ls-header">
            <div style="display:flex;align-items:center;gap:10px;">
                <div style="width:36px;height:36px;border-radius:10px;background:#fef3c7;display:flex;align-items:center;justify-content:center;color:#d97706;">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div>
                    <div style="font-family:var(--font-serif);font-size:.95rem;font-weight:700;color:#92400e;">Low Stock Alerts (Global)</div>
                    <div style="font-size:.74rem;color:#9ca3af;margin-top:1px;">Products with any variant stock ≤ 5 — click to quick-update</div>
                </div>
            </div>
        </div>
        <div class="ls-products">
            <c:choose>
                <c:when test="${!hasLowStock}">
                    <div style="display:flex;align-items:center;gap:8px;font-size:.84rem;color:#059669;font-weight:500;">
                        <i class="fa-solid fa-circle-check"></i> All products are well-stocked!
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${lowStockList}">
                        <c:set var="lowVariants" value="0"/>
                        <c:set var="minStock" value="9999"/>
                        <c:forEach var="cs" items="${p.colorSizes}">
                            <c:if test="${cs.stock le 5}">
                                <c:set var="lowVariants" value="${lowVariants + 1}"/>
                                <c:if test="${cs.stock lt minStock}"><c:set var="minStock" value="${cs.stock}"/></c:if>
                            </c:if>
                        </c:forEach>
                        <c:if test="${lowVariants > 0}">
                            <div class="ls-product-chip" onclick="openQuickStock(${p.productId},'${fn:escapeXml(p.name)}')">
                                <i class="fa-solid fa-box" style="color:#f59e0b;font-size:.8rem;"></i>
                                <span class="name">${p.name}</span>
                                <span class="info">${lowVariants} variant${lowVariants > 1 ? 's' : ''} low</span>
                                <span class="cnt">${minStock == 0 ? 'OUT' : minStock}</span>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- ══════════════════════════════════════════
         PRODUCT TABLE CARD
    ══════════════════════════════════════════ --%>
    <div class="pm-card">

        <%-- ── Toolbar: 1 hàng với search + meta + filters + sort ── --%>
        <div class="pm-toolbar" style="flex-wrap: wrap; row-gap: 12px; min-height: 69px;">
            <div id="defaultToolbar" style="display:flex; flex-wrap:wrap; width:100%; justify-content:space-between; row-gap:12px;">
                <div class="left" style="flex-wrap: wrap; gap: 8px;">
                    <%-- Search --%>
                    <div class="pm-search-wrap" title="Live search as you type">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" id="pmSearch" class="pm-search" placeholder="Search product..."
                               value="${fn:escapeXml(param.searchName)}"
                               oninput="liveSearch(this.value)"
                               onkeydown="if(event.key==='Enter') doSearch()">
                    </div>

                    <%-- Category Filters Inline --%>
                    <select id="genderFilter" class="pm-select" onchange="submitFilters('gender')">
                        <option value="">Any Gender</option>
                        <option value="1" ${param.genderId == '1' ? 'selected' : ''}>Men</option>
                        <option value="2" ${param.genderId == '2' ? 'selected' : ''}>Women</option>
<!--                        <option value="3" ${param.genderId == '3' ? 'selected' : ''}>Unisex</option>-->
                    </select>
                    
                    <select id="parentCatFilter" class="pm-select" onchange="submitFilters('parent')">
                        <option value="">Any Parent</option>
                    </select>
                    
                    <select id="subCatFilter" class="pm-select" onchange="submitFilters('sub')">
                        <option value="">Any Sub</option>
                    </select>

                    <%-- Status filter --%>
                    <select id="statusFilter" class="pm-select" onchange="submitFilters('status')">
                        <option value="" ${empty param.statusFilter ? 'selected' : ''}>Any Status</option>
                        <option value="1" ${param.statusFilter == '1' ? 'selected' : ''}>Active</option>
                        <option value="0" ${param.statusFilter == '0' ? 'selected' : ''}>Hidden</option>
                    </select>
                    
                    <c:if test="${not empty param.searchName or not empty param.genderId or not empty param.parentCategory or not empty param.subCategoryId or not empty param.statusFilter}">
                        <button class="pm-btn ghost" onclick="clearAllFilters()" style="width:36px; height:36px; padding:0;" title="Clear all filters">
                            <i class="fa-solid fa-rotate-left" style="font-size:.9rem; color:#64748b;"></i>
                        </button>
                    </c:if>
                </div>

                <div class="right">
                    <%-- Meta info --%>
                    <span class="pm-meta">
                        Showing <strong>${fn:length(productList)}</strong> / <strong>${totalRecords}</strong>
                        &nbsp;•&nbsp; Page <strong>${currentPage}</strong>/<strong>${totalPages}</strong>
                    </span>

                    <%-- Page size --%>
                    <select class="pm-select" id="pageSzSel" onchange="changePageSize(this.value)" title="Items per page">
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10/page</option>
                        <option value="15" ${pageSize == 15 || empty pageSize ? 'selected' : ''}>15/page</option>
                        <option value="25" ${pageSize == 25 ? 'selected' : ''}>25/page</option>
                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50/page</option>
                    </select>
                </div>
            </div>

            <%-- ── Bulk Action Bar (Replaces default toolbar content) ── --%>
            <div id="bulkBar" class="bulk-bar" style="flex-shrink:0;">
                <div class="left">
                    <span style="font-size:.84rem;font-weight:600;color:#1d4ed8;"><span id="selCount">0</span> selected</span>
                </div>
                <div class="right">
                    <button class="pm-btn ghost" onclick="bulkAction('activate')" style="padding:6px 12px;font-size:.78rem;">
                        <i class="fa-solid fa-eye"></i> Activate
                    </button>
                    <button class="pm-btn ghost" onclick="bulkAction('deactivate')" style="padding:6px 12px;font-size:.78rem;">
                        <i class="fa-regular fa-eye-slash"></i> Deactivate
                    </button>
                    <button class="pm-btn danger" onclick="bulkAction('delete')" style="padding:6px 12px;font-size:.78rem;">
                        <i class="fa-solid fa-trash-can"></i> Delete
                    </button>
                    <button class="pm-btn ghost" onclick="clearSelection()" style="padding:6px 10px;" title="Close">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>
            </div>
        </div>


        <%-- ── Table ── --%>
        <div class="pm-table-container">
            <table class="pm-table" id="prodTable">
                <thead>
                <tr>
                    <th style="width:40px;text-align:center;">
                        <input type="checkbox" id="chkAll" onchange="toggleAll(this)" style="width:15px;height:15px;cursor:pointer;">
                    </th>
                    <th style="text-align:left;">Product</th>
                    <th class="sort-th" style="text-align:right;" onclick="sortBy('price')">
                        Price <i class="fa-solid fa-sort${param.sort == 'price' ? (param.dir == 'asc' ? '-up' : '-down') : ''}" style="opacity:.4;font-size:.7rem;"></i>
                    </th>
                    <th class="sort-th" style="text-align:center;" onclick="sortBy('stock')">
                        Stock <i class="fa-solid fa-sort${param.sort == 'stock' ? (param.dir == 'asc' ? '-up' : '-down') : ''}" style="opacity:.4;font-size:.7rem;"></i>
                    </th>
                    <th style="text-align:center;">Status</th>
                    <th style="text-align:right;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${productList}">
                    <%-- ── resolve primary image URL ── --%>
                    <c:set var="thumbUrl" value=""/>
                    <c:if test="${not empty p.images}">
                        <c:forEach var="img" items="${p.images}" varStatus="loop">
                            <c:if test="${loop.first and empty thumbUrl}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(img.imageUrl,'http') or fn:startsWith(img.imageUrl,'/')}">
                                        <c:set var="thumbUrl" value="${img.imageUrl}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="thumbUrl" value="${pageContext.request.contextPath}/uploads/${img.imageUrl}"/>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty thumbUrl}">
                        <c:set var="thumbUrl" value="https://placehold.co/46x46/f3f4f6/9ca3af?text=?"/>
                    </c:if>

                    <tr data-pid="${p.productId}">
                        <td style="text-align:center;">
                            <input type="checkbox" class="row-chk" value="${p.productId}" onchange="updateSelCount()" style="width:15px;height:15px;cursor:pointer;">
                        </td>

                        <td>
                            <div style="display:flex;align-items:center;gap:12px;">
                                <img class="pm-thumb" src="${thumbUrl}"
                                     alt="${fn:escapeXml(p.name)}"
                                     onclick="showLightbox('${thumbUrl}')"
                                     onerror="this.src='https://placehold.co/46x46/f3f4f6/9ca3af?text=?';this.onerror=null;">
                                <div style="min-width:0;">
                                    <div style="font-weight:600;font-size:.87rem;color:#111827;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:220px;">${p.name}</div>
                                    <div style="margin-top:3px;display:flex;flex-wrap:wrap;gap:4px;align-items:center;">
                                        <span style="font-size:.7rem;color:#9ca3af;">#${p.productId}</span>
                                        <span style="font-size:.7rem;color:#9ca3af;">•</span>
                                        <span style="font-size:.72rem;background:#f3f4f6;color:#6b7280;padding:1px 7px;border-radius:5px;">${p.category.name}</span>
                                        <c:if test="${p.bestseller}">
                                            <span style="font-size:.7rem;background:#fef9c3;color:#d97706;padding:1px 6px;border-radius:5px;font-weight:700;"><i class="fa-solid fa-star" style="font-size:.6rem;"></i> Best</span>
                                        </c:if>
                                        <c:if test="${p.discount > 0}">
                                            <span style="font-size:.7rem;background:#fee2e2;color:#dc2626;padding:1px 6px;border-radius:5px;font-weight:700;">-${p.discount}%</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </td>

                        <td style="text-align:right;white-space:nowrap;">
                            <div class="price-wrap" id="pw-${p.productId}" onclick="startEditPrice(${p.productId}, ${p.price})">
                                <span class="price-val" style="font-weight:700;font-size:.9rem;color:var(--color-primary);">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                </span>
                                <i class="fa-solid fa-pencil price-edit-btn"></i>
                            </div>
                        </td>

                        <td style="text-align:center;">
                            <span class="stk ${p.totalStock > 10 ? 'ok' : p.totalStock > 0 ? 'warn' : 'zero'}"
                                  title="${fn:length(p.colorSizes)} variant(s)">
                                ${p.totalStock}
                            </span>
                        </td>

                        <td style="text-align:center;">
                            <label class="toggle-wrap" title="${p.status == 1 ? 'Active — click to hide' : 'Hidden — click to activate'}">
                                <input type="checkbox" id="sw-${p.productId}"
                                       ${p.status == 1 ? 'checked' : ''}
                                       onchange="doToggleStatus(${p.productId}, this)">
                                <span class="toggle-track" id="tr-${p.productId}"
                                      style="background:${p.status == 1 ? '#10b981' : '#d1d5db'};"></span>
                                <span class="toggle-thumb" id="th-${p.productId}"
                                      style="transform:${p.status == 1 ? 'translateX(18px)' : 'translateX(0)'};"></span>
                            </label>
                        </td>

                        <td style="text-align:right;">
                            <div style="display:flex;gap:5px;justify-content:flex-end;">
                                <a href="${pageContext.request.contextPath}/product?action=edit&id=${p.productId}"
                                   class="ai e" title="Edit product">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </a>
                                <button class="ai s" title="Quick Stock Update"
                                        onclick="openQuickStock(${p.productId},'${fn:escapeXml(p.name)}')">
                                    <i class="fa-solid fa-cubes"></i>
                                </button>
                                <button class="ai d" title="Delete product"
                                        onclick="openDeleteModal(${p.productId},'${fn:escapeXml(p.name)}')">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty productList}">
                    <tr>
                        <td colspan="6" class="empty-state">
                            <i class="fa-solid fa-box-open"></i>
                            <p style="margin:0;font-size:.9rem;">No products found.</p>
                            <c:if test="${not empty param.searchName}">
                                <a href="${pageContext.request.contextPath}/product?action=manage"
                                   style="margin-top:10px;display:inline-block;font-size:.82rem;color:var(--color-primary);">
                                    Clear search
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:if>
            </tbody>
            </table>
        </div>

        <%-- ── Pagination ── --%>
        <c:if test="${totalPages > 1}">
            <div style="display:flex;justify-content:space-between;align-items:center;padding:14px 24px;border-top:1px solid #f1f5f9;flex-shrink:0;">
                <span style="font-size:.78rem;color:#9ca3af;">
                    Page ${currentPage} of ${totalPages} &nbsp;(${totalRecords} total products)
                </span>
                <div class="pag">
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/product?action=manage&page=${currentPage-1}&searchName=${fn:escapeXml(param.searchName)}&sort=${param.sort}&dir=${param.dir}&statusFilter=${param.statusFilter}&ps=${param.ps}">
                            <i class="fa-solid fa-chevron-left" style="font-size:.7rem;"></i>
                        </a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}"><span class="cur">${i}</span></c:when>
                            <c:when test="${i == 1 or i == totalPages or (i >= currentPage-2 and i <= currentPage+2)}">
                                <a href="${pageContext.request.contextPath}/product?action=manage&page=${i}&searchName=${fn:escapeXml(param.searchName)}&sort=${param.sort}&dir=${param.dir}&statusFilter=${param.statusFilter}&ps=${param.ps}">${i}</a>
                            </c:when>
                            <c:when test="${i == currentPage-3 or i == currentPage+3}">
                                <span class="dots">…</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/product?action=manage&page=${currentPage+1}&searchName=${fn:escapeXml(param.searchName)}&sort=${param.sort}&dir=${param.dir}&statusFilter=${param.statusFilter}&ps=${param.ps}">
                            <i class="fa-solid fa-chevron-right" style="font-size:.7rem;"></i>
                        </a>
                    </c:if>
                </div>
            </div>
        </c:if>
    </div>
</div>
</main>

<%-- ══════════════════════ MODALS ══════════════════════ --%>

<%-- Delete confirm --%>
<div id="delModal" class="mp-overlay" onclick="if(event.target===this)closeModal('delModal')">
    <div class="mp-modal" style="max-width:400px;text-align:center;">
        <div class="del-icon-wrap"><i class="fa-solid fa-trash-can" style="color:#dc2626;font-size:1.3rem;"></i></div>
        <h3 style="color:#dc2626;">Confirm Delete</h3>
        <p class="sub">Delete <strong id="delName" style="color:var(--color-primary);"></strong>?<br>
            This permanently removes the product, all images and variant stock.</p>
        <div style="display:flex;gap:10px;justify-content:center;margin-top:4px;">
            <button onclick="closeModal('delModal')" class="pm-btn ghost" style="padding:10px 20px;">Cancel</button>
            <a href="#" id="delLink" class="pm-btn" style="background:#dc2626;color:#fff;padding:10px 20px;text-decoration:none;border-radius:8px;font-size:.82rem;font-weight:600;">
                <i class="fa-solid fa-trash-can"></i> Delete
            </a>
        </div>
    </div>
</div>

<%-- Bulk delete confirm --%>
<div id="bulkDelModal" class="mp-overlay" onclick="if(event.target===this)closeModal('bulkDelModal')">
    <div class="mp-modal" style="max-width:400px;text-align:center;">
        <div class="del-icon-wrap"><i class="fa-solid fa-triangle-exclamation" style="color:#f59e0b;font-size:1.3rem;"></i></div>
        <h3>Bulk Delete</h3>
        <p class="sub">Delete <strong id="bulkDelCount" style="color:#dc2626;"></strong> selected products?<br>This cannot be undone.</p>
        <div style="display:flex;gap:10px;justify-content:center;margin-top:4px;">
            <button onclick="closeModal('bulkDelModal')" class="pm-btn ghost" style="padding:10px 20px;">Cancel</button>
            <button onclick="execBulkDelete()" class="pm-btn" style="background:#dc2626;color:#fff;padding:10px 20px;border-radius:8px;font-size:.82rem;font-weight:600;">
                <i class="fa-solid fa-trash-can"></i> Delete All
            </button>
        </div>
    </div>
</div>

<%-- Quick Stock Modal --%>
<div id="qsModal" class="mp-overlay" onclick="if(event.target===this)closeModal('qsModal')">
    <div class="mp-modal">
        <div style="display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:16px;">
            <div>
                <h3 id="qsTitle">Quick Stock Update</h3>
                <p class="sub" id="qsSub">Adjust inventory for each variant</p>
            </div>
            <button onclick="closeModal('qsModal')" style="background:none;border:none;color:#9ca3af;cursor:pointer;font-size:1.1rem;padding:2px;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div id="qsBody" style="max-height:380px;overflow-y:auto;margin:0 -32px;padding:0 32px;">
            <div style="text-align:center;padding:28px;color:#9ca3af;font-size:.85rem;">
                <i class="fa-solid fa-spinner fa-spin" style="font-size:1.4rem;margin-bottom:8px;display:block;"></i>Loading variants...
            </div>
        </div>
        <div style="display:flex;gap:10px;justify-content:flex-end;padding-top:18px;border-top:1px solid #f1f5f9;margin-top:16px;">
            <button onclick="closeModal('qsModal')" class="pm-btn ghost" style="padding:9px 18px;">Close</button>
            <button onclick="saveAllStock()" id="qsSaveBtn" class="pm-btn primary" style="padding:9px 18px;">
                <i class="fa-solid fa-floppy-disk"></i> Save All
            </button>
        </div>
    </div>
</div>

<%-- Lightbox --%>
<div id="lightbox" class="mp-overlay" onclick="this.classList.remove('open')">
    <img id="lbImg" src="" alt="">
</div>

<%-- Toast --%>
<div id="mp-toast"><i id="toastIco"></i><span id="toastMsg"></span></div>

<%-- ══════════════════════ SCRIPT ══════════════════════ --%>
<script>
const CTX  = '${pageContext.request.contextPath}';
const SORT = '${param.sort}';
const DIR  = '${param.dir}';
const SEARCH = encodeURIComponent('${fn:escapeXml(param.searchName)}');
const STATUS_F = '${param.statusFilter}';
const PS = '${not empty param.ps ? param.ps : 15}';

/* ── Toast ── */
let _tt;
function toast(msg, type='ok') {
    const el = document.getElementById('mp-toast');
    const ic = document.getElementById('toastIco');
    document.getElementById('toastMsg').textContent = msg;
    el.className = type;
    ic.className = type==='ok' ? 'fa-solid fa-circle-check' : type==='war' ? 'fa-solid fa-triangle-exclamation' : 'fa-solid fa-circle-xmark';
    el.style.display = 'flex';
    clearTimeout(_tt);
    _tt = setTimeout(() => el.style.display='none', 4500);
}

/* ── Auto flash from redirect (insert/update success) ── */
(function() {
    const urlP = new URLSearchParams(window.location.search);
    const flash = urlP.get('flash');
    const pname = urlP.get('pname') ? decodeURIComponent(urlP.get('pname')) : '';
    if (flash === 'created') {
        toast('✓ Sản phẩm "' + (pname || 'mới') + '" đã được tạo thành công!');
    } else if (flash === 'updated') {
        toast('✓ Sản phẩm "' + (pname || '') + '" đã được cập nhật thành công!');
    }
    /* Clean flash params from URL without reload */
    if (flash) {
        const clean = new URL(window.location.href);
        clean.searchParams.delete('flash');
        clean.searchParams.delete('pname');
        window.history.replaceState({}, '', clean.toString());
    }
})();

/* ── Modal helpers ── */
function openModal(id) { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
        ['delModal','bulkDelModal','qsModal','lightbox'].forEach(id => {
            const el = document.getElementById(id); if(el) el.classList.remove('open');
        });
    }
});

/* ── Lightbox ── */
function showLightbox(url) {
    if (!url || url.includes('placehold.co')) return;
    document.getElementById('lbImg').src = url;
    openModal('lightbox');
}

/* ── Search & Filter ── */
let _lsTimeout;
function liveSearch(v) {
    clearTimeout(_lsTimeout);
    _lsTimeout = setTimeout(() => {
        doSearch();
    }, 600);
}

function doSearch() {
    submitFilters('search');
}

function clearAllFilters() {
    window.location.href = CTX + '/product?action=manage';
}

function changePageSize(val) {
    var url = new URL(window.location.href);
    url.searchParams.set('ps', val);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

/* ── Sort ── */
function sortBy(col) {
    const d = (SORT === col && DIR === 'asc') ? 'desc' : 'asc';
    var url = new URL(window.location.href);
    url.searchParams.set('sort', col);
    url.searchParams.set('dir', d);
    window.location.href = url.toString();
}

/* ── Quick Price Edit ── */
function startEditPrice(pid, oldVal) {
    const wrap = document.getElementById('pw-' + pid);
    if (wrap.dataset.editing === 'true') return;
    wrap.dataset.editing = 'true';
    
    const currentDisplay = wrap.innerHTML;
    wrap.innerHTML = `<input type="number" class="price-input" id="pi-${pid}" value="${oldVal}" step="1000" min="0">`;
    const input = document.getElementById('pi-' + pid);
    input.focus();
    input.select();

    const save = () => {
        const newVal = input.value;
        if (newVal === String(oldVal)) {
            wrap.dataset.editing = 'false';
            wrap.innerHTML = currentDisplay;
            return;
        }
        
        input.disabled = true;
        fetch(CTX + '/product', {
            method:'POST',
            headers:{'Content-Type':'application/x-www-form-urlencoded'},
            body:`action=quick_price&id=${pid}&price=${newVal}`
        })
        .then(r => r.json())
        .then(res => {
            if (res.success) {
                toast('Price updated successfully');
                // Format currency locally for immediate feedback
                const formatted = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(newVal).replace('₫', 'đ');
                wrap.dataset.editing = 'false';
                wrap.innerHTML = `<span class="price-val" style="font-weight:700;font-size:.9rem;color:var(--color-primary);">${formatted}</span><i class="fa-solid fa-pencil price-edit-btn"></i>`;
                // Update onclick with new val
                wrap.setAttribute('onclick', `startEditPrice(${pid}, ${newVal})`);
            } else {
                toast(res.message || 'Update failed', 'err');
                wrap.dataset.editing = 'false';
                wrap.innerHTML = currentDisplay;
            }
        })
        .catch(() => {
            toast('Network error', 'err');
            wrap.dataset.editing = 'false';
            wrap.innerHTML = currentDisplay;
        });
    };

    input.onkeydown = (e) => {
        if (e.key === 'Enter') save();
        if (e.key === 'Escape') {
            wrap.dataset.editing = 'false';
            wrap.innerHTML = currentDisplay;
        }
    };
    input.onblur = save;
}

/* ── Delete ── */
function openDeleteModal(pid, name) {
    document.getElementById('delName').textContent = name;
    document.getElementById('delLink').href = CTX + '/product?action=delete&id=' + pid;
    openModal('delModal');
}

/* ── Status toggle ── */
function doToggleStatus(pid, cb) {
    fetch(CTX + '/product', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'action=toggle_status&id=' + pid
    })
    .then(r => r.json())
    .then(res => {
        if (res.success) {
            const on = cb.checked;
            document.getElementById('tr-' + pid).style.background = on ? '#10b981' : '#d1d5db';
            document.getElementById('th-' + pid).style.transform  = on ? 'translateX(18px)' : 'translateX(0)';
            toast(on ? 'Product activated.' : 'Product hidden from store.');
        } else {
            cb.checked = !cb.checked;
            toast('Toggle failed: ' + (res.message || 'Unknown error'), 'err');
        }
    })
    .catch(() => { cb.checked = !cb.checked; toast('Network error', 'err'); });
}

/* ── Bulk selection ── */
function toggleAll(src) {
    document.querySelectorAll('.row-chk').forEach(c => c.checked = src.checked);
    updateSelCount();
}
function updateSelCount() {
    const n = document.querySelectorAll('.row-chk:checked').length;
    document.getElementById('selCount').textContent = n;
    
    const bb = document.getElementById('bulkBar');
    const tb = document.getElementById('defaultToolbar');
    bb.className = 'bulk-bar' + (n > 0 ? ' show' : '');
    tb.style.display = (n > 0 ? 'none' : 'flex');
    
    if (!n) document.getElementById('chkAll').checked = false;
}
function clearSelection() {
    document.querySelectorAll('.row-chk, #chkAll').forEach(c => c.checked = false);
    updateSelCount();
}
function getSelectedIds() {
    return [...document.querySelectorAll('.row-chk:checked')].map(c => c.value);
}

function bulkAction(type) {
    const ids = getSelectedIds();
    if (!ids.length) return;
    if (type === 'delete') {
        document.getElementById('bulkDelCount').textContent = ids.length;
        openModal('bulkDelModal');
    } else {
        const targetStatus = (type === 'activate') ? 1 : 0;
        Promise.all(ids.map(id => fetch(CTX + '/product', {
            method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
            body: 'action=toggle_status&id=' + id
        }).then(r=>r.json())))
        .then(results => {
            const ok = results.filter(r => r.success).length;
            toast(`Updated ${ok}/${ids.length} product(s).`, ok===ids.length ? 'ok' : 'war');
            setTimeout(() => location.reload(), 900);
        }).catch(() => toast('Some updates failed.', 'err'));
    }
}

function execBulkDelete() {
    const ids = getSelectedIds();
    closeModal('bulkDelModal');
    // Sequential delete via redirect per product (simple approach via server-side)
    // For production: create a bulk-delete endpoint. Here we chain them:
    const deleteNext = (i) => {
        if (i >= ids.length) { toast(`Deleted ${ids.length} product(s).`); setTimeout(() => location.reload(), 900); return; }
        fetch(CTX + '/product?action=delete&id=' + ids[i])
            .then(() => deleteNext(i + 1))
            .catch(() => { toast('Delete failed for ID ' + ids[i], 'err'); deleteNext(i + 1); });
    };
    deleteNext(0);
}

/* ── Export CSV (current table data) ── */
function exportCSV() {
    const rows = [['ID','Name','Category','Price','Stock','Status']];
    document.querySelectorAll('#prodTable tbody tr[data-pid]').forEach(tr => {
        const cells = tr.querySelectorAll('td');
        if (!cells.length) return;
        const pid   = tr.dataset.pid;
        const name  = cells[1].querySelector('div>div')?.textContent?.trim() || '';
        const cat   = cells[1].querySelector('.\\#' + pid + '~span')?.textContent?.trim() || '';
        const price = cells[2].textContent.trim();
        const stock = cells[3].textContent.trim();
        const status= cells[4].querySelector('.status-badge')?.textContent?.trim() || '';
        rows.push([pid, '"'+name.replace(/"/g,'""')+'"', '"'+cat.replace(/"/g,'""')+'"', price, stock, status]);
    });
    const csv = rows.map(r=>r.join(',')).join('\n');
    const a = document.createElement('a');
    a.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
    a.download = 'products_page_${currentPage}.csv';
    a.click();
}

/* ══════════════════════════════════
   QUICK STOCK MODAL
══════════════════════════════════ */
let _qsIds = [];

function openQuickStock(pid, name) {
    _qsIds = [];
    document.getElementById('qsTitle').textContent = name;
    document.getElementById('qsSub').textContent = 'Loading variants...';
    document.getElementById('qsBody').innerHTML = '<div style="text-align:center;padding:28px;color:#9ca3af;"><i class="fa-solid fa-spinner fa-spin" style="font-size:1.4rem;display:block;margin-bottom:8px;"></i>Loading...</div>';
    openModal('qsModal');

    fetch(CTX + '/product?action=quickview&id=' + pid)
        .then(r => r.json())
        .then(data => {
            if (data.error) {
                document.getElementById('qsBody').innerHTML = '<p style="color:#dc2626;text-align:center;padding:20px;">' + data.error + '</p>';
                return;
            }
            _qsIds = (data.colorSizes || []).map(c => c.productColorSizeId);
            document.getElementById('qsSub').textContent = (data.colorSizes?.length || 0) + ' variant(s) — ID #' + data.productId;
            renderQsBody(data.colorSizes || []);
        })
        .catch(err => {
            document.getElementById('qsBody').innerHTML = '<p style="color:#dc2626;text-align:center;padding:20px;">Failed to load. Please try again.</p>';
            console.error(err);
        });
}

// Color → CSS color mapping for dots
function colorToCss(colorName) {
    const map = {
        'red':'#ef4444','blue':'#3b82f6','green':'#22c55e','black':'#111827',
        'white':'#f9fafb','yellow':'#eab308','pink':'#ec4899','purple':'#a855f7',
        'orange':'#f97316','gray':'#9ca3af','grey':'#9ca3af','brown':'#92400e',
        'navy':'#1e3a5f','beige':'#d2b48c','cream':'#fffdd0'
    };
    return map[colorName?.toLowerCase()] || '#d1d5db';
}

function renderQsBody(colorSizes) {
    if (!colorSizes.length) {
        document.getElementById('qsBody').innerHTML = '<p style="text-align:center;color:#9ca3af;padding:24px;">No variants for this product.</p>';
        return;
    }
    let html = '';
    colorSizes.forEach(cs => {
        const cls = cs.stock === 0 ? 'zero' : cs.stock <= 5 ? 'warn' : 'ok';
        const dot = colorToCss(cs.color);
        html += '<div class="qs-row">' +
            '<span class="qs-color-dot" style="background:' + dot + ';"></span>' +
            '<div class="qs-label">' +
                '<div class="cc">' + cs.color + '</div>' +
                '<div class="sz">Size: ' + cs.size + '</div>' +
            '</div>' +
            '<div class="qs-curr"><span class="stk ' + cls + '">' + cs.stock + '</span></div>' +
            '<div style="color:#9ca3af;font-size:.75rem;padding:0 8px;">→</div>' +
            '<input type="number" class="qs-input" id="qsi-' + cs.productColorSizeId + '" ' +
                   'value="' + cs.stock + '" min="0" max="99999" ' +
                   'title="New stock for ' + cs.color + ' / ' + cs.size + '">' +
        '</div>';
    });
    document.getElementById('qsBody').innerHTML = html;
}

function saveAllStock() {
    if (!_qsIds.length) return;
    const btn = document.getElementById('qsSaveBtn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Saving...';

    const promises = _qsIds.map(id => {
        const inp = document.getElementById('qsi-' + id);
        const stock = inp ? parseInt(inp.value, 10) : 0;
        return fetch(CTX + '/product', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'action=quick_stock&pcsId=' + id + '&stock=' + (isNaN(stock) ? 0 : stock)
        }).then(r => r.json());
    });

    Promise.all(promises)
        .then(results => {
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Save All';
            const failed = results.filter(r => !r.success).length;
            if (failed === 0) {
                toast('Stock updated for all ' + _qsIds.length + ' variant(s)!');
                closeModal('qsModal');
                setTimeout(() => location.reload(), 700);
            } else {
                toast(failed + ' variant(s) failed to save.', 'war');
            }
        })
        .catch(() => {
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Save All';
            toast('Network error. Please try again.', 'err');
        });
}
/* ================= ADVANCED FILTER CASCADE logic ================= */
var filterGenderSel = document.getElementById('genderFilter');
var filterParentSel = document.getElementById('parentCatFilter');
var filterSubSel = document.getElementById('subCatFilter');

function escapeXml(unsafe) {
    if (!unsafe) return "";
    return unsafe.replace(/[<>&'"]/g, function (c) {
        switch (c) {
            case '<': return '&lt;'; case '>': return '&gt;';
            case '&': return '&amp;'; case '\'': return '&apos;';
            case '"': return '&quot;';
        }
    });
}

function cascadeManageGender() {
    filterParentSel.innerHTML = '<option value="">Any Parent Category</option>';
    filterSubSel.innerHTML = '<option value="">Any Sub Category</option>';
    var gid = filterGenderSel.value;
    if (!gid) return;
    
    // Group parent categories from data source
    var addedParents = new Set();
    document.querySelectorAll('#categoryDataSource option').forEach(function(o) {
        if (o.dataset.genderId === gid && (!o.dataset.parentId || o.dataset.parentId === '0' || o.dataset.parentId === 'null' || o.dataset.parentId === '')) {
            var idx = o.dataset.indexName;
            if (!addedParents.has(idx)) {
                addedParents.add(idx);
                var opt = document.createElement('option');
                opt.value = idx;
                opt.textContent = escapeXml(o.textContent);
                filterParentSel.appendChild(opt);
            }
        }
    });
}

function cascadeManageParent() {
    filterSubSel.innerHTML = '<option value="">Any Sub Category</option>';
    var gid = filterGenderSel.value;
    var pidx = filterParentSel.value;
    if (!gid || !pidx) return;
    
    document.querySelectorAll('#categoryDataSource option').forEach(function(o) {
        if (o.dataset.genderId === gid && o.dataset.parentId === pidx) {
            var opt = document.createElement('option');
            opt.value = o.value;
            opt.textContent = escapeXml(o.textContent);
            filterSubSel.appendChild(opt);
        }
    });
}

function submitFilters(changedLevel) {
    if (changedLevel === 'gender') {
        filterParentSel.value = '';
        filterSubSel.value = '';
    } else if (changedLevel === 'parent') {
        filterSubSel.value = '';
    }
    
    var url = new URL(window.location.href);
    url.searchParams.set('page', '1');
    
    // search
    var searchVal = document.getElementById('pmSearch').value.trim();
    if (searchVal) url.searchParams.set('searchName', searchVal);
    else url.searchParams.delete('searchName');
    
    // gender
    var gid = document.getElementById('genderFilter') ? document.getElementById('genderFilter').value : '';
    if (gid) url.searchParams.set('genderId', gid);
    else url.searchParams.delete('genderId');
    
    // parent
    var pid = document.getElementById('parentCatFilter') ? document.getElementById('parentCatFilter').value : '';
    if (pid) url.searchParams.set('parentCategory', pid);
    else url.searchParams.delete('parentCategory');
    
    // sub
    var sid = document.getElementById('subCatFilter') ? document.getElementById('subCatFilter').value : '';
    if (sid) url.searchParams.set('subCategoryId', sid);
    else url.searchParams.delete('subCategoryId');
    
    // status 
    var statusVal = document.getElementById('statusFilter') ? document.getElementById('statusFilter').value : '';
    if (statusVal) url.searchParams.set('statusFilter', statusVal);
    else url.searchParams.delete('statusFilter');
    
    // submit
    window.location.href = url.toString();
}

document.addEventListener('DOMContentLoaded', function() {
    var urlParams = new URLSearchParams(window.location.search);
    var initGid = urlParams.get('genderId');
    var initPcat = urlParams.get('parentCategory');
    var initSub = urlParams.get('subCategoryId');
    
    if (initGid) {
        cascadeManageGender();
        if (initPcat) {
            filterParentSel.value = initPcat;
            cascadeManageParent();
            if (initSub) {
                filterSubSel.value = initSub;
            }
        }
    }
});
</script>

<%-- HIDDEN CATEGORY DATA SOURCE FOR JS --%>
<select id="categoryDataSource" style="display:none;">
    <c:forEach var="c" items="${allCategories}">
        <option value="${c.categoryid}"
                data-gender-id="${c.genderid}"
                data-parent-id="${c.parentid}"
                data-index-name="${c.indexName}">
            <c:out value="${c.name}"/>
        </option>
    </c:forEach>
</select>
</body>
</html>
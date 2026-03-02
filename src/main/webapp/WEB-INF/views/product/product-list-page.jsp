<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <fmt:setLocale value="vi_VN" />
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8" />
                    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                    <title>AISTHÉA - Collection</title>

                    <!-- Fonts -->
                    <link href="https://fonts.googleapis.com" rel="preconnect" />
                    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600;700&amp;family=Playfair+Display:wght@400;600;700&amp;display=swap"
                        rel="stylesheet" />
                    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                        rel="stylesheet" />

                    <!-- Font Awesome (for header icons) -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

                    <!-- Tailwind -->
                    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                    <script id="tailwind-config">
                        tailwind.config = {
                            darkMode: "class",
                            theme: {
                                extend: {
                                    colors: {
                                        "primary": "#024acf",
                                        "primary-light": "#0288D1",
                                        "sky-pale": "#E1F5FE",
                                        "background-light": "#ffffff",
                                        "background-dark": "#0f1623",
                                    },
                                    fontFamily: {
                                        "display": ["Manrope", "sans-serif"],
                                        "serif": ["Playfair Display", "serif"]
                                    },
                                    borderRadius: { "DEFAULT": "0.5rem", "lg": "1rem", "xl": "1.5rem", "full": "9999px" },
                                    boxShadow: {
                                        'glass': '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
                                        'glow': '0 0 15px rgba(2, 74, 207, 0.2)',
                                        'lift': '0 20px 40px -10px rgba(2, 136, 209, 0.15)',
                                    }
                                },
                            },
                        }
                    </script>
                    <style>
                        .glass-panel {
                            background: rgba(255, 255, 255, 0.7);
                            -webkit-backdrop-filter: blur(12px);
                            backdrop-filter: blur(12px);
                            border: 1px solid rgba(255, 255, 255, 0.5);
                        }

                        .glass-sidebar {
                            background: rgba(255, 255, 255, 0.4);
                            -webkit-backdrop-filter: blur(24px);
                            backdrop-filter: blur(24px);
                            border: 1px solid rgba(2, 74, 207, 0.1);
                            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
                        }

                        .scrollbar-hide::-webkit-scrollbar {
                            display: none;
                        }

                        .scrollbar-hide {
                            -ms-overflow-style: none;
                            scrollbar-width: none;
                        }

                        input[type=range] {
                            -webkit-appearance: none;
                            appearance: none;
                            background: transparent;
                        }

                        input[type=range]::-webkit-slider-thumb {
                            -webkit-appearance: none;
                            appearance: none;
                            height: 16px;
                            width: 16px;
                            border-radius: 50%;
                            background: #024acf;
                            cursor: pointer;
                            margin-top: -6px;
                            box-shadow: 0 0 0 4px rgba(2, 74, 207, 0.1);
                        }

                        input[type=range]::-webkit-slider-runnable-track {
                            width: 100%;
                            height: 4px;
                            cursor: pointer;
                            background: #e2e8f0;
                            border-radius: 2px;
                        }

                        .active-swatch {
                            box-shadow: 0 0 0 2px white, 0 0 0 4px #024acf;
                        }

                        /* Header icon styles (from main_layout, scoped to avoid conflicts) */
                        .right {
                            display: flex;
                            align-items: center;
                            gap: 18px;
                        }

                        .icon-btn {
                            font-size: 20px;
                            color: #64748b;
                            cursor: pointer;
                            padding: 8px;
                            border-radius: 8px;
                            text-decoration: none;
                            transition: color 0.2s, transform 0.2s;
                        }

                        .icon-btn:hover {
                            color: #024acf;
                            transform: translateY(-2px);
                        }

                        /* ===== CART ICON BUTTON (Soft Square) ===== */
                        .cart-icon-btn {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            width: 52px;
                            height: 52px;
                            border-radius: 10px;
                            border: none;
                            background: transparent;
                            color: #1e293b;
                            text-decoration: none;
                            transition: background 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
                            cursor: pointer;
                            flex-shrink: 0;
                        }

                        .cart-icon-btn svg {
                            width: 1.6rem;
                            height: 1.6rem;
                            display: block;
                            transition: transform 0.3s ease;
                        }

                        .cart-icon-btn:hover {
                            background: #0f172a;
                            color: #ffffff;
                            border-color: #0f172a;
                            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.25);
                        }

                        .cart-icon-btn:hover svg {
                            transform: scale(1.12);
                        }

                        /* ===== COLOR SWATCHES ===== */
                        .color-swatch {
                            width: 15px;
                            height: 15px;
                            border-radius: 50%;
                            border: 1.5px solid rgba(0, 0, 0, 0.18);
                            padding: 0;
                            cursor: pointer;
                            transition: transform 0.18s ease, outline 0.18s ease;
                            flex-shrink: 0;
                            outline: 2px solid transparent;
                            outline-offset: 2px;
                            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.15);
                        }

                        .color-swatch:hover {
                            transform: scale(1.3);
                        }

                        .color-swatch.swatch-active {
                            outline: 2px solid #024acf;
                            outline-offset: 2px;
                            transform: scale(1.15);
                        }
                    </style>
                </head>

                <body
                    class="font-display text-slate-800 bg-gradient-to-b from-white to-sky-pale min-h-screen dark:from-background-dark dark:to-slate-900 dark:text-slate-100">

                    <!-- Header (product-list specific) -->
                    <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                    <form id="filterForm" action="${pageContext.request.contextPath}/product" method="get">
                        <%-- Hidden inputs to preserve URL-path context (categoryIndex + genderid) during filter form
                            submissions --%>
                            <c:if test="${not empty param.categoryIndex}">
                                <input type="hidden" name="categoryIndex" value="${param.categoryIndex}" />
                            </c:if>
                            <c:if test="${not empty param.genderid}">
                                <input type="hidden" name="genderid" value="${param.genderid}" />
                            </c:if>
                            <div class="max-w-[1600px] mx-auto px-4 md:px-8 mt-6">
                                <nav aria-label="Breadcrumb"
                                    class="text-xs font-medium text-primary-light/70 uppercase tracking-widest">
                                    <ol class="list-none p-0 inline-flex">
                                        <li class="flex items-center">
                                            <a class="hover:text-primary transition-colors"
                                                href="${pageContext.request.contextPath}/">Home</a>
                                            <span class="mx-2">/</span>
                                        </li>
                                        <c:if test="${not empty genderLabel}">
                                            <li class="flex items-center">
                                                <a class="hover:text-primary transition-colors"
                                                    href="${pageContext.request.contextPath}/product">${genderLabel}</a>
                                                <span class="mx-2">/</span>
                                            </li>
                                        </c:if>
                                        <c:if test="${empty genderLabel}">
                                            <li class="flex items-center">
                                                <a class="hover:text-primary transition-colors"
                                                    href="${pageContext.request.contextPath}/product">Collection</a>
                                                <span class="mx-2">/</span>
                                            </li>
                                        </c:if>
                                        <li class="flex items-center text-primary font-bold"
                                            style="text-transform: uppercase;">
                                            <c:choose>
                                                <c:when test="${not empty displayCategory}">${displayCategory.name}
                                                </c:when>
                                                <c:when test="${not empty displayCategoryName}">${displayCategoryName}
                                                </c:when>
                                                <c:otherwise>All Products</c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ol>
                                </nav>
                            </div>

                            <main class="max-w-[1600px] mx-auto px-4 md:px-8 py-8">
                                <!-- Header & Active Filters -->
                                <div class="mb-12">
                                    <h1 class="font-serif text-5xl md:text-6xl text-slate-900 dark:text-white mb-6 tracking-tight uppercase"
                                        style="text-transform: uppercase;">
                                        <c:choose>
                                            <c:when test="${not empty displayCategory}">${displayCategory.name}</c:when>
                                            <c:when test="${not empty displayCategoryName}">${displayCategoryName}
                                            </c:when>
                                            <c:otherwise>SUMMER COLLECTION</c:otherwise>
                                        </c:choose>
                                    </h1>

                                    <%-- Active filter chips: only show for user-applied sidebar params, NOT for the
                                        base URL-path category. Price is only considered active when it's NOT the
                                        default max value (500000000). --%>
                                        <c:set var="priceIsActive"
                                            value="${not empty param.maxPrice and param.maxPrice != '500000000'}" />
                                        <c:set var="hasActiveFilters"
                                            value="${not empty param.categoryId or priceIsActive or not empty param.color or not empty param.size}" />
                                        <c:if test="${hasActiveFilters}">
                                            <div class="flex items-center flex-wrap gap-3">
                                                <span
                                                    class="text-sm font-medium text-slate-500 mr-2 uppercase tracking-wide">Active
                                                    Filters:</span>

                                                <%-- Category chip: only when user picked via sidebar
                                                    (param.categoryId), not URL path --%>
                                                    <c:if
                                                        test="${not empty param.categoryId and not empty displayCategory}">
                                                        <span
                                                            class="inline-flex items-center px-4 py-1.5 rounded-full text-xs font-medium bg-primary-light text-white shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                            ${displayCategory.name}
                                                            <button type="button" onclick="clearCategory()"
                                                                class="ml-2 hover:text-white/80 transition-colors">
                                                                <span
                                                                    class="material-icons-outlined text-[14px]">close</span>
                                                            </button>
                                                        </span>
                                                    </c:if>

                                                    <%-- Price chip: only show when price is NOT the default max --%>
                                                        <c:if test="${priceIsActive}">
                                                            <span
                                                                class="inline-flex items-center px-4 py-1.5 rounded-full text-xs font-medium bg-primary-light text-white shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                                Max:
                                                                <fmt:formatNumber value="${param.maxPrice}"
                                                                    type="number" groupingUsed="true" />₫
                                                                <button type="button" onclick="clearPrice()"
                                                                    class="ml-2 hover:text-white/80 transition-colors">
                                                                    <span
                                                                        class="material-icons-outlined text-[14px]">close</span>
                                                                </button>
                                                            </span>
                                                        </c:if>

                                                        <%-- Color chip --%>
                                                            <c:if test="${not empty param.color}">
                                                                <span
                                                                    class="inline-flex items-center px-4 py-1.5 rounded-full text-xs font-medium bg-primary-light text-white shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                                    Màu: ${param.color}
                                                                    <button type="button" onclick="clearColorFilter()"
                                                                        class="ml-2 hover:text-white/80 transition-colors">
                                                                        <span
                                                                            class="material-icons-outlined text-[14px]">close</span>
                                                                    </button>
                                                                </span>
                                                            </c:if>

                                                            <%-- Size chip --%>
                                                                <c:if test="${not empty param.size}">
                                                                    <span
                                                                        class="inline-flex items-center px-4 py-1.5 rounded-full text-xs font-medium bg-primary-light text-white shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                                        Size: ${param.size}
                                                                        <button type="button"
                                                                            onclick="clearSizeFilter()"
                                                                            class="ml-2 hover:text-white/80 transition-colors">
                                                                            <span
                                                                                class="material-icons-outlined text-[14px]">close</span>
                                                                        </button>
                                                                    </span>
                                                                </c:if>

                                                                <a href="${pageContext.request.contextPath}/product"
                                                                    class="text-xs text-slate-500 hover:text-primary underline ml-2 transition-colors">Xóa
                                                                    tất cả</a>
                                            </div>
                                        </c:if>
                                </div>

                                <div class="flex flex-col lg:flex-row gap-12">
                                    <!-- Sidebar -->
                                    <aside class="w-full lg:w-1/4 flex-shrink-0">
                                        <div
                                            class="sticky top-28 glass-sidebar rounded-xl p-6 lg:h-[calc(100vh-8rem)] overflow-y-auto scrollbar-hide">
                                            <div class="flex items-center justify-between mb-8">
                                                <h2 class="text-lg font-semibold tracking-wide">BỘ LỌC</h2>
                                            </div>
                                            <div class="space-y-8">
                                                <!-- Category Filter -->
                                                <div class="filter-section border-b border-primary/10 pb-6">
                                                    <button type="button"
                                                        class="accordion-btn flex items-center justify-between w-full group mb-4"
                                                        onclick="toggleAccordion(this)">
                                                        <span
                                                            class="font-medium text-slate-800 dark:text-slate-200">Danh
                                                            mục sản phẩm</span>
                                                        <span
                                                            class="material-icons-outlined text-slate-400 group-hover:text-primary transition-colors">expand_less</span>
                                                    </button>
                                                    <div class="accordion-content space-y-4 pl-1">

                                                        <!-- Nam (Male) -->
                                                        <div>
                                                            <span
                                                                class="text-xs font-bold uppercase tracking-wider text-primary mb-2 block">Nam</span>
                                                            <div class="space-y-1 pl-2">
                                                                <c:forEach items="${parentCategoriesMale}" var="parent">
                                                                    <div class="category-parent-group">
                                                                        <div class="flex items-center justify-between">
                                                                            <label
                                                                                class="flex items-center space-x-3 cursor-pointer group flex-1">
                                                                                <input type="radio" name="categoryId"
                                                                                    value="${parent.categoryid}"
                                                                                    data-genderid="1"
                                                                                    onchange="handleCategoryChange(this)"
                                                                                    class="form-radio h-4 w-4 text-primary rounded-full border-slate-300 focus:ring-primary/50 bg-white/50"
                                                                                    ${param.categoryId==parent.categoryid
                                                                                    ? 'checked' : '' } />
                                                                                <span
                                                                                    class="text-sm font-semibold text-slate-700 group-hover:text-primary transition-colors dark:text-slate-300">${parent.name}</span>
                                                                            </label>
                                                                            <button type="button"
                                                                                onclick="toggleChildren(this)"
                                                                                class="text-slate-400 hover:text-primary transition-colors p-1">
                                                                                <span
                                                                                    class="material-icons-outlined text-[16px]">expand_more</span>
                                                                            </button>
                                                                        </div>
                                                                        <div
                                                                            class="children-list hidden space-y-1 pl-5 mt-1 border-l-2 border-primary/10">
                                                                            <c:forEach items="${categories}"
                                                                                var="child">
                                                                                <c:if
                                                                                    test="${child.genderid == 1 and not empty child.parentid and child.parentid == parent.indexName}">
                                                                                    <label
                                                                                        class="flex items-center space-x-3 cursor-pointer group">
                                                                                        <input type="radio"
                                                                                            name="categoryId"
                                                                                            value="${child.categoryid}"
                                                                                            data-genderid="1"
                                                                                            onchange="handleCategoryChange(this)"
                                                                                            class="form-radio h-3.5 w-3.5 text-primary rounded-full border-slate-300 focus:ring-primary/50 bg-white/50"
                                                                                            ${param.categoryId==child.categoryid
                                                                                            ? 'checked' : '' } />
                                                                                        <span
                                                                                            class="text-sm text-slate-500 group-hover:text-primary transition-colors dark:text-slate-400">${child.name}</span>
                                                                                    </label>
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </div>

                                                        <!-- Nữ (Female) -->
                                                        <div class="mt-2">
                                                            <span
                                                                class="text-xs font-bold uppercase tracking-wider text-primary mb-2 block">Nữ</span>
                                                            <div class="space-y-1 pl-2">
                                                                <c:forEach items="${parentCategoriesFemale}"
                                                                    var="parent">
                                                                    <div class="category-parent-group">
                                                                        <div class="flex items-center justify-between">
                                                                            <label
                                                                                class="flex items-center space-x-3 cursor-pointer group flex-1">
                                                                                <input type="radio" name="categoryId"
                                                                                    value="${parent.categoryid}"
                                                                                    data-genderid="2"
                                                                                    onchange="handleCategoryChange(this)"
                                                                                    class="form-radio h-4 w-4 text-primary rounded-full border-slate-300 focus:ring-primary/50 bg-white/50"
                                                                                    ${param.categoryId==parent.categoryid
                                                                                    ? 'checked' : '' } />
                                                                                <span
                                                                                    class="text-sm font-semibold text-slate-700 group-hover:text-primary transition-colors dark:text-slate-300">${parent.name}</span>
                                                                            </label>
                                                                            <button type="button"
                                                                                onclick="toggleChildren(this)"
                                                                                class="text-slate-400 hover:text-primary transition-colors p-1">
                                                                                <span
                                                                                    class="material-icons-outlined text-[16px]">expand_more</span>
                                                                            </button>
                                                                        </div>
                                                                        <div
                                                                            class="children-list hidden space-y-1 pl-5 mt-1 border-l-2 border-primary/10">
                                                                            <c:forEach items="${categories}"
                                                                                var="child">
                                                                                <c:if
                                                                                    test="${child.genderid == 2 and not empty child.parentid and child.parentid == parent.indexName}">
                                                                                    <label
                                                                                        class="flex items-center space-x-3 cursor-pointer group">
                                                                                        <input type="radio"
                                                                                            name="categoryId"
                                                                                            value="${child.categoryid}"
                                                                                            data-genderid="2"
                                                                                            onchange="handleCategoryChange(this)"
                                                                                            class="form-radio h-3.5 w-3.5 text-primary rounded-full border-slate-300 focus:ring-primary/50 bg-white/50"
                                                                                            ${param.categoryId==child.categoryid
                                                                                            ? 'checked' : '' } />
                                                                                        <span
                                                                                            class="text-sm text-slate-500 group-hover:text-primary transition-colors dark:text-slate-400">${child.name}</span>
                                                                                    </label>
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>

                                                <!-- Price Filter -->
                                                <div class="filter-section border-b border-primary/10 pb-6">
                                                    <button type="button"
                                                        class="accordion-btn flex items-center justify-between w-full group mb-4"
                                                        onclick="toggleAccordion(this)">
                                                        <span
                                                            class="font-medium text-slate-800 dark:text-slate-200">Khoảng
                                                            giá</span>
                                                        <span
                                                            class="material-icons-outlined text-slate-400 group-hover:text-primary transition-colors">expand_less</span>
                                                    </button>
                                                    <div class="accordion-content px-1">
                                                        <input name="maxPrice" id="priceRangeInput"
                                                            class="w-full h-1 bg-slate-200 rounded-lg appearance-none cursor-pointer dark:bg-slate-700"
                                                            type="range" min="0" max="500000000" step="500000"
                                                            value="${not empty param.maxPrice ? param.maxPrice : 500000000}"
                                                            oninput="updatePriceLabel(this.value)"
                                                            onchange="this.form.submit()" />
                                                        <div
                                                            class="flex items-center justify-between mt-4 text-sm font-medium text-slate-600 dark:text-slate-400">
                                                            <span>0₫</span>
                                                            <span id="priceLabel" class="text-primary">
                                                                <c:choose>
                                                                    <c:when test="${not empty param.maxPrice}">
                                                                        <fmt:formatNumber value="${param.maxPrice}"
                                                                            type="number" groupingUsed="true" />₫
                                                                    </c:when>
                                                                    <c:otherwise>500.000.000₫</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Color Filter -->
                                                <div class="filter-section border-b border-primary/10 pb-6">
                                                    <button type="button"
                                                        class="accordion-btn flex items-center justify-between w-full group mb-4"
                                                        onclick="toggleAccordion(this)">
                                                        <span class="font-medium text-slate-800 dark:text-slate-200">Màu
                                                            sắc</span>
                                                        <span
                                                            class="material-icons-outlined text-slate-400 group-hover:text-primary transition-colors">expand_less</span>
                                                    </button>
                                                    <div class="accordion-content">
                                                        <!-- Hidden input to hold selected color -->
                                                        <input type="hidden" name="color" id="colorFilterInput"
                                                            value="${param.color}" />
                                                        <div class="flex flex-wrap gap-3">
                                                            <%-- data-color now sends Vietnamese color NAME to match DB
                                                                values --%>
                                                                <button type="button" data-color="đen"
                                                                    onclick="selectColorFilter(this)"
                                                                    class="color-swatch-btn w-8 h-8 rounded-full border-2 hover:scale-110 transition-all ${param.color == 'đen' ? 'ring-2 ring-primary ring-offset-2' : 'border-slate-200'}"
                                                                    style="background-color:#0f172a"
                                                                    title="Đen"></button>
                                                                <button type="button" data-color="trắng"
                                                                    onclick="selectColorFilter(this)"
                                                                    class="color-swatch-btn w-8 h-8 rounded-full border-2 hover:scale-110 transition-all shadow-sm ${param.color == 'trắng' ? 'ring-2 ring-primary ring-offset-2' : 'border-slate-300'}"
                                                                    style="background-color:#ffffff"
                                                                    title="Trắng"></button>
                                                                <button type="button" data-color="nâu"
                                                                    onclick="selectColorFilter(this)"
                                                                    class="color-swatch-btn w-8 h-8 rounded-full border-2 hover:scale-110 transition-all ${param.color == 'nâu' ? 'ring-2 ring-primary ring-offset-2' : 'border-slate-200'}"
                                                                    style="background-color:#B2967D"
                                                                    title="Nâu"></button>
                                                                <button type="button" data-color="xanh"
                                                                    onclick="selectColorFilter(this)"
                                                                    class="color-swatch-btn w-8 h-8 rounded-full border-2 hover:scale-110 transition-all ${param.color == 'xanh' ? 'ring-2 ring-primary ring-offset-2' : 'border-slate-200'}"
                                                                    style="background-color:#8FA3AD"
                                                                    title="Xanh"></button>
                                                                <button type="button" data-color="đỏ"
                                                                    onclick="selectColorFilter(this)"
                                                                    class="color-swatch-btn w-8 h-8 rounded-full border-2 hover:scale-110 transition-all ${param.color == 'đỏ' ? 'ring-2 ring-primary ring-offset-2' : 'border-slate-200'}"
                                                                    style="background-color:#C25E5E"
                                                                    title="Đỏ"></button>
                                                        </div>
                                                        <c:if test="${not empty param.color}">
                                                            <button type="button" onclick="clearColorFilter()"
                                                                class="mt-3 text-xs text-slate-400 hover:text-primary transition-colors underline">Bỏ
                                                                lọc màu</button>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <!-- Size Filter -->
                                                <div class="filter-section">
                                                    <button type="button"
                                                        class="accordion-btn flex items-center justify-between w-full group mb-4"
                                                        onclick="toggleAccordion(this)">
                                                        <span
                                                            class="font-medium text-slate-800 dark:text-slate-200">Kích
                                                            cỡ</span>
                                                        <span
                                                            class="material-icons-outlined text-slate-400 group-hover:text-primary transition-colors">expand_less</span>
                                                    </button>
                                                    <div class="accordion-content">
                                                        <!-- Hidden input to hold selected size -->
                                                        <input type="hidden" name="size" id="sizeFilterInput"
                                                            value="${param.size}" />
                                                        <div class="grid grid-cols-4 gap-2">
                                                            <c:forEach var="sz" items="XS,S,M,L,XL,XXL">
                                                                <button type="button" data-size="${sz}"
                                                                    onclick="selectSizeFilter(this)"
                                                                    class="size-btn h-10 rounded-lg border text-sm font-medium transition-colors ${param.size == sz ? 'border-primary bg-primary text-white shadow-glow' : 'border-slate-200 text-slate-700 hover:border-primary hover:text-primary bg-white/50 dark:bg-slate-800 dark:border-slate-700'} ">${sz}</button>
                                                            </c:forEach>
                                                        </div>
                                                        <c:if test="${not empty param.size}">
                                                            <button type="button" onclick="clearSizeFilter()"
                                                                class="mt-3 text-xs text-slate-400 hover:text-primary transition-colors underline">Bỏ
                                                                lọc size</button>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </aside>

                                    <!-- Product Grid -->
                                    <div class="w-full lg:w-3/4">
                                        <div class="flex items-center justify-between mb-8">
                                            <span class="text-sm text-slate-500 font-medium">Showing
                                                ${fn:length(productList) > 0 ? (currentPage - 1) * 12 + 1 : 0}
                                                -
                                                ${(currentPage - 1) * 12 + fn:length(productList)}
                                                of
                                                ${not empty totalRecords ? totalRecords : fn:length(productList)}
                                                results</span>
                                            <div class="flex items-center space-x-2">
                                                <span class="text-sm text-slate-500">Sort by:</span>
                                                <select name="sort" onchange="this.form.submit()"
                                                    class="text-sm font-medium border-none bg-transparent focus:ring-0 text-slate-800 cursor-pointer pl-1 dark:text-slate-200">
                                                    <option value="featured" ${param.sort=='featured' ? 'selected' : ''
                                                        }>
                                                        Featured</option>
                                                    <option value="price_asc" ${param.sort=='price_asc' ? 'selected'
                                                        : '' }>
                                                        Price: Low to High</option>
                                                    <option value="price_desc" ${param.sort=='price_desc' ? 'selected'
                                                        : '' }>
                                                        Price: High to Low</option>
                                                    <option value="newest" ${param.sort=='newest' ? 'selected' : '' }>
                                                        Newest
                                                    </option>
                                                </select>
                                            </div>
                                        </div>

                                        <!-- Products -->
                                        <c:choose>
                                            <c:when test="${not empty productList}">
                                                <div
                                                    class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-12 gap-x-8">
                                                    <c:forEach items="${productList}" var="p">
                                                        <div class="group cursor-pointer">
                                                            <div
                                                                class="relative w-full aspect-[3/4] rounded-lg overflow-hidden mb-4 bg-slate-100 shadow-sm group-hover:shadow-lift group-hover:-translate-y-2 transition-all duration-500 ease-out">
                                                                <a href="${pageContext.request.contextPath}/product?action=view&id=${p.productId}"
                                                                    class="block w-full h-full relative">
                                                                    <!-- Primary Image -->
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${not empty p.images and fn:length(p.images) > 0}">
                                                                            <img class="absolute inset-0 w-full h-full object-cover transition-opacity duration-500 group-hover:opacity-0"
                                                                                src="${p.images[0].imageUrl}"
                                                                                alt="${p.name}"
                                                                                onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/defaults/no-image.svg'" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div
                                                                                class="absolute inset-0 w-full h-full flex items-center justify-center bg-slate-100 text-slate-300">
                                                                                <span
                                                                                    class="material-icons-outlined text-6xl">image</span>
                                                                            </div>
                                                                        </c:otherwise>
                                                                    </c:choose>

                                                                    <!-- Hover Image -->
                                                                    <c:if
                                                                        test="${not empty p.images and fn:length(p.images) > 1}">
                                                                        <img class="absolute inset-0 w-full h-full object-cover opacity-0 transition-opacity duration-500 group-hover:opacity-100"
                                                                            src="${p.images[1].imageUrl}"
                                                                            alt="${p.name} Hover"
                                                                            onerror="this.onerror=null; this.style.display='none'" />
                                                                    </c:if>
                                                                </a>

                                                                <!-- Badges - Out of Stock -->
                                                                <c:if test="${p.totalStock <= 0}">
                                                                    <div
                                                                        class="absolute top-3 left-3 bg-red-500 text-white text-[10px] font-bold px-2 py-1 rounded uppercase tracking-wider z-10 pointer-events-none">
                                                                        Out of Stock</div>
                                                                </c:if>
                                                            </div>

                                                            <div class="space-y-1 px-1">
                                                                <h3
                                                                    class="text-[10px] text-slate-400 uppercase tracking-widest font-semibold">
                                                                    ${not empty p.brand ? p.brand : 'AISTHÉA'}
                                                                </h3>
                                                                <!-- Name + Cart icon row -->
                                                                <div class="flex items-start justify-between gap-2">
                                                                    <div class="flex-1 min-w-0">
                                                                        <h2
                                                                            class="text-base font-bold text-slate-900 group-hover:text-primary transition-colors dark:text-white leading-tight">
                                                                            <a
                                                                                href="${pageContext.request.contextPath}/product?action=view&id=${p.productId}">${p.name}</a>
                                                                        </h2>
                                                                        <div class="flex items-center mt-0.5">
                                                                            <span
                                                                                class="text-primary font-semibold text-sm">
                                                                                <c:choose>
                                                                                    <c:when test="${not empty p.price}">
                                                                                        <fmt:formatNumber
                                                                                            value="${p.price}"
                                                                                            type="number"
                                                                                            groupingUsed="true" />₫
                                                                                    </c:when>
                                                                                    <c:otherwise>0₫</c:otherwise>
                                                                                </c:choose>
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <!-- Cart Icon Button (right side) -->
                                                                    <a href="${pageContext.request.contextPath}/product?action=view&id=${p.productId}"
                                                                        title="Thêm vào giỏ hàng" class="cart-icon-btn"
                                                                        style="flex-shrink:0;">
                                                                        <svg xmlns="http://www.w3.org/2000/svg"
                                                                            viewBox="0 0 24 24" fill="none"
                                                                            stroke="currentColor" stroke-width="2"
                                                                            stroke-linecap="round"
                                                                            stroke-linejoin="round">
                                                                            <!-- Cart body -->
                                                                            <circle cx="9" cy="21" r="1" />
                                                                            <circle cx="20" cy="21" r="1" />
                                                                            <path
                                                                                d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6" />
                                                                            <!-- Plus sign -->
                                                                            <line x1="17" y1="9" x2="17" y2="13" />
                                                                            <line x1="15" y1="11" x2="19" y2="11" />
                                                                        </svg>
                                                                    </a>
                                                                </div>
                                                                <!-- Color Swatches -->
                                                                <div class="flex flex-wrap gap-1.5 pt-2"
                                                                    id="swatches-${p.productId}">
                                                                    <c:set var="seenColors" value="," />
                                                                    <c:forEach items="${p.colorSizes}" var="cs">
                                                                        <c:if
                                                                            test="${not empty cs.color and not fn:contains(seenColors, concat(',', concat(cs.color, ',')))}">
                                                                            <c:set var="seenColors"
                                                                                value="${seenColors}${cs.color}," />
                                                                            <c:set var="matchedImgUrl" value="" />
                                                                            <c:forEach items="${p.images}" var="img">
                                                                                <c:if
                                                                                    test="${empty matchedImgUrl and not empty img.color and img.color == cs.color}">
                                                                                    <c:set var="matchedImgUrl"
                                                                                        value="${img.imageUrl}" />
                                                                                </c:if>
                                                                            </c:forEach>
                                                                            <c:set var="imgUrlForSwatch"
                                                                                value="${not empty matchedImgUrl ? matchedImgUrl : (not empty p.images ? p.images[0].imageUrl : '')}" />
                                                                            <button type="button"
                                                                                onclick="changeProductImageWithHex(${p.productId}, '${imgUrlForSwatch}', this)"
                                                                                class="color-swatch"
                                                                                data-color-name="${cs.color}"
                                                                                title="${cs.color}">
                                                                            </button>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                    <!-- Fallback from images if no colorSizes -->
                                                                    <c:if test="${empty p.colorSizes}">
                                                                        <c:forEach items="${p.images}" var="img">
                                                                            <c:if test="${not empty img.color}">
                                                                                <button type="button"
                                                                                    onclick="changeProductImageWithHex(${p.productId}, '${img.imageUrl}', this)"
                                                                                    class="color-swatch"
                                                                                    data-color-name="${img.color}"
                                                                                    title="${img.color}">
                                                                                </button>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Empty State -->
                                                <div
                                                    class="text-center py-20 flex flex-col items-center justify-center">
                                                    <div
                                                        class="w-20 h-20 bg-slate-100 rounded-full flex items-center justify-center mb-6 text-slate-300">
                                                        <span
                                                            class="material-icons-outlined text-4xl">inventory_2</span>
                                                    </div>
                                                    <h3 class="text-xl font-serif text-slate-800 mb-2">No products found
                                                    </h3>
                                                    <p class="text-slate-500 max-w-md mx-auto mb-8">Try adjusting your
                                                        filters
                                                        or search criteria.</p>
                                                    <a href="${pageContext.request.contextPath}/product"
                                                        class="inline-flex items-center justify-center px-6 py-2.5 border border-transparent text-sm font-medium rounded-full shadow-sm text-white bg-primary hover:bg-primary-light transition-colors">
                                                        Clear Filters
                                                    </a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Pagination (Dynamic) -->
                                        <c:if test="${totalPages > 1}">
                                            <div class="mt-16 flex justify-center">
                                                <nav class="flex items-center space-x-2">
                                                    <!-- Prev -->
                                                    <button
                                                        onclick="changePage(${currentPage > 1 ? currentPage - 1 : 1})"
                                                        class="w-10 h-10 flex items-center justify-center rounded-full bg-white border border-slate-200 text-slate-500 hover:border-primary hover:text-primary transition-colors ${currentPage == 1 ? 'opacity-50 cursor-not-allowed' : ''}"
                                                        ${currentPage==1 ? 'disabled' : '' }>
                                                        <span
                                                            class="material-icons-outlined text-sm">chevron_left</span>
                                                    </button>

                                                    <!-- Page Numbers -->
                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <button onclick="changePage(${i})"
                                                            class="w-10 h-10 flex items-center justify-center rounded-full font-medium shadow-sm transition-colors ${currentPage == i ? 'bg-primary text-white shadow-glow' : 'bg-white border border-slate-200 text-slate-600 hover:border-primary hover:text-primary'}">
                                                            ${i}
                                                        </button>
                                                    </c:forEach>

                                                    <!-- Next -->
                                                    <button
                                                        onclick="changePage(${currentPage < totalPages ? currentPage + 1 : totalPages})"
                                                        class="w-10 h-10 flex items-center justify-center rounded-full bg-white border border-slate-200 text-slate-500 hover:border-primary hover:text-primary transition-colors ${currentPage == totalPages ? 'opacity-50 cursor-not-allowed' : ''}"
                                                        ${currentPage==totalPages ? 'disabled' : '' }>
                                                        <span
                                                            class="material-icons-outlined text-sm">chevron_right</span>
                                                    </button>
                                                </nav>
                                            </div>
                                            <script>
                                                function changePage(page) {
                                                    const url = new URL(window.location.href);
                                                    url.searchParams.set("page", page);
                                                    window.location.href = url.toString();
                                                }
                                            </script>
                                        </c:if>
                                    </div>
                                </div>
                            </main>
                    </form>

                    <!-- Global Luxury Footer -->
                    <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                    <!-- Quick View Modal -->
                    <div id="quickViewModal" class="relative z-[100] hidden" aria-labelledby="modal-title" role="dialog"
                        aria-modal="true">
                        <div class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity"></div>
                        <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
                            <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
                                <div
                                    class="relative transform overflow-hidden rounded-2xl bg-white text-left shadow-2xl transition-all sm:my-8 sm:w-full sm:max-w-4xl border border-white/50">

                                    <!-- Close Button -->
                                    <div class="absolute right-4 top-4 z-20">
                                        <button type="button" onclick="closeQuickView()"
                                            class="rounded-full bg-white/80 p-2 text-slate-400 hover:text-slate-500 hover:bg-white transition-colors">
                                            <span class="material-icons-outlined">close</span>
                                        </button>
                                    </div>

                                    <!-- Content with Loading State -->
                                    <div id="quickViewContent"
                                        class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4 min-h-[400px] flex items-center justify-center">
                                        <!-- Loading Spinner -->
                                        <div class="flex flex-col items-center">
                                            <div
                                                class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mb-4">
                                            </div>
                                            <p class="text-slate-400 text-sm tracking-wide">LOADING AISTHÉA...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Scripts -->
                    <script>
                        // ===== VIETNAMESE COLOR NAME → HEX MAPPING =====
                        const COLOR_MAP = {
                            // Đen / trắng / xám
                            'den': '#111111', 'đen': '#111111', 'black': '#111111',
                            'trang': '#FFFFFF', 'trắng': '#FFFFFF', 'white': '#FFFFFF',
                            'xam': '#9CA3AF', 'xám': '#9CA3AF', 'grey': '#9CA3AF', 'gray': '#9CA3AF',
                            'xam nhat': '#D1D5DB', 'xám nhạt': '#D1D5DB',
                            'xam dam': '#6B7280', 'xám đậm': '#6B7280',
                            // Đỏ
                            'do': '#EF4444', 'đỏ': '#EF4444', 'red': '#EF4444',
                            'do dam': '#B91C1C', 'đỏ đậm': '#B91C1C', 'dark red': '#B91C1C',
                            'do tuoi': '#F87171', 'đỏ tươi': '#F87171',
                            // Xanh lam
                            'xanh': '#3B82F6', 'blue': '#3B82F6',
                            'xanh lam': '#3B82F6', 'xanh dam': '#1D4ED8', 'xanh đậm': '#1D4ED8',
                            'xanh duong': '#2563EB', 'xanh dương': '#2563EB',
                            'xanh navy': '#1E3A5F', 'navy': '#1E3A5F',
                            'xanh nhat': '#93C5FD', 'xanh nhạt': '#93C5FD',
                            'xanh co': '#22D3EE', 'xanh cổ': '#22D3EE', 'cyan': '#22D3EE',
                            // Xanh lá
                            'xanh la': '#22C55E', 'xanh lá': '#22C55E', 'green': '#22C55E',
                            'xanh la dam': '#15803D', 'xanh lá đậm': '#15803D', 'dark green': '#15803D',
                            'xanh reu': '#84CC16', 'xanh rêu': '#718096', 'olive': '#718096',
                            'xanh mint': '#6EE7B7', 'mint': '#6EE7B7',
                            // Vàng / cam / nâu
                            'vang': '#EAB308', 'vàng': '#EAB308', 'yellow': '#EAB308',
                            'vang kem': '#FEF3C7', 'vàng kem': '#FEF3C7', 'cream': '#FEF3C7', 'kem': '#FEF9E7',
                            'vang nhat': '#FDE68A', 'vàng nhạt': '#FDE68A',
                            'cam': '#F97316', 'orange': '#F97316',
                            'cam dat': '#C2410C', 'cam đất': '#C2410C', 'terracotta': '#C2410C',
                            'nau': '#92400E', 'nâu': '#92400E', 'brown': '#92400E',
                            'nau nhat': '#D97706', 'nâu nhạt': '#D97706', 'tan': '#D2B48C',
                            'camel': '#C19A6B', 'be': '#C8A97E', 'bê': '#C8A97E', 'beige': '#F5F5DC',
                            'sua': '#FEFCE8', 'sữa': '#FEFCE8',
                            // Hồng / tím
                            'hong': '#EC4899', 'hồng': '#EC4899', 'pink': '#EC4899',
                            'hong nhat': '#FBCFE8', 'hồng nhạt': '#FBCFE8', 'light pink': '#FBCFE8',
                            'hong phan': '#F9A8D4', 'hồng phấn': '#F9A8D4',
                            'tim': '#8B5CF6', 'tím': '#8B5CF6', 'purple': '#8B5CF6',
                            'tim nhat': '#DDD6FE', 'tím nhạt': '#DDD6FE', 'lavender': '#E6E6FA',
                            // Khác
                            'vang dong': '#B45309', 'vàng đồng': '#B45309', 'gold': '#D4AF37',
                            'bac': '#C0C0C0', 'bạc': '#C0C0C0', 'silver': '#C0C0C0',
                        };

                        function getColorHex(name) {
                            if (!name) return '#CCCCCC';
                            const key = name.trim().toLowerCase();
                            // Direct match
                            if (COLOR_MAP[key]) return COLOR_MAP[key];
                            // Partial match (e.g. "xanh lam đậm" → "xanh dam")
                            for (const [k, v] of Object.entries(COLOR_MAP)) {
                                if (key.includes(k) || k.includes(key)) return v;
                            }
                            return '#CCCCCC'; // fallback: light gray
                        }

                        // Initialize all swatch backgrounds on page load
                        document.addEventListener('DOMContentLoaded', function () {
                            document.querySelectorAll('.color-swatch').forEach(function (btn) {
                                const name = btn.getAttribute('data-color-name');
                                btn.style.backgroundColor = getColorHex(name);
                            });
                        });

                        // New version of changeProductImage that also handles swatch highlight
                        function changeProductImageWithHex(productId, imageUrl, swatchBtn) {
                            if (!imageUrl) return;
                            const swatchContainer = document.querySelector('#swatches-' + productId);
                            if (!swatchContainer) return;
                            const productCard = swatchContainer.closest('.group');
                            if (!productCard) return;
                            const imgContainer = productCard.querySelector('.relative.w-full');
                            if (imgContainer) {
                                const imgs = imgContainer.querySelectorAll('img');
                                if (imgs.length > 0) {
                                    imgs[0].src = imageUrl;
                                    imgs[0].classList.remove('group-hover:opacity-0');
                                    if (imgs.length > 1) imgs[1].style.display = 'none';
                                }
                            }
                            // Toggle active class on swatches
                            swatchContainer.querySelectorAll('.color-swatch').forEach(function (s) {
                                s.classList.remove('swatch-active');
                            });
                            if (swatchBtn) {
                                swatchBtn.classList.add('swatch-active');
                            }
                        }

                        // ===== ACCORDION TOGGLE =====
                        function toggleAccordion(btn) {
                            const section = btn.closest('.filter-section');
                            const content = section.querySelector('.accordion-content');
                            const icon = btn.querySelector('.material-icons-outlined');

                            if (content.style.display === 'none' || content.classList.contains('accordion-collapsed')) {
                                content.style.display = '';
                                content.classList.remove('accordion-collapsed');
                                icon.textContent = 'expand_less';
                            } else {
                                content.style.display = 'none';
                                content.classList.add('accordion-collapsed');
                                icon.textContent = 'expand_more';
                            }
                        }

                        // Toggle child categories visibility
                        function toggleChildren(btn) {
                            const parentGroup = btn.closest('.category-parent-group');
                            const childrenList = parentGroup.querySelector('.children-list');
                            const icon = btn.querySelector('.material-icons-outlined');

                            if (childrenList.classList.contains('hidden')) {
                                childrenList.classList.remove('hidden');
                                icon.textContent = 'expand_less';
                            } else {
                                childrenList.classList.add('hidden');
                                icon.textContent = 'expand_more';
                            }
                        }

                        // Auto-expand parent groups that have a selected child
                        document.addEventListener('DOMContentLoaded', function () {
                            document.querySelectorAll('.children-list input[type="radio"]:checked').forEach(function (radio) {
                                const childrenList = radio.closest('.children-list');
                                if (childrenList) {
                                    childrenList.classList.remove('hidden');
                                    const parentGroup = childrenList.closest('.category-parent-group');
                                    if (parentGroup) {
                                        const icon = parentGroup.querySelector('button[onclick="toggleChildren(this)"] .material-icons-outlined');
                                        if (icon) icon.textContent = 'expand_less';
                                    }
                                }
                            });
                        });

                        // ===== PRICE FILTER =====
                        function updatePriceLabel(value) {
                            const formatted = new Intl.NumberFormat('vi-VN').format(value) + '\u20ab';
                            document.getElementById('priceLabel').textContent = formatted;
                        }

                        function clearPrice() {
                            const input = document.getElementById('priceRangeInput');
                            if (input) input.disabled = true;
                            document.getElementById('filterForm').submit();
                        }

                        // ===== CATEGORY CLEAR =====
                        function clearCategory() {
                            const radios = document.getElementsByName('categoryId');
                            for (let i = 0; i < radios.length; i++) radios[i].checked = false;
                            document.getElementById('filterForm').submit();
                        }

                        // ===== CATEGORY CHANGE (with gender conflict resolution) =====
                        function handleCategoryChange(radio) {
                            const selectedGender = parseInt(radio.getAttribute('data-genderid'));
                            const form = document.getElementById('filterForm');

                            // Get the current genderid hidden input (if any)
                            const genderInput = form.querySelector('input[name="genderid"]');
                            const categoryIndexInput = form.querySelector('input[name="categoryIndex"]');

                            if (genderInput) {
                                const currentGender = parseInt(genderInput.value);
                                // If gender conflicts, clear the old context (categoryIndex + genderid)
                                // so the controller uses only the new categoryId (which carries its own gender in DB)
                                if (currentGender !== selectedGender) {
                                    genderInput.remove();
                                    if (categoryIndexInput) categoryIndexInput.remove();
                                }
                            }

                            // Also reset price/color/size when switching gender context (fresh navigation)
                            const priceInput = form.querySelector('input[name="maxPrice"]');
                            const colorInput = form.querySelector('input[name="color"]');
                            const sizeInput = form.querySelector('input[name="size"]');
                            if (priceInput) priceInput.disabled = true;
                            if (colorInput) colorInput.value = '';
                            if (sizeInput) sizeInput.value = '';

                            form.submit();
                        }

                        // ===== COLOR FILTER =====
                        function selectColorFilter(btn) {
                            const selectedColor = btn.getAttribute('data-color');
                            const currentColor = document.getElementById('colorFilterInput').value;

                            // Toggle: click same color again to deselect
                            if (currentColor === selectedColor) {
                                document.getElementById('colorFilterInput').value = '';
                            } else {
                                document.getElementById('colorFilterInput').value = selectedColor;
                            }
                            document.getElementById('filterForm').submit();
                        }

                        function clearColorFilter() {
                            document.getElementById('colorFilterInput').value = '';
                            document.getElementById('filterForm').submit();
                        }

                        // ===== SIZE FILTER =====
                        function selectSizeFilter(btn) {
                            const selectedSize = btn.getAttribute('data-size');
                            const currentSize = document.getElementById('sizeFilterInput').value;

                            // Toggle: click same size again to deselect
                            if (currentSize === selectedSize) {
                                document.getElementById('sizeFilterInput').value = '';
                            } else {
                                document.getElementById('sizeFilterInput').value = selectedSize;
                            }
                            document.getElementById('filterForm').submit();
                        }

                        function clearSizeFilter() {
                            document.getElementById('sizeFilterInput').value = '';
                            document.getElementById('filterForm').submit();
                        }

                        // ===== QUICK VIEW =====
                        function quickView(productId) {
                            const modal = document.getElementById('quickViewModal');
                            const content = document.getElementById('quickViewContent');
                            modal.classList.remove('hidden');
                            content.innerHTML = '<div class="flex flex-col items-center"><div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mb-4"></div><p class="text-slate-400 text-sm tracking-wide">LOADING...</p></div>';
                            fetch('${pageContext.request.contextPath}/product?action=view&id=' + productId)
                                .then(r => r.text())
                                .then(html => {
                                    content.innerHTML = '<div class="prose max-w-none">' + html + '</div>';
                                    content.querySelectorAll('script').forEach(s => s.remove());
                                })
                                .catch(() => {
                                    content.innerHTML = '<p class="text-red-500 text-center">Failed to load product details.</p>';
                                });
                        }

                        function closeQuickView() {
                            document.getElementById('quickViewModal').classList.add('hidden');
                        }

                        document.getElementById('quickViewModal').addEventListener('click', function (e) {
                            if (e.target === this.firstElementChild) closeQuickView();
                        });

                        // ===== PRODUCT IMAGE SWATCH =====
                        function changeProductImage(productId, imageUrl) {
                            if (!imageUrl) return;
                            const swatchContainer = document.querySelector('#swatches-' + productId);
                            if (!swatchContainer) return;
                            const productCard = swatchContainer.closest('.group');
                            if (!productCard) return;
                            const imgContainer = productCard.querySelector('.relative.w-full');
                            if (imgContainer) {
                                const imgs = imgContainer.querySelectorAll('img');
                                if (imgs.length > 0) {
                                    imgs[0].src = imageUrl;
                                    imgs[0].classList.remove('group-hover:opacity-0');
                                    if (imgs.length > 1) imgs[1].style.display = 'none';
                                }
                            }
                            // Highlight active swatch
                            swatchContainer.querySelectorAll('button').forEach(s => {
                                s.classList.remove('ring-2', 'ring-offset-1');
                                s.style.boxShadow = '';
                            });
                            if (event && event.currentTarget) {
                                event.currentTarget.style.boxShadow = '0 0 0 2px white, 0 0 0 4px #024acf';
                            }
                        }
                    </script>

                </body>

                </html>
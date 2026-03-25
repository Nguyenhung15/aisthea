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
        <c:choose>
            <c:when test="${not empty pageTitle}">
                <title>AISTHÉA | ${pageTitle}</title>
            </c:when>
            <c:when test="${not empty displayCategory}">
                <title>AISTHÉA | ${displayCategory.name}</title>
            </c:when>
            <c:when test="${not empty displayCategoryName}">
                <title>AISTHÉA | ${displayCategoryName}</title>
            </c:when>
            <c:otherwise>
                <title>AISTHÉA | Bộ sưu tập</title>
            </c:otherwise>
        </c:choose>
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
                        borderRadius: {"DEFAULT": "0.5rem", "lg": "1rem", "xl": "1.5rem", "full": "9999px"},
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

            /* ===== PRODUCT BADGES ===== */
            @keyframes badgeFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-6px) scale(0.92);
                }

                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .badge {
                position: absolute;
                z-index: 20;
                pointer-events: none;
                font-family: 'Manrope', sans-serif;
                font-size: 10px;
                font-weight: 800;
                letter-spacing: 0.08em;
                line-height: 1;
                padding: 5px 9px;
                border-radius: 4px;
                animation: badgeFadeIn 0.45s cubic-bezier(0.22, 1, 0.36, 1) both;
                white-space: nowrap;
                user-select: none;
            }

            /* Discount badge — striking modern design with active sheen effect */
            .badge-discount {
                top: 10px;
                left: 10px;
                font-size: 13px;
                padding: 6px 14px;
                background: linear-gradient(135deg, #FF3131 0%, #FF914D 100%);
                color: #ffffff;
                font-weight: 800;
                letter-spacing: 0.05em;
                border-radius: 8px 0px 8px 0px; /* Unique folded-leaf shape */
                border: 1px solid rgba(255, 255, 255, 0.4);
                box-shadow: 0 6px 14px rgba(255, 49, 49, 0.4), inset 0 2px 3px rgba(255, 255, 255, 0.4);
                text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
                animation-delay: 0.05s;
                overflow: hidden;
            }

            .badge-discount::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 50%;
                height: 100%;
                background: linear-gradient(to right, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.6) 50%, rgba(255, 255, 255, 0) 100%);
                transform: skewX(-25deg);
                animation: badgeShine 3s infinite;
            }

            @keyframes badgeShine {
                0% { left: -100%; }
                20% { left: 200%; }
                100% { left: 200%; }
            }

            /* Best Seller badge — top-right, deep navy with gold text */
            .badge-bestseller {
                top: 12px;
                right: 12px;
                background: #0f172a;
                color: #F0C040;
                border: 1px solid rgba(240, 192, 64, 0.35);
                animation-delay: 0.12s;
            }

            /* Strikethrough original price */
            .price-original {
                text-decoration: line-through;
                color: #94a3b8;
                font-size: 11px;
                margin-right: 4px;
            }

            /* ===== DUAL PRICE RANGE SLIDER ===== */
            .price-dual-thumb {
                height: 4px;
                pointer-events: none;
                position: absolute;
                left: 0;
                width: 100%;
                outline: none;
                border: none;
                background: transparent;
                -webkit-appearance: none;
                appearance: none;
            }
            .price-dual-thumb::-webkit-slider-thumb {
                -webkit-appearance: none;
                appearance: none;
                width: 18px;
                height: 18px;
                background: #ffffff;
                border: 2px solid #1a1a1a;
                border-radius: 50%;
                cursor: pointer;
                pointer-events: all;
                box-shadow: 0 1px 4px rgba(0,0,0,0.18);
                transition: box-shadow 0.15s ease, transform 0.15s ease;
            }
            .price-dual-thumb::-webkit-slider-thumb:hover {
                box-shadow: 0 0 0 4px rgba(26,26,26,0.12);
                transform: scale(1.1);
            }
            .price-dual-thumb::-moz-range-thumb {
                width: 18px;
                height: 18px;
                background: #ffffff;
                border: 2px solid #1a1a1a;
                border-radius: 50%;
                cursor: pointer;
                pointer-events: all;
                box-shadow: 0 1px 4px rgba(0,0,0,0.18);
            }
            #sliderMin {
                z-index: 3;
            }
            #sliderMax {
                z-index: 4;
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
                        <%-- Level 2: Gender --%>
                        <c:choose>
                            <c:when test="${not empty genderLabel}">
                                <li class="flex items-center">
                                    <a class="hover:text-primary transition-colors"
                                       href="${pageContext.request.contextPath}/product?genderid=${genderId}">${genderLabel}</a>
                                    <span class="mx-2">/</span>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="flex items-center">
                                    <a class="hover:text-primary transition-colors"
                                       href="${pageContext.request.contextPath}/product">Collection</a>
                                    <span class="mx-2">/</span>
                                </li>
                            </c:otherwise>
                        </c:choose>
                        <%-- Level 3: Parent Category (only when a child is selected) --%>
                        <c:if test="${not empty parentCategory}">
                            <li class="flex items-center">
                                <a class="hover:text-primary transition-colors"
                                   href="${pageContext.request.contextPath}/product?categoryId=${parentCategory.categoryid}">
                                    ${parentCategory.name}
                                </a>
                                <span class="mx-2">/</span>
                            </li>
                        </c:if>
                        <%-- Level 4 (final): Current category or fallback --%>
                        <li class="flex items-center text-primary font-bold"
                            style="text-transform: uppercase;">
                            <c:choose>
                                <c:when test="${not empty displayCategory}">
                                    ${displayCategory.name}
                                </c:when>
                                <c:when test="${not empty displayCategoryName}">
                                    ${displayCategoryName}
                                </c:when>
                                <c:otherwise>Tất cả sản phẩm</c:otherwise>
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
                            <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                            <c:when test="${not empty displayCategory}">${displayCategory.name}</c:when>
                            <c:when test="${not empty displayCategoryName}">${displayCategoryName}
                            </c:when>
                            <c:otherwise>BỘ SƯU TẬP</c:otherwise>
                        </c:choose>
                    </h1>

                    <%-- Active filter chips: only show for user-applied sidebar params, NOT for the
                        base URL-path category. Price is only considered active when it's NOT the
                        default max value (500000000). --%>
                    <c:set var="priceIsActive"
                           value="${(not empty param.minPrice and param.minPrice != '0') or (not empty param.maxPrice and param.maxPrice != '500000000')}" />
                    <c:set var="hasActiveFilters"
                           value="${not empty param.categoryId or priceIsActive or not empty param.color or not empty param.size or not empty param.search}" />
                    <c:if test="${hasActiveFilters}">
                        <div class="flex items-center flex-wrap gap-3">
                            <span
                                class="text-sm font-medium text-slate-500 mr-2 uppercase tracking-wide">Active
                                Filters:</span>

                            <%-- Search chip --%>
                            <c:if test="${not empty param.search}">
                                <span
                                    class="inline-flex items-center px-4 py-1.5 rounded-full text-xs font-medium bg-primary text-white shadow-sm hover:shadow-md transition-shadow cursor-default">
                                    Search: "${param.search}"
                                    <a href="${pageContext.request.contextPath}/product"
                                       class="ml-2 hover:text-white/80 transition-colors">
                                        <span
                                            class="material-icons-outlined text-[14px]">close</span>
                                    </a>
                                </span>
                            </c:if>

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

                            <%-- Price chip: shows min–max range --%>
                            <c:if test="${priceIsActive}">
                                <span
                                    class="inline-flex items-center px-4 py-1.5 rounded-full text-xs font-medium bg-primary-light text-white shadow-sm hover:shadow-md transition-shadow cursor-default">
                                    <c:if test="${not empty param.minPrice and param.minPrice != '0'}">
                                        <fmt:formatNumber value="${param.minPrice}" type="number" groupingUsed="true" />₫
                                    </c:if>
                                    <c:if test="${empty param.minPrice or param.minPrice == '0'}">0₫</c:if>
                                        &nbsp;–&nbsp;
                                    <c:choose>
                                        <c:when test="${not empty param.maxPrice and param.maxPrice != '500000000'}">
                                            <fmt:formatNumber value="${param.maxPrice}" type="number" groupingUsed="true" />₫
                                        </c:when>
                                        <c:otherwise>Any</c:otherwise>
                                    </c:choose>
                                    <button type="button" onclick="clearPriceFilter()"
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
                                    Color: ${param.color}
                                    <button type="button"
                                            onclick="clearColorFilter()"
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
                               class="text-xs text-slate-500 hover:text-primary underline ml-2 transition-colors">Clear all</a>
                        </div>
                    </c:if>
                </div>

                <div class="flex flex-col lg:flex-row gap-12">
                    <!-- Sidebar -->
                    <aside class="w-full lg:w-1/4 flex-shrink-0">
                        <div
                            class="sticky top-28 glass-sidebar rounded-xl p-6 lg:h-[calc(100vh-8rem)] overflow-y-auto scrollbar-hide">
                            <div class="flex items-center justify-between mb-8">
                                <h2 class="text-lg font-semibold tracking-wide">FILTERS</h2>
                            </div>
                            <div class="space-y-8">
                                <!-- Category Filter -->
                                <div class="filter-section border-b border-primary/10 pb-6">
                                    <button type="button"
                                            class="accordion-btn flex items-center justify-between w-full group mb-4"
                                            onclick="toggleAccordion(this)">
                                        <span
                                            class="font-medium text-slate-800 dark:text-slate-200">Categories</span>
                                        <span
                                            class="material-icons-outlined text-slate-400 group-hover:text-primary transition-colors">expand_less</span>
                                    </button>
                                    <div class="accordion-content space-y-4 pl-1">

                                        <!-- Nam (Male) -->
                                        <div>
                                            <span
                                                class="text-xs font-bold uppercase tracking-wider text-primary mb-2 block">Men</span>
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
                                                class="text-xs font-bold uppercase tracking-wider text-primary mb-2 block">Women</span>
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


                                                                                        <!-- Color Filter -->
                                                                                        <div class="filter-section border-b border-primary/10 pb-6">
                                                                                        <button type="button"
                                                                                        class="accordion-btn flex items-center justify-between w-full group mb-4"
                                                                                        onclick="toggleAccordion(this)">
                                                                                        <span class="font-medium text-slate-800 dark:text-slate-200">Color</span>
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
                                                                                        class="mt-3 text-xs text-slate-400 hover:text-primary transition-colors underline">Clear color</button>
                                                                                        </c:if>
                                                                                        </div>
                                                                                        </div>

                                                                                        <!-- Size Filter -->
                                                                                        <div class="filter-section border-b border-primary/10 pb-6">
                                                                                        <button type="button"
                                                                                        class="accordion-btn flex items-center justify-between w-full group mb-4"
                                                                                        onclick="toggleAccordion(this)">
                                                                                        <span
                                                                                        class="font-medium text-slate-800 dark:text-slate-200">Size</span>
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
                                                                                        class="mt-3 text-xs text-slate-400 hover:text-primary transition-colors underline">Clear size</button>
                                                                                        </c:if>
                                                                                        </div>
                                                                                        </div>

                                                                                        <!-- Price Range Filter -->
                                                                                        <div class="filter-section">
                                                                                        <button type="button"
                                                                                        class="accordion-btn flex items-center justify-between w-full group mb-4"
                                                                                        onclick="toggleAccordion(this)">
                                                                                        <span
                                                                                        class="font-medium text-slate-800 dark:text-slate-200">Price Range</span>
                                                                                        <span
                                                                                        class="material-icons-outlined text-slate-400 group-hover:text-primary transition-colors">expand_less</span>
                                                                                        </button>
                                                                                        <div class="accordion-content px-1">
                                                                                        <%-- Hidden inputs for form submission --%>
                                                                                        <input type="hidden" name="minPrice" id="minPriceHidden"
                                                                                        value="${not empty param.minPrice ? param.minPrice : 0}" />
                                                                                        <input type="hidden" name="maxPrice" id="maxPriceHidden"
                                                                                        value="${not empty param.maxPrice ? param.maxPrice : 500000000}" />

                                                                                        <%-- Dual text inputs --%>
                                                                                        <div class="flex items-center gap-2 mb-4">
                                                                                        <div class="flex-1 relative">
                                                                                        <input type="text" id="minPriceInput"
                                                                                        class="w-full border border-slate-200 rounded-lg px-3 py-2 text-xs font-medium text-slate-700 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary/30 bg-white/60"
                                                                                        placeholder="Min"
                                                                                        value="<c:choose><c:when test='${not empty param.minPrice and param.minPrice != \"0\"}'><fmt:formatNumber value='${param.minPrice}' type='number' groupingUsed='true'/></c:when><c:otherwise></c:otherwise></c:choose>"
                                                                                        oninput="formatPriceInput(this)"
                                                                                        onblur="syncFromInputs()" />
                                                                                        <span class="absolute right-2.5 top-1/2 -translate-y-1/2 text-[10px] text-slate-400 font-medium pointer-events-none">₫</span>
                                                                                        </div>
                                                                                        <span class="text-slate-300 font-bold text-base">—</span>
                                                                                        <div class="flex-1 relative">
                                                                                        <input type="text" id="maxPriceInput"
                                                                                        class="w-full border border-slate-200 rounded-lg px-3 py-2 text-xs font-medium text-slate-700 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary/30 bg-white/60"
                                                                                        placeholder="Max"
                                                                                        value="<c:choose><c:when test='${not empty param.maxPrice and param.maxPrice != \"500000000\"}'><fmt:formatNumber value='${param.maxPrice}' type='number' groupingUsed='true'/></c:when><c:otherwise></c:otherwise></c:choose>"
                                                                                        oninput="formatPriceInput(this)"
                                                                                        onblur="syncFromInputs()" />
                                                                                        <span class="absolute right-2.5 top-1/2 -translate-y-1/2 text-[10px] text-slate-400 font-medium pointer-events-none">₫</span>
                                                                                        </div>
                                                                                        </div>

                                                                                        <%-- Dual range slider --%>
                                                                                        <div class="relative h-5 flex items-center" id="priceSliderTrack">
                                                                                        <div class="absolute left-0 right-0 h-1 bg-slate-200 rounded-full"></div>
                                                                                        <div id="priceRangeFill" class="absolute h-1 bg-primary rounded-full"></div>
                                                                                        <input type="range" id="sliderMin"
                                                                                        class="price-dual-thumb absolute w-full appearance-none bg-transparent pointer-events-none"
                                                                                        min="0" max="500000000" step="100000"
                                                                                        value="${not empty param.minPrice ? param.minPrice : 0}"
                                                                                        oninput="onSliderChange()" />
                                                                                        <input type="range" id="sliderMax"
                                                                                        class="price-dual-thumb absolute w-full appearance-none bg-transparent pointer-events-none"
                                                                                        min="0" max="500000000" step="100000"
                                                                                        value="${not empty param.maxPrice ? param.maxPrice : 500000000}"
                                                                                        oninput="onSliderChange()" />
                                                                                        </div>

                                                                                        <%-- Range extremes label --%>
                                                                                        <div class="flex items-center justify-between mt-2 text-[10px] text-slate-400 font-medium">
                                                                                        <span>0₫</span>
                                                                                        <span>500.000.000₫</span>
                                                                                        </div>

                                                                                        <%-- Apply button --%>
                                                                                        <button type="button" onclick="applyPriceFilter()"
                                                                                        class="mt-4 w-full py-2.5 bg-primary text-white text-[11px] font-bold tracking-widest uppercase rounded-lg hover:bg-primary/90 transition-colors">
                                                                                        Apply
                                                                                        </button>
                                                                                        <c:if test="${(not empty param.minPrice and param.minPrice != '0') or (not empty param.maxPrice and param.maxPrice != '500000000')}">
                                                                                        <button type="button" onclick="clearPriceFilter()"
                                                                                        class="mt-2 w-full text-xs text-slate-400 hover:text-primary transition-colors underline">
                                                                                        Clear price filter
                                                                                        </button>
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
                                                                                        <span class="text-sm text-slate-500 font-medium tracking-wide">Sort
                                                                                        by:</span>
                                                                                        <div class="relative inline-block text-left" id="customSortDropdown">
                                                                                        <button type="button" onclick="toggleSortMenu()"
                                                                                        class="flex items-center gap-3 group px-4 py-2 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 transition-all duration-200 focus:outline-none">
                                                                                        <span
                                                                                        class="text-sm font-bold text-slate-900 dark:text-white uppercase tracking-widest"
                                                                                        id="currentSortLabel">
                                                                                        <c:choose>
                                                                                        <c:when test="${param.sort == 'price_asc'}">Low to High
                                                                                        </c:when>
                                                                                        <c:when test="${param.sort == 'price_desc'}">High to Low
                                                                                        </c:when>
                                                                                        <c:when test="${param.sort == 'newest'}">Newest</c:when>
                                                                                        <c:otherwise>Featured</c:otherwise>
                                                                                        </c:choose>
                                                                                        </span>
                                                                                        <span
                                                                                        class="material-icons-outlined text-[18px] text-slate-400 group-hover:text-primary transition-transform duration-300"
                                                                                        id="sortChevron">expand_more</span>
                                                                                        </button>

                                                                                        <!-- Dropdown Menu -->
                                                                                        <div id="sortMenu"
                                                                                        class="absolute right-0 mt-2 w-56 origin-top-right rounded-xl bg-white dark:bg-slate-800 shadow-lift border border-slate-100 dark:border-slate-700 focus:outline-none z-[100] transform scale-95 opacity-0 invisible transition-all duration-300">
                                                                                        <div class="py-2 px-1" role="none">
                                                                                        <button type="button" onclick="handleSortSelect('featured')"
                                                                                        class="w-full text-left px-4 py-3 text-[13px] font-bold uppercase tracking-wider ${empty param.sort or param.sort == 'featured' ? 'text-primary bg-primary/5' : 'text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-700/50'} rounded-lg transition-colors flex items-center justify-between">
                                                                                        <span>Featured</span>
                                                                                        <c:if
                                                                                        test="${empty param.sort or param.sort == 'featured'}">
                                                                                        <span
                                                                                        class="material-icons-outlined text-[16px]">check</span>
                                                                                        </c:if>
                                                                                        </button>
                                                                                        <button type="button"
                                                                                        onclick="handleSortSelect('price_asc')"
                                                                                        class="w-full text-left px-4 py-3 text-[13px] font-bold uppercase tracking-wider ${param.sort == 'price_asc' ? 'text-primary bg-primary/5' : 'text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-700/50'} rounded-lg transition-colors flex items-center justify-between">
                                                                                        <span>Price: Low to High</span>
                                                                                        <c:if test="${param.sort == 'price_asc'}"><span
                                                                                        class="material-icons-outlined text-[16px]">check</span>
                                                                                        </c:if>
                                                                                        </button>
                                                                                        <button type="button"
                                                                                        onclick="handleSortSelect('price_desc')"
                                                                                        class="w-full text-left px-4 py-3 text-[13px] font-bold uppercase tracking-wider ${param.sort == 'price_desc' ? 'text-primary bg-primary/5' : 'text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-700/50'} rounded-lg transition-colors flex items-center justify-between">
                                                                                        <span>Price: High to Low</span>
                                                                                        <c:if test="${param.sort == 'price_desc'}"><span
                                                                                        class="material-icons-outlined text-[16px]">check</span>
                                                                                        </c:if>
                                                                                        </button>
                                                                                        <button type="button" onclick="handleSortSelect('newest')"
                                                                                        class="w-full text-left px-4 py-3 text-[13px] font-bold uppercase tracking-wider ${param.sort == 'newest' ? 'text-primary bg-primary/5' : 'text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-700/50'} rounded-lg transition-colors flex items-center justify-between">
                                                                                        <span>Newest</span>
                                                                                        <c:if test="${param.sort == 'newest'}"><span
                                                                                        class="material-icons-outlined text-[16px]">check</span>
                                                                                        </c:if>
                                                                                        </button>
                                                                                        </div>
                                                                                        </div>
                                                                                        </div>
                                                                                        <input type="hidden" name="sort" id="sortHiddenInput"
                                                                                        value="${not empty param.sort ? param.sort : 'featured'}" />
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
                                                                                        <%-- Find primary or fallback to first --%>
                                                                                        <c:set var="primaryImg" value="${p.images[0].imageUrl}" />
                                                                                        <c:forEach var="img" items="${p.images}">
                                                                                            <c:if test="${img.primary}">
                                                                                                <c:set var="primaryImg" value="${img.imageUrl}" />
                                                                                            </c:if>
                                                                                        </c:forEach>
                                                                                        
                                                                                        <c:if test="${not empty primaryImg and not fn:startsWith(primaryImg, 'http') and not fn:startsWith(primaryImg, '/')}">
                                                                                            <c:set var="primaryImg" value="${pageContext.request.contextPath}/uploads/${primaryImg}" />
                                                                                        </c:if>

                                                                                        <img class="absolute inset-0 w-full h-full object-cover transition-opacity duration-500 group-hover:opacity-0"
                                                                                        src="${primaryImg}"
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
                                                                                        <c:set var="hoverImg" value="${p.images[1].imageUrl}" />
                                                                                        <c:if test="${not empty hoverImg and not fn:startsWith(hoverImg, 'http') and not fn:startsWith(hoverImg, '/')}">
                                                                                            <c:set var="hoverImg" value="${pageContext.request.contextPath}/uploads/${hoverImg}" />
                                                                                        </c:if>
                                                                                        <img class="absolute inset-0 w-full h-full object-cover opacity-0 transition-opacity duration-500 group-hover:opacity-100"
                                                                                        src="${hoverImg}" 
                                                                                        alt="${p.name} Hover"
                                                                                        onerror="this.onerror=null; this.style.display='none'" />
                                                                                        </c:if>

                                                                                        <c:if test="${p.totalStock <= 0}">
                                                                                            <!-- Prominent Out of Stock Overlay -->
                                                                                            <div class="absolute inset-0 z-20 bg-white/40 backdrop-blur-[2px] flex items-center justify-center pointer-events-none transition-all duration-300">
                                                                                                <div style="background:#dc2626; color:white; font-size:0.9rem; font-weight:800; padding:10px 28px; text-transform:uppercase; letter-spacing:2.5px; transform:rotate(-8deg) scale(1.05); box-shadow:0 10px 25px -5px rgba(220,38,38,0.5), inset 0 0 0 2px rgba(255,255,255,0.2); border-radius:6px; backdrop-filter:blur(4px);">
                                                                                                    Hết Hàng
                                                                                                </div>
                                                                                            </div>
                                                                                        </c:if>
                                                                                        </a>

                                                                                        <%--===BADGES LAYER (outside <a> so they always show)
                                                                                        === --%>

                                                                                        <%-- 1. Discount Badge (top-left) --%>
                                                                                        <c:if
                                                                                        test="${not empty p.discount and p.discount > 0}">
                                                                                        <%-- discount đã là % nguyên (vd: 10=10%)
                                                                                        --%>
                                                                                        <span class="badge badge-discount">
                                                                                        -
                                                                                        <fmt:formatNumber
                                                                                        value="${p.discount}"
                                                                                        maxFractionDigits="0" />%
                                                                                        </span>
                                                                                        </c:if>

                                                                                        <%-- 2. Best Seller Badge (top-right) --%>
                                                                                        <c:if test="${p.bestseller}">
                                                                                        <span class="badge badge-bestseller">★
                                                                                        BEST SELLER</span>
                                                                                        </c:if>

                                                                                        <%-- 3. Out of Stock Badge (Removed in favor of overlay above) --%>
                                                                                        </div>

                                                                                        <div class="space-y-1 px-1">
                                                                                        <h3
                                                                                        class="text-[10px] text-slate-400 uppercase tracking-widest font-semibold mt-1 mb-1">
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
                                                                                        <div class="flex items-baseline gap-2 mt-0.5">
                                                                                        <%-- Show struck-through original price only
                                                                                        when discounted --%>
                                                                                        <c:if
                                                                                        test="${not empty p.discount and p.discount > 0 and not empty p.price}">
                                                                                        <span class="price-original">
                                                                                        <fmt:formatNumber
                                                                                        value="${p.price}"
                                                                                        type="number"
                                                                                        groupingUsed="true" />₫
                                                                                        </span>
                                                                                        </c:if>
                                                                                        <span
                                                                                        class="${not empty p.discount and p.discount > 0 ? 'text-[#E05252]' : 'text-primary'} font-semibold text-sm">
                                                                                        <c:choose>
                                                                                        <c:when
                                                                                        test="${not empty p.price and not empty p.discount and p.discount > 0}">
                                                                                        <fmt:formatNumber
                                                                                        value="${p.price * (1 - p.discount / 100)}"
                                                                                        type="number"
                                                                                        groupingUsed="true"
                                                                                        maxFractionDigits="0" />
                                                                                        ₫
                                                                                        </c:when>
                                                                                        <c:when
                                                                                        test="${not empty p.price}">
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
                                                                                        <!-- Cart Icon Button → opens Quick Add modal -->
                                                                                        <button type="button"
                                                                                        onclick="event.preventDefault(); openQuickView(${p.productId})"
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
                                                                                        </button>
                                                                                        </div>
                                                                                        <!-- Bottom Row: Color Swatches & Rating -->
                                                                                        <div class="flex items-center pt-2 min-h-[24px]">
                                                                                        <!-- Color Swatches -->
                                                                                        <div class="flex flex-wrap gap-1.5"
                                                                                        id="swatches-${p.productId}">
                                                                                        <c:set var="seenColors" value="," />
                                                                                        <c:forEach items="${p.colorSizes}" var="cs">
                                                                                        <c:if
                                                                                        test="${not empty cs.color and not fn:contains(seenColors, ','.concat(cs.color).concat(','))}">
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
                                                                                        <c:set var="swatchPath" value="${imgUrlForSwatch}" /><c:if test="${not empty swatchPath and not fn:startsWith(swatchPath, 'http') and not fn:startsWith(swatchPath, '/')}"><c:set var="swatchPath" value="${pageContext.request.contextPath}/uploads/${swatchPath}" /></c:if>onclick="changeProductImageWithHex(${p.productId}, '${swatchPath}', this)"
                                                                                        class="color-swatch"
                                                                                        data-color-name="${cs.color}"
                                                                                        title="${cs.color}">
                                                                                        </button>
                                                                                        </c:if>
                                                                                        </c:forEach>
                                                                                        <!-- Fallback from images if no colorSizes -->
                                                                                        <c:if test="${empty p.colorSizes}">
                                                                                        <c:forEach items="${p.images}" var="img">
                                                                                        <c:set var="colorCheckImg" value=",${img.color}," /><c:if test="${not empty img.color and not fn:contains(seenColors, colorCheckImg)}"><c:set var="seenColors" value="${seenColors}${img.color}," />
                                                                                        <button type="button"
                                                                                        <c:set var="swatchImg" value="${img.imageUrl}" /><c:if test="${not empty swatchImg and not fn:startsWith(swatchImg, 'http') and not fn:startsWith(swatchImg, '/')}"><c:set var="swatchImg" value="${pageContext.request.contextPath}/uploads/${swatchImg}" /></c:if>onclick="changeProductImageWithHex(${p.productId}, '${swatchImg}', this)"
                                                                                        class="color-swatch"
                                                                                        data-color-name="${img.color}"
                                                                                        title="${img.color}">
                                                                                        </button>
                                                                                        </c:if>
                                                                                        </c:forEach>
                                                                                        </c:if>
                                                                                        </div>
                                                                                        <!-- Rating (Aligned right of swatches) -->
                                                                                        <c:if test="${p.reviewCount > 0}">
                                                                                            <div class="flex items-center ml-auto">
                                                                                                <div class="flex text-[#F0C040]">
                                                                                                    <c:forEach var="i" begin="1" end="5">
                                                                                                        <c:choose>
                                                                                                            <c:when test="${p.avgRating >= i}">
                                                                                                                <span class="material-icons-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">star</span>
                                                                                                            </c:when>
                                                                                                            <c:when test="${p.avgRating >= (i - 0.5)}">
                                                                                                                <span class="material-icons-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">star_half</span>
                                                                                                            </c:when>
                                                                                                            <c:otherwise>
                                                                                                                <span class="material-icons-outlined text-[16px]">star_border</span>
                                                                                                            </c:otherwise>
                                                                                                        </c:choose>
                                                                                                    </c:forEach>
                                                                                                </div>
                                                                                                <span class="text-xs text-slate-500 font-bold ml-1.5"><fmt:formatNumber value="${p.avgRating}" maxFractionDigits="1" minFractionDigits="1" /></span>
                                                                                                <span class="text-xs text-slate-400 font-medium ml-1">(${p.reviewCount})</span>
                                                                                            </div>
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
                                                                                        <script>
                                                                                        function changePage(page) {
                                                                                        const url = new URL(window.location.href);
                                                                                        url.searchParams.set('page', page);
                                                                                        window.location.href = url.toString();
                                                                                        }
                                                                                        </script>
                                                                                        <div class="mt-16 flex justify-center">
                                                                                        <nav class="flex items-center space-x-2" aria-label="Pagination">
                                                                                        <!-- Prev -->
                                                                                        <button type="button" onclick="changePage(${currentPage - 1})"
                                                                                        class="w-10 h-10 flex items-center justify-center rounded-full bg-white border border-slate-200 text-slate-500 hover:border-primary hover:text-primary transition-colors ${currentPage == 1 ? 'opacity-50 cursor-not-allowed pointer-events-none' : ''}"
                                                                                        ${currentPage==1 ? 'disabled' : '' }>
                                                                                        <span
                                                                                        class="material-icons-outlined text-sm">chevron_left</span>
                                                                                        </button>

                                                                                        <!-- Page Numbers -->
                                                                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                                                                        <button type="button" onclick="changePage(${i})"
                                                                                        class="w-10 h-10 flex items-center justify-center rounded-full font-medium shadow-sm transition-colors ${currentPage == i ? 'bg-primary text-white shadow-glow pointer-events-none' : 'bg-white border border-slate-200 text-slate-600 hover:border-primary hover:text-primary'}">
                                                                                        ${i}
                                                                                        </button>
                                                                                        </c:forEach>

                                                                                        <!-- Next -->
                                                                                        <button type="button" onclick="changePage(${currentPage + 1})"
                                                                                        class="w-10 h-10 flex items-center justify-center rounded-full bg-white border border-slate-200 text-slate-500 hover:border-primary hover:text-primary transition-colors ${currentPage == totalPages ? 'opacity-50 cursor-not-allowed pointer-events-none' : ''}"
                                                                                        ${currentPage==totalPages ? 'disabled' : '' }>
                                                                                        <span
                                                                                        class="material-icons-outlined text-sm">chevron_right</span>
                                                                                        </button>
                                                                                        </nav>
                                                                                        </div>
                                                                                        </c:if>
                                                                                        </div>
                                                                                        </div>
                                                                                        </main>
                                                                                        </form>

                                                                                        <!-- Global Luxury Footer -->
                                                                                        <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                                                                                        <!-- ====== QUICK ADD TO CART MODAL ====== -->
                                                                                        <div id="quickViewModal" class="fixed inset-0 z-[200] hidden" aria-modal="true" role="dialog">

                                                                                        <!-- Overlay -->
                                                                                        <div id="modalOverlay"
                                                                                        class="fixed inset-0 z-[201] flex items-center justify-center p-4 bg-slate-900/40 backdrop-blur-sm transition-opacity duration-300 opacity-0"
                                                                                        onclick="closeQuickView()">

                                                                                        <!-- Modal card — stop click propagation inside -->
                                                                                        <div class="relative w-full max-w-4xl bg-white shadow-2xl rounded-none overflow-hidden flex flex-col md:flex-row min-h-[560px] md:min-h-[600px]"
                                                                                        onclick="event.stopPropagation()">

                                                                                        <!-- Close button -->
                                                                                        <button type="button" onclick="closeQuickView()"
                                                                                        class="absolute top-4 right-4 z-30 p-2 text-slate-400 hover:text-slate-900 transition-colors">
                                                                                        <span class="material-symbols-outlined text-[24px]">close</span>
                                                                                        </button>

                                                                                        <!-- LEFT: Image (1/2) -->
                                                                                        <div class="w-full md:w-1/2 bg-slate-50 relative group flex-shrink-0">
                                                                                        <div id="qv-image-bg"
                                                                                        class="h-full w-full bg-center bg-no-repeat bg-cover min-h-[350px] md:min-h-[600px] transition-all duration-500"
                                                                                        style="background-image:none;">
                                                                                        <%-- Fallback visible img for non-bg-image display --%>
                                                                                        </div>

                                                                                        <!-- Discount badge top-left -->
                                                                                        <span id="qv-badge-discount"
                                                                                        class="hidden absolute top-4 left-4 z-10 bg-[#E05252] text-white text-[10px] font-extrabold tracking-widest px-3 py-1.5 pointer-events-none"></span>

                                                                                        <!-- Best Seller badge top-right (offset for close btn) -->
                                                                                        <span id="qv-badge-bestseller"
                                                                                        class="hidden absolute top-4 left-1/2 -translate-x-1/2 z-10 bg-slate-900 text-[#F0C040] text-[10px] font-extrabold tracking-widest px-3 py-1.5 pointer-events-none border border-[#F0C040]/30">
                                                                                        &#9733; BEST SELLER
                                                                                        </span>
                                                                                        </div>

                                                                                        <!-- RIGHT: Info (1/2) -->
                                                                                        <div
                                                                                        class="w-full md:w-1/2 p-8 md:p-12 flex flex-col justify-center overflow-y-auto custom-scroll">

                                                                                        <!-- Loader -->
                                                                                        <div id="qv-loader" class="flex flex-col items-center justify-center py-20">
                                                                                        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mb-3">
                                                                                        </div>
                                                                                        <p class="text-slate-400 text-[10px] tracking-widest uppercase">Loading
                                                                                        AISTHÉA...</p>
                                                                                        </div>

                                                                                        <!-- Content -->
                                                                                        <div id="qv-content" class="hidden">

                                                                                        <!-- Header block -->
                                                                                        <div class="mb-8">
                                                                                        <p id="qv-brand"
                                                                                        class="text-xs uppercase tracking-[0.2em] text-slate-400 mb-2 font-medium">
                                                                                        AISTHÉA Exclusive</p>
                                                                                        <h2 id="qv-name"
                                                                                        class="font-serif text-4xl text-slate-900 mb-2 leading-tight"></h2>
                                                                                        <p id="qv-sku"
                                                                                        class="text-xs text-slate-400 font-light tracking-widest uppercase"></p>
                                                                                        </div>

                                                                                        <!-- Price -->
                                                                                        <div class="mb-8 flex items-baseline gap-3">
                                                                                        <span id="qv-price" class="text-2xl font-light text-slate-900"></span>
                                                                                        <span id="qv-price-original"
                                                                                        class="text-lg font-light text-slate-300 line-through hidden"></span>
                                                                                        </div>

                                                                                        <!-- Color selection -->
                                                                                        <div class="mb-8">
                                                                                        <p
                                                                                        class="text-[10px] uppercase tracking-widest text-slate-500 mb-4 font-semibold">
                                                                                        Select Color
                                                                                        <span id="qv-selected-color-label"
                                                                                        class="ml-1 normal-case tracking-normal text-slate-800"></span>
                                                                                        </p>
                                                                                        <div id="qv-colors" class="flex gap-4"></div>
                                                                                        </div>

                                                                                        <!-- Size selection -->
                                                                                        <div class="mb-10">
                                                                                        <div class="flex justify-between items-center mb-4">
                                                                                        <p
                                                                                        class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">
                                                                                        Select Size</p>
                                                                                        </div>
                                                                                        <div id="qv-sizes" class="grid grid-cols-5 gap-2"></div>
                                                                                        <p id="qv-size-error" class="hidden text-[10px] text-red-500 mt-2">Please
                                                                                        select a size.</p>
                                                                                        </div>

                                                                                        <!-- Actions -->
                                                                                        <div class="space-y-6">
                                                                                        <button id="qv-add-btn" type="button" onclick="quickAddToCart()"
                                                                                        class="w-full bg-slate-900 text-white py-5 text-[10px] font-bold tracking-[0.3em] uppercase hover:bg-slate-800 transition-colors duration-300 disabled:opacity-40 disabled:cursor-not-allowed">
                                                                                        Add to Cart
                                                                                        </button>
                                                                                        <div class="text-center">
                                                                                        <a id="qv-detail-link" href="#"
                                                                                        class="inline-block text-[10px] uppercase tracking-[0.15em] text-slate-400 border-b border-slate-200 pb-1 hover:text-slate-900 hover:border-slate-900 transition-all duration-300">
                                                                                        View full details
                                                                                        </a>
                                                                                        </div>
                                                                                        </div>

                                                                                        </div><%-- /qv-content --%>
                                                                                        </div>
                                                                                        </div><%-- /card --%>
                                                                                        </div><%-- /overlay --%>
                                                                                        </div><%-- /quickViewModal --%>

                                                                                        <!-- Quick View JS -->
                                                                                        <script>
                                                                                        (function () {
                                                                                        const CTX = '${pageContext.request.contextPath}';
                                                                                        let qvData = null;      // full product data from server
                                                                                        let selectedColor = null;
                                                                                        let selectedPcsId = null;
                                                                                        let selectedImageUrl = '';

                                                                                        /* ---------- OPEN ---------- */
                                                                                        window.openQuickView = function (productId) {
                                                                                        const modal = document.getElementById('quickViewModal');
                                                                                        const overlay = document.getElementById('modalOverlay');

                                                                                        // reset state
                                                                                        document.getElementById('qv-loader').classList.remove('hidden');
                                                                                        document.getElementById('qv-content').classList.add('hidden');
                                                                                        document.getElementById('qv-image-bg').style.backgroundImage = 'none';
                                                                                        selectedColor = null; selectedPcsId = null;

                                                                                        modal.classList.remove('hidden');
                                                                                        document.body.style.overflow = 'hidden';

                                                                                        // animate in
                                                                                        requestAnimationFrame(() => {
                                                                                        overlay.classList.remove('opacity-0');
                                                                                        });

                                                                                        // fetch data
                                                                                        fetch(CTX + '/product?action=quickview&id=' + productId, {
                                                                                        headers: { 'X-Requested-With': 'XMLHttpRequest' }
                                                                                        })
                                                                                        .then(r => r.json())
                                                                                        .then(data => {
                                                                                        qvData = data;
                                                                                        renderModal(data);
                                                                                        })
                                                                                        .catch(() => {
                                                                                        document.getElementById('qv-loader').innerHTML =
                                                                                        '<p class="text-slate-400 text-sm">Không thể tải sản phẩm. Thử lại.</p>';
                                                                                        });
                                                                                        };

                                                                                        /* ---------- CLOSE ---------- */
                                                                                        window.closeQuickView = function () {
                                                                                        const modal = document.getElementById('quickViewModal');
                                                                                        const overlay = document.getElementById('modalOverlay');
                                                                                        overlay.classList.add('opacity-0');
                                                                                        setTimeout(() => {
                                                                                        modal.classList.add('hidden');
                                                                                        document.body.style.overflow = '';
                                                                                        }, 300);
                                                                                        };

                                                                                        /* ---------- RENDER ---------- */
                                                                                        function renderModal(d) {
                                                                                        // text fields
                                                                                        document.getElementById('qv-brand').textContent = d.brand || 'AISTHÉA';
                                                                                        document.getElementById('qv-name').textContent = d.name || '';
                                                                                        document.getElementById('qv-sku').textContent = 'SKU: ' + (d.productId || '');
                                                                                        document.getElementById('qv-detail-link').href = CTX + '/product?action=view&id=' + d.productId;

                                                                                        // price
                                                                                        const fmt = v => new Intl.NumberFormat('vi-VN').format(Math.round(v));
                                                                                        const rawPrice = d.price || 0;
                                                                                        const disc = d.discount || 0;  // already %
                                                                                        const salePrice = disc > 0 ? rawPrice * (1 - disc / 100) : rawPrice;

                                                                                        document.getElementById('qv-price').textContent = fmt(salePrice) + '₫';
                                                                                        const origEl = document.getElementById('qv-price-original');
                                                                                        if (disc > 0) {
                                                                                        origEl.textContent = fmt(rawPrice) + '₫';
                                                                                        origEl.classList.remove('hidden');
                                                                                        document.getElementById('qv-price').className = 'text-2xl font-light text-[#E05252]';
                                                                                        } else {
                                                                                        origEl.classList.add('hidden');
                                                                                        document.getElementById('qv-price').className = 'text-2xl font-light text-slate-900';
                                                                                        }

                                                                                        // badges
                                                                                        const discBadge = document.getElementById('qv-badge-discount');
                                                                                        if (disc > 0) {
                                                                                        discBadge.textContent = '-' + Math.round(disc) + '%';
                                                                                        discBadge.classList.remove('hidden');
                                                                                        } else {
                                                                                        discBadge.classList.add('hidden');
                                                                                        }
                                                                                        const bsBadge = document.getElementById('qv-badge-bestseller');
                                                                                        d.bestseller ? bsBadge.classList.remove('hidden') : bsBadge.classList.add('hidden');

                                                                                        // gather unique colors
                                                                                        const colorMap = {};   // color -> {pcsId, stock, imageUrl}
                                                                                        const colorImageMap = {}; // color -> imageUrl
                                                                                        if (d.images) {
                                                                                        d.images.forEach(img => {
                                                                                        if (img.color) colorImageMap[img.color.toLowerCase()] = img.imageUrl;
                                                                                        });
                                                                                        }
                                                                                        if (d.colorSizes) {
                                                                                        d.colorSizes.forEach(cs => {
                                                                                        const key = cs.color ? cs.color.toLowerCase() : 'default';
                                                                                        if (!colorMap[key]) colorMap[key] = [];
                                                                                        colorMap[key].push(cs);
                                                                                        });
                                                                                        }

                                                                                        // render color swatches
                                                                                        const colorsDiv = document.getElementById('qv-colors');
                                                                                        colorsDiv.innerHTML = '';
                                                                                        const colorNames = Object.keys(colorMap);
                                                                                        colorNames.forEach((c, idx) => {
                                                                                        const hex = window.getColorHex ? window.getColorHex(c) : '#CCCCCC';
                                                                                        const btn = document.createElement('button');
                                                                                        btn.type = 'button';
                                                                                        btn.title = colorMap[c][0].color || c;
                                                                                        btn.dataset.color = c;
                                                                                        btn.className = 'w-7 h-7 rounded-full border-2 border-white shadow transition-all hover:scale-105 hover:ring-2 hover:ring-slate-900 hover:ring-offset-1';
                                                                                        btn.style.backgroundColor = hex;
                                                                                        btn.onclick = () => selectColor(c, colorMap, colorImageMap, d.images);
                                                                                        colorsDiv.appendChild(btn);
                                                                                        if (idx === 0) { // auto-select first
                                                                                        setTimeout(() => selectColor(c, colorMap, colorImageMap, d.images), 10);
                                                                                        }
                                                                                        });

                                                                                        // main image — use background-image
                                                                                        if (d.images && d.images.length > 0) {
                                                                                        selectedImageUrl = d.images[0].imageUrl;
                                                                                        document.getElementById('qv-image-bg').style.backgroundImage =
                                                                                        'url("' + selectedImageUrl + '")';
                                                                                        }

                                                                                        // show content
                                                                                        document.getElementById('qv-loader').classList.add('hidden');
                                                                                        document.getElementById('qv-content').classList.remove('hidden');
                                                                                        }

                                                                                        /* ---------- SELECT COLOR ---------- */
                                                                                        function selectColor(color, colorMap, colorImageMap, allImages) {
                                                                                        selectedColor = color;
                                                                                        selectedPcsId = null;
                                                                                        document.getElementById('qv-selected-color-label').textContent =
                                                                                        colorMap[color][0].color || color;

                                                                                        // ring
                                                                                        document.getElementById('qv-colors').querySelectorAll('button').forEach(b => {
                                                                                        if (b.dataset.color === color) {
                                                                                        b.style.boxShadow = '0 0 0 2px white, 0 0 0 4px #0f172a';
                                                                                        b.style.transform = 'scale(1.15)';
                                                                                        } else {
                                                                                        b.style.boxShadow = '';
                                                                                        b.style.transform = '';
                                                                                        }
                                                                                        });

                                                                                        // switch main image via background-image
                                                                                        const imgUrl = colorImageMap[color];
                                                                                        if (imgUrl) {
                                                                                        selectedImageUrl = imgUrl;
                                                                                        document.getElementById('qv-image-bg').style.backgroundImage = 'url("' + imgUrl + '")';
                                                                                        } else if (qvData && qvData.images && qvData.images.length > 0) {
                                                                                        selectedImageUrl = qvData.images[0].imageUrl;
                                                                                        document.getElementById('qv-image-bg').style.backgroundImage = 'url("' + selectedImageUrl + '")';
                                                                                        }

                                                                                        // render sizes
                                                                                        const sizesDiv = document.getElementById('qv-sizes');
                                                                                        sizesDiv.innerHTML = '';
                                                                                        colorMap[color].forEach(cs => {
                                                                                        const oos = cs.stock <= 0;
                                                                                        const btn = document.createElement('button');
                                                                                        btn.type = 'button';
                                                                                        btn.dataset.pcsid = cs.productColorSizeId;
                                                                                        btn.dataset.size = cs.size;
                                                                                        btn.disabled = oos;
                                                                                        btn.className = oos
                                                                                        ? 'aspect-square border border-slate-100 bg-slate-50 flex items-center justify-center text-xs font-medium text-slate-300 cursor-not-allowed'
                                                                                        : 'aspect-square border border-slate-200 flex items-center justify-center text-xs font-medium hover:border-slate-900 transition-colors';
                                                                                        if (oos) {
                                                                                        btn.innerHTML = '<span class="relative">' + cs.size +
                                                                                        '<span class="absolute inset-0 flex items-center justify-center"><span class="w-full h-[1px] bg-slate-200 rotate-45"></span></span></span>';
                                                                                        } else {
                                                                                        btn.textContent = cs.size;
                                                                                        btn.onclick = () => selectSize(btn, cs.productColorSizeId);
                                                                                        }
                                                                                        sizesDiv.appendChild(btn);
                                                                                        });
                                                                                        }

                                                                                        /* ---------- SELECT SIZE ---------- */
                                                                                        function selectSize(btn, pcsId) {
                                                                                        selectedPcsId = pcsId;
                                                                                        document.getElementById('qv-size-error').classList.add('hidden');
                                                                                        document.getElementById('qv-sizes').querySelectorAll('button:not(:disabled)').forEach(b => {
                                                                                        b.className = b === btn
                                                                                        ? 'aspect-square border border-slate-900 bg-slate-900 text-white flex items-center justify-center text-xs font-medium'
                                                                                        : 'aspect-square border border-slate-200 flex items-center justify-center text-xs font-medium hover:border-slate-900 transition-colors';
                                                                                        });
                                                                                        }

                                                                                        /* ---------- ADD TO CART ---------- */
                                                                                        window.quickAddToCart = function () {
                                                                                        if (!selectedPcsId) {
                                                                                        document.getElementById('qv-size-error').classList.remove('hidden');
                                                                                        return;
                                                                                        }
                                                                                        const btn = document.getElementById('qv-add-btn');
                                                                                        btn.disabled = true;
                                                                                        btn.textContent = 'Đang thêm...';

                                                                                        const body = new URLSearchParams({
                                                                                        action: 'add',
                                                                                        productId: qvData.productId,
                                                                                        productColorSizeId: selectedPcsId,
                                                                                        quantity: 1,
                                                                                        imageUrl: selectedImageUrl,
                                                                                        ajax: 'true'
                                                                                        });

                                                                                        fetch(CTX + '/cart', {
                                                                                        method: 'POST',
                                                                                        headers: {
                                                                                        'Content-Type': 'application/x-www-form-urlencoded',
                                                                                        'X-Requested-With': 'XMLHttpRequest'
                                                                                        },
                                                                                        body: body.toString()
                                                                                        })
                                                                                        .then(r => r.json())
                                                                                        .then(res => {
                                                                                        if (res.success) {
                                                                                        btn.textContent = '✓ Đã thêm vào giỏ!';
                                                                                        btn.className = btn.className.replace('bg-slate-900', 'bg-green-600');
                                                                                        // update cart badge
                                                                                        const badge = document.querySelector('.cart-count-badge');
                                                                                        if (badge) badge.textContent = res.cartCount;
                                                                                        setTimeout(() => {
                                                                                        btn.disabled = false;
                                                                                        btn.textContent = 'Thêm vào giỏ hàng';
                                                                                        btn.className = btn.className.replace('bg-green-600', 'bg-slate-900');
                                                                                        closeQuickView();
                                                                                        }, 1800);
                                                                                        } else {
                                                                                        btn.textContent = 'Hết hàng!';
                                                                                        btn.className = btn.className.replace('bg-slate-900', 'bg-red-500');
                                                                                        setTimeout(() => {
                                                                                        btn.disabled = false;
                                                                                        btn.textContent = 'Thêm vào giỏ hàng';
                                                                                        btn.className = btn.className.replace('bg-red-500', 'bg-slate-900');
                                                                                        }, 2000);
                                                                                        }
                                                                                        })
                                                                                        .catch(() => {
                                                                                        btn.disabled = false;
                                                                                        btn.textContent = 'Lỗi kết nối!';
                                                                                        setTimeout(() => { btn.textContent = 'Thêm vào giỏ hàng'; }, 2000);
                                                                                        });
                                                                                        };
                                                                                        })();
                                                                                        </script>

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

                                                                                        // ===== PRICE FILTER — DUAL RANGE =====

                                                                                        const PRICE_MAX = 500000000;
                                                                                        const PRICE_MIN_BOUND = 0;
                                                                                        const fmt = new Intl.NumberFormat('vi-VN');

                                                                                        // Parse formatted string like "200.000" → 200000
                                                                                        function parsePriceStr(str) {
                                                                                        return parseInt(str.replace(/\./g, '').replace(/,/g, '').trim()) || 0;
                                                                                        }

                                                                                        // Format number → "200.000"
                                                                                        function fmtPrice(v) {
                                                                                        return fmt.format(v);
                                                                                        }

                                                                                        // Auto-format while typing (insert dots)
                                                                                        function formatPriceInput(el) {
                                                                                        const raw = parsePriceStr(el.value);
                                                                                        const pos = el.selectionStart;
                                                                                        if (el.value !== '') {
                                                                                        el.value = fmtPrice(raw);
                                                                                        }
                                                                                        }

                                                                                        // Update the colored fill bar between the two thumbs
                                                                                        function updateRangeFill() {
                                                                                        const sMin = document.getElementById('sliderMin');
                                                                                        const sMax = document.getElementById('sliderMax');
                                                                                        const fill = document.getElementById('priceRangeFill');
                                                                                        if (!sMin || !sMax || !fill) return;
                                                                                        const minPct = (sMin.value / PRICE_MAX) * 100;
                                                                                        const maxPct = (sMax.value / PRICE_MAX) * 100;
                                                                                        fill.style.left = minPct + '%';
                                                                                        fill.style.width = (maxPct - minPct) + '%';
                                                                                        }

                                                                                        // Slider moved → sync text inputs + hidden fields
                                                                                        function onSliderChange() {
                                                                                        const sMin = document.getElementById('sliderMin');
                                                                                        const sMax = document.getElementById('sliderMax');
                                                                                        const minIn = document.getElementById('minPriceInput');
                                                                                        const maxIn = document.getElementById('maxPriceInput');
                                                                                        let minVal = parseInt(sMin.value);
                                                                                        let maxVal = parseInt(sMax.value);

                                                                                        // Clamp so min ≤ max
                                                                                        if (minVal > maxVal) {
                                                                                        if (this === sMin) { minVal = maxVal; sMin.value = maxVal; }
                                                                                        else              { maxVal = minVal; sMax.value = minVal; }
                                                                                        }

                                                                                        minIn.value = minVal > 0 ? fmtPrice(minVal) : '';
                                                                                        maxIn.value = maxVal < PRICE_MAX ? fmtPrice(maxVal) : '';
                                                                                        document.getElementById('minPriceHidden').value = minVal;
                                                                                        document.getElementById('maxPriceHidden').value = maxVal;
                                                                                        updateRangeFill();
                                                                                        }

                                                                                        // Text input changed → sync sliders + hidden fields
                                                                                        function syncFromInputs() {
                                                                                        const minIn = document.getElementById('minPriceInput');
                                                                                        const maxIn = document.getElementById('maxPriceInput');
                                                                                        let minVal = minIn.value === '' ? 0 : parsePriceStr(minIn.value);
                                                                                        let maxVal = maxIn.value === '' ? PRICE_MAX : parsePriceStr(maxIn.value);

                                                                                        // Clamp values
                                                                                        minVal = Math.max(PRICE_MIN_BOUND, Math.min(minVal, PRICE_MAX));
                                                                                        maxVal = Math.max(PRICE_MIN_BOUND, Math.min(maxVal, PRICE_MAX));
                                                                                        if (minVal > maxVal) { const tmp = minVal; minVal = maxVal; maxVal = tmp; }

                                                                                        minIn.value = minVal > 0 ? fmtPrice(minVal) : '';
                                                                                        maxIn.value = maxVal < PRICE_MAX ? fmtPrice(maxVal) : '';

                                                                                        document.getElementById('sliderMin').value = minVal;
                                                                                        document.getElementById('sliderMax').value = maxVal;
                                                                                        document.getElementById('minPriceHidden').value = minVal;
                                                                                        document.getElementById('maxPriceHidden').value = maxVal;
                                                                                        updateRangeFill();
                                                                                        }

                                                                                        // Apply button → submit with price params
                                                                                        function applyPriceFilter() {
                                                                                        syncFromInputs();
                                                                                        document.getElementById('filterForm').submit();
                                                                                        }

                                                                                        // Clear all price params and navigate clean
                                                                                        function clearPriceFilter() {
                                                                                        const minH = document.getElementById('minPriceHidden');
                                                                                        const maxH = document.getElementById('maxPriceHidden');
                                                                                        if (minH) minH.disabled = true;
                                                                                        if (maxH) maxH.disabled = true;
                                                                                        document.getElementById('filterForm').submit();
                                                                                        }

                                                                                        // Init fill bar on page load
                                                                                        document.addEventListener('DOMContentLoaded', function () {
                                                                                        updateRangeFill();
                                                                                        });

                                                                                        // ===== CATEGORY CLEAR =====
                                                                                        function clearCategory() {
                                                                                        const radios = document.getElementsByName('categoryId');
                                                                                        for (let i = 0; i < radios.length; i++) radios[i].checked = false;
                                                                                        document.getElementById('filterForm').submit();
                                                                                        }

                                                                                        // ===== CATEGORY CHANGE =====
                                                                                        function handleCategoryChange(radio) {
                                                                                        const form = document.getElementById('filterForm');

                                                                                        // ALWAYS remove categoryIndex and genderid hidden inputs when user picks
                                                                                        // a category from the sidebar. The categoryId param is sufficient for the
                                                                                        // servlet (Priority 3) and contains its own gender info via the DB.
                                                                                        // Keeping the old categoryIndex would cause the servlet to use Priority 2
                                                                                        // (categoryIndex+genderid) and ignore the new categoryId selection entirely.
                                                                                        const genderInput = form.querySelector('input[name="genderid"]');
                                                                                        const categoryIndexInput = form.querySelector('input[name="categoryIndex"]');
                                                                                        if (genderInput) genderInput.remove();
                                                                                        if (categoryIndexInput) categoryIndexInput.remove();

                                                                                        // Reset secondary filters for a clean navigation experience
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

                                                                                        // ===== (Legacy quick details removed to prevent conflicts) =====

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

                                                                                        // ===== CUSTOM SORT DROPDOWN =====
                                                                                        function toggleSortMenu() {
                                                                                        const menu = document.getElementById('sortMenu');
                                                                                        const chevron = document.getElementById('sortChevron');
                                                                                        const isVisible = !menu.classList.contains('invisible');

                                                                                        if (isVisible) {
                                                                                        menu.classList.add('opacity-0', 'invisible', 'scale-95');
                                                                                        menu.classList.remove('opacity-100', 'visible', 'scale-100');
                                                                                        chevron.style.transform = 'rotate(0deg)';
                                                                                        } else {
                                                                                        menu.classList.remove('opacity-0', 'invisible', 'scale-95');
                                                                                        menu.classList.add('opacity-100', 'visible', 'scale-100');
                                                                                        chevron.style.transform = 'rotate(180deg)';
                                                                                        }
                                                                                        }

                                                                                        function handleSortSelect(value) {
                                                                                        document.getElementById('sortHiddenInput').value = value;
                                                                                        document.getElementById('filterForm').submit();
                                                                                        }

                                                                                        // Close dropdown when clicking outside
                                                                                        document.addEventListener('click', function (event) {
                                                                                        const dropdown = document.getElementById('customSortDropdown');
                                                                                        const menu = document.getElementById('sortMenu');
                                                                                        const chevron = document.getElementById('sortChevron');

                                                                                        if (dropdown && !dropdown.contains(event.target)) {
                                                                                        menu.classList.add('opacity-0', 'invisible', 'scale-95');
                                                                                        menu.classList.remove('opacity-100', 'visible', 'scale-100');
                                                                                        if (chevron) chevron.style.transform = 'rotate(0deg)';
                                                                                        }
                                                                                        });
                                                                                        </script>



                                                                                        </body>

                                                                                        </html>
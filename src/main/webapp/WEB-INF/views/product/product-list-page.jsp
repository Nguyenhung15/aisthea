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
                    </style>
                </head>

                <body
                    class="font-display text-slate-800 bg-gradient-to-b from-white to-sky-pale min-h-screen dark:from-background-dark dark:to-slate-900 dark:text-slate-100">

                    <!-- Navigation -->
                    <nav class="sticky top-0 z-50 glass-panel border-b border-white/20">
                        <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
                            <div class="flex items-center space-x-8 hidden md:flex">
                                <a class="text-sm font-medium hover:text-primary transition-colors"
                                    href="${pageContext.request.contextPath}/product?sort=newest">New Arrivals</a>
                                <a class="text-sm font-medium hover:text-primary transition-colors"
                                    href="${pageContext.request.contextPath}/product">Collection</a>
                                <a class="text-sm font-medium hover:text-primary transition-colors"
                                    href="#">Editorial</a>
                            </div>
                            <button class="md:hidden text-slate-800 dark:text-white">
                                <span class="material-icons-outlined">menu</span>
                            </button>
                            <div class="absolute left-1/2 transform -translate-x-1/2">
                                <a class="text-2xl font-bold tracking-[0.2em] text-primary dark:text-white"
                                    href="${pageContext.request.contextPath}/">AISTHÉA</a>
                            </div>
                            <div class="flex items-center space-x-6">
                                <button class="text-slate-600 hover:text-primary transition-colors dark:text-slate-300">
                                    <span class="material-icons-outlined">search</span>
                                </button>
                                <button class="text-slate-600 hover:text-primary transition-colors dark:text-slate-300">
                                    <span class="material-icons-outlined">favorite_border</span>
                                </button>
                                <button onclick="window.location.href='${pageContext.request.contextPath}/cart'"
                                    class="text-slate-600 hover:text-primary transition-colors relative dark:text-slate-300">
                                    <span class="material-icons-outlined">shopping_bag</span>
                                    <c:if test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
                                        <span
                                            class="absolute -top-1 -right-1 h-4 w-4 bg-primary text-white text-[10px] flex items-center justify-center rounded-full">
                                            ${sessionScope.cart.size()}
                                        </span>
                                    </c:if>
                                </button>
                            </div>
                        </div>
                    </nav>

                    <form id="filterForm" action="${pageContext.request.contextPath}/product" method="get">
                        <div class="max-w-[1600px] mx-auto px-4 md:px-8 mt-6">
                            <nav aria-label="Breadcrumb"
                                class="text-xs font-medium text-primary-light/70 uppercase tracking-widest">
                                <ol class="list-none p-0 inline-flex">
                                    <li class="flex items-center">
                                        <a class="hover:text-primary transition-colors"
                                            href="${pageContext.request.contextPath}/">Home</a>
                                        <span class="mx-2">/</span>
                                    </li>
                                    <li class="flex items-center">
                                        <a class="hover:text-primary transition-colors"
                                            href="${pageContext.request.contextPath}/product">Collection</a>
                                        <span class="mx-2">/</span>
                                    </li>
                                    <li class="flex items-center text-primary font-bold">
                                        <c:choose>
                                            <c:when test="${not empty displayCategory}">${displayCategory.name}</c:when>
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
                                <h1
                                    class="font-serif text-5xl md:text-6xl text-slate-900 dark:text-white mb-6 tracking-tight">
                                    <c:choose>
                                        <c:when test="${not empty displayCategory}">${displayCategory.name}</c:when>
                                        <c:when test="${not empty displayCategoryName}">${displayCategoryName}</c:when>
                                        <c:otherwise>SUMMER COLLECTION</c:otherwise>
                                    </c:choose>
                                </h1>

                                <c:if test="${not empty displayCategory or not empty param.maxPrice}">
                                    <div class="flex items-center flex-wrap gap-3">
                                        <span
                                            class="text-sm font-medium text-slate-500 mr-2 uppercase tracking-wide">Active
                                            Filters:</span>

                                        <c:if test="${not empty displayCategory}">
                                            <span
                                                class="inline-flex items-center px-4 py-1.5 rounded-full text-xs font-medium bg-primary-light text-white shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                ${displayCategory.name}
                                                <button type="button" onclick="clearCategory()"
                                                    class="ml-2 hover:text-white/80 transition-colors"><span
                                                        class="material-icons-outlined text-[14px]">close</span></button>
                                            </span>
                                        </c:if>

                                        <c:if test="${not empty param.maxPrice}">
                                            <span
                                                class="inline-flex items-center px-4 py-1.5 rounded-full text-xs font-medium bg-primary-light text-white shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                Wait Max
                                                <fmt:formatNumber value="${param.maxPrice}" type="currency"
                                                    currencySymbol="$" />
                                                <button type="button" onclick="clearPrice()"
                                                    class="ml-2 hover:text-white/80 transition-colors"><span
                                                        class="material-icons-outlined text-[14px]">close</span></button>
                                            </span>
                                        </c:if>

                                        <a href="${pageContext.request.contextPath}/product"
                                            class="text-xs text-slate-500 hover:text-primary underline ml-2 transition-colors">Clear
                                            all</a>
                                    </div>
                                </c:if>
                            </div>

                            <div class="flex flex-col lg:flex-row gap-12">
                                <!-- Sidebar -->
                                <aside class="w-full lg:w-1/4 flex-shrink-0">
                                    <div
                                        class="sticky top-28 glass-sidebar rounded-xl p-6 lg:h-[calc(100vh-8rem)] overflow-y-auto scrollbar-hide">
                                        <div class="flex items-center justify-between mb-8">
                                            <h2 class="text-lg font-semibold tracking-wide">Filters</h2>
                                        </div>
                                        <div class="space-y-8">
                                            <!-- Category Filter -->
                                            <div class="border-b border-primary/10 pb-6">
                                                <button type="button"
                                                    class="flex items-center justify-between w-full group mb-4">
                                                    <span
                                                        class="font-medium text-slate-800 dark:text-slate-200">Category</span>
                                                    <span
                                                        class="material-icons-outlined text-slate-400 group-hover:text-primary transition-colors">expand_less</span>
                                                </button>
                                                <div class="space-y-3 pl-1">
                                                    <!-- All Categories Option -->
                                                    <label class="flex items-center space-x-3 cursor-pointer group">
                                                        <input type="radio" name="categoryId" value=""
                                                            onchange="this.form.submit()"
                                                            class="form-radio h-4 w-4 text-primary rounded-full border-slate-300 focus:ring-primary/50 bg-white/50"
                                                            ${empty param.categoryId ? 'checked' : '' } />
                                                        <span
                                                            class="text-sm text-slate-600 group-hover:text-primary transition-colors dark:text-slate-400">All
                                                            Categories</span>
                                                    </label>

                                                    <!-- Nam -->
                                                    <div class="mt-3">
                                                        <span
                                                            class="text-xs font-bold uppercase tracking-wider text-primary mb-2 block">Nam</span>
                                                        <div class="space-y-2 pl-2">
                                                            <c:forEach items="${categories}" var="cat">
                                                                <c:if test="${cat.genderid == 1}">
                                                                    <label
                                                                        class="flex items-center space-x-3 cursor-pointer group">
                                                                        <input type="radio" name="categoryId"
                                                                            value="${cat.categoryid}"
                                                                            onchange="this.form.submit()"
                                                                            class="form-radio h-4 w-4 text-primary rounded-full border-slate-300 focus:ring-primary/50 bg-white/50"
                                                                            ${param.categoryId==cat.categoryid
                                                                            ? 'checked' : '' } />
                                                                        <span
                                                                            class="text-sm text-slate-600 group-hover:text-primary transition-colors dark:text-slate-400">${cat.name}</span>
                                                                    </label>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </div>

                                                    <!-- Nữ -->
                                                    <div class="mt-3">
                                                        <span
                                                            class="text-xs font-bold uppercase tracking-wider text-primary mb-2 block">Nữ</span>
                                                        <div class="space-y-2 pl-2">
                                                            <c:forEach items="${categories}" var="cat">
                                                                <c:if test="${cat.genderid == 2}">
                                                                    <label
                                                                        class="flex items-center space-x-3 cursor-pointer group">
                                                                        <input type="radio" name="categoryId"
                                                                            value="${cat.categoryid}"
                                                                            onchange="this.form.submit()"
                                                                            class="form-radio h-4 w-4 text-primary rounded-full border-slate-300 focus:ring-primary/50 bg-white/50"
                                                                            ${param.categoryId==cat.categoryid
                                                                            ? 'checked' : '' } />
                                                                        <span
                                                                            class="text-sm text-slate-600 group-hover:text-primary transition-colors dark:text-slate-400">${cat.name}</span>
                                                                    </label>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Price Filter -->
                                            <div class="border-b border-primary/10 pb-6">
                                                <button type="button"
                                                    class="flex items-center justify-between w-full group mb-4">
                                                    <span
                                                        class="font-medium text-slate-800 dark:text-slate-200">Price</span>
                                                    <span
                                                        class="material-icons-outlined text-slate-400 group-hover:text-primary transition-colors">expand_less</span>
                                                </button>
                                                <div class="px-1">
                                                    <input name="maxPrice"
                                                        class="w-full h-1 bg-slate-200 rounded-lg appearance-none cursor-pointer dark:bg-slate-700"
                                                        type="range" min="0" max="500000000" step="500000"
                                                        value="${not empty param.maxPrice ? param.maxPrice : 500000000}"
                                                        oninput="updatePriceLabel(this.value)"
                                                        onchange="this.form.submit()" />
                                                    <div
                                                        class="flex items-center justify-between mt-4 text-sm font-medium text-slate-600 dark:text-slate-400">
                                                        <span>0₫</span>
                                                        <span id="priceLabel" class="text-primary">
                                                            <fmt:formatNumber
                                                                value="${not empty param.maxPrice ? param.maxPrice : 500000000}"
                                                                type="number" groupingUsed="true" />₫
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Color Filter (Static for now) -->
                                            <div class="border-b border-primary/10 pb-6">
                                                <span
                                                    class="block font-medium text-slate-800 dark:text-slate-200 mb-4">Color</span>
                                                <div class="flex flex-wrap gap-3">
                                                    <button type="button"
                                                        class="w-8 h-8 rounded-full bg-slate-900 border border-slate-200 hover:scale-110 transition-transform active-swatch"></button>
                                                    <button type="button"
                                                        class="w-8 h-8 rounded-full bg-white border border-slate-300 hover:scale-110 transition-transform shadow-sm"></button>
                                                    <button type="button"
                                                        class="w-8 h-8 rounded-full bg-[#B2967D] border border-slate-200 hover:scale-110 transition-transform"></button>
                                                    <button type="button"
                                                        class="w-8 h-8 rounded-full bg-[#8FA3AD] border border-slate-200 hover:scale-110 transition-transform"></button>
                                                    <button type="button"
                                                        class="w-8 h-8 rounded-full bg-[#C25E5E] border border-slate-200 hover:scale-110 transition-transform"></button>
                                                </div>
                                            </div>

                                            <!-- Size Filter (Static for now) -->
                                            <div>
                                                <span
                                                    class="block font-medium text-slate-800 dark:text-slate-200 mb-4">Size</span>
                                                <div class="grid grid-cols-4 gap-2">
                                                    <button type="button"
                                                        class="h-10 rounded-lg border border-slate-200 text-sm font-medium hover:border-primary hover:text-primary transition-colors bg-white/50 dark:bg-slate-800 dark:border-slate-700 dark:hover:border-primary">XS</button>
                                                    <button type="button"
                                                        class="h-10 rounded-lg border border-slate-200 text-sm font-medium hover:border-primary hover:text-primary transition-colors bg-white/50 dark:bg-slate-800 dark:border-slate-700 dark:hover:border-primary">S</button>
                                                    <button type="button"
                                                        class="h-10 rounded-lg border border-primary bg-primary text-white text-sm font-medium shadow-glow">M</button>
                                                    <button type="button"
                                                        class="h-10 rounded-lg border border-slate-200 text-sm font-medium hover:border-primary hover:text-primary transition-colors bg-white/50 dark:bg-slate-800 dark:border-slate-700 dark:hover:border-primary">L</button>
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
                                                <option value="featured" ${param.sort=='featured' ? 'selected' : '' }>
                                                    Featured</option>
                                                <option value="price_asc" ${param.sort=='price_asc' ? 'selected' : '' }>
                                                    Price: Low to High</option>
                                                <option value="price_desc" ${param.sort=='price_desc' ? 'selected' : ''
                                                    }>
                                                    Price: High to Low</option>
                                                <option value="newest" ${param.sort=='newest' ? 'selected' : '' }>Newest
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
                                                            <h2
                                                                class="text-base font-bold text-slate-900 group-hover:text-primary transition-colors dark:text-white leading-tight min-h-[1.5rem]">
                                                                <a
                                                                    href="${pageContext.request.contextPath}/product?action=view&id=${p.productId}">${p.name}</a>
                                                            </h2>
                                                            <div class="flex items-center space-x-2">
                                                                <span class="text-primary font-semibold text-sm">
                                                                    <c:choose>
                                                                        <c:when test="${not empty p.price}">
                                                                            <fmt:formatNumber value="${p.price}"
                                                                                type="number" groupingUsed="true" />₫
                                                                        </c:when>
                                                                        <c:otherwise>0₫</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                            <!-- Color Swatches -->
                                                            <div class="flex flex-wrap gap-1.5 pt-2"
                                                                id="swatches-${p.productId}">
                                                                <c:forEach items="${p.images}" var="img"
                                                                    varStatus="imgStat">
                                                                    <c:if test="${not empty img.color}">
                                                                        <button type="button"
                                                                            onclick="changeProductImage(${p.productId}, '${img.imageUrl}')"
                                                                            class="w-5 h-5 rounded-full border border-slate-300 shadow-sm transition-transform hover:scale-110 focus:outline-none focus:ring-1 focus:ring-primary focus:ring-offset-1"
                                                                            style="background-color: ${img.color}; background-image: linear-gradient(135deg, rgba(255,255,255,0.4) 0%, rgba(0,0,0,0.05) 100%);"
                                                                            title="${img.color}">
                                                                        </button>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Empty State -->
                                            <div class="text-center py-20 flex flex-col items-center justify-center">
                                                <div
                                                    class="w-20 h-20 bg-slate-100 rounded-full flex items-center justify-center mb-6 text-slate-300">
                                                    <span class="material-icons-outlined text-4xl">inventory_2</span>
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
                                                <button onclick="changePage(${currentPage > 1 ? currentPage - 1 : 1})"
                                                    class="w-10 h-10 flex items-center justify-center rounded-full bg-white border border-slate-200 text-slate-500 hover:border-primary hover:text-primary transition-colors ${currentPage == 1 ? 'opacity-50 cursor-not-allowed' : ''}"
                                                    ${currentPage==1 ? 'disabled' : '' }>
                                                    <span class="material-icons-outlined text-sm">chevron_left</span>
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
                                                    <span class="material-icons-outlined text-sm">chevron_right</span>
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

                    <!-- Footer -->
                    <footer
                        class="bg-white/80 backdrop-blur-md border-t border-slate-100 mt-20 dark:bg-slate-900/80 dark:border-slate-800">
                        <div class="max-w-7xl mx-auto px-8 py-12">
                            <div class="flex flex-col md:flex-row justify-between items-center">
                                <div class="mb-4 md:mb-0">
                                    <span
                                        class="text-xl font-bold tracking-[0.2em] text-slate-800 dark:text-white">AISTHÉA</span>
                                </div>
                                <div class="flex space-x-6 text-sm text-slate-500">
                                    <a class="hover:text-primary" href="#">About</a>
                                    <a class="hover:text-primary" href="#">Customer Care</a>
                                    <a class="hover:text-primary" href="#">Privacy</a>
                                    <a class="hover:text-primary" href="#">Terms</a>
                                </div>
                                <div class="mt-4 md:mt-0 text-xs text-slate-400">
                                    © 2023 Aisthea. All rights reserved.
                                </div>
                            </div>
                        </div>
                    </footer>

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
                        function updatePriceLabel(value) {
                            // Format as Currency
                            const formatter = new Intl.NumberFormat('en-US', {
                                style: 'currency',
                                currency: 'USD', // Matching user template's currency
                                maximumFractionDigits: 0
                            });
                            document.getElementById('priceLabel').innerText = formatter.format(value);
                        }

                        function clearCategory() {
                            const radios = document.getElementsByName("categoryId");
                            for (let i = 0; i < radios.length; i++) radios[i].checked = false;
                            // Check "All"
                            if (radios.length > 0) radios[0].checked = true;
                            document.getElementById("filterForm").submit();
                        }

                        function clearPrice() {
                            // Reset to max
                            const input = document.querySelector('input[name="maxPrice"]');
                            input.value = 10000000;
                            input.disabled = true; // disable to remove from submission or set to high val
                            document.getElementById("filterForm").submit();
                        }

                        // Quick View Logic
                        function quickView(productId) {
                            const modal = document.getElementById('quickViewModal');
                            const content = document.getElementById('quickViewContent');

                            modal.classList.remove('hidden');

                            // Show Loading
                            content.innerHTML = `
            <div class="flex flex-col items-center">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mb-4"></div>
                <p class="text-slate-400 text-sm tracking-wide">LOADING...</p>
            </div>
        `;

                            // Fetch Content
                            fetch('${pageContext.request.contextPath}/product?action=view&id=' + productId)
                                .then(response => response.text())
                                .then(html => {
                                    // Extract just the product detail part using DOMParser
                                    const parser = new DOMParser();
                                    const doc = parser.parseFromString(html, 'text/html');
                                    // You usually need to target the main container of the detail page
                                    // Assuming detail page has a specific class or ID, or we just take body
                                    // For now, let's take a guess or improvements
                                    // We'll wrap the fetched content in a scrollable div
                                    content.innerHTML = '<div class="prose max-w-none">' + html + '</div>';

                                    // Optional: Clean up full page elements if fetching full page
                                    const scripts = content.querySelectorAll('script');
                                    scripts.forEach(s => s.remove());
                                })
                                .catch(err => {
                                    content.innerHTML = '<p class="text-red-500 text-center">Failed to load product details.</p>';
                                });
                        }

                        function closeQuickView() {
                            document.getElementById('quickViewModal').classList.add('hidden');
                        }

                        // Close modal on click outside
                        document.getElementById('quickViewModal').addEventListener('click', function (e) {
                            if (e.target === this.firstElementChild) { // Check if clicking backdrop
                                closeQuickView();
                            }
                        });

                        // Change product image when clicking color swatch
                        function changeProductImage(productId, imageUrl) {
                            const card = document.querySelector('#swatches-' + productId);
                            if (card) {
                                const productCard = card.closest('.group');
                                if (productCard) {
                                    // Find image container (relative div containing images)
                                    const imgContainer = productCard.querySelector('.relative');
                                    if (imgContainer) {
                                        const imgs = imgContainer.querySelectorAll('img');
                                        if (imgs.length > 0) {
                                            const primary = imgs[0];
                                            primary.src = imageUrl;
                                            // Remove hover opacity effect so this new image stays visible even when hovering
                                            primary.classList.remove('group-hover:opacity-0');

                                            // Hide the secondary hover image if it exists
                                            if (imgs.length > 1) {
                                                const hoverImg = imgs[1];
                                                hoverImg.style.display = 'none';
                                            }
                                        }
                                    }
                                }
                                // Highlight active swatch
                                const swatches = card.querySelectorAll('button');
                                swatches.forEach(s => s.classList.remove('ring-2', 'ring-primary', 'ring-offset-1'));
                                event.target.classList.add('ring-2', 'ring-primary', 'ring-offset-1');
                            }
                        }

                        // Update price label with VND format
                        function updatePriceLabel(value) {
                            const formatted = new Intl.NumberFormat('vi-VN').format(value) + '\u20ab';
                            document.getElementById('priceLabel').textContent = formatted;
                        }
                    </script>

                </body>

                </html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <fmt:setLocale value="vi_VN" />
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>AISTHÉA | ${not empty product.name ? product.name : 'Product Detail'}</title>

                    <!-- Fonts & Icons -->
                    <link href="https://fonts.googleapis.com" rel="preconnect" />
                    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap"
                        rel="stylesheet" />
                    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                        rel="stylesheet" />
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
                        rel="stylesheet" />

                    <!-- Tailwind -->
                    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                    <script id="tailwind-config">
                        tailwind.config = {
                            darkMode: "class",
                            theme: {
                                extend: {
                                    colors: {
                                        "primary": "#1a1a1a",
                                        "accent": "#c5a059",
                                        "primary-light": "#333333",
                                        "sky-pale": "#f8f8f8",
                                        "background-light": "#ffffff",
                                        "background-dark": "#0f1623",
                                    },
                                    fontFamily: {
                                        "display": ["Manrope", "sans-serif"],
                                        "serif": ["Bodoni Moda", "serif"]
                                    },
                                    borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
                                    boxShadow: {
                                        'glass': '0 8px 32px 0 rgba(0, 0, 0, 0.03)',
                                        'glow': '0 0 15px rgba(197, 160, 89, 0.1)',
                                        'lift': '0 20px 40px -10px rgba(0, 0, 0, 0.05)',
                                    }
                                },
                            },
                        }
                    </script>

                    <style>
                        /* ── Base font override ── */
                        body, button, input, select, textarea {
                            font-family: 'Manrope', sans-serif;
                        }

                        .glass-panel {
                            background: rgba(255, 255, 255, 0.7);
                            -webkit-backdrop-filter: blur(12px);
                            backdrop-filter: blur(12px);
                            border: 1px solid rgba(255, 255, 255, 0.5);
                        }

                        .liquid-bg {
                            background: linear-gradient(135deg, #f8fcfd 0%, #eef6fa 50%, #fdfdfd 100%);
                        }

                        .custom-scrollbar::-webkit-scrollbar {
                            width: 4px;
                        }

                        .custom-scrollbar::-webkit-scrollbar-track {
                            background: transparent;
                        }

                        .custom-scrollbar::-webkit-scrollbar-thumb {
                            background: #e2e8f0;
                            border-radius: 10px;
                        }

                        .star-filled {
                            font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                            color: #c5a059;
                        }

                        .star-filled-primary {
                            font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                            color: #024acf;
                        }

                        .btn-luxury {
                            position: relative;
                            overflow: hidden;
                            transition: all 0.5s cubic-bezier(0.19, 1, 0.22, 1);
                        }

                        .btn-luxury:hover {
                            letter-spacing: 0.15em;
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

                        /* Accordion */
                        .accordion-item.active .accordion-content {
                            display: block;
                        }

                        .accordion-item.active .accordion-icon {
                            transform: rotate(45deg);
                        }

                        .accordion-icon {
                            transition: transform 0.3s ease;
                        }

                        /* Rating bars */
                        .rating-bar-fill {
                            transition: width 0.8s ease;
                        }
                    </style>
                </head>

                <body
                    class="font-display text-slate-800 liquid-bg min-h-screen selection:bg-blue-100 selection:text-blue-900">

                    <!-- Header (shared with product-list page) -->
                    <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                    <%-- Image URL resolving --%>
                        <c:set var="placeholderImg" value="https://placehold.co/600x800/eee/ccc?text=No+Image" />
                        <c:set var="primaryImgUrl" value="${placeholderImg}" />

                        <c:if test="${not empty images}">
                            <c:set var="foundPrimary" value="false" />
                            <c:forEach var="img" items="${images}">
                                <c:if test="${img.primary and not foundPrimary}">
                                    <c:set var="rawUrl" value="${img.imageUrl}" />
                                    <c:choose>
                                        <c:when
                                            test="${not empty rawUrl and (fn:startsWith(rawUrl, 'http') or fn:startsWith(rawUrl, '/'))}">
                                            <c:set var="primaryImgUrl" value="${rawUrl}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="primaryImgUrl"
                                                value="${pageContext.request.contextPath}/uploads/${rawUrl}" />
                                        </c:otherwise>
                                    </c:choose>
                                    <c:set var="foundPrimary" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:if test="${not foundPrimary and not empty images[0]}">
                                <c:set var="rawUrl" value="${images[0].imageUrl}" />
                                <c:choose>
                                    <c:when
                                        test="${not empty rawUrl and (fn:startsWith(rawUrl, 'http') or fn:startsWith(rawUrl, '/'))}">
                                        <c:set var="primaryImgUrl" value="${rawUrl}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="primaryImgUrl"
                                            value="${pageContext.request.contextPath}/uploads/${rawUrl}" />
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:if>

                        <main class="relative pt-8 pb-20 px-4 md:px-8 min-h-screen">

                            <!-- ======= PRODUCT DETAIL SECTION ======= -->
                            <div
                                class="max-w-[1400px] mx-auto w-full grid grid-cols-1 lg:grid-cols-12 gap-8 xl:gap-16 relative z-10">


                                <!-- Left: Images -->
                                <div class="lg:col-span-7 flex flex-col gap-4">
                                    <div
                                        class="relative w-full max-w-xl mx-auto aspect-[4/5] overflow-hidden rounded-sm bg-white shadow-sm group cursor-crosshair"
                                        onmousemove="zoomImage(event, this)"
                                        onmouseleave="resetZoom(this)">
                                        <img id="mainImage" src="${primaryImgUrl}" alt="${product.name}"
                                            class="w-full h-full object-cover origin-center transition-transform hover:duration-200 duration-500 ease-out group-hover:scale-[2]"
                                            onerror="this.src='${placeholderImg}'">
                                            
                                        <!-- Prev / Next Buttons -->
                                        <button onclick="prevImage(event)" class="absolute left-4 top-1/2 -translate-y-1/2 w-10 h-10 flex items-center justify-center bg-white/70 hover:bg-white text-slate-800 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition-all z-10 transition-colors">
                                            <span class="material-icons-outlined">chevron_left</span>
                                        </button>
                                        <button onclick="nextImage(event)" class="absolute right-4 top-1/2 -translate-y-1/2 w-10 h-10 flex items-center justify-center bg-white/70 hover:bg-white text-slate-800 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition-all z-10 transition-colors">
                                            <span class="material-icons-outlined">chevron_right</span>
                                        </button>
                                    </div>

                                    <div class="relative w-full max-w-xl mx-auto group/thumbs">
                                        <!-- Prev Button Thumbnails -->
                                        <button onclick="scrollThumbs('left')" class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-white border border-slate-100 text-slate-800 rounded-full shadow-md opacity-0 group-hover/thumbs:opacity-100 transition-all z-10 hover:bg-slate-50 hover:scale-105 pointer-events-auto">
                                            <span class="material-icons-outlined text-[18px]">chevron_left</span>
                                        </button>

                                        <div class="flex gap-3 overflow-x-auto pb-1 pt-1 w-full [scrollbar-width:none] [&::-webkit-scrollbar]:hidden scroll-smooth" id="thumbnail-container">
                                            <c:forEach var="img" items="${images}">
                                                <c:set var="thumbUrl" value="${img.imageUrl}" />
                                                <c:if
                                                    test="${not empty thumbUrl and not fn:startsWith(thumbUrl, 'http') and not fn:startsWith(thumbUrl, '/')}">
                                                    <c:set var="thumbUrl"
                                                        value="${pageContext.request.contextPath}/uploads/${thumbUrl}" />
                                                </c:if>
                                                <div class="flex-shrink-0 w-20 aspect-[3/4] overflow-hidden rounded-sm cursor-pointer border-2 border-transparent hover:border-slate-800 transition-colors thumbnail-item opacity-70 hover:opacity-100"
                                                    data-color="${img.color}"
                                                    onclick="changeImage('${thumbUrl}')">
                                                    <img src="${thumbUrl}" alt="Thumbnail"
                                                        class="w-full h-full object-cover"
                                                        onerror="this.src='${placeholderImg}'">
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <!-- Next Button Thumbnails -->
                                        <button onclick="scrollThumbs('right')" class="absolute right-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-white border border-slate-100 text-slate-800 rounded-full shadow-md opacity-0 group-hover/thumbs:opacity-100 transition-all z-10 hover:bg-slate-50 hover:scale-105 pointer-events-auto">
                                            <span class="material-icons-outlined text-[18px]">chevron_right</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- Right: Info -->
                                <div class="lg:col-span-5 flex flex-col pt-4 lg:pt-8 lg:sticky lg:top-28 h-fit">

                                    <!-- Breadcrumb -->
                                    <nav aria-label="Breadcrumb"
                                        class="flex items-center flex-wrap text-[10px] uppercase tracking-[0.2em] text-slate-400 mb-4 font-bold gap-1 mt-0">
                                        <%-- Level 1: Home --%>
                                            <a class="hover:text-primary transition-colors"
                                                href="${pageContext.request.contextPath}/home">Home</a>
                                            <span class="mx-2 text-slate-300">/</span>

                                            <%-- Level 2: Gender (NAM / NỮ) --%>
                                                <c:choose>
                                                    <c:when test="${not empty genderLabel}">
                                                        <a class="hover:text-primary transition-colors"
                                                            href="${pageContext.request.contextPath}/product?genderid=${genderId}">${genderLabel}</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a class="hover:text-primary transition-colors"
                                                            href="${pageContext.request.contextPath}/product">Collection</a>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="mx-2 text-slate-300">/</span>

                                                <%-- Level 3: Parent Category (only when product belongs to a child
                                                    category) --%>
                                                    <c:if test="${not empty parentCategory}">
                                                        <a class="hover:text-primary transition-colors"
                                                            href="${pageContext.request.contextPath}/product?categoryId=${parentCategory.categoryid}">
                                                            ${parentCategory.name}
                                                        </a>
                                                        <span class="mx-2 text-slate-300">/</span>
                                                    </c:if>

                                                    <%-- Level 4: Category of this product (clickable) --%>
                                                        <c:if test="${not empty product.category}">
                                                            <a class="hover:text-primary transition-colors"
                                                                href="${pageContext.request.contextPath}/product?categoryId=${product.category.categoryid}">
                                                                ${product.category.name}
                                                            </a>
                                                            <span class="mx-2 text-slate-300">/</span>
                                                        </c:if>

                                                        <%-- Level 5: Product Name (current, not clickable) --%>
                                                            <span class="text-slate-800 truncate max-w-[180px]"
                                                                title="${product.name}">${product.name}</span>
                                    </nav>

                                    <!-- Product Name -->
                                    <h1 class="font-serif text-5xl md:text-6xl text-slate-900 leading-[1.1] mb-4">
                                        ${product.name}
                                    </h1>

                                    <!-- Price & Rating -->
                                    <div class="flex items-center justify-between mb-6 border-b border-slate-100 pb-5">
                                        <span class="text-3xl text-primary font-bold">
                                            <c:choose>
                                                <c:when test="${not empty product.price}">
                                                    <fmt:formatNumber value="${product.price}" type="number"
                                                        groupingUsed="true" />₫
                                                </c:when>
                                                <c:otherwise>0₫</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <c:set var="totalStars" value="0" />
                                        <c:set var="totalCount" value="${fn:length(feedbacks)}" />
                                        <c:forEach var="f" items="${feedbacks}">
                                            <c:set var="totalStars" value="${totalStars + f.rating}" />
                                        </c:forEach>
                                        <c:set var="finalAvg" value="${totalCount > 0 ? totalStars / totalCount : 0}" />

                                        <div class="flex items-center gap-1">
                                            <div class="flex gap-0.5">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span
                                                        class="material-symbols-outlined text-sm ${i <= finalAvg ? 'star-filled-primary' : 'text-slate-200'}">star</span>
                                                </c:forEach>
                                            </div>
                                            <span
                                                class="text-[10px] text-slate-400 ml-2 font-bold tracking-widest uppercase">
                                                (${totalCount} Đánh giá)
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Description -->
                                    <p class="text-slate-500 font-medium leading-relaxed mb-10 text-sm">
                                        ${product.description}
                                    </p>

                                    <!-- Cart Form -->
                                    <form id="cartForm" action="${pageContext.request.contextPath}/cart" method="POST"
                                        class="space-y-8">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        <input type="hidden" id="productImageUrlHidden" name="imageUrl"
                                            value="${primaryImgUrl}">
                                        <input type="hidden" id="quantityHidden" name="quantity" value="1">
                                        <input type="hidden" id="selectedPCSId" name="productColorSizeId" value="">

                                        <!-- Color Selection -->
                                        <div>
                                            <span
                                                class="block text-[10px] font-extrabold uppercase tracking-[0.25em] text-slate-900 mb-5">Select
                                                Color</span>
                                            <div class="flex gap-4" id="color-options">
                                                <!-- Dynamic load via JS -->
                                            </div>
                                        </div>

                                        <!-- Size Selection -->
                                        <div>
                                            <div class="flex justify-between items-center mb-5">
                                                <span
                                                    class="block text-[10px] font-extrabold uppercase tracking-[0.25em] text-slate-900">Select
                                                    Size</span>
                                                <button type="button"
                                                    class="text-[10px] uppercase tracking-widest text-primary border-b border-primary/30 hover:border-primary transition-colors font-bold">Size
                                                    Guide</button>
                                            </div>
                                            <div class="grid grid-cols-4 gap-3" id="size-options">
                                                <!-- Dynamic load via JS -->
                                            </div>
                                        </div>

                                        <!-- Quantity & Actions -->
                                        <div class="pt-2 space-y-5">
                                            <div class="flex items-center gap-6">
                                                <div
                                                    class="flex items-center border border-slate-200 overflow-hidden h-12">
                                                    <button type="button" id="minusBtn"
                                                        class="w-12 h-full flex items-center justify-center hover:bg-slate-50 text-slate-900 transition-colors disabled:opacity-30">
                                                        <i class="fa-solid fa-minus text-[10px]"></i>
                                                    </button>
                                                    <input type="text" id="quantityInput" value="1"
                                                        class="w-12 h-full text-center border-0 text-sm font-bold text-slate-900 focus:ring-0">
                                                    <button type="button" id="plusBtn"
                                                        class="w-12 h-full flex items-center justify-center hover:bg-slate-50 text-slate-900 transition-colors disabled:opacity-30">
                                                        <i class="fa-solid fa-plus text-[10px]"></i>
                                                    </button>
                                                </div>
                                                <span id="stock-info"
                                                    class="text-[10px] font-bold uppercase tracking-[0.15em] text-slate-400"></span>
                                            </div>

                                            <div class="flex flex-col gap-4">
                                                <button type="submit" id="add-to-cart-btn" disabled
                                                    class="btn-luxury w-full py-5 bg-primary text-white text-[11px] font-extrabold tracking-[0.25em] uppercase hover:shadow-xl hover:shadow-primary/20 transition-all flex items-center justify-center gap-3 disabled:bg-slate-200 disabled:shadow-none disabled:text-slate-400 disabled:cursor-not-allowed">
                                                    <span>Add to Cart</span>
                                                    <span
                                                        class="material-symbols-outlined text-base">shopping_bag</span>
                                                </button>
                                                <button type="submit" id="buy-now-btn"
                                                    onclick="document.querySelector('input[name=action]').value='buy'"
                                                    disabled
                                                    class="w-full py-5 border border-slate-900 text-slate-900 text-[11px] font-extrabold tracking-[0.25em] uppercase hover:bg-slate-900 hover:text-white transition-all disabled:opacity-30 disabled:hover:bg-transparent disabled:hover:text-slate-900 disabled:cursor-not-allowed">
                                                    Buy Now
                                                </button>
                                            </div>

                                            <div id="stock-error"
                                                class="hidden text-red-500 text-[10px] font-bold uppercase tracking-widest text-center">
                                                Selected quantity exceeds stock limits
                                            </div>
                                        </div>
                                    </form>

                                    <!-- Accordions -->
                                    <div class="mt-10 border-t border-slate-100">
                                        <div class="accordion-item py-5 border-b border-slate-100">
                                            <div class="flex justify-between items-center cursor-pointer"
                                                onclick="toggleAccordionItem(this.parentElement)">
                                                <span
                                                    class="text-[11px] font-extrabold uppercase tracking-[0.2em] text-slate-900">Composition
                                                    &amp; Care</span>
                                                <span
                                                    class="material-symbols-outlined text-slate-400 accordion-icon text-lg">add</span>
                                            </div>
                                            <div
                                                class="accordion-content hidden mt-4 text-xs text-slate-500 leading-relaxed font-medium">
                                                100% Mongolian Cashmere. Crafted with traditional weaving techniques.
                                                <br><br>
                                                • Hand wash cold or professional dry clean<br>
                                                • Do not tumble dry<br>
                                                • Iron at low temperature
                                            </div>
                                        </div>
                                        <div class="accordion-item py-5 border-b border-slate-100">
                                            <div class="flex justify-between items-center cursor-pointer"
                                                onclick="toggleAccordionItem(this.parentElement)">
                                                <span
                                                    class="text-[11px] font-extrabold uppercase tracking-[0.2em] text-slate-900">Shipping
                                                    &amp; Returns</span>
                                                <span
                                                    class="material-symbols-outlined text-slate-400 accordion-icon text-lg">add</span>
                                            </div>
                                            <div
                                                class="accordion-content hidden mt-4 text-xs text-slate-500 leading-relaxed font-medium">
                                                Complimentary express shipping on all orders over 5.000.000₫. Secure
                                                signature delivery.
                                                Returns accepted within 14 days in original condition with all tags
                                                attached.
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <!-- ======= REVIEWS SECTION ======= -->
                            <section class="max-w-[1400px] mx-auto mt-6 pt-6 border-t border-slate-100">
                                <c:set var="totalRating" value="0" />
                                <c:set var="reviewCount" value="${fn:length(feedbacks)}" />
                                <c:forEach var="fb" items="${feedbacks}">
                                    <c:set var="totalRating" value="${totalRating + fb.rating}" />
                                </c:forEach>
                                <c:set var="avgRating" value="${reviewCount > 0 ? totalRating / reviewCount : 0}" />

                                <div class="grid grid-cols-1 lg:grid-cols-12 gap-20">
                                    <!-- Left: Summary -->
                                    <div class="lg:col-span-4 sticky top-32 self-start">
                                        <div class="flex items-center gap-3 mb-4">
                                            <span class="w-10 h-[1px] bg-accent"></span>
                                            <span
                                                class="text-[10px] uppercase tracking-[0.3em] text-accent font-bold">Feedback</span>
                                        </div>
                                        <h2 class="font-serif text-5xl text-slate-900 mb-8">Client Reviews</h2>

                                        <div class="flex items-center gap-6 mb-10">
                                            <div class="flex flex-col">
                                                <span class="text-6xl font-serif text-slate-950">
                                                    <c:choose>
                                                        <c:when test="${reviewCount > 0}">
                                                            <fmt:formatNumber value="${avgRating}"
                                                                maxFractionDigits="1" />
                                                        </c:when>
                                                        <c:otherwise>0.0</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <div class="flex gap-0.5 mt-2">
                                                    <c:forEach begin="1" end="5" var="starIdx">
                                                        <span
                                                            class="material-symbols-outlined text-[18px] ${starIdx <= avgRating ? 'star-filled-primary' : 'text-slate-200'}">star</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="h-16 w-[1px] bg-slate-100"></div>
                                            <div>
                                                <p class="text-sm font-bold text-slate-900 mb-1">Dựa trên ${reviewCount}
                                                    đánh giá</p>
                                                <p
                                                    class="text-[10px] text-slate-400 font-bold tracking-widest uppercase truncate max-w-[200px]">
                                                    100% Khách hàng hài lòng</p>
                                            </div>
                                        </div>

                                        <!-- Rating Breakdown (Optional Visual) -->
                                        <div class="space-y-4 mb-12">
                                            <c:forEach begin="1" end="5" var="countIdx">
                                                <c:set var="starVal" value="${6 - countIdx}" />
                                                <c:set var="thisStarCount" value="0" />
                                                <c:forEach var="f" items="${feedbacks}">
                                                    <c:if test="${f.rating eq starVal}">
                                                        <c:set var="thisStarCount" value="${thisStarCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                <c:set var="percent"
                                                    value="${reviewCount > 0 ? (thisStarCount * 100) / reviewCount : 0}" />
                                                <div class="flex items-center gap-4 text-xs">
                                                    <span class="w-8 font-bold text-slate-400">${starVal} <span
                                                            class="text-[10px]">★</span></span>
                                                    <div class="flex-1 h-1 bg-slate-50 rounded-full overflow-hidden">
                                                        <div class="h-full bg-slate-900 rating-bar-fill"
                                                            style="width: ${percent}%"></div>
                                                    </div>
                                                    <span
                                                        class="w-8 text-right text-slate-300 font-bold">${thisStarCount}</span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <!-- Right: Actual feedback from DB -->
                                    <div class="lg:col-span-8">
                                        <c:choose>
                                            <c:when test="${empty feedbacks}">
                                                <div
                                                    class="flex flex-col items-center justify-center py-24 text-center glass-panel rounded-lg border-dashed border-2 border-slate-100 bg-white/30">
                                                    <div
                                                        class="w-16 h-16 rounded-full bg-white flex items-center justify-center shadow-sm mb-6">
                                                        <span
                                                            class="material-symbols-outlined text-3xl text-slate-200">rate_review</span>
                                                    </div>
                                                    <h3 class="font-serif text-xl text-slate-900 mb-2">Chưa có đánh giá
                                                    </h3>
                                                    <p
                                                        class="text-sm text-slate-400 font-medium max-w-[300px] mx-auto leading-relaxed">
                                                        Hãy là người đầu tiên chia sẻ cảm nhận về sản phẩm này.</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="flex flex-col divide-y divide-slate-100">
                                                    <c:forEach var="fb" items="${feedbacks}">
                                                        <div class="py-6 group relative">
                                                            <div class="flex items-start gap-4">
                                                                <!-- Avatar -->
                                                                <div class="w-10 h-10 rounded-full bg-slate-900 text-white flex items-center justify-center font-serif text-sm font-bold uppercase shrink-0">
                                                                    ${not empty fb.username ? fn:substring(fb.username, 0, 1) : 'A'}
                                                                </div>
                                                                
                                                                <div class="flex-1 min-w-0">
                                                                    <!-- Header inline -->
                                                                    <div class="flex flex-wrap items-center gap-x-4 gap-y-1 mb-1">
                                                                        <h4 class="font-bold text-[14px] text-slate-900 truncate max-w-full">
                                                                            ${not empty fb.username ? fb.username : 'Anonymous'}
                                                                        </h4>
                                                                        <div class="flex gap-0.5 text-xs">
                                                                            <c:forEach begin="1" end="5" var="s">
                                                                                <span class="material-symbols-outlined text-[12px] ${s <= fb.rating ? 'text-yellow-400' : 'text-slate-200'}" style="${s <= fb.rating ? 'font-variation-settings: \'FILL\' 1;' : ''}">star</span>
                                                                            </c:forEach>
                                                                        </div>
                                                                        <c:if test="${fb.verified}">
                                                                            <span class="inline-flex items-center gap-1 text-[8px] font-extrabold uppercase tracking-widest text-[#024acf] bg-blue-50/80 px-2 py-0.5 rounded border border-blue-100">
                                                                                <span class="material-symbols-outlined text-[10px]" style="font-variation-settings: 'FILL' 1;">verified</span>
                                                                                Verified
                                                                            </span>
                                                                        </c:if>
                                                                        <div class="text-[9px] font-bold text-slate-400 uppercase tracking-widest ml-auto shrink-0">
                                                                            <fmt:formatDate value="${fb.createdat}" pattern="MMM dd, yyyy" />
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <!-- Message & Actions Horizontal -->
                                                                    <div class="flex flex-wrap items-end gap-x-4 gap-y-2 mt-1">
                                                                        <p class="text-[14px] text-slate-800 leading-relaxed font-medium flex-1 min-w-[200px]">
                                                                            ${not empty fb.comment ? fb.comment : ''}
                                                                        </p>

                                                                        <!-- Helpful/Edit Actions -->
                                                                        <div class="shrink-0 flex items-center">
                                                                            <c:choose>
                                                                                <c:when test="${not empty sessionScope.user and sessionScope.user.userId == fb.userid}">
                                                                                    <button onclick="window.location.href='${pageContext.request.contextPath}/profile?tab=reviews'" class="flex items-center gap-1 text-slate-400 hover:text-slate-900 transition-colors group/btn">
                                                                                        <span class="material-symbols-outlined text-[15px]">edit_note</span>
                                                                                        <span class="text-[10px] font-bold uppercase tracking-widest">Edit</span>
                                                                                    </button>
                                                                                </c:when>
                                                                                <c:when test="${not empty sessionScope.likedMap and sessionScope.likedMap[fb.feedbackid]}">
                                                                                    <button type="button" disabled class="flex items-center gap-1.5 text-rose-500 transition-all duration-300 group/btn cursor-not-allowed">
                                                                                        <span class="material-symbols-outlined text-[24px]" style="font-variation-settings: 'FILL' 1;">favorite</span>
                                                                                        <span class="text-[12px] font-bold tracking-widest ml-1"><span class="count">${fb.helpfulCount}</span></span>
                                                                                    </button>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <button type="button" onclick="handleHelpful(${fb.feedbackid}, this)" data-fbid="${fb.feedbackid}" class="helpful-btn flex items-center gap-1.5 text-slate-400 hover:text-rose-500 transition-all duration-300 group/btn">
                                                                                        <span class="material-symbols-outlined text-[24px] group-hover/btn:scale-110 transition-transform" style="font-variation-settings: 'FILL' 0;">favorite</span>
                                                                                        <span class="text-[12px] font-bold tracking-widest ml-1"><span class="count">${fb.helpfulCount}</span></span>
                                                                                    </button>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>

                                                                    <div class="flex flex-col items-start">
                                                                        <c:if test="${not empty fb.imageUrl}">
                                                                            <c:set var="resolvedImageUrl" value="${fb.imageUrl}" />
                                                                            <c:if test="${not fn:startsWith(resolvedImageUrl, 'http') and not fn:startsWith(resolvedImageUrl, '/')}">
                                                                                <c:set var="resolvedImageUrl" value="${pageContext.request.contextPath}/uploads/${resolvedImageUrl}" />
                                                                            </c:if>
                                                                            <div class="mt-2 overflow-hidden rounded border border-slate-100 inline-block group/img">
                                                                                <img src="${resolvedImageUrl}" alt="User upload" class="max-w-[90px] aspect-square object-cover transition-transform duration-700 group-hover/img:scale-105" onerror="this.parentElement.style.display='none'">
                                                                            </div>
                                                                        </c:if>

                                                                        <!-- Admin Reply -->
                                                                        <c:if test="${not empty fb.adminReply}">
                                                                            <div class="bg-slate-50/80 p-3 rounded-tr-xl rounded-b-xl rounded-bl-sm border-l-2 border-slate-900 mt-2 inline-block">
                                                                                <div class="flex items-center gap-1.5 mb-1">
                                                                                    <span class="text-[9px] font-extrabold uppercase tracking-[0.2em] text-slate-900">AISTHÉA Reply</span>
                                                                                </div>
                                                                                <p class="text-[12px] text-slate-700 font-serif leading-relaxed italic pr-2">
                                                                                    "${fb.adminReply}"
                                                                                </p>
                                                                            </div>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </section>

                            <!-- ======= COMPLETE THE LOOK ======= -->
                            <section class="py-24 relative z-10 overflow-hidden">
                                <div class="max-w-[1400px] mx-auto">
                                    <div class="flex flex-col md:flex-row justify-between items-end mb-16">
                                        <div>
                                            <span
                                                class="block text-primary font-semibold tracking-[0.25em] text-xs mb-4 uppercase">Recommendations</span>
                                            <h2 class="font-serif text-4xl lg:text-5xl text-slate-900">Complete The Look
                                            </h2>
                                        </div>
                                        <div class="hidden md:flex gap-4 mt-6 md:mt-0">
                                            <button id="reco-prev"
                                                class="w-12 h-12 rounded-full border border-slate-200 flex items-center justify-center hover:bg-slate-900 hover:text-white hover:border-slate-900 transition-all duration-300">
                                                <span class="material-symbols-outlined text-sm">arrow_back</span>
                                            </button>
                                            <button id="reco-next"
                                                class="w-12 h-12 rounded-full border border-slate-200 flex items-center justify-center hover:bg-slate-900 hover:text-white hover:border-slate-900 transition-all duration-300">
                                                <span class="material-symbols-outlined text-sm">arrow_forward</span>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 lg:gap-10">
                                        <!-- Item 1 -->
                                        <a href="${pageContext.request.contextPath}/product"
                                            class="group cursor-pointer">
                                            <div class="relative overflow-hidden mb-5 aspect-[3/4] bg-slate-100">
                                                <div
                                                    class="absolute inset-0 bg-slate-200 flex items-center justify-center">
                                                    <span
                                                        class="material-icons-outlined text-slate-300 text-6xl">image</span>
                                                </div>
                                                <div
                                                    class="absolute inset-0 bg-black/0 group-hover:bg-black/5 transition-colors duration-500">
                                                </div>
                                                <button type="button" onclick="event.preventDefault()"
                                                    class="absolute bottom-4 right-4 w-10 h-10 bg-white/90 backdrop-blur-sm flex items-center justify-center rounded-full opacity-0 translate-y-4 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 shadow-sm hover:bg-primary hover:text-white">
                                                    <span
                                                        class="material-symbols-outlined text-[18px]">add_shopping_cart</span>
                                                </button>
                                            </div>
                                            <div class="flex flex-col gap-1">
                                                <h3
                                                    class="font-serif text-lg text-slate-900 group-hover:text-primary transition-colors">
                                                    Merino Wool Scarf</h3>
                                                <p class="text-xs text-slate-500 uppercase tracking-wider">Accessories
                                                </p>
                                                <span
                                                    class="text-sm font-semibold text-slate-800 mt-1">1.800.000₫</span>
                                            </div>
                                        </a>

                                        <!-- Item 2 -->
                                        <a href="${pageContext.request.contextPath}/product"
                                            class="group cursor-pointer lg:mt-16">
                                            <div class="relative overflow-hidden mb-5 aspect-[3/4] bg-slate-100">
                                                <div
                                                    class="absolute top-4 left-4 bg-white/80 backdrop-blur-sm px-3 py-1 text-[9px] uppercase tracking-widest font-bold text-slate-800">
                                                    Best Seller</div>
                                                <div
                                                    class="absolute inset-0 bg-slate-200 flex items-center justify-center">
                                                    <span
                                                        class="material-icons-outlined text-slate-300 text-6xl">image</span>
                                                </div>
                                                <div
                                                    class="absolute inset-0 bg-black/0 group-hover:bg-black/5 transition-colors duration-500">
                                                </div>
                                                <button type="button" onclick="event.preventDefault()"
                                                    class="absolute bottom-4 right-4 w-10 h-10 bg-white/90 backdrop-blur-sm flex items-center justify-center rounded-full opacity-0 translate-y-4 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 shadow-sm hover:bg-primary hover:text-white">
                                                    <span
                                                        class="material-symbols-outlined text-[18px]">add_shopping_cart</span>
                                                </button>
                                            </div>
                                            <div class="flex flex-col gap-1">
                                                <h3
                                                    class="font-serif text-lg text-slate-900 group-hover:text-primary transition-colors">
                                                    Pleated Wide Trousers</h3>
                                                <p class="text-xs text-slate-500 uppercase tracking-wider">Ready to Wear
                                                </p>
                                                <span
                                                    class="text-sm font-semibold text-slate-800 mt-1">3.500.000₫</span>
                                            </div>
                                        </a>

                                        <!-- Item 3 -->
                                        <a href="${pageContext.request.contextPath}/product"
                                            class="group cursor-pointer">
                                            <div class="relative overflow-hidden mb-5 aspect-[3/4] bg-slate-100">
                                                <div
                                                    class="absolute inset-0 bg-slate-200 flex items-center justify-center">
                                                    <span
                                                        class="material-icons-outlined text-slate-300 text-6xl">image</span>
                                                </div>
                                                <div
                                                    class="absolute inset-0 bg-black/0 group-hover:bg-black/5 transition-colors duration-500">
                                                </div>
                                                <button type="button" onclick="event.preventDefault()"
                                                    class="absolute bottom-4 right-4 w-10 h-10 bg-white/90 backdrop-blur-sm flex items-center justify-center rounded-full opacity-0 translate-y-4 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 shadow-sm hover:bg-primary hover:text-white">
                                                    <span
                                                        class="material-symbols-outlined text-[18px]">add_shopping_cart</span>
                                                </button>
                                            </div>
                                            <div class="flex flex-col gap-1">
                                                <h3
                                                    class="font-serif text-lg text-slate-900 group-hover:text-primary transition-colors">
                                                    Structure Tote</h3>
                                                <p class="text-xs text-slate-500 uppercase tracking-wider">Leather Goods
                                                </p>
                                                <span
                                                    class="text-sm font-semibold text-slate-800 mt-1">8.900.000₫</span>
                                            </div>
                                        </a>

                                        <!-- Item 4 -->
                                        <a href="${pageContext.request.contextPath}/product"
                                            class="group cursor-pointer lg:mt-16">
                                            <div class="relative overflow-hidden mb-5 aspect-[3/4] bg-slate-100">
                                                <div
                                                    class="absolute inset-0 bg-slate-200 flex items-center justify-center">
                                                    <span
                                                        class="material-icons-outlined text-slate-300 text-6xl">image</span>
                                                </div>
                                                <div
                                                    class="absolute inset-0 bg-black/0 group-hover:bg-black/5 transition-colors duration-500">
                                                </div>
                                                <button type="button" onclick="event.preventDefault()"
                                                    class="absolute bottom-4 right-4 w-10 h-10 bg-white/90 backdrop-blur-sm flex items-center justify-center rounded-full opacity-0 translate-y-4 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 shadow-sm hover:bg-primary hover:text-white">
                                                    <span
                                                        class="material-symbols-outlined text-[18px]">add_shopping_cart</span>
                                                </button>
                                            </div>
                                            <div class="flex flex-col gap-1">
                                                <h3
                                                    class="font-serif text-lg text-slate-900 group-hover:text-primary transition-colors">
                                                    Silk Tie Blouse</h3>
                                                <p class="text-xs text-slate-500 uppercase tracking-wider">Ready to Wear
                                                </p>
                                                <span
                                                    class="text-sm font-semibold text-slate-800 mt-1">2.900.000₫</span>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </section>

                        </main>

                        <!-- Footer (shared with product-list page) -->
                        <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                        <%-- Toast notification khi feedback thành công --%>
                            <c:if test="${param.feedback eq 'success'}">
                                <div id="feedbackToast"
                                    class="fixed bottom-8 right-8 z-50 flex items-center gap-3 bg-slate-900 text-white px-6 py-4 shadow-2xl rounded-sm"
                                    style="animation: slideInToast 0.4s cubic-bezier(0.19,1,0.22,1) both;">
                                    <span class="material-symbols-outlined text-primary text-xl">check_circle</span>
                                    <div>
                                        <p class="text-sm font-bold tracking-wide">Cảm ơn bạn đã đánh giá!</p>
                                        <p class="text-[11px] text-slate-400 font-medium">Feedback của bạn đã được ghi
                                            nhận.</p>
                                    </div>
                                    <button onclick="document.getElementById('feedbackToast').remove()"
                                        class="ml-4 text-slate-400 hover:text-white transition-colors">
                                        <span class="material-symbols-outlined text-base">close</span>
                                    </button>
                                </div>
                                <style>
                                    @keyframes slideInToast {
                                        from {
                                            opacity: 0;
                                            transform: translateY(20px);
                                        }

                                        to {
                                            opacity: 1;
                                            transform: translateY(0);
                                        }
                                    }
                                </style>
                                <script>
                                    setTimeout(() => {
                                        const t = document.getElementById('feedbackToast');
                                        if (t) { t.style.opacity = '0'; t.style.transition = 'opacity 0.5s'; setTimeout(() => t.remove(), 500); }
                                    }, 5000);
                                </script>
                            </c:if>

                            <!-- ======= SCRIPTS ======= -->
                            <script>
                                (function () {
                                    // ── Accordion ──────────────────────────────────────────────
                                    window.toggleAccordionItem = function (item) {
                                        item.classList.toggle('active');
                                    }

                                    // ── Image Gallery (Zoom & Prev/Next) ─────────────────
                                    window.zoomImage = function (e, container) {
                                        const img = container.querySelector('img');
                                        const rect = container.getBoundingClientRect();
                                        const x = ((e.clientX - rect.left) / rect.width) * 100;
                                        const y = ((e.clientY - rect.top) / rect.height) * 100;
                                        img.style.transformOrigin = x + '% ' + y + '%';
                                    };

                                    window.resetZoom = function (container) {
                                        const img = container.querySelector('img');
                                        img.style.transformOrigin = 'center center';
                                    };

                                    const productImages = [];
                                    const thumbs = document.querySelectorAll('.thumbnail-item');
                                    thumbs.forEach(thumb => {
                                        const imgUrl = thumb.querySelector('img').src;
                                        productImages.push(imgUrl);
                                    });

                                    let currentImgIdx = 0;
                                    const mainImgElt = document.getElementById('mainImage');
                                    
                                    function updateThumbStyle(activeIndex) {
                                        if (!thumbs || thumbs.length === 0) return;
                                        thumbs.forEach((t, i) => {
                                            if (i === activeIndex) {
                                                t.classList.add('border-slate-800', 'opacity-100');
                                                t.classList.remove('border-transparent', 'opacity-70');
                                                t.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
                                            } else {
                                                t.classList.remove('border-slate-800', 'opacity-100');
                                                t.classList.add('border-transparent', 'opacity-70');
                                            }
                                        });
                                    }

                                    if(productImages.length > 0) {
                                        const foundIdx = productImages.findIndex(url => mainImgElt.src.includes(url));
                                        if (foundIdx >= 0) currentImgIdx = foundIdx;
                                        updateThumbStyle(currentImgIdx);
                                    }

                                    window.changeImage = function (url) {
                                        // handle if called from older color switch logic that passes img element
                                        if(typeof url === 'object' && url.src) {
                                            url = url.src;
                                        }
                                        mainImgElt.src = url;
                                        const idx = productImages.findIndex(u => u.includes(url) || url.includes(u));
                                        if (idx >= 0) {
                                            currentImgIdx = idx;
                                            updateThumbStyle(currentImgIdx);
                                        }
                                    };

                                    window.prevImage = function (e) {
                                        e.stopPropagation();
                                        if (productImages.length === 0) return;
                                        currentImgIdx = (currentImgIdx - 1 + productImages.length) % productImages.length;
                                        mainImgElt.src = productImages[currentImgIdx];
                                        updateThumbStyle(currentImgIdx);
                                    };

                                    window.nextImage = function (e) {
                                        e.stopPropagation();
                                        if (productImages.length === 0) return;
                                        currentImgIdx = (currentImgIdx + 1) % productImages.length;
                                        mainImgElt.src = productImages[currentImgIdx];
                                        updateThumbStyle(currentImgIdx);
                                    };

                                    window.scrollThumbs = function (direction) {
                                        const container = document.getElementById('thumbnail-container');
                                        const scrollAmount = container.clientWidth / 2;
                                        if (direction === 'left') {
                                            container.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
                                        } else {
                                            container.scrollBy({ left: scrollAmount, behavior: 'smooth' });
                                        }
                                    };

                                    // ── Color / Size Data from server ──────────────────────────
                                    const colorSizeData = [];
                                    <c:forEach var="cs" items="${colorSizes}">
                                        colorSizeData.push({
                                            "id": '${not empty cs.productColorSizeId ? cs.productColorSizeId : 0}',
                                        "color": "${not empty cs.color ? cs.color : ''}",
                                        "size": "${not empty cs.size ? cs.size : ''}",
                                        "stock": parseInt('${not empty cs.stock ? cs.stock : 0}')
                                    });
                                    </c:forEach>

                                    const colorToImageUrlMap = {};
                                    <c:forEach var="img" items="${images}">
                                        <c:set var="mappedUrl" value="${img.imageUrl}" />
                                        <c:if test="${not empty mappedUrl and not fn:startsWith(mappedUrl, 'http') and not fn:startsWith(mappedUrl, '/')}">
                                            <c:set var="mappedUrl" value="${pageContext.request.contextPath}/uploads/${mappedUrl}" />
                                        </c:if>
                                        colorToImageUrlMap["${img.color}"] = "${mappedUrl}";
                                    </c:forEach>

                                    const mainImage = document.getElementById('mainImage');
                                    const colorOptions = document.getElementById('color-options');
                                    const sizeOptions = document.getElementById('size-options');
                                    const addToCartBtn = document.getElementById('add-to-cart-btn');
                                    const buyBtn = document.getElementById('buy-now-btn');
                                    const quantityInput = document.getElementById('quantityInput');
                                    const stockInfo = document.getElementById('stock-info');
                                    const stockError = document.getElementById('stock-error');

                                    let selectedColor = null;
                                    let selectedSize = null;

                                    // ===== VIETNAMESE COLOR NAME → HEX MAPPING (Synced with listing page) =====
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
                                        // Final fallback to hash-based for unknown colors
                                        let hash = 0;
                                        for (let i = 0; i < key.length; i++) hash = key.charCodeAt(i) + ((hash << 5) - hash);
                                        const h = Math.abs(hash) % 360;
                                        return 'hsl(' + h + ', 55%, 48%)';
                                    }

                                    function renderColors() {
                                        const colors = [...new Set(colorSizeData.map(d => d.color))].filter(c => c !== '');
                                        if (colorOptions) {
                                            colorOptions.innerHTML = colors.map(function (c) {
                                                return '<label class="cursor-pointer group relative">'
                                                    + '<input type="radio" name="color" value="' + c + '" class="peer sr-only" onchange="selectColor(\'' + c + '\')">'
                                                    + '<div class="w-10 h-10 rounded-full border border-slate-200 peer-checked:ring-2 peer-checked:ring-offset-2 peer-checked:ring-slate-900 transition-all group-hover:scale-110 group-hover:ring-2 group-hover:ring-black group-hover:ring-offset-2" '
                                                    + 'style="background-color: ' + getColorHex(c) + '"></div>'
                                                    + '<span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] font-bold uppercase tracking-widest text-slate-400 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">' + c + '</span>'
                                                    + '</label>';
                                            }).join('');
                                        }
                                    }

                                    function renderSizes() {
                                        const sizes = [...new Set(colorSizeData.map(d => d.size))].filter(s => s !== '');
                                        if (sizeOptions) {
                                            sizeOptions.innerHTML = sizes.map(function (s) {
                                                return '<label class="cursor-pointer">'
                                                    + '<input type="radio" name="size" value="' + s + '" class="peer sr-only" onchange="selectSize(\'' + s + '\')">'
                                                    + '<div class="h-12 border border-slate-200 flex items-center justify-center text-[11px] font-extrabold text-slate-800 hover:bg-black hover:border-black hover:text-white peer-checked:bg-slate-900 peer-checked:text-white peer-checked:border-slate-900 transition-all uppercase">' + s + '</div>'
                                                    + '</label>';
                                            }).join('');
                                        }
                                    }

                                    window.selectColor = function (c) {
                                        selectedColor = c;

                                        if (colorToImageUrlMap[c]) {
                                            const hiddenInput = document.getElementById('productImageUrlHidden');
                                            if (hiddenInput) hiddenInput.value = colorToImageUrlMap[c];
                                        }

                                        let firstVisibleThumbSrc = null;

                                        // Filter thumbnails
                                        document.querySelectorAll('.thumbnail-item').forEach(t => {
                                            if (!c || t.dataset.color === c || !t.dataset.color) {
                                                t.style.display = 'block';
                                                
                                                if (!firstVisibleThumbSrc) {
                                                    const imgElt = t.querySelector('img');
                                                    if (imgElt && imgElt.src) firstVisibleThumbSrc = imgElt.src;
                                                }
                                            } else {
                                                t.style.display = 'none';
                                            }
                                        });

                                        // Always display the first thumbnail of the chosen color
                                        if (firstVisibleThumbSrc) {
                                            changeImage(firstVisibleThumbSrc);
                                        } else if (colorToImageUrlMap[c] && mainImage) {
                                            changeImage(colorToImageUrlMap[c]);
                                        }

                                        updateUI();
                                    }

                                    window.selectSize = function (s) {
                                        selectedSize = s;
                                        updateUI();
                                    }

                                    // ── Quantity Listeners ───────────────────────────────────
                                    const minusBtn = document.getElementById('minusBtn');
                                    const plusBtn = document.getElementById('plusBtn');
                                    const quantityHidden = document.getElementById('quantityHidden');

                                    if (minusBtn && plusBtn && quantityInput) {
                                        minusBtn.addEventListener('click', function () {
                                            let current = parseInt(quantityInput.value) || 1;
                                            if (current > 1) {
                                                quantityInput.value = current - 1;
                                                if (quantityHidden) quantityHidden.value = current - 1;
                                                updateUI();
                                            }
                                        });

                                        plusBtn.addEventListener('click', function () {
                                            const item = colorSizeData.find(d => d.color === selectedColor && d.size === selectedSize);
                                            const maxStock = item ? item.stock : 0;
                                            let current = parseInt(quantityInput.value) || 1;
                                            if (current < maxStock) {
                                                quantityInput.value = current + 1;
                                                if (quantityHidden) quantityHidden.value = current + 1;
                                                updateUI();
                                            }
                                        });

                                        quantityInput.addEventListener('input', function () {
                                            const item = colorSizeData.find(d => d.color === selectedColor && d.size === selectedSize);
                                            const maxStock = item ? item.stock : 1;
                                            let val = parseInt(this.value);

                                            if (isNaN(val)) return; // Allow temporary empty type

                                            if (val > maxStock) {
                                                val = maxStock;
                                                this.value = val;
                                            } else if (val < 1) {
                                                val = 1;
                                                this.value = val;
                                            }
                                            if (quantityHidden) quantityHidden.value = val;
                                            updateUI();
                                        });

                                        quantityInput.addEventListener('blur', function () {
                                            if (!this.value || isNaN(parseInt(this.value))) {
                                                this.value = 1;
                                                if (quantityHidden) quantityHidden.value = 1;
                                                updateUI();
                                            }
                                        });
                                    }

                                    function updateUI() {
                                        const item = colorSizeData.find(d => d.color === selectedColor && d.size === selectedSize);

                                        // PCS ID hidden input
                                        const pcsIdInput = document.getElementById('selectedPCSId');
                                        if (item && pcsIdInput) {
                                            pcsIdInput.value = item.id;
                                        }

                                        if (!item) {
                                            if (stockInfo) stockInfo.innerText = "Vui lòng chọn Màu & Size";
                                            if (addToCartBtn) addToCartBtn.disabled = true;
                                            if (buyBtn) buyBtn.disabled = true;
                                            return;
                                        }

                                        if (stockInfo) {
                                            stockInfo.innerText = item.stock > 0 ? ("Còn hàng: " + item.stock) : "Hết hàng";
                                            stockInfo.className = item.stock > 0
                                                ? "text-[10px] font-bold uppercase tracking-[0.15em] text-slate-400"
                                                : "text-[10px] font-bold uppercase tracking-[0.15em] text-red-500";
                                        }

                                        let qty = parseInt(quantityInput.value) || 1;
                                        const outOfStock = item.stock <= 0;

                                        // Correct quantity if it exceeds stock
                                        if (!outOfStock && qty > item.stock) {
                                            qty = item.stock;
                                            quantityInput.value = qty;
                                            if (quantityHidden) quantityHidden.value = qty;
                                        } else if (!outOfStock && qty < 1) {
                                            qty = 1;
                                            quantityInput.value = qty;
                                            if (quantityHidden) quantityHidden.value = qty;
                                        }

                                        // Disable buttons based on limits
                                        if (minusBtn) minusBtn.disabled = qty <= 1 || outOfStock;
                                        if (plusBtn) plusBtn.disabled = qty >= item.stock || outOfStock;

                                        if (addToCartBtn) {
                                            addToCartBtn.disabled = outOfStock;
                                            if (outOfStock) {
                                                addToCartBtn.innerHTML = '<span>Hết hàng</span>';
                                                addToCartBtn.classList.add('bg-slate-200', 'text-slate-400');
                                                addToCartBtn.classList.remove('bg-primary', 'text-white');
                                            } else {
                                                addToCartBtn.innerHTML = '<span>Thêm vào giỏ hàng</span><span class="material-symbols-outlined text-base">shopping_bag</span>';
                                                addToCartBtn.classList.remove('bg-slate-200', 'text-slate-400');
                                                addToCartBtn.classList.add('bg-primary', 'text-white');
                                            }
                                        }

                                        if (buyBtn) {
                                            buyBtn.disabled = outOfStock;
                                            buyBtn.innerHTML = outOfStock ? 'Cháy hàng' : 'Mua ngay';
                                            if (outOfStock) {
                                                buyBtn.classList.add('opacity-50');
                                            } else {
                                                buyBtn.classList.remove('opacity-50');
                                            }
                                        }

                                        if (stockError) {
                                            const overQty = !outOfStock && qty > item.stock;
                                            stockError.classList.toggle('hidden', !overQty);
                                        }
                                    }

                                    // ── Helpful Button AJAX ───────────────────────────
                                    window.handleHelpful = function (feedbackId, btn) {
                                        if (btn.hasAttribute('disabled')) return;
                                        btn.setAttribute('disabled', 'true');

                                        const formData = new URLSearchParams();
                                        formData.append('action', 'incrementHelpful');
                                        formData.append('feedbackId', feedbackId);

                                        fetch('${pageContext.request.contextPath}/feedback', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                            body: formData
                                        })
                                            .then(response => response.json())
                                            .then(data => {
                                                if (data.success) {
                                                    const countSpan = btn.querySelector('.count');
                                                    if (countSpan) {
                                                        const currentCount = parseInt(countSpan.textContent);
                                                        countSpan.textContent = currentCount + 1;
                                                    }
                                                    
                                                    // Make the button look permanently "liked" and unclickable
                                                    btn.style.color = '#f43f5e'; // rose-500
                                                    btn.style.cursor = 'not-allowed';
                                                    btn.classList.remove('hover:text-rose-500');
                                                    
                                                    const icon = btn.querySelector('.material-symbols-outlined');
                                                    if (icon) {
                                                        icon.style.fontVariationSettings = "'FILL' 1";
                                                        icon.classList.remove('group-hover/btn:scale-110');
                                                        
                                                        // Heart beat animation once
                                                        icon.style.transform = 'scale(1.3)';
                                                        setTimeout(() => icon.style.transform = 'scale(1)', 300);
                                                    }
                                                    
                                                    // Remove the onclick event so it can't be clicked again
                                                    btn.removeAttribute('onclick');

                                                    // Save to LocalStorage for persistence
                                                    const liked = JSON.parse(localStorage.getItem('likedFeedbacks') || '[]');
                                                    if (!liked.includes(feedbackId)) {
                                                        liked.push(feedbackId);
                                                        localStorage.setItem('likedFeedbacks', JSON.stringify(liked));
                                                    }
                                                } else {
                                                    btn.removeAttribute('disabled');
                                                }
                                            })
                                            .catch(err => {
                                                console.error('Error:', err);
                                                btn.removeAttribute('disabled');
                                            });
                                    };

                                    // Hydrate helpful buttons on load
                                    const likedFeedbacks = JSON.parse(localStorage.getItem('likedFeedbacks') || '[]');
                                    if (likedFeedbacks.length > 0) {
                                        document.querySelectorAll('.helpful-btn').forEach(btn => {
                                            const fbId = parseInt(btn.dataset.fbid);
                                            if (likedFeedbacks.includes(fbId)) {
                                                btn.setAttribute('disabled', 'true');
                                                btn.style.color = '#f43f5e';
                                                btn.style.cursor = 'not-allowed';
                                                btn.classList.remove('hover:text-rose-500');
                                                btn.removeAttribute('onclick');
                                                const icon = btn.querySelector('.material-symbols-outlined');
                                                if (icon) {
                                                    icon.style.fontVariationSettings = "'FILL' 1";
                                                    icon.classList.remove('group-hover/btn:scale-110');
                                                }
                                            }
                                        });
                                    }

                                    renderColors();
                                    renderSizes();
                                })();
                            </script>

                </body>

                </html>
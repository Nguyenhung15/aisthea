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
                        body,
                        button,
                        input,
                        select,
                        textarea {
                            font-family: 'Manrope', sans-serif;
                        }

                        h1,
                        h2,
                        h3,
                        h4 {
                            font-family: 'Playfair Display', serif;
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

                        <main class="relative pt-20 pb-20 px-4 md:px-8 min-h-screen">

                            <!-- ======= PRODUCT DETAIL SECTION ======= -->
                            <div
                                class="max-w-[1400px] mx-auto w-full grid grid-cols-1 lg:grid-cols-12 gap-8 xl:gap-16 relative z-10">


                                <!-- Left: Images -->
                                <div class="lg:col-span-7 flex flex-col gap-4">
                                    <div
                                        class="relative w-full max-w-xl mx-auto aspect-[4/5] overflow-hidden rounded-sm bg-white shadow-sm">
                                        <img id="mainImage" src="${primaryImgUrl}" alt="${product.name}"
                                            class="w-full h-full object-cover transition-transform duration-700 hover:scale-[1.02]"
                                            onerror="this.src='${placeholderImg}'">
                                    </div>

                                    <div class="grid grid-cols-4 gap-4" id="thumbnail-container">
                                        <c:forEach var="img" items="${images}">
                                            <c:set var="thumbUrl" value="${img.imageUrl}" />
                                            <c:if
                                                test="${not empty thumbUrl and not fn:startsWith(thumbUrl, 'http') and not fn:startsWith(thumbUrl, '/')}">
                                                <c:set var="thumbUrl"
                                                    value="${pageContext.request.contextPath}/uploads/${thumbUrl}" />
                                            </c:if>
                                            <div class="aspect-[3/4] overflow-hidden rounded-sm cursor-pointer border border-slate-200 hover:border-primary transition-colors thumbnail-item"
                                                onclick="changeImage(this.querySelector('img'))">
                                                <img src="${thumbUrl}" alt="Thumbnail"
                                                    class="w-full h-full object-cover hover:opacity-90 transition-opacity"
                                                    onerror="this.src='${placeholderImg}'">
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Right: Info -->
                                <div class="lg:col-span-5 flex flex-col pt-4 lg:pt-8 lg:sticky lg:top-28 h-fit">

                                    <!-- Breadcrumb -->
                                    <nav aria-label="Breadcrumb"
                                        class="flex items-center flex-wrap text-[10px] uppercase tracking-[0.2em] text-slate-400 mb-8 font-bold gap-1">
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
                                    <div class="flex items-center justify-between mb-8 border-b border-slate-100 pb-8">
                                        <span class="text-3xl text-primary font-serif italic font-medium">
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
                                                    <input type="text" id="quantityInput" value="1" readonly
                                                        class="w-12 h-full text-center border-0 text-sm font-bold text-slate-900 focus:ring-0 cursor-default">
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
                            <section class="max-w-[1400px] mx-auto mt-32 pt-24 border-t border-slate-100">
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
                                                <div class="space-y-12">
                                                    <c:forEach var="fb" items="${feedbacks}">
                                                        <div class="group relative">
                                                            <div class="flex flex-col md:flex-row gap-6">
                                                                <!-- Meta side -->
                                                                <div class="md:w-48 flex-shrink-0">
                                                                    <div class="mb-4">
                                                                        <h4
                                                                            class="font-serif text-lg text-slate-950 mb-1 leading-tight">
                                                                            ${not empty fb.username ? fb.username :
                                                                            'Anonymous'}
                                                                        </h4>
                                                                        <div class="flex items-center gap-1.5">
                                                                            <c:if test="${fb.verified}">
                                                                                <span
                                                                                    class="inline-flex items-center gap-1 text-[8px] font-extrabold uppercase tracking-widest text-[#024acf] bg-blue-50/50 px-2 py-0.5 rounded-full border border-blue-100/50">
                                                                                    <span
                                                                                        class="material-symbols-outlined text-[10px]"
                                                                                        style="font-variation-settings: 'FILL' 1;">verified</span>
                                                                                    Verified
                                                                                </span>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                    <div
                                                                        class="text-[10px] font-extrabold text-slate-300 uppercase tracking-[0.2em]">
                                                                        <fmt:formatDate value="${fb.createdat}"
                                                                            pattern="dd MMM yyyy" />
                                                                    </div>
                                                                </div>

                                                                <!-- Content side -->
                                                                <div class="flex-1">
                                                                    <div class="flex gap-0.5 mb-4">
                                                                        <c:forEach begin="1" end="5" var="s">
                                                                            <span
                                                                                class="material-symbols-outlined text-sm ${s <= fb.rating ? 'star-filled-primary' : 'text-slate-100'}">star</span>
                                                                        </c:forEach>
                                                                    </div>

                                                                    <div class="relative">
                                                                        <span
                                                                            class="absolute -left-6 -top-2 text-4xl text-slate-50 font-serif opacity-50">“</span>
                                                                        <p
                                                                            class="text-sm text-slate-600 leading-[1.8] font-medium italic mb-6">
                                                                            ${not empty fb.comment ? fb.comment : ''}
                                                                        </p>
                                                                    </div>

                                                                    <c:if test="${not empty fb.imageUrl}">
                                                                        <div
                                                                            class="mt-6 mb-8 overflow-hidden rounded-sm group/img ring-1 ring-black/5">
                                                                            <img src="${fb.imageUrl}" alt="User sensory"
                                                                                class="max-w-[320px] w-full object-cover transition-transform duration-700 group-hover/img:scale-105"
                                                                                onerror="this.parentElement.style.display='none'">
                                                                        </div>
                                                                    </c:if>

                                                                    <c:if test="${not empty fb.adminReply}">
                                                                        <div
                                                                            class="mt-8 bg-slate-50/80 p-6 rounded-sm border-l-2 border-slate-900 relative">
                                                                            <div class="flex items-center gap-2 mb-3">
                                                                                <img src="${pageContext.request.contextPath}/assets/images/ata-logo.png"
                                                                                    alt="AISTHÉA Logo"
                                                                                    class="w-5 h-5 object-contain">
                                                                                <span
                                                                                    class="text-[10px] font-extrabold uppercase tracking-[0.2em] text-slate-900">AISTHÉA</span>
                                                                            </div>
                                                                            <p
                                                                                class="text-[13px] text-slate-600 font-serif leading-relaxed italic pr-4">
                                                                                "${fb.adminReply}"
                                                                            </p>
                                                                            <div
                                                                                class="text-[9px] text-slate-300 uppercase tracking-widest mt-4 flex justify-between items-center">
                                                                                <span>Approved Experience</span>
                                                                                <span>
                                                                                    <fmt:formatDate
                                                                                        value="${fb.repliedAt}"
                                                                                        pattern="MMM dd, yyyy" />
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </c:if>

                                                                    <div
                                                                        class="mt-8 pt-6 border-t border-slate-50 flex items-center gap-6">
                                                                        <button
                                                                            onclick="handleHelpful(${fb.feedbackid}, this)"
                                                                            class="flex items-center gap-2 text-slate-400 hover:text-[#024acf] transition-all duration-500 group/btn">
                                                                            <span
                                                                                class="material-symbols-outlined text-[18px] group-hover/btn:scale-110 transition-transform"
                                                                                style="font-variation-settings: 'FILL' 0;">favorite</span>
                                                                            <span
                                                                                class="text-[10px] font-bold uppercase tracking-widest">Helpful
                                                                                (<span
                                                                                    class="count">${fb.helpfulCount}</span>)</span>
                                                                        </button>
                                                                        <button
                                                                            class="flex items-center gap-2 text-slate-400 hover:text-slate-900 transition-all duration-500 opacity-0 group-hover:opacity-100">
                                                                            <span
                                                                                class="material-symbols-outlined text-[16px]">share</span>
                                                                            <span
                                                                                class="text-[10px] font-bold uppercase tracking-widest">Share</span>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="h-[1px] w-full bg-slate-50 my-12 last:hidden"></div>
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

                                    function getColorHex(name) {
                                        const map = {
                                            "white": "#ffffff", "black": "#0c0c0c", "red": "#e53e3e",
                                            "blue": "#0047ab", "navy": "#000080", "cerulean": "#007ba7",
                                            "royal blue": "#4169e1", "sky blue": "#87ceeb",
                                            "green": "#2d7a4f", "yellow": "#f6d55c", "orange": "#f97316", "pink": "#f472b6",
                                            "purple": "#7c3aed", "brown": "#5d4037", "beige": "#d4be8d", "grey": "#9e9e9e"
                                        };
                                        const key = name.toLowerCase().trim();
                                        if (map[key]) return map[key];
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
                                                    + '<div class="w-10 h-10 rounded-full border border-slate-200 peer-checked:ring-2 peer-checked:ring-offset-2 peer-checked:ring-accent transition-all group-hover:scale-110" '
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
                                                    + '<div class="h-12 border border-slate-200 flex items-center justify-center text-[11px] font-extrabold text-slate-800 hover:border-accent peer-checked:bg-slate-900 peer-checked:text-white peer-checked:border-slate-900 transition-all uppercase">' + s + '</div>'
                                                    + '</label>';
                                            }).join('');
                                        }
                                    }

                                    window.selectColor = function (c) {
                                        selectedColor = c;
                                        if (colorToImageUrlMap[c] && mainImage) {
                                            mainImage.src = colorToImageUrlMap[c];
                                            const hiddenInput = document.getElementById('productImageUrlHidden');
                                            if (hiddenInput) hiddenInput.value = colorToImageUrlMap[c];
                                        }
                                        updateUI();
                                    }

                                    window.selectSize = function (s) {
                                        selectedSize = s;
                                        updateUI();
                                    }

                                    function updateUI() {
                                        const item = colorSizeData.find(d => d.color === selectedColor && d.size === selectedSize);
                                        if (!item) return;

                                        const pcsIdInput = document.getElementById('selectedPCSId');
                                        if (pcsIdInput) pcsIdInput.value = item.id;

                                        if (stockInfo) stockInfo.innerText = item.stock > 0 ? ("In Stock: " + item.stock) : "Sold Out";

                                        const qty = quantityInput ? parseInt(quantityInput.value) : 1;
                                        const outOfStock = item.stock <= 0;
                                        const overQty = qty > item.stock;

                                        if (addToCartBtn) {
                                            addToCartBtn.disabled = outOfStock || overQty;
                                            if (outOfStock) {
                                                addToCartBtn.innerHTML = '<span>Sold Out</span>';
                                            } else {
                                                addToCartBtn.innerHTML = '<span>Add to Cart</span><span class="material-symbols-outlined text-base">shopping_bag</span>';
                                            }
                                        }
                                        if (buyBtn) buyBtn.disabled = outOfStock || overQty;
                                        if (stockError) stockError.classList.toggle('hidden', !overQty);
                                    }

                                    // ── Helpful Button AJAX ───────────────────────────
                                    window.handleHelpful = function (feedbackId, btn) {
                                        if (btn.disabled) return;
                                        btn.disabled = true;

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
                                                    btn.style.color = '#024acf';
                                                    const icon = btn.querySelector('.material-symbols-outlined');
                                                    if (icon) {
                                                        icon.style.fontVariationSettings = "'FILL' 1";
                                                        icon.style.transform = 'scale(1.2)';
                                                        setTimeout(() => icon.style.transform = 'scale(1)', 200);
                                                    }
                                                }
                                            })
                                            .catch(err => {
                                                console.error('Error:', err);
                                                btn.disabled = false;
                                            });
                                    };

                                    renderColors();
                                    renderSizes();
                                })();
                            </script>

                </body>

                </html>
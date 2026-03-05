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
                            color: #C8A97E;
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
                                        <div class="flex items-center gap-1">
                                            <c:forEach begin="1" end="5" var="i">
                                                <span
                                                    class="material-symbols-outlined ${i <= 4 ? 'star-filled-primary' : 'text-slate-200'} text-sm">star</span>
                                            </c:forEach>
                                            <span class="text-xs text-slate-400 ml-2 font-semibold tracking-wider">(12
                                                Reviews)</span>
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
                            <section class="max-w-[1400px] mx-auto mt-32 pt-20 border-t border-slate-100">
                                <%-- Tính rating trung bình --%>
                                <c:set var="totalRating" value="0" />
                                <c:set var="reviewCount" value="0" />
                                <c:forEach var="fb" items="${feedbacks}">
                                    <c:set var="totalRating" value="${totalRating + fb.rating}" />
                                    <c:set var="reviewCount" value="${reviewCount + 1}" />
                                </c:forEach>
                                <c:set var="avgRating" value="${reviewCount > 0 ? totalRating / reviewCount : 0}" />

                                <div class="grid grid-cols-1 lg:grid-cols-12 gap-16">
                                    <!-- Left: Summary -->
                                    <div class="lg:col-span-4 sticky top-32 self-start">
                                        <h2 class="font-serif text-4xl text-slate-900 mb-6">Client Reviews</h2>
                                        <div class="flex items-baseline gap-4 mb-4">
                                            <span class="text-5xl font-serif text-slate-900">
                                                <c:choose>
                                                    <c:when test="${reviewCount > 0}">
                                                        <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" />
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <div class="flex gap-0.5">
                                                <c:forEach begin="1" end="5" var="starIdx">
                                                    <span class="material-symbols-outlined text-xl ${starIdx <= avgRating ? 'star-filled' : 'text-slate-200'}">star</span>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <p class="text-[10px] text-slate-400 font-bold tracking-[0.2em] uppercase mb-8">
                                            <c:choose>
                                                <c:when test="${reviewCount > 0}">${reviewCount} Verified Review${reviewCount > 1 ? 's' : ''}</c:when>
                                                <c:otherwise>No Reviews Yet</c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>

                                    <!-- Right: Actual feedback from DB -->
                                    <div class="lg:col-span-8">
                                        <c:choose>
                                            <c:when test="${empty feedbacks}">
                                                <div class="flex flex-col items-center justify-center py-16 text-center">
                                                    <span class="material-symbols-outlined text-4xl text-slate-200 mb-4">rate_review</span>
                                                    <p class="text-sm text-slate-400 font-medium">Chưa có đánh giá nào cho sản phẩm này.</p>
                                                    <p class="text-[11px] text-slate-300 mt-1 tracking-wide uppercase font-bold">Be the first to share your experience</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="space-y-10">
                                                    <c:forEach var="fb" items="${feedbacks}">
                                                        <div class="pb-10 border-b border-slate-50 last:border-0">
                                                            <div class="flex justify-between items-start mb-3">
                                                                <div class="flex items-center gap-3">
                                                                    <span class="text-sm font-bold text-slate-900 font-serif tracking-tight">
                                                                        ${not empty fb.username ? fb.username : 'Anonymous'}
                                                                    </span>
                                                                    <span class="bg-blue-50 text-primary text-[9px] px-2 py-0.5 uppercase tracking-wider">Verified Buyer</span>
                                                                </div>
                                                                <span class="text-slate-300 text-[10px] font-bold tracking-widest uppercase">
                                                                    <fmt:formatDate value="${fb.createdat}" pattern="dd MMM yyyy" />
                                                                </span>
                                                            </div>
                                                            <div class="flex gap-0.5 mb-3">
                                                                <c:forEach begin="1" end="5" var="s">
                                                                    <span class="material-symbols-outlined text-sm ${s <= fb.rating ? 'star-filled' : 'text-slate-200'}">star</span>
                                                                </c:forEach>
                                                            </div>
                                                            <p class="text-xs text-slate-500 leading-relaxed font-medium italic">
                                                                "${not empty fb.comment ? fb.comment : ''}"
                                                            </p>
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
                                    <p class="text-[11px] text-slate-400 font-medium">Feedback của bạn đã được ghi nhận.</p>
                                </div>
                                <button onclick="document.getElementById('feedbackToast').remove()"
                                    class="ml-4 text-slate-400 hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-base">close</span>
                                </button>
                            </div>
                            <style>
                                @keyframes slideInToast {
                                    from { opacity: 0; transform: translateY(20px); }
                                    to { opacity: 1; transform: translateY(0); }
                                }
                            </style>
                            <script>
                                setTimeout(() => {
                                    const t = document.getElementById('feedbackToast');
                                    if (t) { t.style.opacity = '0'; t.style.transition = 'opacity 0.5s'; setTimeout(() => t.remove(), 500); }
                                }, 5000);
                            <\/script>
                        </c:if>

                        <!-- ======= SCRIPTS ======= -->
                        <script>
                            // ── Accordion ──────────────────────────────────────────────
                            function toggleAccordionItem(item) {
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
                                    // English
                                    "white": "#ffffff", "black": "#0c0c0c", "red": "#e53e3e",
                                    "blue": "#0047ab", "navy": "#000080", "cerulean": "#007ba7",
                                    "royal blue": "#4169e1", "sky blue": "#87ceeb",
                                    "sky": "#87ceeb", "green": "#2d7a4f", "olive": "#808000",
                                    "yellow": "#f6d55c", "orange": "#f97316", "pink": "#f472b6",
                                    "purple": "#7c3aed", "violet": "#8b5cf6", "lavender": "#c4b5fd",
                                    "brown": "#5d4037", "beige": "#d4be8d", "cream": "#f5f5dc",
                                    "ivory": "#fffff0", "grey": "#9e9e9e", "gray": "#9e9e9e",
                                    "charcoal": "#333333", "silver": "#c0c0c0", "gold": "#ffd700",
                                    "rose": "#f43f5e", "coral": "#ff6b6b", "teal": "#008080",
                                    "mint": "#98ff98", "lime": "#32cd32", "khaki": "#c3b091",
                                    "camel": "#c19a6b", "sand": "#c2b280", "tan": "#d2b48c",
                                    "burgundy": "#800020", "maroon": "#800000", "wine": "#722f37",
                                    "cobalt": "#0047ab", "indigo": "#4b0082",
                                    // Vietnamese - Blues (most common cause of hash-fallback)
                                    "xanh biển": "#0047ab", "xanh dương": "#0047ab", "xanh lam": "#0047ab",
                                    "xanh da trời": "#4fc3f7", "xanh trời": "#4fc3f7",
                                    "xanh navy": "#1a237e", "xanh đen": "#0d1b4b",
                                    "xanh đậm": "#1e3a5f", "xanh nhạt": "#87ceeb",
                                    "xanh ngọc": "#008080", "xanh bạc hà": "#98ff98",
                                    "xanh lá": "#2d7a4f", "xanh lá cây": "#2d7a4f",
                                    "xanh rêu": "#556b2f", "xanh cổ vịt": "#008080",
                                    "xanh": "#0047ab",
                                    // Vietnamese - Others
                                    "trắng": "#ffffff", "đen": "#0c0c0c",
                                    "đỏ": "#e53e3e", "đỏ đậm": "#9b1c1c", "đỏ nhạt": "#fca5a5",
                                    "đỏ đô": "#800020", "đỏ burgundy": "#800020",
                                    "vàng": "#f6d55c", "vàng đồng": "#b8860b", "vàng kim": "#ffd700",
                                    "vàng be": "#d4be8d", "vàng nhạt": "#fffacd", "vàng nâu": "#c19a6b",
                                    "cam": "#f97316", "cam đất": "#c2410c",
                                    "hồng": "#f472b6", "hồng đậm": "#ec4899", "hồng nhạt": "#fce7f3",
                                    "hồng phấn": "#ffb6c1", "hồng sen": "#ff6f91",
                                    "tím": "#7c3aed", "tím đậm": "#4c1d95", "tím nhạt": "#c4b5fd",
                                    "tím lavender": "#e6e6fa",
                                    "nâu": "#5d4037", "nâu đất": "#78350f", "nâu nhạt": "#d4be8d",
                                    "nâu camel": "#c19a6b",
                                    "be": "#d4be8d", "kem": "#f5f5dc", "nude": "#e8c9a0",
                                    "xám": "#9e9e9e", "xám đậm": "#4b5563", "xám nhạt": "#e5e7eb",
                                    "xám tro": "#78909c", "xám xi măng": "#607d8b",
                                    "bạc": "#c0c0c0", "rêu": "#808000", "mận": "#722f37"
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
                                colorOptions.innerHTML = colors.map(function (c) {
                                    return '<label class="cursor-pointer group relative">'
                                        + '<input type="radio" name="color" value="' + c + '" class="peer sr-only" onchange="selectColor(\'' + c + '\')">'
                                        + '<div class="w-10 h-10 rounded-full border border-slate-200 peer-checked:ring-2 peer-checked:ring-offset-2 peer-checked:ring-primary transition-all group-hover:scale-110" '
                                        + 'style="background-color: ' + getColorHex(c) + '"></div>'
                                        + '<span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] font-bold uppercase tracking-widest text-slate-400 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">' + c + '</span>'
                                        + '</label>';
                                }).join('');
                            }

                            function renderSizes() {
                                const sizes = [...new Set(colorSizeData.map(d => d.size))].filter(s => s !== '');
                                sizeOptions.innerHTML = sizes.map(function (s) {
                                    return '<label class="cursor-pointer">'
                                        + '<input type="radio" name="size" value="' + s + '" class="peer sr-only" onchange="selectSize(\'' + s + '\')">'
                                        + '<div class="h-12 border border-slate-200 flex items-center justify-center text-[11px] font-extrabold text-slate-800 hover:border-primary peer-checked:bg-slate-900 peer-checked:text-white peer-checked:border-slate-900 transition-all uppercase">' + s + '</div>'
                                        + '</label>';
                                }).join('');
                            }

                            window.selectColor = function (c) {
                                selectedColor = c;
                                if (colorToImageUrlMap[c]) {
                                    mainImage.src = colorToImageUrlMap[c];
                                    document.getElementById('productImageUrlHidden').value = colorToImageUrlMap[c];
                                }
                                updateUI();
                            }

                            window.selectSize = function (s) {
                                selectedSize = s;
                                updateUI();
                            }

                            function updateUI() {
                                const item = colorSizeData.find(d => d.color === selectedColor && d.size === selectedSize);
                                const qty = parseInt(quantityInput.value);

                                if (item) {
                                    document.getElementById('selectedPCSId').value = item.id;
                                    stockInfo.innerText = item.stock > 0 ? ("In Stock: " + item.stock) : "Sold Out";

                                    const outOfStock = item.stock <= 0;
                                    const overQty = qty > item.stock;

                                    addToCartBtn.disabled = outOfStock || overQty;
                                    buyBtn.disabled = outOfStock || overQty;
                                    stockError.classList.toggle('hidden', !overQty);

                                    if (outOfStock) {
                                        addToCartBtn.innerHTML = '<span>Sold Out</span>';
                                    } else {
                                        addToCartBtn.innerHTML = '<span>Add to Cart</span><span class="material-symbols-outlined text-base">shopping_bag</span>';
                                    }

                        </script>  <%-- end main script block --%>

                </body>

                </html>
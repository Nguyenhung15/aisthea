<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <%--============================================================product-list-header.jsp (Editorial style — v2)
            3-column layout: [NAV LINKS] | [AISTHÉA] | [ICONS] Dependencies (in parent page <head>):
            - Tailwind CDN + config (primary: #024acf)
            - .glass-panel CSS class
            - Font Awesome 6.x
            - Material Symbols Outlined (for mobile menu icon)
            ============================================================ --%>
            <nav class="sticky top-0 z-50 bg-white border-b border-slate-100 transition-all duration-300" id="pl-nav">
                <div class="max-w-[1400px] mx-auto px-6 h-24 flex items-center justify-between">

                    <%-- ── LEFT: Nav Links (desktop) ── --%>
                        <div class="hidden lg:flex items-center space-x-10 w-1/3">
                            <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-primary transition-colors relative group text-slate-600"
                                href="${pageContext.request.contextPath}/product?genderid=2">
                                Women
                                <span
                                    class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary transition-all duration-300 group-hover:w-full"></span>
                            </a>
                            <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-primary transition-colors relative group text-slate-600"
                                href="${pageContext.request.contextPath}/product?genderid=1">
                                Men
                                <span
                                    class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary transition-all duration-300 group-hover:w-full"></span>
                            </a>
                            <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-primary transition-colors relative group text-slate-600"
                                href="${pageContext.request.contextPath}/stylist">
                                Stylist
                                <span
                                    class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary transition-all duration-300 group-hover:w-full"></span>
                            </a>
                        </div>

                        <%-- Mobile hamburger --%>
                            <button class="lg:hidden text-slate-800 hover:text-primary transition-colors">
                                <span class="material-symbols-outlined text-3xl">menu</span>
                            </button>

                            <%-- ── CENTER: Brand Logo ── --%>
                                <div class="flex-shrink-0 w-1/3 text-center">
                                    <a class="text-3xl md:text-4xl font-serif font-bold tracking-[0.15em] text-slate-900 hover:text-primary transition-colors duration-300"
                                        href="${pageContext.request.contextPath}/">
                                        AISTHÉA
                                    </a>
                                </div>

                                <%-- ── RIGHT: Icons ── --%>
                                    <div class="flex items-center justify-end gap-6 w-1/3">

                                        <%-- Search Button --%>
                                            <button onclick="toggleSearchOverlay(true)"
                                                class="text-slate-600 hover:text-primary transition-transform hover:-translate-y-0.5 duration-200"
                                                title="Search">
                                                <i class="fa-solid fa-magnifying-glass text-lg"></i>
                                            </button>

                                            <%-- Cart with badge --%>
                                                <a class="text-slate-600 hover:text-primary transition-transform hover:-translate-y-0.5 duration-200 relative"
                                                    href="${pageContext.request.contextPath}/cart" title="Cart">
                                                    <i class="fa-solid fa-bag-shopping text-lg"></i>
                                                    <c:if
                                                        test="${not empty sessionScope.cart and sessionScope.cart.totalQuantity > 0}">
                                                        <span class="absolute -top-1.5 -right-1.5 flex h-4 w-4 items-center justify-center
                                 rounded-full bg-primary text-[10px] text-white font-bold">
                                                            ${sessionScope.cart.totalQuantity}
                                                        </span>
                                                    </c:if>
                                                </a>

                                                <%-- User / Account --%>
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.user}">
                                                            <%-- Logged in: avatar + dropdown --%>
                                                                <div class="relative flex items-center gap-2 cursor-pointer group"
                                                                    id="pl-account-btn"
                                                                    title="${sessionScope.user.fullname}">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${not empty sessionScope.user.avatar and sessionScope.user.avatar != 'images/ava_default.png' and !sessionScope.user.avatar.contains('/')}">
                                                                            <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}"
                                                                                alt="Avatar" class="w-9 h-9 rounded-full object-cover border-2 border-white shadow-md
                                             group-hover:scale-105 transition-transform duration-200">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div
                                                                                class="text-slate-600 group-hover:text-primary transition-transform group-hover:-translate-y-0.5 duration-200">
                                                                                <i class="fa-solid fa-user text-lg"></i>
                                                                            </div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <span id="pl-user-name"
                                                                        data-fullname="${sessionScope.user.fullname}"
                                                                        class="text-sm font-medium text-slate-700 group-hover:text-primary transition-colors hidden md:block select-none">
                                                                        ${sessionScope.user.fullname}
                                                                    </span>
                                                                    <script>
                                                                        (function () {
                                                                            var nameEl = document.getElementById('pl-user-name');
                                                                            if (nameEl) {
                                                                                var nameStr = nameEl.getAttribute('data-fullname') || '';
                                                                                var parts = nameStr.trim().split(/\s+/);
                                                                                if (parts.length > 2) {
                                                                                    nameEl.textContent = parts[parts.length - 2] + ' ' + parts[parts.length - 1];
                                                                                }
                                                                            }
                                                                        })();
                                                                    </script>

                                                                    <%-- Dropdown menu --%>
                                                                        <div id="pl-account-menu" style="display:none;"
                                                                            class="absolute top-12 right-0 bg-white/95 backdrop-blur-md rounded-2xl shadow-xl
                                     border border-slate-100 min-w-[200px] z-50 overflow-hidden">
                                                                            <%-- User Info Header --%>
                                                                                <div
                                                                                    class="px-4 py-3.5 border-b border-slate-100 bg-slate-50/30 mb-1">
                                                                                    <p
                                                                                        class="text-[11px] font-semibold text-slate-400 uppercase tracking-wider mb-0.5">
                                                                                        Welcome back</p>
                                                                                    <p
                                                                                        class="text-sm font-bold text-slate-800 truncate font-serif-display tracking-wide">
                                                                                        ${sessionScope.user.fullname}
                                                                                    </p>
                                                                                </div>
                                                                                <a href="${pageContext.request.contextPath}/profile"
                                                                                    class="flex items-center gap-2 px-4 py-2.5 text-sm text-slate-700
                                       hover:text-primary hover:bg-blue-50/60 transition-colors font-medium">
                                                                                    <i
                                                                                        class="fa-solid fa-id-card text-sm w-4"></i>
                                                                                    Profile
                                                                                </a>
                                                                                <c:if
                                                                                    test="${sessionScope.user.role == 'ADMIN'}">
                                                                                    <a href="${pageContext.request.contextPath}/dashboard"
                                                                                        class="flex items-center gap-2 px-4 py-2.5 text-sm text-slate-700
                                           hover:text-primary hover:bg-blue-50/60 transition-colors font-medium">
                                                                                        <i
                                                                                            class="fa-solid fa-tachometer-alt text-sm w-4"></i>
                                                                                        Dashboard
                                                                                    </a>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${sessionScope.user.role == 'USER'}">
                                                                                    <a href="${pageContext.request.contextPath}/order"
                                                                                        class="flex items-center gap-2 px-4 py-2.5 text-sm text-slate-700
                                           hover:text-primary hover:bg-blue-50/60 transition-colors font-medium">
                                                                                        <i
                                                                                            class="fa-solid fa-box text-sm w-4"></i>
                                                                                        Đơn hàng
                                                                                    </a>
                                                                                </c:if>
                                                                                <hr class="my-1 border-slate-100">
                                                                                <a href="${pageContext.request.contextPath}/logout"
                                                                                    class="flex items-center gap-2 px-4 py-2.5 text-sm text-red-500
                                       hover:bg-red-50/60 transition-colors font-medium">
                                                                                    <i
                                                                                        class="fa-solid fa-right-from-bracket text-sm w-4"></i>
                                                                                    Logout
                                                                                </a>
                                                                        </div>
                                                                </div>
                                                                <script>
                                                                    (function () {
                                                                        var btn = document.getElementById('pl-account-btn');
                                                                        var menu = document.getElementById('pl-account-menu');
                                                                        if (btn && menu) {
                                                                            btn.addEventListener('click', function (e) {
                                                                                e.stopPropagation();
                                                                                menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
                                                                            });
                                                                            window.addEventListener('click', function () {
                                                                                menu.style.display = 'none';
                                                                            });
                                                                        }
                                                                    })();
                                                                </script>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <%-- Not logged in --%>
                                                                <a class="text-slate-600 hover:text-primary transition-transform hover:-translate-y-0.5 duration-200 hidden sm:block"
                                                                    href="${pageContext.request.contextPath}/login"
                                                                    title="Login">
                                                                    <i class="fa-solid fa-user text-lg"></i>
                                                                </a>
                                                        </c:otherwise>
                                                    </c:choose>

                                    </div>
                </div>
            </nav>

            <%-- ── SEARCH OVERLAY (AJAX-powered) ── --%>
                <div id="search-overlay"
                    class="fixed inset-0 z-[100] bg-white/95 backdrop-blur-xl transition-all duration-500 opacity-0 pointer-events-none transform translate-y-[-10px]"
                    style="overflow-y:auto">
                    <div class="h-20 px-6 max-w-[1400px] mx-auto flex items-center justify-end">
                        <button onclick="toggleSearchOverlay(false)"
                            class="w-12 h-12 rounded-full flex items-center justify-center hover:bg-slate-100 transition-colors">
                            <span class="material-symbols-outlined text-3xl text-slate-800">close</span>
                        </button>
                    </div>

                    <div class="max-w-[900px] mx-auto px-6 pt-8">
                        <div class="relative group">
                            <input type="text" id="search-input" placeholder="Tìm sản phẩm, thương hiệu..."
                                autocomplete="off"
                                class="w-full bg-transparent border-0 border-b-2 border-slate-200 py-5 text-2xl md:text-3xl font-serif text-slate-800 focus:ring-0 focus:border-primary focus:outline-none placeholder:text-slate-300 transition-all">
                            <button type="button" onclick="doAjaxSearch()"
                                class="absolute right-0 bottom-5 text-slate-400 hover:text-primary transition-colors">
                                <i class="fa-solid fa-magnifying-glass text-xl"></i>
                            </button>
                        </div>

                        <%-- Loading indicator --%>
                            <div id="search-loading" style="display:none"
                                class="flex items-center justify-center py-12">
                                <div
                                    style="width:32px;height:32px;border:3px solid #e2e8f0;border-top-color:#024acf;border-radius:50%;animation:spin 0.8s linear infinite">
                                </div>
                                <span class="ml-3 text-sm text-slate-400">Đang tìm kiếm...</span>
                            </div>
                            <style>
                                @keyframes spin {
                                    to {
                                        transform: rotate(360deg)
                                    }
                                }
                            </style>

                            <%-- Search results container --%>
                                <div id="search-results"></div>

                                <%-- Popular searches (shown initially) --%>
                                    <div id="popular-searches" class="mt-10">
                                        <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400 mb-5">
                                            Tìm kiếm phổ biến</p>
                                        <div class="flex flex-wrap gap-3" id="popular-tags">
                                            <button type="button" onclick="quickSearch('áo thun')"
                                                class="px-5 py-2 rounded-full border border-slate-200 text-[11px] font-bold text-slate-600 uppercase tracking-widest hover:border-primary hover:text-primary transition-all">Áo
                                                thun</button>
                                            <button type="button" onclick="quickSearch('quần')"
                                                class="px-5 py-2 rounded-full border border-slate-200 text-[11px] font-bold text-slate-600 uppercase tracking-widest hover:border-primary hover:text-primary transition-all">Quần</button>
                                            <button type="button" onclick="quickSearch('váy')"
                                                class="px-5 py-2 rounded-full border border-slate-200 text-[11px] font-bold text-slate-600 uppercase tracking-widest hover:border-primary hover:text-primary transition-all">Váy</button>
                                            <button type="button" onclick="quickSearch('áo khoác')"
                                                class="px-5 py-2 rounded-full border border-slate-200 text-[11px] font-bold text-slate-600 uppercase tracking-widest hover:border-primary hover:text-primary transition-all">Áo
                                                khoác</button>
                                            <button type="button" onclick="quickSearch('sơ mi')"
                                                class="px-5 py-2 rounded-full border border-slate-200 text-[11px] font-bold text-slate-600 uppercase tracking-widest hover:border-primary hover:text-primary transition-all">Sơ
                                                mi</button>
                                        </div>
                                    </div>
                    </div>
                </div>

                <script>
                    (function () {
                        var nav = document.getElementById('pl-nav');
                        if (!nav) return;
                        window.addEventListener('scroll', function () {
                            if (window.scrollY > 10) {
                                nav.style.boxShadow = '0 4px 16px rgba(0, 0, 0, 0.06)';
                                nav.style.borderBottomColor = 'transparent';
                            } else {
                                nav.style.boxShadow = 'none';
                                nav.style.borderBottomColor = '';
                            }
                        }, { passive: true });
                    })();

                    window.toggleSearchOverlay = function (isOpen) {
                        var overlay = document.getElementById('search-overlay');
                        var input = document.getElementById('search-input');
                        if (!overlay) return;

                        if (isOpen) {
                            overlay.classList.remove('opacity-0', 'pointer-events-none', 'translate-y-[-10px]');
                            overlay.classList.add('opacity-100', 'pointer-events-auto', 'translate-y-0');
                            document.body.style.overflow = 'hidden';
                            setTimeout(function () { if (input) input.focus(); }, 300);
                        } else {
                            overlay.classList.add('opacity-0', 'pointer-events-none', 'translate-y-[-10px]');
                            overlay.classList.remove('opacity-100', 'pointer-events-auto', 'translate-y-0');
                            document.body.style.overflow = '';
                        }
                    };

                    // Close on Escape
                    window.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') toggleSearchOverlay(false);
                    });

                    // Enter key triggers search
                    var searchInput = document.getElementById('search-input');
                    if (searchInput) {
                        searchInput.addEventListener('keydown', function (e) {
                            if (e.key === 'Enter') {
                                e.preventDefault();
                                doAjaxSearch();
                            }
                        });
                    }

                    // Quick search from popular tags
                    window.quickSearch = function (term) {
                        document.getElementById('search-input').value = term;
                        doAjaxSearch();
                    };

                    // ===== AJAX SEARCH ENGINE =====
                    var ctxPath = '${pageContext.request.contextPath}';
                    // Robust detection: if ctxPath seems wrong for this environment, try to detect from URL
                    if (window.location.pathname.indexOf(ctxPath) === -1) {
                        var p = window.location.pathname;
                        ctxPath = p.substring(0, p.indexOf('/', 1)) || '';
                    }
                    console.log('Detected Search Context Path:', ctxPath);

                    var cachedProducts = null; // cache fetched products

                    window.doAjaxSearch = function () {
                        var queryInput = document.getElementById('search-input');
                        var query = queryInput ? queryInput.value.trim() : '';
                        if (!query) return;

                        var keyword = query.toLowerCase();
                        var resultsDiv = document.getElementById('search-results');
                        var loadingDiv = document.getElementById('search-loading');
                        var popularDiv = document.getElementById('popular-searches');

                        // Hide popular, show loading
                        if (popularDiv) popularDiv.style.display = 'none';

                        // If we already cached all products, filter immediately
                        if (cachedProducts) {
                            displayFilteredResults(cachedProducts, keyword, resultsDiv);
                            return;
                        }

                        // Show loading
                        if (loadingDiv) loadingDiv.style.display = 'flex';
                        resultsDiv.innerHTML = '';

                        // Fetch all pages
                        fetchAllProducts(1, [], function (allProducts) {
                            cachedProducts = allProducts;
                            if (loadingDiv) loadingDiv.style.display = 'none';
                            displayFilteredResults(allProducts, keyword, resultsDiv);
                        });
                    };

                    function fetchAllProducts(page, accumulated, callback) {
                        var url = ctxPath + '/product?page=' + page;
                        console.log('Fetching products from:', url);
                        fetch(url)
                            .then(function (r) { return r.text(); })
                            .then(function (html) {
                                var parser = new DOMParser();
                                var doc = parser.parseFromString(html, 'text/html');
                                var cards = doc.querySelectorAll('div.group.cursor-pointer');

                                if (cards.length === 0) {
                                    callback(accumulated);
                                    return;
                                }

                                cards.forEach(function (card) {
                                    var linkEl = card.querySelector('a[href*="action=view"]');
                                    var nameEl = card.querySelector('h2');
                                    var brandEl = card.querySelector('h3');
                                    var imgEl = card.querySelector('img');
                                    var priceEl = card.querySelector('.text-primary');

                                    if (linkEl) {
                                        accumulated.push({
                                            url: linkEl.getAttribute('href'),
                                            name: nameEl ? nameEl.textContent.trim() : '',
                                            brand: brandEl ? brandEl.textContent.trim() : '',
                                            img: imgEl ? imgEl.getAttribute('src') : '',
                                            price: priceEl ? priceEl.textContent.trim() : '',
                                            searchText: (nameEl ? nameEl.textContent : '') + ' ' + (brandEl ? brandEl.textContent : '') + ' ' + card.textContent
                                        });
                                    }
                                });

                                // Check if there are more pages
                                var pageButtons = doc.querySelectorAll('nav[aria-label="Pagination"] button');
                                var maxPage = 1;
                                pageButtons.forEach(function (btn) {
                                    var num = parseInt(btn.textContent.trim());
                                    if (!isNaN(num) && num > maxPage) maxPage = num;
                                });

                                if (page < maxPage) {
                                    fetchAllProducts(page + 1, accumulated, callback);
                                } else {
                                    callback(accumulated);
                                }
                            })
                            .catch(function (err) {
                                console.error('Fetch error:', err);
                                callback(accumulated);
                            });
                    }

                    function displayFilteredResults(allProducts, keyword, container) {
                        var searchWords = keyword.split(/\s+/).filter(function (w) { return w.length > 0; });

                        var matches = allProducts.filter(function (p) {
                            var productText = p.searchText.toLowerCase();
                            // Match if any word in the search query is found in the product text
                            return searchWords.some(function (word) {
                                return productText.indexOf(word) !== -1;
                            });
                        });

                        if (matches.length === 0) {
                            container.innerHTML = '<div class="text-center py-16">'
                                + '<div style="width:64px;height:64px;background:#f1f5f9;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 16px">'
                                + '<span class="material-icons-outlined" style="font-size:28px;color:#cbd5e1">search_off</span></div>'
                                + '<h3 style="font-size:18px;font-family:Playfair Display,serif;color:#1e293b;margin-bottom:8px">Không tìm thấy sản phẩm</h3>'
                                + '<p style="color:#94a3b8;font-size:14px">Không có sản phẩm nào phù hợp với "' + keyword + '"</p></div>';
                            return;
                        }

                        var html = '<div style="margin-top:24px">'
                            + '<p style="font-size:10px;font-weight:800;letter-spacing:0.2em;text-transform:uppercase;color:#94a3b8;margin-bottom:16px">'
                            + matches.length + ' kết quả</p>'
                            + '<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:16px">';

                        matches.forEach(function (p) {
                            html += '<a href="' + p.url + '" style="text-decoration:none;display:block;transition:transform 0.2s" onmouseenter="this.style.transform=\'translateY(-4px)\'" onmouseleave="this.style.transform=\'translateY(0)\'">'
                                + '<div style="aspect-ratio:3/4;border-radius:8px;overflow:hidden;background:#f8fafc;margin-bottom:8px">';
                            if (p.img) {
                                html += '<img src="' + p.img + '" alt="' + p.name + '" style="width:100%;height:100%;object-fit:cover" onerror="this.style.display=\'none\'">';
                            }
                            html += '</div>'
                                + '<p style="font-size:10px;font-weight:700;color:#94a3b8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:2px">' + p.brand + '</p>'
                                + '<p style="font-size:13px;font-weight:600;color:#1e293b;line-height:1.3;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden">' + p.name + '</p>'
                                + '<p style="font-size:12px;font-weight:700;color:#024acf;margin-top:4px">' + p.price + '</p>'
                                + '</a>';
                        });

                        html += '</div></div>';
                        container.innerHTML = html;
                    }
                </script>
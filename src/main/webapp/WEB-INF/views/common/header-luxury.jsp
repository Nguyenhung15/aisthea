<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <%--============================================================header-luxury.jsp New luxury glassmorphism nav
            for homepage & future pages. Dependencies (must be loaded in parent page's <head>):
            - Tailwind CDN with tailwind.config (primary:#024acf, font-serif-display)
            - Material Symbols Outlined (Google Fonts)
            - Font Awesome 6.x
            ============================================================ --%>
            <%-- Fixed full-width wrapper for positioning — pill inside is constrained to 1400px --%>
                <div class="fixed top-0 left-0 right-0 z-50 flex justify-center px-6 pt-4 pb-6" id="nav-hover-zone">
                    <nav id="luxury-nav"
                        style="background:rgba(255,255,255,0.95);border:1px solid rgba(2,74,207,0.12);box-shadow:0 8px 32px rgba(0,0,0,0.10);border-radius:9999px;width:100%;max-width:1400px;transition:box-shadow 0.3s ease;pointer-events:auto">
                        <div class="px-8 h-[72px] flex items-center justify-between">

                            <%-- ── LEFT: Nav Links (desktop) ── --%>
                                <div class="hidden md:flex items-center space-x-10 w-1/3" id="mega-nav-links">

                                    <%-- Women --%>
                                        <div class="relative mega-trigger" data-menu="women">
                                            <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-[#024acf] transition-colors relative group text-slate-600 flex items-center gap-1 cursor-pointer"
                                                href="${pageContext.request.contextPath}/product?genderid=2">
                                                Women
                                                <span class="material-symbols-outlined text-[13px] opacity-60"
                                                    style="font-size:13px">keyboard_arrow_down</span>
                                                <span
                                                    class="absolute -bottom-1 left-0 w-0 h-0.5 bg-[#024acf] transition-all duration-300 group-hover:w-full"></span>
                                            </a>
                                        </div>

                                        <%-- Men --%>
                                            <div class="relative mega-trigger" data-menu="men">
                                                <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-[#024acf] transition-colors relative group text-slate-600 flex items-center gap-1 cursor-pointer"
                                                    href="${pageContext.request.contextPath}/product?genderid=1">
                                                    Men
                                                    <span class="material-symbols-outlined text-[13px] opacity-60"
                                                        style="font-size:13px">keyboard_arrow_down</span>
                                                    <span
                                                        class="absolute -bottom-1 left-0 w-0 h-0.5 bg-[#024acf] transition-all duration-300 group-hover:w-full"></span>
                                                </a>
                                            </div>

                                            <%-- Stylist --%>
                                                <div class="relative mega-trigger" data-menu="stylist">
                                                    <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-[#024acf] transition-colors relative group text-slate-600 flex items-center gap-1 cursor-pointer"
                                                        href="${pageContext.request.contextPath}/product">
                                                        Stylist
                                                        <span class="material-symbols-outlined text-[13px] opacity-60"
                                                            style="font-size:13px">keyboard_arrow_down</span>
                                                        <span
                                                            class="absolute -bottom-1 left-0 w-0 h-0.5 bg-[#024acf] transition-all duration-300 group-hover:w-full"></span>
                                                    </a>
                                                </div>

                                </div>

                                <%-- ── MEGA MENU PANEL (full-width, below nav pill) ── --%>
                                    <div id="mega-panel"
                                        style="position:fixed;top:90px;left:50%;transform:translateX(-50%);width:min(900px,96vw);background:rgba(255,255,255,0.98);backdrop-filter:blur(20px);border:1px solid rgba(2,74,207,0.08);border-radius:16px;box-shadow:0 24px 64px rgba(0,0,0,0.12);z-index:60;opacity:0;pointer-events:none;transition:opacity 0.15s ease,transform 0.15s ease;transform:translateX(-50%) translateY(-6px)">
                                    </div>

                                    <%-- Mobile hamburger --%>
                                        <button class="md:hidden text-slate-800 hover:text-[#024acf] transition-colors">
                                            <span class="material-symbols-outlined text-3xl">menu</span>
                                        </button>

                                        <%-- ── CENTER: Brand Logo ── --%>
                                            <div class="flex-shrink-0 w-1/3 text-center">
                                                <a class="text-3xl md:text-4xl font-serif font-bold tracking-[0.15em] text-slate-900 hover:text-[#024acf] transition-colors duration-300"
                                                    href="${pageContext.request.contextPath}/">
                                                    AISTHÉA
                                                </a>
                                            </div>

                                            <%-- ── RIGHT: Icons ── --%>
                                                <div class="flex items-center justify-end gap-6 w-1/3">

                                                    <%-- Search --%>
                                                        <button onclick="toggleSearchOverlay(true)"
                                                            class="text-slate-600 hover:text-[#024acf] transition-transform hover:-translate-y-0.5 duration-200"
                                                            title="Search">
                                                            <i class="fa-solid fa-magnifying-glass text-lg"></i>
                                                        </button>

                                                        <%-- Cart with badge --%>
                                                            <a class="text-slate-600 hover:text-[#024acf] transition-transform hover:-translate-y-0.5 duration-200 relative"
                                                                href="${pageContext.request.contextPath}/cart"
                                                                title="Cart">
                                                                <i class="fa-solid fa-bag-shopping text-lg"></i>
                                                                <c:if
                                                                    test="${not empty sessionScope.cart and sessionScope.cart.totalQuantity > 0}">
                                                                    <span class="absolute -top-1.5 -right-1.5 flex h-4 w-4 items-center justify-center
                                 rounded-full bg-[#024acf] text-[10px] text-white font-bold">
                                                                        ${sessionScope.cart.totalQuantity}
                                                                    </span>
                                                                </c:if>
                                                            </a>
                                                            <%-- ── Notification Bell ── --%>
                                                                <c:if test="${not empty sessionScope.user}">
                                                                    <div class="relative" id="pl-bell-wrapper">
                                                                        <button id="pl-bell-btn"
                                                                            class="text-slate-600 hover:text-primary transition-transform hover:-translate-y-0.5 duration-200 relative"
                                                                            title="Thông báo" aria-label="Thông báo">
                                                                            <i class="fa-solid fa-bell text-lg"></i>
                                                                            <span id="pl-bell-badge"
                                                                                style="display:none;"
                                                                                class="absolute -top-1.5 -right-1.5 flex h-4 w-4 items-center justify-center rounded-full bg-red-500 text-[10px] text-white font-bold leading-none"></span>
                                                                        </button>
                                                                        <%-- Dropdown panel --%>
                                                                            <div id="pl-bell-menu" style="display:none;"
                                                                                class="absolute top-10 right-0 w-[340px] rounded-2xl shadow-2xl border border-blue-200 z-50 overflow-hidden"
                                                                                style="background:#F8FBFF;">
                                                                                <div class="flex items-center justify-between px-4 py-3 border-b border-blue-200"
                                                                                    style="background:#EFF6FF;">
                                                                                    <span
                                                                                        class="text-xs font-bold uppercase tracking-widest text-slate-500">Thông
                                                                                        báo</span>
                                                                                    <a href="${pageContext.request.contextPath}/notifications?action=markAllRead"
                                                                                        class="text-[11px] text-primary hover:underline font-semibold"
                                                                                        onclick="event.preventDefault();plMarkAllRead();">Dánh
                                                                                        dấu tất cả đã đọc</a>
                                                                                </div>
                                                                                <div id="pl-bell-list"
                                                                                    class="max-h-[320px] overflow-y-auto divide-y divide-slate-50">
                                                                                    <div
                                                                                        class="flex items-center justify-center py-8 text-slate-400 text-sm">
                                                                                        <i
                                                                                            class="fa-solid fa-spinner fa-spin mr-2"></i>
                                                                                        Đang tải...
                                                                                    </div>
                                                                                </div>
                                                                                <div class="border-t border-blue-200">
                                                                                    <a href="${pageContext.request.contextPath}/notifications"
                                                                                        class="flex items-center justify-center gap-2 py-3 text-xs font-bold uppercase tracking-widest text-primary transition-colors"
                                                                                        style="background:#EFF6FF;"
                                                                                        onmouseenter="this.style.background='#DBEAFE'"
                                                                                        onmouseleave="this.style.background='#EFF6FF'">
                                                                                        <i
                                                                                            class="fa-solid fa-list text-xs"></i>
                                                                                        Tất cả thông báo
                                                                                    </a>
                                                                                </div>
                                                                            </div>
                                                                    </div>
                                                                </c:if>

                                                                <%-- User / Account --%>
                                                                    <c:choose>
                                                                        <c:when test="${not empty sessionScope.user}">
                                                                            <%-- Logged in: avatar + dropdown --%>
                                                                                <div class="relative flex items-center gap-2 cursor-pointer group"
                                                                                    id="lux-account-btn"
                                                                                    title="${sessionScope.user.fullname}">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty sessionScope.user.avatar and sessionScope.user.avatar != 'images/ava_default.png' and !sessionScope.user.avatar.contains('/')}">
                                                                                            <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}"
                                                                                                alt="Avatar" class="w-9 h-9 rounded-full object-cover border-2 border-white shadow-md
                                            group-hover:scale-105 transition-transform duration-200">
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <img src="${pageContext.request.contextPath}/images/ava_default.png"
                                                                                                alt="Avatar" class="w-9 h-9 rounded-full object-cover border-2 border-white shadow-md
                                            group-hover:scale-105 transition-transform duration-200">
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <span id="lux-user-name"
                                                                                        data-fullname="${sessionScope.user.fullname}"
                                                                                        class="text-sm font-medium text-slate-700 group-hover:text-[#024acf] transition-colors hidden md:block select-none">
                                                                                        ${sessionScope.user.fullname}
                                                                                    </span>
                                                                                    <script>
                                                                                        (function () {
                                                                                            var nameEl = document.getElementById('lux-user-name');
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
                                                                                        <div id="lux-account-menu"
                                                                                            style="display:none;" class="absolute top-12 right-0 bg-white/95 backdrop-blur-md rounded-2xl shadow-xl
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
                                      hover:text-[#024acf] hover:bg-blue-50/60 transition-colors font-medium">
                                                                                                    <i
                                                                                                        class="fa-solid fa-id-card text-sm w-4"></i>
                                                                                                    Profile
                                                                                                </a>
                                                                                                <c:if
                                                                                                    test="${sessionScope.user.role == 'ADMIN'}">
                                                                                                    <a href="${pageContext.request.contextPath}/dashboard"
                                                                                                        class="flex items-center gap-2 px-4 py-2.5 text-sm text-slate-700
                                          hover:text-[#024acf] hover:bg-blue-50/60 transition-colors font-medium">
                                                                                                        <i
                                                                                                            class="fa-solid fa-tachometer-alt text-sm w-4"></i>
                                                                                                        Dashboard
                                                                                                    </a>
                                                                                                </c:if>
                                                                                                <c:if
                                                                                                    test="${sessionScope.user.role == 'USER'}">
                                                                                                    <a href="${pageContext.request.contextPath}/order"
                                                                                                        class="flex items-center gap-2 px-4 py-2.5 text-sm text-slate-700
                                          hover:text-[#024acf] hover:bg-blue-50/60 transition-colors font-medium">
                                                                                                        <i
                                                                                                            class="fa-solid fa-box text-sm w-4"></i>
                                                                                                        Đơn hàng
                                                                                                    </a>
                                                                                                </c:if>
                                                                                                <hr
                                                                                                    class="my-1 border-slate-100">
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
                                                                                        var btn = document.getElementById('lux-account-btn');
                                                                                        var menu = document.getElementById('lux-account-menu');
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
                                                                                <a class="flex items-center gap-2 transition-transform hover:-translate-y-0.5 duration-200 hidden sm:block"
                                                                                    href="${pageContext.request.contextPath}/login"
                                                                                    title="Login">
                                                                                    <img src="${pageContext.request.contextPath}/images/ava_default.png"
                                                                                        alt="Avatar"
                                                                                        class="w-9 h-9 rounded-full object-cover border-2 border-white shadow-md">
                                                                                </a>
                                                                        </c:otherwise>
                                                                    </c:choose>

                                                </div>
                    </nav>
                </div><%-- end fixed outer wrapper --%>

                    <%-- ── SEARCH OVERLAY (Homepage, AJAX-powered) ── --%>
                        <div id="search-overlay"
                            class="fixed inset-0 z-[200] bg-white/95 transition-all duration-500 opacity-0 pointer-events-none"
                            style="backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);transform:translateY(-10px);overflow-y:auto">
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
                                        class="w-full bg-transparent border-0 border-b-2 border-slate-200 py-5 text-2xl md:text-3xl text-slate-800 focus:ring-0 focus:border-[#024acf] focus:outline-none placeholder:text-slate-300 transition-all"
                                        style="font-family:'Playfair Display',serif">
                                    <button type="button" onclick="doAjaxSearch()"
                                        class="absolute right-0 bottom-5 text-slate-400 hover:text-[#024acf] transition-colors">
                                        <i class="fa-solid fa-magnifying-glass text-xl"></i>
                                    </button>
                                </div>

                                <%-- Loading indicator --%>
                                    <div id="search-loading"
                                        style="display:none;justify-content:center;align-items:center;padding:48px 0">
                                        <div
                                            style="width:32px;height:32px;border:3px solid #e2e8f0;border-top-color:#024acf;border-radius:50%;animation:hpSpin 0.8s linear infinite">
                                        </div>
                                        <span style="margin-left:12px;font-size:14px;color:#94a3b8">Đang tìm
                                            kiếm...</span>
                                    </div>
                                    <style>
                                        @keyframes hpSpin {
                                            to {
                                                transform: rotate(360deg)
                                            }
                                        }
                                    </style>

                                    <%-- Search results --%>
                                        <div id="search-results"></div>

                                        <%-- Popular searches --%>
                                            <div id="popular-searches" style="margin-top:40px">
                                                <p
                                                    style="font-size:10px;font-weight:800;letter-spacing:0.2em;text-transform:uppercase;color:#94a3b8;margin-bottom:20px">
                                                    Tìm kiếm phổ biến</p>
                                                <div style="display:flex;flex-wrap:wrap;gap:10px">
                                                    <button type="button" onclick="quickSearch('áo thun')"
                                                        style="padding:8px 20px;border-radius:9999px;border:1px solid #e2e8f0;font-size:11px;font-weight:700;color:#475569;text-transform:uppercase;letter-spacing:0.1em;background:none;cursor:pointer;transition:all 0.2s"
                                                        onmouseenter="this.style.borderColor='#024acf';this.style.color='#024acf'"
                                                        onmouseleave="this.style.borderColor='#e2e8f0';this.style.color='#475569'">Áo
                                                        thun</button>
                                                    <button type="button" onclick="quickSearch('quần')"
                                                        style="padding:8px 20px;border-radius:9999px;border:1px solid #e2e8f0;font-size:11px;font-weight:700;color:#475569;text-transform:uppercase;letter-spacing:0.1em;background:none;cursor:pointer;transition:all 0.2s"
                                                        onmouseenter="this.style.borderColor='#024acf';this.style.color='#024acf'"
                                                        onmouseleave="this.style.borderColor='#e2e8f0';this.style.color='#475569'">Quần</button>
                                                    <button type="button" onclick="quickSearch('váy')"
                                                        style="padding:8px 20px;border-radius:9999px;border:1px solid #e2e8f0;font-size:11px;font-weight:700;color:#475569;text-transform:uppercase;letter-spacing:0.1em;background:none;cursor:pointer;transition:all 0.2s"
                                                        onmouseenter="this.style.borderColor='#024acf';this.style.color='#024acf'"
                                                        onmouseleave="this.style.borderColor='#e2e8f0';this.style.color='#475569'">Váy</button>
                                                    <button type="button" onclick="quickSearch('áo khoác')"
                                                        style="padding:8px 20px;border-radius:9999px;border:1px solid #e2e8f0;font-size:11px;font-weight:700;color:#475569;text-transform:uppercase;letter-spacing:0.1em;background:none;cursor:pointer;transition:all 0.2s"
                                                        onmouseenter="this.style.borderColor='#024acf';this.style.color='#024acf'"
                                                        onmouseleave="this.style.borderColor='#e2e8f0';this.style.color='#475569'">Áo
                                                        khoác</button>
                                                    <button type="button" onclick="quickSearch('sơ mi')"
                                                        style="padding:8px 20px;border-radius:9999px;border:1px solid #e2e8f0;font-size:11px;font-weight:700;color:#475569;text-transform:uppercase;letter-spacing:0.1em;background:none;cursor:pointer;transition:all 0.2s"
                                                        onmouseenter="this.style.borderColor='#024acf';this.style.color='#024acf'"
                                                        onmouseleave="this.style.borderColor='#e2e8f0';this.style.color='#475569'">Sơ
                                                        mi</button>
                                                </div>
                                            </div>
                            </div>
                        </div>

                        <script>
                            window.toggleSearchOverlay = function (isOpen) {
                                var overlay = document.getElementById('search-overlay');
                                var input = document.getElementById('search-input');
                                if (!overlay) return;
                                if (isOpen) {
                                    overlay.style.opacity = '1';
                                    overlay.style.pointerEvents = 'auto';
                                    overlay.style.transform = 'translateY(0)';
                                    document.body.style.overflow = 'hidden';
                                    setTimeout(function () { if (input) input.focus(); }, 300);
                                } else {
                                    overlay.style.opacity = '0';
                                    overlay.style.pointerEvents = 'none';
                                    overlay.style.transform = 'translateY(-10px)';
                                    document.body.style.overflow = '';
                                }
                            };
                            window.addEventListener('keydown', function (e) {
                                if (e.key === 'Escape') toggleSearchOverlay(false);
                            });

                            // Enter key triggers search
                            var searchInput = document.getElementById('search-input');
                            if (searchInput) {
                                searchInput.addEventListener('keydown', function (e) {
                                    if (e.key === 'Enter') { e.preventDefault(); doAjaxSearch(); }
                                });
                            }

                            // Quick search from popular tags
                            window.quickSearch = function (term) {
                                document.getElementById('search-input').value = term;
                                doAjaxSearch();
                            };

                            // ===== AJAX SEARCH ENGINE =====
                            var ctxPath = '${pageContext.request.contextPath}';
                            // Robust detection
                            if (window.location.pathname.indexOf(ctxPath) === -1) {
                                var p = window.location.pathname;
                                ctxPath = p.substring(0, p.indexOf('/', 1)) || '';
                            }
                            console.log('Detected Home Search Context:', ctxPath);

                            var cachedProducts = null;

                            window.doAjaxSearch = function () {
                                var queryInput = document.getElementById('search-input');
                                var query = queryInput ? queryInput.value.trim() : '';
                                if (!query) return;
                                var keyword = query.toLowerCase();
                                var resultsDiv = document.getElementById('search-results');
                                var loadingDiv = document.getElementById('search-loading');
                                var popularDiv = document.getElementById('popular-searches');
                                if (popularDiv) popularDiv.style.display = 'none';

                                if (cachedProducts) {
                                    displayFilteredResults(cachedProducts, keyword, resultsDiv);
                                    return;
                                }

                                if (loadingDiv) loadingDiv.style.display = 'flex';
                                resultsDiv.innerHTML = '';

                                fetchAllProducts(1, [], function (allProducts) {
                                    cachedProducts = allProducts;
                                    if (loadingDiv) loadingDiv.style.display = 'none';
                                    displayFilteredResults(allProducts, keyword, resultsDiv);
                                });
                            };

                            function fetchAllProducts(page, accumulated, callback) {
                                var url = ctxPath + '/product?page=' + page;
                                console.log('Fetching products (home) from:', url);
                                fetch(url)
                                    .then(function (r) { return r.text(); })
                                    .then(function (html) {
                                        var parser = new DOMParser();
                                        var doc = parser.parseFromString(html, 'text/html');
                                        var cards = doc.querySelectorAll('div.group.cursor-pointer');
                                        if (cards.length === 0) { callback(accumulated); return; }

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

                                        var pageButtons = doc.querySelectorAll('nav[aria-label="Pagination"] button');
                                        var maxPage = 1;
                                        pageButtons.forEach(function (btn) {
                                            var num = parseInt(btn.textContent.trim());
                                            if (!isNaN(num) && num > maxPage) maxPage = num;
                                        });
                                        if (page < maxPage) { fetchAllProducts(page + 1, accumulated, callback); }
                                        else { callback(accumulated); }
                                    })
                                    .catch(function (err) {
                                        console.error('Fetch error (home):', err);
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
                                    container.innerHTML = '<div style="text-align:center;padding:64px 0">'
                                        + '<div style="width:64px;height:64px;background:#f1f5f9;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 16px">'
                                        + '<span class="material-symbols-outlined" style="font-size:28px;color:#cbd5e1">search_off</span></div>'
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
                                    if (p.img) { html += '<img src="' + p.img + '" alt="' + p.name + '" style="width:100%;height:100%;object-fit:cover" onerror="this.style.display=\'none\'">'; }
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
                        <script>
                            (function () {
                                var panel = document.getElementById('mega-panel');

                                // ── Mega Menu Data ──
                                var ctxPath = '${pageContext.request.contextPath}';
                                var megaData = {
                                    women: {
                                        "ÁO KHOÁC": { genderid: 2, index: "ao_khoac", img: "https://i.pinimg.com/1200x/e8/b4/08/e8b408e3efca56101817e5dcc493646d.jpg" },
                                        "ÁO THUN": { genderid: 2, index: "ao_thun", img: "https://i.pinimg.com/1200x/32/8f/54/328f54a667c60e64abcc633568ed7a3b.jpg" },
                                        "QUẦN": { genderid: 2, index: "quan", img: "https://i.pinimg.com/736x/6f/19/18/6f1918a12889cf8b40686d5e377a4cdb.jpg" },
                                        "CHÂN VÁY & ĐẦM": { genderid: 2, index: "vay_dam", img: "https://i.pinimg.com/1200x/39/4d/bb/394dbb1d073379c4247c0219d31b4e03.jpg" },
                                        "ĐỒ MẶC TRONG": { genderid: 2, index: "do_mac_trong", img: "https://i.pinimg.com/736x/bd/fe/5b/bdfe5b90e07b09208331dd31f3e8ce82.jpg" },
                                        "ÁO SƠ MI": { genderid: 2, index: "ao_so_mi", img: "https://i.pinimg.com/474x/6e/82/c2/6e82c2ac2e271234d258b465af9bcd9d.jpg" },
                                        "ÁO LEN": { genderid: 2, index: "ao_len", img: "https://i.pinimg.com/1200x/45/c4/f2/45c4f2e1f048d0a3370f1a75b58cb18a.jpg" },
                                        "PHỤ KIỆN": { genderid: 2, index: "phu_kien", img: "https://i.pinimg.com/736x/77/6d/fd/776dfddd9ec89ce50c37fcec61dd1270.jpg" }
                                    },
                                    men: {
                                        "ÁO KHOÁC": { genderid: 1, index: "ao_khoac", img: "https://i.pinimg.com/736x/46/be/3a/46be3a5ba779ab45bc6349329c44e49e.jpg" },
                                        "ÁO THUN": { genderid: 1, index: "ao_thun", img: "https://i.pinimg.com/736x/4d/64/aa/4d64aa295c000ec2b3bc7da2718d035d.jpg" },
                                        "ÁO LEN": { genderid: 1, index: "ao_len", img: "https://i.pinimg.com/736x/f2/f5/d1/f2f5d1ec7c5279f7a6e744054a23387e.jpg" },
                                        "ÁO SƠ MI": { genderid: 1, index: "ao_so_mi", img: "https://i.pinimg.com/736x/5e/6e/4f/5e6e4fabc24bc0439ba0d1277a4de758.jpg" },
                                        "QUẦN": { genderid: 1, index: "quan", img: "https://i.pinimg.com/474x/34/86/7a/34867afcdf4f8f6954bfe1b2a4a5a572.jpg" },
                                        "ĐỒ THỂ THAO": { genderid: 1, index: "do_the_thao", img: "https://i.pinimg.com/736x/0f/74/ea/0f74ead793543694e7c9c0ceb71f7804.jpg" },
                                        "ĐỒ MẶC NHÀ": { genderid: 1, index: "do_mac_nha", img: "https://i.pinimg.com/474x/9b/11/5a/9b115a490e81e07fa5c701282a223498.jpg" },
                                        "PHỤ KIỆN": { genderid: 1, index: "phu_kien", img: "https://i.pinimg.com/736x/b0/37/86/b03786cd59d0c34446c8ea257c0a2a00.jpg" }
                                    },
                                    stylist: {
                                        "Minimalist": { genderid: 2, index: "style_minimalist", img: "https://images.unsplash.com/photo-1551854838-ef3d0d7c2f4f?auto=format&fit=crop&w=800&q=60" },
                                        "Streetwear": { genderid: 1, index: "style_streetwear", img: "https://images.unsplash.com/photo-1519741491601-9f5dcd2b0f3e?auto=format&fit=crop&w=800&q=60" }
                                    }
                                };

                                function renderPanel(menuKey) {
                                    var cats = megaData[menuKey];
                                    if (!cats || !panel) return;
                                    var keys = Object.keys(cats);
                                    var html = '<div style="padding:20px 28px">';
                                    html += '<p style="font-size:9px;font-weight:800;letter-spacing:0.3em;text-transform:uppercase;color:#94a3b8;margin-bottom:14px">' + menuKey.toUpperCase() + ' COLLECTION</p>';
                                    html += '<div style="display:grid;grid-template-columns:repeat(4,1fr);gap:8px">';
                                    keys.forEach(function (name) {
                                        var cat = cats[name];
                                        var url = ctxPath + '/product?categoryIndex=' + cat.index + '&genderid=' + cat.genderid;
                                        html += '<a href="' + url + '" style="display:block;text-decoration:none" onmouseenter="this.querySelector(\'img\').style.transform=\'scale(1.07)\'" onmouseleave="this.querySelector(\'img\').style.transform=\'scale(1)\'">';
                                        html += '<div style="overflow:hidden;border-radius:8px;aspect-ratio:1/1;margin-bottom:8px">';
                                        html += '<img src="' + cat.img + '" alt="' + name + '" style="width:100%;height:100%;object-fit:cover;transition:transform 0.2s ease">';
                                        html += '</div>';
                                        html += '<p style="font-size:9px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#1e293b;text-align:center">' + name + '</p>';
                                        html += '</a>';
                                    });
                                    html += '</div></div>';
                                    panel.innerHTML = html;
                                }

                                var hideTimer;
                                function openMega(menuKey) {
                                    clearTimeout(hideTimer);
                                    renderPanel(menuKey);
                                    panel.style.opacity = '1';
                                    panel.style.pointerEvents = 'auto';
                                    panel.style.transform = 'translateX(-50%) translateY(0)';
                                }
                                function closeMega() {
                                    hideTimer = setTimeout(function () {
                                        panel.style.opacity = '0';
                                        panel.style.pointerEvents = 'none';
                                        panel.style.transform = 'translateX(-50%) translateY(-8px)';
                                    }, 120);
                                }

                                document.querySelectorAll('.mega-trigger').forEach(function (el) {
                                    el.addEventListener('mouseenter', function () { openMega(el.dataset.menu); });
                                    el.addEventListener('mouseleave', closeMega);
                                });
                                if (panel) {
                                    panel.addEventListener('mouseenter', function () { clearTimeout(hideTimer); });
                                    panel.addEventListener('mouseleave', closeMega);
                                }
                            })();
                        </script>

                        <%-- ── Notification Bell Script (header-luxury.jsp) ── --%>
                            <script>
                                (function () {
                                    var bellBtn = document.getElementById('pl-bell-btn');
                                    var bellMenu = document.getElementById('pl-bell-menu');
                                    var bellList = document.getElementById('pl-bell-list');
                                    var bellBadge = document.getElementById('pl-bell-badge');
                                    if (!bellBtn || !bellMenu) return;

                                    var ctxPath = '${pageContext.request.contextPath}';
                                    var loaded = false;

                                    // ── Toggle dropdown ──
                                    bellBtn.addEventListener('click', function (e) {
                                        e.stopPropagation();
                                        var isOpen = bellMenu.style.display === 'block';
                                        bellMenu.style.display = isOpen ? 'none' : 'block';
                                        if (!isOpen && !loaded) { loadNotifications(); }
                                    });

                                    // ── Close when clicking outside ──
                                    document.addEventListener('click', function (e) {
                                        if (!bellMenu.contains(e.target) && e.target !== bellBtn) {
                                            bellMenu.style.display = 'none';
                                        }
                                    });

                                    // ── Fetch & render notifications ──
                                    function loadNotifications() {
                                        loaded = true;
                                        fetch(ctxPath + '/notifications/api?limit=10', { credentials: 'same-origin' })
                                            .then(function (r) { return r.json(); })
                                            .then(function (data) {
                                                renderNotifications(data.notifications || []);
                                                updateBadge(data.unreadCount || 0);
                                            })
                                            .catch(function () {
                                                if (bellList) bellList.innerHTML =
                                                    '<div style="display:flex;align-items:center;justify-content:center;padding:32px 16px;color:#94a3b8;font-size:13px;">'
                                                    + '<i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>Không thể tải thông báo</div>';
                                            });
                                    }

                                    function iconForType(type) {
                                        if (type === 'ORDER') return { icon: 'local_shipping', bg: '#eff6ff', color: '#0056b3', border: '#bfdbfe' };
                                        if (type === 'PROMOTION') return { icon: 'percent', bg: '#fffbeb', color: '#C5A059', border: '#fde68a' };
                                        return { icon: 'info', bg: '#f8fafc', color: '#94a3b8', border: '#e2e8f0' };
                                    }

                                    function labelForType(type) {
                                        if (type === 'ORDER') return 'Cập nhật đơn hàng';
                                        if (type === 'PROMOTION') return 'Khuyến mãi';
                                        return 'Hệ thống';
                                    }

                                    function renderNotifications(list) {
                                        if (!bellList) return;
                                        if (!list.length) {
                                            bellList.innerHTML =
                                                '<div style="display:flex;flex-direction:column;align-items:center;justify-content:center;padding:40px 16px;color:#94a3b8;gap:10px;">'
                                                + '<span class="material-symbols-outlined" style="font-size:48px;opacity:0.25;">notifications_off</span>'
                                                + '<span style="font-size:13px;font-weight:500;">Bạn chưa có thông báo nào</span></div>';
                                            return;
                                        }
                                        var html = '';
                                        list.forEach(function (n) {
                                            var ic = iconForType(n.type);
                                            var lbl = labelForType(n.type);
                                            var unreadBg = n.read ? '#F8FBFF' : '#EFF6FF';
                                            var dotStyle = n.read
                                                ? 'display:none;'
                                                : 'position:absolute;top:18px;left:14px;width:8px;height:8px;border-radius:50%;background:#38bdf8;box-shadow:0 0 8px #38bdf8;';
                                            
                                            var redirectQuery = '';
                                            if (n.type === 'ORDER' && n.content) {
                                                var match = n.content.match(/#(\d+)/);
                                                if (match && match[1]) {
                                                    redirectQuery = '&redirectUrl=' + encodeURIComponent('/order?action=view&id=' + match[1]);
                                                }
                                            } else if (n.type === 'PROMOTION') {
                                                redirectQuery = '&redirectUrl=' + encodeURIComponent('/home');
                                            }

                                            html += '<a href="' + ctxPath + '/notifications?action=markRead&id=' + n.id + redirectQuery + '"'
                                                + ' style="display:flex;align-items:flex-start;gap:12px;padding:14px 16px 14px 20px;'
                                                + 'background:' + unreadBg + ';border-bottom:1px solid #DBEAFE;'
                                                + 'text-decoration:none;transition:background 0.2s;position:relative;cursor:pointer;"'
                                                + ' onmouseenter="this.style.background=\'#DBEAFE\'"'
                                                + ' onmouseleave="this.style.background=\'' + unreadBg + '\'">'
                                                /* unread dot */
                                                + '<span style="' + dotStyle + '"></span>'
                                                /* type icon circle */
                                                + '<div style="width:44px;height:44px;border-radius:50%;flex-shrink:0;'
                                                + 'display:flex;align-items:center;justify-content:center;'
                                                + 'background:' + ic.bg + ';border:1px solid ' + ic.border + ';margin-left:4px;">'
                                                + '<span class="material-symbols-outlined" style="font-size:20px;color:' + ic.color + ';">' + ic.icon + '</span>'
                                                + '</div>'
                                                /* text block */
                                                + '<div style="flex:1;min-width:0;">'
                                                + '<div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:2px;">'
                                                + '<p style="font-size:13px;font-weight:700;color:#0f172a;margin:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:160px;">' + (n.title || 'Thông báo') + '</p>'
                                                + '<span style="font-size:10px;color:#94a3b8;background:#f8fafc;border:1px solid #e2e8f0;border-radius:9999px;padding:1px 7px;white-space:nowrap;flex-shrink:0;margin-left:6px;">' + (n.time || '') + '</span>'
                                                + '</div>'
                                                + '<p style="font-size:12px;color:#475569;margin:0 0 4px;line-height:1.45;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;">' + (n.content || '') + '</p>'
                                                + '<span style="font-size:10px;font-weight:700;color:#94a3b8;text-transform:uppercase;letter-spacing:0.08em;">' + lbl + '</span>'
                                                + '</div>'
                                                + '</a>';
                                        });
                                        bellList.innerHTML = html;
                                    }

                                    function updateBadge(count) {
                                        if (!bellBadge) return;
                                        if (count > 0) {
                                            bellBadge.textContent = count > 99 ? '99+' : count;
                                            bellBadge.style.display = 'flex';
                                        } else {
                                            bellBadge.style.display = 'none';
                                        }
                                    }

                                    // ── Mark single read ──
                                    window.luxBellMarkRead = function (id) {
                                        fetch(ctxPath + '/notifications/api?action=markRead&id=' + id,
                                            { method: 'POST', credentials: 'same-origin' }).catch(function () { });
                                    };

                                    // ── Mark all read ──
                                    window.plMarkAllRead = function () {
                                        fetch(ctxPath + '/notifications/api?action=markAllRead',
                                            { method: 'POST', credentials: 'same-origin' })
                                            .then(function () { updateBadge(0); loaded = false; loadNotifications(); })
                                            .catch(function () { });
                                    };

                                    // ── Auto-fetch badge count on page load ──
                                    fetch(ctxPath + '/notifications/api?limit=1', { credentials: 'same-origin' })
                                        .then(function (r) { return r.json(); })
                                        .then(function (data) { updateBadge(data.unreadCount || 0); })
                                        .catch(function () { });
                                })();
                            </script>
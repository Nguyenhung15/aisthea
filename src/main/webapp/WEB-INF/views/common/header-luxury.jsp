<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <%--============================================================header-luxury.jsp New luxury glassmorphism nav
            for homepage & future pages. Dependencies (must be loaded in parent page's <head>):
            - Tailwind CDN with tailwind.config (primary:#024acf, font-serif-display)
            - Material Symbols Outlined (Google Fonts)
            - Font Awesome 6.x
            ============================================================ --%>
            <%-- Fixed full-width wrapper for positioning — pill inside is constrained to 1400px --%>
                <div class="fixed top-6 left-0 right-0 z-50 flex justify-center px-6">
                    <nav class="glass-header glow-border rounded-full w-full max-w-[1400px] transition-all duration-300"
                        id="luxury-nav">
                        <div class="px-8 h-20 flex items-center justify-between">

                            <%-- ── LEFT: Nav Links (desktop) ── --%>
                                <div class="hidden md:flex items-center space-x-10 w-1/3">
                                    <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-[#024acf] transition-colors relative group text-slate-600"
                                        href="${pageContext.request.contextPath}/product?genderid=2">
                                        Women
                                        <span
                                            class="absolute -bottom-1 left-0 w-0 h-0.5 bg-[#024acf] transition-all duration-300 group-hover:w-full"></span>
                                    </a>
                                    <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-[#024acf] transition-colors relative group text-slate-600"
                                        href="${pageContext.request.contextPath}/product?genderid=1">
                                        Men
                                        <span
                                            class="absolute -bottom-1 left-0 w-0 h-0.5 bg-[#024acf] transition-all duration-300 group-hover:w-full"></span>
                                    </a>
                                    <a class="text-xs font-semibold uppercase tracking-[0.1em] hover:text-[#024acf] transition-colors relative group text-slate-600"
                                        href="${pageContext.request.contextPath}/product">
                                        Stylist
                                        <span
                                            class="absolute -bottom-1 left-0 w-0 h-0.5 bg-[#024acf] transition-all duration-300 group-hover:w-full"></span>
                                    </a>
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
                                                    <button
                                                        class="text-slate-600 hover:text-[#024acf] transition-transform hover:-translate-y-0.5 duration-200"
                                                        title="Search">
                                                        <i class="fa-solid fa-magnifying-glass text-lg"></i>
                                                    </button>

                                                    <%-- Cart with badge --%>
                                                        <a class="text-slate-600 hover:text-[#024acf] transition-transform hover:-translate-y-0.5 duration-200 relative"
                                                            href="${pageContext.request.contextPath}/cart" title="Cart">
                                                            <i class="fa-solid fa-bag-shopping text-lg"></i>
                                                            <c:if
                                                                test="${not empty sessionScope.cart and sessionScope.cart.totalQuantity > 0}">
                                                                <span class="absolute -top-1.5 -right-1.5 flex h-4 w-4 items-center justify-center
                                 rounded-full bg-[#024acf] text-[10px] text-white font-bold">
                                                                    ${sessionScope.cart.totalQuantity}
                                                                </span>
                                                            </c:if>
                                                        </a>

                                                        <%-- User / Account --%>
                                                            <c:choose>
                                                                <c:when test="${not empty sessionScope.user}">
                                                                    <%-- Logged in: avatar + dropdown --%>
                                                                        <div class="relative flex items-center gap-2 cursor-pointer group"
                                                                            id="lux-account-btn"
                                                                            title="${sessionScope.user.fullname}">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty sessionScope.user.avatar and !sessionScope.user.avatar.equals('images/ava_default.png')}">
                                                                                    <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}"
                                                                                        alt="Avatar" class="w-9 h-9 rounded-full object-cover border-2 border-white shadow-md
                                            group-hover:scale-105 transition-transform duration-200">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <div
                                                                                        class="text-slate-600 group-hover:text-[#024acf] transition-transform group-hover:-translate-y-0.5 duration-200">
                                                                                        <i
                                                                                            class="fa-solid fa-user text-lg"></i>
                                                                                    </div>
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
                                                                        <a class="text-slate-600 hover:text-[#024acf] transition-transform hover:-translate-y-0.5 duration-200 hidden sm:block"
                                                                            href="${pageContext.request.contextPath}/login"
                                                                            title="Login">
                                                                            <i class="fa-solid fa-user text-lg"></i>
                                                                        </a>
                                                                </c:otherwise>
                                                            </c:choose>

                                            </div>
                    </nav>
                </div><%-- end fixed outer wrapper --%>
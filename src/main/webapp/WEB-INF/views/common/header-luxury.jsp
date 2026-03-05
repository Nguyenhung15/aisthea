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
                                                        <button
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
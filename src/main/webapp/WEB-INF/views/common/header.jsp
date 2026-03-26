<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <header>
            <div class="left">
                <div class="logo">
                    <a href="${pageContext.request.contextPath}/home">
                        <img src="${pageContext.request.contextPath}/assets/images/ata-logo.png" alt="AISTHEA">
                    </a>
                </div>
            </div>

            <div class="center">
                <nav id="main-nav">
                    <div class="nav-item" data-key="women">WOMEN</div>
                    <div class="nav-item" data-key="men">MEN</div>
                    <div class="nav-item" data-key="stylist">STYLIST</div>
                </nav>
            </div>

            <div class="right">
                <div id="search-icon" class="icon-btn" title="Search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </div>

                <a class="icon-btn" href="${pageContext.request.contextPath}/cart" title="Cart"
                    style="position:relative;">
                    <i class="fa-solid fa-bag-shopping"></i>
                    <c:if test="${not empty sessionScope.cart and sessionScope.cart.totalQuantity > 0}">
                        <span
                            style="position:absolute;top:-6px;right:-8px;background:#ef4444;color:#fff;font-size:11px;font-weight:700;border-radius:50%;min-width:18px;height:18px;display:flex;align-items:center;justify-content:center;padding:0 4px;">
                            ${sessionScope.cart.totalQuantity}
                        </span>
                    </c:if>
                </a>

                <%-- ── Notification Bell ── --%>
                <c:if test="${not empty sessionScope.user}">
                    <div id="hdr-bell-wrapper" style="position:relative;display:inline-flex;align-items:center;">
                        <button id="hdr-bell-btn" class="icon-btn" title="Thông báo" style="position:relative;">
                            <i class="fa-solid fa-bell"></i>
                            <span id="hdr-bell-badge"
                                style="display:none;position:absolute;top:-6px;right:-8px;background:#ef4444;color:#fff;
                                       font-size:10px;font-weight:700;border-radius:50%;min-width:16px;height:16px;
                                       align-items:center;justify-content:center;padding:0 3px;"></span>
                        </button>
                        <%-- Dropdown --%>
                        <div id="hdr-bell-menu"
                             style="display:none;position:absolute;top:52px;right:0;width:320px;background:#F8FBFF;
                                    border-radius:12px;box-shadow:0 8px 32px rgba(0,0,0,0.13);border:1px solid #DBEAFE;
                                    z-index:200;overflow:hidden;">
                            <div style="display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid #DBEAFE;background:#EFF6FF;">
                                <span style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;color:#94a3b8;">Thông báo</span>
                                <a href="${pageContext.request.contextPath}/notifications?action=markAllRead"
                                   style="font-size:11px;color:#024acf;font-weight:600;text-decoration:none;"
                                   onclick="event.preventDefault();hdrMarkAllRead();">Đánh dấu tất cả đã đọc</a>
                            </div>
                            <div id="hdr-bell-list" style="max-height:300px;overflow-y:auto;">
                                <div style="display:flex;align-items:center;justify-content:center;padding:32px 16px;color:#94a3b8;font-size:13px;">
                                    <i class="fa-solid fa-spinner fa-spin" style="margin-right:8px;"></i> Đang tải...
                                </div>
                            </div>
                            <div style="border-top:1px solid #DBEAFE;">
                                <a href="${pageContext.request.contextPath}/notifications"
                                   style="display:flex;align-items:center;justify-content:center;gap:6px;padding:12px;
                                          font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;
                                          color:#024acf;text-decoration:none;transition:background 0.2s;background:#EFF6FF;"
                                   onmouseenter="this.style.background='#DBEAFE'"
                                   onmouseleave="this.style.background='#EFF6FF'">
                                    <i class="fa-solid fa-list" style="font-size:11px;"></i>
                                    Tất cả thông báo
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div id="account-btn" class="icon-btn" style="position:relative;">
                            <c:choose>
                                <c:when
                                    test="${not empty sessionScope.user.avatar and sessionScope.user.avatar != 'images/ava_default.png' and !sessionScope.user.avatar.contains('/')}">
                                    <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}"
                                        alt="Avatar"
                                        style="width:36px;height:36px;border-radius:50%;object-fit:cover;vertical-align:middle;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/images/ava_default.png"
                                        alt="Avatar"
                                        style="width:36px;height:36px;border-radius:50%;object-fit:cover;vertical-align:middle;">
                                </c:otherwise>
                            </c:choose>

                            <span style="font-weight:600;margin-left:6px;">${sessionScope.user.fullname}</span>

                            <div id="account-menu" style="display:none;position:absolute;top:60px;right:0;background:white;
                        border-radius:8px;box-shadow:0 4px 15px rgba(0,0,0,0.15);min-width:160px;z-index:100;">

                                <a href="${pageContext.request.contextPath}/profile"
                                    style="display:block;padding:10px 16px;color:#a0522d;text-decoration:none;font-weight:600;">
                                    <i class="fa-solid fa-id-card"></i> Profile
                                </a>

                                <%--===LOGIC MỚI CHO ROLE===--%>
                                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                        <a href="${pageContext.request.contextPath}/dashboard"
                                            style="display:block;padding:10px 16px;color:#a0522d;text-decoration:none;font-weight:600;">
                                            <i class="fa-solid fa-tachometer-alt"></i> Dashboard
                                        </a>
                                    </c:if>

                                    <c:if test="${sessionScope.user.role == 'USER'}">
                                        <a href="${pageContext.request.contextPath}/order"
                                            style="display:block;padding:10px 16px;color:#a0522d;text-decoration:none;font-weight:600;">
                                            <i class="fa-solid fa-box"></i> Đơn hàng
                                        </a>
                                    </c:if>
                                    <%--===KẾT THÚC LOGIC MỚI===--%>

                                        <a href="${pageContext.request.contextPath}/logout"
                                            style="display:block;padding:10px 16px;color:#a0522d;text-decoration:none;font-weight:600;">
                                            <i class="fa-solid fa-right-from-bracket"></i> Logout
                                        </a>
                            </div>
                        </div>

                        <script>
                            const accountBtn = document.getElementById("account-btn");
                            const accountMenu = document.getElementById("account-menu");
                            if (accountBtn) {
                                accountBtn.addEventListener("click", (e) => {
                                    e.stopPropagation();
                                    accountMenu.style.display = accountMenu.style.display === "block" ? "none" : "block";
                                });
                            }
                            window.addEventListener("click", (e) => {
                                if (accountMenu && accountMenu.style.display === "block") {
                                    accountMenu.style.display = "none";
                                }
                            });
                        </script>
                    </c:when>

                    <c:otherwise>
                        <a class="icon-btn" href="${pageContext.request.contextPath}/login" title="Login" style="display: flex; align-items: center; gap: 8px; text-decoration: none;">
                            <img src="${pageContext.request.contextPath}/images/ava_default.png"
                                 alt="Avatar"
                                 style="width:36px;height:36px;border-radius:50%;object-fit:cover;vertical-align:middle;">
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <div class="mega-wrap" id="mega-wrap">
            <div class="mega" id="mega">
                <div class="mega-content" id="mega-content"></div>
            </div>
        </div>
        <div class="media-banner__shadow"></div>
        <div id="search-pop"></div>

        <%-- ── Notification Bell Script (header.jsp) ── --%>
        <script>
            (function () {
                var bellBtn   = document.getElementById('hdr-bell-btn');
                var bellMenu  = document.getElementById('hdr-bell-menu');
                var bellList  = document.getElementById('hdr-bell-list');
                var bellBadge = document.getElementById('hdr-bell-badge');
                if (!bellBtn || !bellMenu) return;

                var ctxPath = '${pageContext.request.contextPath}';
                var loaded  = false;

                bellBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    var isOpen = bellMenu.style.display === 'block';
                    bellMenu.style.display = isOpen ? 'none' : 'block';
                    if (!isOpen && !loaded) { loadNotifications(); }
                });

                document.addEventListener('click', function (e) {
                    if (!bellMenu.contains(e.target) && e.target !== bellBtn) {
                        bellMenu.style.display = 'none';
                    }
                });

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
                                '<div style="display:flex;align-items:center;justify-content:center;padding:32px;color:#94a3b8;font-size:13px;">'
                                + '<i class="fa-solid fa-circle-exclamation" style="margin-right:8px;"></i>Không thể tải thông báo</div>';
                        });
                }

                function iconForType(type) {
                    if (type === 'ORDER')     return { icon: 'local_shipping', bg: '#eff6ff', color: '#0056b3', border: '#bfdbfe' };
                    if (type === 'PROMOTION') return { icon: 'percent',        bg: '#fffbeb', color: '#C5A059', border: '#fde68a' };
                    return                           { icon: 'info',            bg: '#f8fafc', color: '#94a3b8', border: '#e2e8f0' };
                }
                function labelForType(type) {
                    if (type === 'ORDER')     return 'Cập nhật đơn hàng';
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
                        var ic  = iconForType(n.type);
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
                            +         'background:' + unreadBg + ';border-bottom:1px solid #DBEAFE;'
                            +         'text-decoration:none;transition:background 0.2s;position:relative;"'
                            + ' onmouseenter="this.style.background=\'#DBEAFE\'"'
                            + ' onmouseleave="this.style.background=\'' + unreadBg + '\'">'
                            + '<span style="' + dotStyle + '"></span>'
                            + '<div style="width:44px;height:44px;border-radius:50%;flex-shrink:0;'
                            +           'display:flex;align-items:center;justify-content:center;'
                            +           'background:' + ic.bg + ';border:1px solid ' + ic.border + ';margin-left:4px;">'
                            +   '<span class="material-symbols-outlined" style="font-size:20px;color:' + ic.color + ';">' + ic.icon + '</span>'
                            + '</div>'
                            + '<div style="flex:1;min-width:0;">'
                            +   '<div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:2px;">'
                            +     '<p style="font-size:13px;font-weight:700;color:#0f172a;margin:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:155px;">' + (n.title || 'Thông báo') + '</p>'
                            +     '<span style="font-size:10px;color:#94a3b8;background:#f8fafc;border:1px solid #e2e8f0;border-radius:9999px;padding:1px 7px;white-space:nowrap;flex-shrink:0;margin-left:6px;">' + (n.time || '') + '</span>'
                            +   '</div>'
                            +   '<p style="font-size:12px;color:#475569;margin:0 0 4px;line-height:1.45;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;">' + (n.content || '') + '</p>'
                            +   '<span style="font-size:10px;font-weight:700;color:#94a3b8;text-transform:uppercase;letter-spacing:0.08em;">' + lbl + '</span>'
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

                window.hdrMarkRead = function (id) {
                    fetch(ctxPath + '/notifications/api?action=markRead&id=' + id, { method: 'POST', credentials: 'same-origin' }).catch(function(){});
                };

                window.hdrMarkAllRead = function () {
                    fetch(ctxPath + '/notifications/api?action=markAllRead', { method: 'POST', credentials: 'same-origin' })
                        .then(function () { updateBadge(0); loaded = false; loadNotifications(); })
                        .catch(function(){});
                };

                // Auto-fetch badge count on page load
                fetch(ctxPath + '/notifications/api?limit=1', { credentials: 'same-origin' })
                    .then(function (r) { return r.json(); })
                    .then(function (data) { updateBadge(data.unreadCount || 0); })
                    .catch(function(){});
            })();
        </script>
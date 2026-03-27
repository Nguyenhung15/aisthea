<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <header class="lux-header">
            <div class="lux-header__left">
                <!-- Optional: Breadcrumbs or Search could go here -->
            </div>

            <!-- Right Actions -->
            <div class="lux-header__actions">
                <!-- Notifications -->
                <div class="lux-header__icon-btn" id="notifToggle">
                    <i class="fa-regular fa-bell"></i>
                    <span class="lux-header__badge" id="notifBadge" style="display:none;"></span>

                    <!-- Notification Dropdown -->
                    <div class="lux-header__dropdown" id="notifDropdown" style="width: 300px;">
                        <div class="lux-header__dropdown-header"
                            style="display:flex; justify-content:space-between; align-items:center;">
                            <span style="font-weight:700;color:var(--color-primary);font-size:0.85rem;">Thông báo hệ thống</span>
                            <span id="notifPulseCount"
                                style="background:#f59e0b; color:#fff; font-size: 0.7rem; font-weight:700; padding: 2px 8px; border-radius: 20px; min-width: 20px; text-align:center; display:inline-block;">0</span>
                        </div>
                        <div class="lux-header__dropdown-divider"></div>
                        <div id="notifList" style="max-height: 350px; overflow-y: auto;">
                            <!-- Items will be injected here -->
                            <div class="lux-header__dropdown-item"
                                style="justify-content:center; color:var(--color-text-muted); font-style:italic;">
                                Đang tải thông báo...
                            </div>
                        </div>
                        <div class="lux-header__dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/admin-notifs"
                            class="lux-header__dropdown-item"
                            style="justify-content:center; font-weight:600; color:var(--color-primary);">
                            Xem tất cả thông báo
                        </a>
                    </div>
                </div>

                <div class="lux-header__divider"></div>

                <!-- User Profile with Dropdown -->
                <div class="lux-header__profile" id="profileToggle">
                    <div class="lux-header__avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                ${sessionScope.user.fullname.substring(0,1)}
                            </c:when>
                            <c:otherwise>A</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="lux-header__user-info">
                        <span class="lux-header__user-name">
                            <c:out
                                value="${sessionScope.user != null ? sessionScope.user.fullname : 'Administrator'}" />
                        </span>
                        <span class="lux-header__user-role">
                            <c:out value="${sessionScope.user != null ? sessionScope.user.role : 'Super Admin'}" />
                        </span>
                    </div>
                    <i class="fa-solid fa-chevron-down lux-header__chevron"></i>

                    <!-- Dropdown Menu -->
                    <div class="lux-header__dropdown" id="profileDropdown">
                        <div class="lux-header__dropdown-header">
                            <div style="font-weight:700;color:var(--color-primary);font-size:0.85rem;">
                                <c:out value="${sessionScope.user != null ? sessionScope.user.fullname : 'Admin'}" />
                            </div>
                            <div style="font-size:0.72rem;color:var(--color-text-muted);">${sessionScope.user.email}
                            </div>
                        </div>
                        <div class="lux-header__dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/profile" class="lux-header__dropdown-item">
                            <i class="fa-regular fa-user"></i> My Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/settings" class="lux-header__dropdown-item">
                            <i class="fa-regular fa-circle-question"></i> Help Center
                        </a>
                        <div class="lux-header__dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/logout"
                            class="lux-header__dropdown-item lux-header__dropdown-item--danger">
                            <i class="fa-solid fa-right-from-bracket"></i> Logout account
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Global Toast for Alerts -->
        <div id="chatToast" class="lux-toast">
            <div class="lux-toast__icon"><i class="fa-solid fa-bell"></i></div>
            <div class="lux-toast__content">
                <span class="lux-toast__title" id="chatToastTitle">Thông báo mới</span>
                <span class="lux-toast__text" id="chatToastText">Có thông báo từ hệ thống.</span>
            </div>
        </div>

        <style>
            .lux-header__left {
                flex: 1;
            }

            .lux-header__actions {
                display: flex;
                align-items: center;
                gap: var(--space-lg);
            }

            .lux-header__divider {
                width: 1px;
                height: 24px;
                background: var(--color-border-light);
                margin: 0 var(--space-xs);
            }

            .lux-header__icon-btn {
                position: relative;
                font-size: 1.15rem;
                color: var(--color-text-secondary);
                cursor: pointer;
                transition: color 0.2s;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                border-radius: 50%;
            }

            .lux-header__icon-btn:hover {
                color: var(--color-primary);
                background: var(--color-bg);
            }

            .lux-header__badge {
                position: absolute;
                top: 8px;
                right: 8px;
                width: 10px;
                height: 10px;
                background: #ef4444;
                border: 2px solid #fff;
                border-radius: 50%;
                box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.2);
            }

            /* Custom for notif list */
            .notif-item {
                padding: 12px 16px;
                display: flex;
                align-items: center;
                gap: 12px;
                text-decoration: none;
                transition: background 0.2s;
                border-bottom: 1px solid var(--color-border-light);
            }

            .notif-item:hover {
                background: var(--color-bg);
            }

            .notif-ava {
                width: 32px;
                height: 32px;
                min-width: 32px;
                min-height: 32px;
                border-radius: 50%;
                background: #f59e0b;
                color: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 0.75rem;
                flex-shrink: 0;
            }

            .notif-content {
                flex: 1;
                min-width: 0;
                overflow: hidden;
            }

            .notif-name {
                display: block;
                font-weight: 700;
                color: var(--color-text-primary);
                font-size: 0.78rem;
                margin-bottom: 2px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .notif-text {
                display: block;
                font-size: 0.7rem;
                color: var(--color-text-muted);
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .notif-time {
                font-size: 0.6rem;
                color: var(--color-primary);
                font-weight: 600;
                flex-shrink: 0;
                white-space: nowrap;
            }

            /* Toast Notification */
            .lux-toast {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 10001;
                background: #fff;
                border-left: 4px solid #f59e0b;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                border-radius: 12px;
                padding: 16px 20px;
                display: flex;
                align-items: center;
                gap: 16px;
                transform: translateX(120%);
                transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
                max-width: 320px;
            }

            .lux-toast.show {
                transform: translateX(0);
            }

            .lux-toast__icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: rgba(245, 158, 11, 0.1);
                color: #f59e0b;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                flex-shrink: 0;
            }

            .lux-toast__content {
                flex: 1;
            }

            .lux-toast__title {
                display: block;
                font-weight: 700;
                font-size: 0.85rem;
                color: #0f172a;
                margin-bottom: 2px;
            }

            .lux-toast__text {
                display: block;
                font-size: 0.75rem;
                color: #64748b;
            }

            .lux-header__profile {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 6px 12px;
                border-radius: var(--radius-full);
                transition: all 0.2s ease;
                cursor: pointer;
                position: relative;
                user-select: none;
                border: 1px solid transparent;
            }

            .lux-header__profile:hover {
                background: var(--color-bg);
                border-color: var(--color-border-light);
            }

            .lux-header__avatar {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background: var(--color-primary);
                color: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 0.85rem;
                box-shadow: 0 4px 8px rgba(26, 35, 50, 0.15);
            }

            .lux-header__user-info {
                display: flex;
                flex-direction: column;
            }

            .lux-header__user-name {
                font-size: 0.88rem;
                font-weight: 700;
                color: var(--color-text-primary);
                line-height: 1.2;
            }

            .lux-header__user-role {
                font-size: 0.72rem;
                color: var(--color-text-muted);
                font-weight: 500;
            }

            .lux-header__chevron {
                font-size: 0.65rem;
                color: var(--color-text-muted);
                transition: transform 0.3s ease;
            }

            .lux-header__profile:hover .lux-header__chevron {
                color: var(--color-primary);
            }

            .lux-header__dropdown {
                position: absolute;
                top: calc(100% + 12px);
                right: 0;
                width: 220px;
                background: #fff;
                border-radius: var(--radius-md);
                box-shadow: var(--shadow-lg);
                border: 1px solid var(--color-border-light);
                opacity: 0;
                visibility: hidden;
                transform: translateY(10px);
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                z-index: 1000;
                overflow: hidden;
            }

            .lux-header__dropdown.show {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .lux-header__dropdown-header {
                padding: 16px 20px;
                background: var(--color-bg);
            }

            .lux-header__dropdown-divider {
                height: 1px;
                background: var(--color-border-light);
            }

            .lux-header__dropdown-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 20px;
                font-size: 0.82rem;
                font-weight: 500;
                color: var(--color-text-secondary);
                text-decoration: none;
                transition: all 0.2s;
            }

            .lux-header__dropdown-item i {
                font-size: 1rem;
                color: var(--color-text-muted);
                width: 18px;
                text-align: center;
            }

            .lux-header__dropdown-item:hover {
                background: var(--color-bg);
                color: var(--color-primary);
            }

            .lux-header__dropdown-item:hover i {
                color: var(--color-primary);
            }

            .lux-header__dropdown-item--danger:hover {
                color: #dc2626;
                background: #fff1f2;
            }

            .lux-header__dropdown-item--danger:hover i {
                color: #dc2626;
            }

            @keyframes pulseNotif {
                0% {
                    transform: scale(1);
                    box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7);
                }

                70% {
                    transform: scale(1.2);
                    box-shadow: 0 0 0 10px rgba(239, 68, 68, 0);
                }

                100% {
                    transform: scale(1);
                    box-shadow: 0 0 0 0 rgba(239, 68, 68, 0);
                }
            }
        </style>

        <script>
            (function () {
                const ctx = '${pageContext.request.contextPath}';
                const profileToggle = document.getElementById('profileToggle');
                const profileDropdown = document.getElementById('profileDropdown');
                const notifToggle = document.getElementById('notifToggle');
                const notifDropdown = document.getElementById('notifDropdown');
                const notifBadge = document.getElementById('notifBadge');
                const notifList = document.getElementById('notifList');
                const notifPulseCount = document.getElementById('notifPulseCount');
                const chatToast = document.getElementById('chatToast');
                const chatToastTitle = document.getElementById('chatToastTitle');
                const chatToastText = document.getElementById('chatToastText');

                let knownNotifIds = new Set();
                let isInitialized = false;

                function showToast(title, text, actionUrl, icon) {
                    icon = icon || 'fa-bell';
                    chatToastTitle.textContent = title;
                    chatToastText.textContent = text;
                    chatToast.querySelector('i').className = 'fa-solid ' + icon;
                    chatToast.classList.add('show');
                    chatToast.style.cursor = 'pointer';
                    chatToast.onclick = function() {
                        chatToast.classList.remove('show');
                        if (actionUrl) {
                            window.location.href = actionUrl;
                        }
                    };
                    setTimeout(function() { chatToast.classList.remove('show'); }, 8000);
                }

                // UI Interactions
                if (profileToggle) profileToggle.onclick = function(e) { e.stopPropagation(); notifDropdown.classList.remove('show'); profileDropdown.classList.toggle('show'); };
                if (notifToggle) notifToggle.onclick = function(e) { e.stopPropagation(); profileDropdown.classList.remove('show'); notifDropdown.classList.toggle('show'); };
                document.onclick = function() { profileDropdown.classList.remove('show'); notifDropdown.classList.remove('show'); };

                async function pollUnifiedNotifs() {
                    const chatUrl = ctx + '/chat?action=conversations&t=' + Date.now();
                    const sysUrl = ctx + '/notifications/api?t=' + Date.now();

                    try {
                        const [chatRes, sysRes] = await Promise.all([
                            fetch(chatUrl).then(r => r.json()),
                            fetch(sysUrl).then(r => r.json())
                        ]);

                        const allChatConvos = (chatRes.conversations || []).filter(c => c.chatType === 'STAFF' && c.status === 'OPEN');
                        
                        // Simple logic: hide chat notifications when admin is ON the chat page
                        const isOnChatPage = window.location.href.includes('/chat');
                        const chatConvos = isOnChatPage ? [] : allChatConvos;

                        // STRICT FILTER: Only ORDER and RETURN from system notifications
                        const adminTypes = ['ORDER', 'RETURN'];
                        const sysNotifs = (sysRes.notifications || []).filter(n => !n.read && adminTypes.includes((n.type || '').toUpperCase()));
                        const totalUnread = chatConvos.length + sysNotifs.length;

                        if (totalUnread > 0) {
                            notifBadge.style.display = 'block';
                            notifPulseCount.textContent = totalUnread;
                            notifBadge.style.animation = 'pulseNotif 1.2s infinite';

                            let html = '';
                            
                            // Chat Notifications (only unseen/new-message conversations)
                            chatConvos.forEach(c => {
                                const id = 'chat_' + c.convoId;
                                const name = c.fullname || 'Khách hàng';
                                if (!knownNotifIds.has(id)) {
                                    if (isInitialized) showToast('Yêu cầu hỗ trợ', name + ' cần giúp đỡ', ctx + '/chat?action=manage&convoId=' + c.convoId, 'fa-comment-dots');
                                    knownNotifIds.add(id);
                                }
                                // Simple click - just navigate to chat page (badge auto-hides there)
                                html += '<a href="' + ctx + '/chat?action=manage&convoId=' + c.convoId + '" class="notif-item">' +
                                        '<div class="notif-ava" style="background:#f59e0b"><i class="fa-solid fa-comment-dots"></i></div>' +
                                        '<div class="notif-content"><span class="notif-name">' + name + '</span>' +
                                        '<span class="notif-text">Yêu cầu hỗ trợ trực tuyến</span></div>' +
                                        '<span class="notif-time">Chat</span></a>';
                            });

                            // System Notifications (ORDER and RETURN only)
                            sysNotifs.forEach(n => {
                                const id = 'sys_' + n.id;
                                const safeTitle = (n.title || '').replace(/'/g, "\\'");
                                const safeContent = (n.content || '').replace(/'/g, "\\'");
                                if (!knownNotifIds.has(id)) {
                                    if (isInitialized) showToast(n.title || 'Thông báo', n.content || '', '', n.type === 'ORDER' ? 'fa-cart-shopping' : 'fa-bell');
                                    knownNotifIds.add(id);
                                }
                                var icon = 'fa-bell', color = '#64748b';
                                if (n.type === 'ORDER') { icon = 'fa-cart-shopping'; color = '#10b981'; }
                                else if (n.type === 'RETURN') { icon = 'fa-rotate-left'; color = '#ef4444'; }

                                html += '<a href="javascript:void(0)" class="notif-item" onclick="handleNotifClick(' + n.id + ', \'' + n.type + '\', ' + n.targetId + ', \'' + safeTitle + '\', \'' + safeContent + '\')">' +
                                        '<div class="notif-ava" style="background:' + color + '"><i class="fa-solid ' + icon + '"></i></div>' +
                                        '<div class="notif-content"><span class="notif-name">' + (n.title || 'Thông báo') + '</span>' +
                                        '<span class="notif-text">' + (n.content || '') + '</span></div>' +
                                        '<span class="notif-time">Mới</span></a>';
                            });

                            notifList.innerHTML = html;
                        } else {
                            notifBadge.style.display = 'none';
                            notifPulseCount.style.display = 'none';
                            notifList.innerHTML = '<div class="lux-header__dropdown-item" style="justify-content:center; color:var(--color-text-muted); font-style:italic;">Không có thông báo mới</div>';
                        }
                        isInitialized = true;
                    } catch (err) { console.error('[AdminNotif] Poll error:', err); }
                }

                window.handleNotifClick = async function(notifId, type, targetId, title, content) {
                    await fetch(ctx + '/notifications/api?action=markRead&id=' + notifId, {method: 'POST'});
                    
                    // Extract real order ID from content text (e.g., 'Đơn hàng #48 - ...')
                    function extractOrderId(text) {
                        var match = (text || '').match(/#(\d+)/);
                        return match ? match[1] : null;
                    }
                    
                    if (type === 'ORDER') {
                        var orderId = extractOrderId(content) || targetId;
                        var lowerContent = (content || '').toLowerCase();
                        
                        if (lowerContent.includes('đã hủy') || lowerContent.includes('cancelled')) {
                            // Cancelled order - just view, no confirmation
                            window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                        } else if (lowerContent.includes('chờ xác nhận') || lowerContent.includes('pending')) {
                            // Pending order - offer to confirm
                            if (confirm('Xác nhận đơn hàng #' + orderId + '?\nĐơn hàng sẽ chuyển sang trạng thái Processing.')) {
                                window.location.href = ctx + '/order?action=adminUpdateStatus&orderId=' + orderId + '&newStatus=Processing';
                            } else {
                                window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                            }
                        } else {
                            // Other status - just view details
                            window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                        }
                    } else if (type === 'RETURN') {
                        var orderId = extractOrderId(content) || targetId;
                        window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                    } else if (type === 'CHAT' || type === 'SUPPORT') {
                        window.location.href = ctx + '/chat?action=manage&convoId=' + targetId;
                    } else {
                        window.location.href = ctx + '/admin-notifs';
                    }
                };


                pollUnifiedNotifs();
                setInterval(pollUnifiedNotifs, 10000);
            })();
        </script>
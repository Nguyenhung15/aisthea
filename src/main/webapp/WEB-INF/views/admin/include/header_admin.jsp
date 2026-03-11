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
                        <div class="lux-header__dropdown-header" style="display:flex; justify-content:space-between; align-items:center;">
                            <span style="font-weight:700;color:var(--color-primary);font-size:0.85rem;">Tin nhắn cần hỗ trợ</span>
                            <span id="notifPulseCount" class="convo-count-badge" style="background:#f59e0b; font-size: 0.65rem;">0</span>
                        </div>
                        <div class="lux-header__dropdown-divider"></div>
                        <div id="notifList" style="max-height: 350px; overflow-y: auto;">
                            <!-- Items will be injected here -->
                            <div class="lux-header__dropdown-item" style="justify-content:center; color:var(--color-text-muted); font-style:italic;">
                                Không có yêu cầu mới
                            </div>
                        </div>
                        <div class="lux-header__dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/chat?action=manage" class="lux-header__dropdown-item" style="justify-content:center; font-weight:600; color:var(--color-primary);">
                            Xem tất cả hội thoại
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

        <!-- Global Toast for Chat -->
        <div id="chatToast" class="lux-toast">
            <div class="lux-toast__icon"><i class="fa-solid fa-person-circle-exclamation"></i></div>
            <div class="lux-toast__content">
                <span class="lux-toast__title" id="chatToastTitle">Yêu cầu hỗ trợ mới</span>
                <span class="lux-toast__text" id="chatToastText">Có khách hàng đang cần bạn giúp đỡ.</span>
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
            .notif-item:hover { background: var(--color-bg); }
            .notif-ava { width: 32px; height: 32px; border-radius: 50%; background: #f59e0b; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:0.75rem; flex-shrink:0;}
            .notif-content { flex: 1; min-width: 0; }
            .notif-name { display: block; font-weight: 700; color: var(--color-text-primary); font-size: 0.78rem; margin-bottom: 2px; }
            .notif-text { display: block; font-size: 0.7rem; color: var(--color-text-muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
            .notif-time { font-size: 0.6rem; color: var(--color-primary); font-weight: 600; margin-left: auto; }

            /* Toast Notification */
            .lux-toast {
                position: fixed; top: 20px; right: 20px; z-index: 10001;
                background: #fff; border-left: 4px solid #f59e0b;
                box-shadow: 0 10px 30px rgba(0,0,0,0.15); border-radius: 12px;
                padding: 16px 20px; display: flex; align-items: center; gap: 16px;
                transform: translateX(120%); transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
                max-width: 320px;
            }
            .lux-toast.show { transform: translateX(0); }
            .lux-toast__icon { width: 40px; height: 40px; border-radius: 50%; background: rgba(245,158,11,0.1); color: #f59e0b; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
            .lux-toast__content { flex: 1; }
            .lux-toast__title { display: block; font-weight: 700; font-size: 0.85rem; color: #0f172a; margin-bottom: 2px; }
            .lux-toast__text { display: block; font-size: 0.75rem; color: #64748b; }

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
                
                let knownHandoffIds = new Set();
                let isInitialized = false;

                function showToast(title, text, convoId) {
                    chatToastTitle.textContent = title;
                    chatToastText.textContent = text;
                    chatToast.classList.add('show');
                    chatToast.style.cursor = 'pointer';
                    chatToast.onclick = () => window.location.href = ctx + '/chat?action=manage&convoId=' + convoId;
                    setTimeout(() => chatToast.classList.remove('show'), 6000);
                }

                // Toggle Profile
                if (profileToggle && profileDropdown) {
                    profileToggle.addEventListener('click', function (e) {
                        e.stopPropagation();
                        notifDropdown.classList.remove('show');
                        profileDropdown.classList.toggle('show');
                    });
                }

                // Toggle Notif
                if (notifToggle && notifDropdown) {
                    notifToggle.addEventListener('click', function (e) {
                        e.stopPropagation();
                        profileDropdown.classList.remove('show');
                        notifDropdown.classList.toggle('show');
                    });
                }

                document.addEventListener('click', function () {
                    if (profileDropdown) profileDropdown.classList.remove('show');
                    if (notifDropdown) notifDropdown.classList.remove('show');
                });

                // Polling for chat notifications
                function pollChatNotifs() {
                    const url = ctx + (ctx.endsWith('/') ? '' : '/') + 'chat?action=conversations&t=' + Date.now();
                    fetch(url)
                    .then(r => r.json())
                    .then(data => {
                        const convos = data.conversations || [];
                        const types = convos.map(c => String(c.chatType || '').trim().toUpperCase() + '/' + String(c.status || '').trim().toUpperCase());
                        console.log('[Poll] Raw Data (Type/Stat):', types);

                        const staffConvos = convos.filter(c => {
                            const type = String(c.chatType || '').trim().toUpperCase();
                            const stat = String(c.status || '').trim().toUpperCase();
                            return type === 'STAFF' && stat === 'OPEN';
                        });

                        console.log('[Poll] Staff Requests (Filtered):', staffConvos.length);

                        if (staffConvos.length > 0) {
                            notifBadge.style.display = 'block';
                            notifPulseCount.textContent = staffConvos.length;
                            notifPulseCount.style.display = 'inline-block';
                            
                            let html = '';
                            staffConvos.forEach((c, idx) => {
                                const sid = String(c.convoId);
                                if (isInitialized && !knownHandoffIds.has(sid)) {
                                    console.log('[Poll] NEW handoff request:', sid);
                                    showToast('Yêu cầu hỗ trợ', (c.fullname || c.username || 'Khách hàng') + ' cần giúp đỡ', c.convoId);
                                    try {
                                        const bell = new Audio('https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3');
                                        bell.play().catch(e => console.warn('Audio play blocked:', e));
                                    } catch(e) {}
                                }
                                knownHandoffIds.add(sid);

                                if (idx < 5) {
                                    const name = c.fullname || c.username || 'Khách hàng';
                                    const initials = name.charAt(0).toUpperCase();
                                    const msg = (c.lastMessage || 'Cần hỗ trợ gấp...').substring(0, 50);
                                    html += `
                                        <a href="\${ctx}/chat?action=manage&convoId=\${c.convoId}" class="notif-item">
                                            <div class="notif-ava">\${initials}</div>
                                            <div class="notif-content">
                                                <span class="notif-name">\${name}</span>
                                                <span class="notif-text">\${msg}</span>
                                            </div>
                                            <span class="notif-time">Mới</span>
                                        </a>
                                    `;
                                }
                            });
                            notifList.innerHTML = html;
                        } else {
                            notifBadge.style.display = 'none';
                            notifPulseCount.style.display = 'none';
                            notifList.innerHTML = '<div class="lux-header__dropdown-item" style="justify-content:center; color:var(--color-text-muted); font-style:italic;">Không có yêu cầu mới</div>';
                            knownHandoffIds.clear(); 
                        }
                        isInitialized = true;
                    })
                    .catch(err => {
                        console.error('[AdminNotif] Poll error:', err);
                    });
                }

                pollChatNotifs();
                setInterval(pollChatNotifs, 5000); // 5 seconds instead of 10
            })();
        </script>
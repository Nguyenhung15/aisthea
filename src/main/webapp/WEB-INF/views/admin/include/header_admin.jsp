<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <header class="lux-header">
            <div class="lux-header__left">
                <!-- Optional: Breadcrumbs or Search could go here -->
            </div>

            <!-- Right Actions -->
            <div class="lux-header__actions">
                <!-- Notifications (coming soon/placeholder) -->
                <div class="lux-header__icon-btn">
                    <i class="fa-regular fa-bell"></i>
                    <span class="lux-header__badge"></span>
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
                top: 10px;
                right: 10px;
                width: 8px;
                height: 8px;
                background: #dc2626;
                border: 2px solid #fff;
                border-radius: 50%;
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
        </style>

        <script>
            (function () {
                const toggle = document.getElementById('profileToggle');
                const dropdown = document.getElementById('profileDropdown');
                const chevron = toggle ? toggle.querySelector('.lux-header__chevron') : null;
                if (toggle && dropdown) {
                    toggle.addEventListener('click', function (e) {
                        e.stopPropagation();
                        const isShow = dropdown.classList.toggle('show');
                        if (chevron) chevron.style.transform = isShow ? 'rotate(180deg)' : 'rotate(0)';
                    });
                    document.addEventListener('click', function () {
                        dropdown.classList.remove('show');
                        if (chevron) chevron.style.transform = 'rotate(0)';
                    });
                }
            })();
        </script>
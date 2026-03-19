<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <aside class="lux-sidebar">
            <!-- Logo Section -->
            <div class="lux-sidebar__logo-container">
                <a href="${pageContext.request.contextPath}/" class="lux-sidebar__logo">
                    <img src="${pageContext.request.contextPath}/assets/images/ata-logo.png" alt="AISTHÉA"
                        class="lux-sidebar__logo-img">
                    <span class="lux-sidebar__logo-text">AISTHÉA</span>
                </a>
            </div>

            <!-- Navigation -->
            <nav class="lux-sidebar__nav">
                <!-- Dashboard Group -->
                <span class="lux-sidebar__section-label">Overview</span>
                <a href="${pageContext.request.contextPath}/dashboard" class="lux-sidebar__link" data-path="/dashboard">
                    <i class="fa-solid fa-gauge-high"></i>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/analytics" class="lux-sidebar__link"
                    data-path="/admin/analytics">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Analytics</span>
                </a>

                <!-- Management Group -->
                <span class="lux-sidebar__section-label">Inventory</span>
                <a href="${pageContext.request.contextPath}/product?action=manage" class="lux-sidebar__link"
                    data-path="/product">
                    <i class="fa-solid fa-bag-shopping"></i>
                    <span>Products</span>
                </a>
                <a href="${pageContext.request.contextPath}/category" class="lux-sidebar__link" data-path="/category">
                    <i class="fa-solid fa-tags"></i>
                    <span>Categories</span>
                </a>

                <span class="lux-sidebar__section-label">Relations</span>
                <a href="${pageContext.request.contextPath}/order?action=list" class="lux-sidebar__link"
                    data-path="/order">
                    <i class="fa-solid fa-box"></i>
                    <span>Orders</span>
                </a>
                <a href="${pageContext.request.contextPath}/user?action=list" class="lux-sidebar__link"
                    data-path="/user">
                    <i class="fa-solid fa-users"></i>
                    <span>Customers</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/feedback" class="lux-sidebar__link"
                    data-path="/admin/feedback">
                    <i class="fa-solid fa-star"></i>
                    <span>Reviews</span>
                </a>
                <a href="${pageContext.request.contextPath}/voucher?action=list" class="lux-sidebar__link"
                    data-path="/voucher">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Vouchers</span>
                </a>
                <a href="${pageContext.request.contextPath}/chat?action=manage" class="lux-sidebar__link"
                    data-path="/chat">
                    <i class="fa-solid fa-comments"></i>
                    <span>AI Chats</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/emails" class="lux-sidebar__link"
                    data-path="/admin/emails">
                    <i class="fa-solid fa-envelope-open-text"></i>
                    <span>Email Hub</span>
                </a>
            </nav>

        </aside>

        <style>
            .lux-sidebar__logo-container {
                margin-top: 10px;
                /* Đã đẩy lên 10px */
                margin-left: 10px;
                margin-bottom: var(--space-3xl);
            }

            .lux-sidebar__logo {
                display: flex;
                align-items: center;
                /* Căn giữa tâm Logo và Chữ */
                gap: 15px;
                /* Khoảng cách giữa hình và chữ */
                text-decoration: none;
            }

            .lux-sidebar__logo-img {
                height: 60px;
                /* Tăng kích thước Logo lên (điều chỉnh số này để to hơn) */
                width: auto;
                object-fit: contain;
                filter: drop-shadow(0 4px 10px rgba(0, 0, 0, 0.12));
                transition: transform 0.3s ease;
            }

            .lux-sidebar__logo:hover .lux-sidebar__logo-img {
                transform: scale(1.08);
            }

            .lux-sidebar__logo-text {
                font-family: var(--font-serif);
                font-size: 1.5rem;
                font-weight: 700;
                letter-spacing: 1px;
                color: var(--color-primary);
            }
        </style>

        <script>
            (function () {
                const path = window.location.pathname;
                const links = document.querySelectorAll('.lux-sidebar__link');
                links.forEach(link => {
                    const dataPath = link.getAttribute('data-path');
                    if (path.includes(dataPath)) {
                        link.classList.add('active');
                    }
                });
            })();
        </script>
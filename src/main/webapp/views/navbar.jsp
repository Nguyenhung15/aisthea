<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% // Check if user is logged in - declare at top for entire page scope Object user=session.getAttribute("user");
        boolean isLoggedIn=user !=null; %>
        <!-- Nike+ Navigation Bar -->
        <style>
            /* Navbar Styles */
            .navbar {
                position: sticky;
                top: 0;
                z-index: 1000;
                background: transparent;
            }

            .navbar-container {
                max-width: 80rem;
                margin: 0 auto;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 1.5rem;
            }

            /* Desktop Nav */
            .nav-desktop {
                display: none;
                align-items: center;
                gap: 1.5rem;
                padding: 0.375rem 0.75rem;
                border-radius: 1rem;
                border: 1px solid #2b2b2b;
                background: rgba(18, 18, 18, 0.7);
                backdrop-filter: blur(20px);
            }

            @media (min-width: 1024px) {
                .nav-desktop {
                    display: flex;
                }
            }

            .nav-logo {
                display: flex;
                align-items: center;
                text-decoration: none;
                color: #fafafa;
                font-size: 1.125rem;
                font-weight: 700;
            }

            .nav-logo svg {
                width: 24px;
                height: 24px;
                margin-right: 0.5rem;
            }

            .nav-link {
                color: #fafafa;
                text-decoration: none;
                font-size: 0.875rem;
                font-weight: 600;
                padding: 0.5rem 1rem;
                border-radius: 0.5rem;
                transition: all 0.3s;
            }

            .nav-link:hover {
                background-color: rgba(255, 255, 255, 0.1);
            }

            /* Dropdown */
            .nav-dropdown {
                position: relative;
            }

            .nav-dropdown-button {
                color: #fafafa;
                background: none;
                border: none;
                font-size: 0.875rem;
                font-weight: 600;
                padding: 0.5rem 1rem;
                border-radius: 0.5rem;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 0.25rem;
                transition: all 0.3s;
            }

            .nav-dropdown-button:hover {
                background-color: rgba(255, 255, 255, 0.1);
            }

            .nav-dropdown-button svg {
                width: 1.25rem;
                height: 1.25rem;
            }

            .nav-dropdown-menu {
                position: absolute;
                top: calc(100% + 0.75rem);
                left: 0;
                width: 28rem;
                max-width: 100vw;
                background: white;
                border-radius: 1.5rem;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s;
                z-index: 50;
            }

            .nav-dropdown:hover .nav-dropdown-menu {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .nav-dropdown-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                background: #f9fafb;
            }

            .nav-dropdown-item {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.625rem;
                padding: 0.75rem;
                color: #111827;
                text-decoration: none;
                font-size: 0.875rem;
                font-weight: 600;
                transition: background 0.3s;
            }

            .nav-dropdown-item:hover {
                background: #e5e7eb;
            }

            .nav-dropdown-item svg {
                width: 1.25rem;
                height: 1.25rem;
                color: #9ca3af;
            }

            .nav-dropdown-divider {
                border-right: 1px solid #e5e7eb;
            }

            /* Sign In Button */
            .btn-signin {
                background: #fafafa;
                color: #18181B;
                padding: 0.375rem 0.625rem;
                border-radius: 0.5rem;
                font-size: 0.875rem;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s;
                border: none;
                cursor: pointer;
            }

            .btn-signin:hover {
                background: #e5e5e5;
            }

            /* Mobile Nav */
            .nav-mobile {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            @media (min-width: 1024px) {
                .nav-mobile {
                    display: none;
                }
            }

            .mobile-menu-button {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                padding: 0.5rem;
            }

            .mobile-menu-button svg {
                width: 1.5rem;
                height: 1.5rem;
            }

            /* Mobile Menu Overlay */
            .mobile-menu {
                position: fixed;
                inset: 0;
                z-index: 1000;
                background: rgba(0, 0, 0, 0.5);
                display: none;
            }

            .mobile-menu.active {
                display: block;
            }

            .mobile-menu-panel {
                position: fixed;
                top: 0;
                right: 0;
                bottom: 0;
                width: 100%;
                max-width: 24rem;
                background: #1A222C;
                padding: 1.5rem;
                overflow-y: auto;
                transform: translateX(100%);
                transition: transform 0.3s;
            }

            .mobile-menu.active .mobile-menu-panel {
                transform: translateX(0);
            }

            .mobile-menu-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 1.5rem;
            }

            .mobile-menu-close {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                padding: 0.5rem;
            }

            .mobile-menu-close svg {
                width: 1.5rem;
                height: 1.5rem;
            }

            .mobile-menu-links {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .mobile-menu-link {
                color: #878787;
                text-decoration: none;
                font-size: 1rem;
                font-weight: 600;
                padding: 0.5rem 0.75rem;
                border-radius: 0.5rem;
                transition: background 0.3s;
            }

            .mobile-menu-link:hover {
                background: rgba(255, 255, 255, 0.05);
            }
        </style>

        <nav class="navbar">
            <div class="navbar-container">
                <!-- Desktop Navigation -->
                <div class="nav-desktop">
                    <!-- Logo -->
                    <a href="<%= request.getContextPath() %>/" class="nav-logo">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z" />
                        </svg>
                        Nike +
                    </a>

                    <!-- SNKRS -->
                    <a href="<%= request.getContextPath() %>#" class="nav-link">SNKRS</a>

                    <!-- About Us -->
                    <a href="<%= request.getContextPath() %>/about-us" class="nav-link">About us</a>

                    <!-- Marketplace Dropdown -->
                    <div class="nav-dropdown">
                        <button class="nav-dropdown-button">
                            Marketplace
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
                            </svg>
                        </button>
                        <div class="nav-dropdown-menu">
                            <div class="nav-dropdown-grid">
                                <a href="<%= request.getContextPath() %>/marketplace"
                                    class="nav-dropdown-item nav-dropdown-divider">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                        stroke-width="1.5" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round"
                                            d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z" />
                                    </svg>
                                    Shop all categories
                                </a>
                                <a href="<%= request.getContextPath() %>/community/post" class="nav-dropdown-item">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                        stroke-width="1.5" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round"
                                            d="M12 21a9.004 9.004 0 008.716-6.747M12 21a9.004 9.004 0 01-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 017.843 4.582M12 3a8.997 8.997 0 00-7.843 4.582m15.686 0A11.953 11.953 0 0112 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0121 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0112 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 013 12c0-1.605.42-3.113 1.157-4.418" />
                                    </svg>
                                    Auction community
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Dropdown (if logged in) -->
                    <% if (isLoggedIn) { %>
                        <div class="nav-dropdown">
                            <button class="nav-dropdown-button">
                                Profile
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                    stroke-width="1.5" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
                                </svg>
                            </button>
                            <div class="nav-dropdown-menu">
                                <div class="nav-dropdown-grid">
                                    <a href="<%= request.getContextPath() %>/auth/profile"
                                        class="nav-dropdown-item nav-dropdown-divider">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                            stroke-width="1.5" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                                        </svg>
                                        Profile
                                    </a>
                                    <!-- Admin link if user is admin -->
                                    <a href="<%= request.getContextPath() %>/admin" class="nav-dropdown-item">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                            stroke-width="1.5" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 011.37.49l1.296 2.247a1.125 1.125 0 01-.26 1.431l-1.003.827c-.293.24-.438.613-.431.992a6.759 6.759 0 010 .255c-.007.378.138.75.43.99l1.005.828c.424.35.534.954.26 1.43l-1.298 2.247a1.125 1.125 0 01-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.57 6.57 0 01-.22.128c-.331.183-.581.495-.644.869l-.213 1.28c-.09.543-.56.941-1.11.941h-2.594c-.55 0-1.02-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 01-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 01-1.369-.49l-1.297-2.247a1.125 1.125 0 01.26-1.431l1.004-.827c.292-.24.437-.613.43-.992a6.932 6.932 0 010-.255c.007-.378-.138-.75-.43-.99l-1.004-.828a1.125 1.125 0 01-.26-1.43l1.297-2.247a1.125 1.125 0 011.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.087.22-.128.332-.183.582-.495.644-.869l.214-1.281z" />
                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        </svg>
                                        Admin
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Sign Out Button -->
                        <form action="<%= request.getContextPath() %>/logout" method="post" style="display: inline;">
                            <button type="submit" class="btn-signin">Sign out</button>
                        </form>
                        <% } else { %>
                            <!-- Sign In Button -->
                            <a href="<%= request.getContextPath() %>/auth/login" class="btn-signin">Sign in</a>
                            <% } %>
                </div>

                <!-- Mobile Navigation -->
                <div class="nav-mobile">
                    <a href="<%= request.getContextPath() %>/" class="nav-logo">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z" />
                        </svg>
                    </a>
                    <button class="mobile-menu-button" onclick="toggleMobileMenu()">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                            stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
                        </svg>
                    </button>
                </div>
            </div>
        </nav>

        <!-- Mobile Menu -->
        <div class="mobile-menu" id="mobileMenu">
            <div class="mobile-menu-panel">
                <div class="mobile-menu-header">
                    <a href="<%= request.getContextPath() %>/" class="nav-logo">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z" />
                        </svg>
                        Nike +
                    </a>
                    <button class="mobile-menu-close" onclick="toggleMobileMenu()">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                            stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                <div class="mobile-menu-links">
                    <a href="<%= request.getContextPath() %>#" class="mobile-menu-link">SNKRS</a>
                    <a href="<%= request.getContextPath() %>/marketplace" class="mobile-menu-link">Marketplace</a>
                    <a href="<%= request.getContextPath() %>/about-us" class="mobile-menu-link">About us</a>
                    <a href="<%= request.getContextPath() %>/community/post" class="mobile-menu-link">Community</a>

                    <% if (isLoggedIn) { %>
                        <a href="<%= request.getContextPath() %>/auth/profile" class="mobile-menu-link">Profile</a>
                        <a href="<%= request.getContextPath() %>/admin" class="mobile-menu-link">Admin</a>
                        <form action="<%= request.getContextPath() %>/logout" method="post" style="margin-top: 1rem;">
                            <button type="submit" class="mobile-menu-link"
                                style="width: 100%; text-align: left; border: none; background: none; cursor: pointer;">
                                Sign out
                            </button>
                        </form>
                        <% } else { %>
                            <a href="<%= request.getContextPath() %>/auth/login" class="mobile-menu-link"
                                style="margin-top: 1rem;">Sign in</a>
                            <% } %>
                </div>
            </div>
        </div>

        <script>
            function toggleMobileMenu() {
                const menu = document.getElementById('mobileMenu');
                menu.classList.toggle('active');
            }

            // Close mobile menu when clicking outside
            document.getElementById('mobileMenu').addEventListener('click', function (e) {
                if (e.target === this) {
                    toggleMobileMenu();
                }
            });
        </script>
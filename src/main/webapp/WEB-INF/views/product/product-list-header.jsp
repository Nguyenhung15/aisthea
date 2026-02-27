<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Product List Page Navigation -->
        <nav class="sticky top-0 z-50 glass-panel border-b border-white/20">
            <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
                <div class="flex items-center space-x-8 hidden md:flex">
                    <a class="text-sm font-medium hover:text-primary transition-colors"
                        href="${pageContext.request.contextPath}/product?sort=newest">New Arrivals</a>
                    <a class="text-sm font-medium hover:text-primary transition-colors"
                        href="${pageContext.request.contextPath}/product">Collection</a>
                    <a class="text-sm font-medium hover:text-primary transition-colors" href="#">Editorial</a>
                </div>
                <button class="md:hidden text-slate-800 dark:text-white">
                    <span class="material-icons-outlined">menu</span>
                </button>
                <div class="absolute left-1/2 transform -translate-x-1/2">
                    <a class="text-2xl font-bold tracking-[0.2em] text-primary dark:text-white"
                        href="${pageContext.request.contextPath}/">AISTHÉA</a>
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
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div id="account-btn" class="icon-btn" style="position:relative;">
                                <c:choose>
                                    <c:when
                                        test="${not empty sessionScope.user.avatar and !sessionScope.user.avatar.equals('images/ava_default.png')}">
                                        <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}"
                                            alt="Avatar"
                                            style="width:36px;height:36px;border-radius:50%;object-fit:cover;vertical-align:middle;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-solid fa-user"></i>
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
                            <a class="icon-btn" href="${pageContext.request.contextPath}/login" title="Login">
                                <i class="fa-solid fa-user"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </nav>
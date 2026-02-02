<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <header>
            <div class="left">
                <div class="logo">
                    <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                        <img src="${pageContext.request.contextPath}/images/ata-logo.png" alt="AISTHEA">
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

                <a class="icon-btn" href="${pageContext.request.contextPath}/cart" title="Cart">
                    <i class="fa-solid fa-bag-shopping"></i>
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
                                    e.stopPropagation(); // Ngăn event click lan ra ngoài
                                    accountMenu.style.display = accountMenu.style.display === "block" ? "none" : "block";
                                });
                            }
                            window.addEventListener("click", (e) => {
                                // Nếu click ra ngoài button VÀ menu đang mở, thì đóng lại
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
        </header>

        <div class="mega-wrap" id="mega-wrap">
            <div class="mega" id="mega">
                <div class="mega-content" id="mega-content"></div>
            </div>
        </div>
        <div class="media-banner__shadow"></div>
        <div id="search-pop"></div>
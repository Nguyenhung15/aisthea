<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="bg-white sticky top-0 z-40" style="height: 72px;">
    <div class="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-full">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                    <img src="${pageContext.request.contextPath}/images/ata-logo.png" alt="AISTHEA" style="height: 80px; position: relative; bottom: 11px;">
                </a>
            </div>
            <div class="hidden md:flex items-center space-x-10">
                <div id="search-icon" class="icon-btn" title="Search" style="font-weight: 900;font-size: 20px;">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </div>
                <a class="icon-btn" href="${pageContext.request.contextPath}/cart" title="Cart" style="font-weight: 900;font-size: 20px;">
                    <i class="fa-solid fa-bag-shopping"></i>
                </a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        
                        <div id="account-btn" 
                             style="position:relative; display:flex; align-items:center; cursor:pointer; 
                                    padding: 8px 12px; border-radius: 8px; transition: background-color 0.2s ease;"
                             onmouseover="this.style.backgroundColor='#f3f4f6'"
                             onmouseout="this.style.backgroundColor='transparent'">
                            
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.avatar}">
                                    <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}"
                                         alt="Avatar"
                                         style="width:36px;height:36px;border-radius:50%;object-fit:cover; margin-right: 8px;">
                                </c:when>
                                <c:otherwise>
                                    <i class="fa-solid fa-user" style="margin-right: 8px; width: 36px; height: 36px; line-height: 36px; text-align: center; font-size: 20px;"></i>
                                </c:otherwise>
                            </c:choose>

                            <span style="font-weight:600;">${sessionScope.user.fullname}</span>

                            <div id="account-menu"
                                 style="display:none;position:absolute;top:60px;right:0;background:white;
                                 border-radius:8px;box-shadow:0 4px 15px rgba(0,0,0,0.15);min-width:160px;z-index:100; overflow: hidden; border: 1px solid #eee;">
                                
                                <a href="${pageContext.request.contextPath}/profile"
                                   style="display:flex; align-items: center; padding:12px 16px;color:#111827;text-decoration:none;font-weight:600; transition: background-color 0.2s ease;"
                                   onmouseover="this.style.backgroundColor='#f3f4f6'"
                                   onmouseout="this.style.backgroundColor='transparent'">
                                    <i class="fa-solid fa-id-card" style="width: 20px; margin-right: 8px; text-align: center;"></i> Profile
                                </a>

                                <%-- === LOGIC MỚI CHO ROLE === --%>
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/dashboard"
                                       style="display:flex; align-items: center; padding:12px 16px;color:#111827;text-decoration:none;font-weight:600; transition: background-color 0.2s ease;"
                                       onmouseover="this.style.backgroundColor='#f3f4f6'"
                                       onmouseout="this.style.backgroundColor='transparent'">
                                        <i class="fa-solid fa-tachometer-alt" style="width: 20px; margin-right: 8px; text-align: center;"></i> Dashboard
                                    </a>
                                </c:if>

                                <c:if test="${sessionScope.user.role == 'USER'}">
                                    <a href="${pageContext.request.contextPath}/order"
                                       style="display:flex; align-items: center; padding:12px 16px;color:#111827;text-decoration:none;font-weight:600; transition: background-color 0.2s ease;"
                                       onmouseover="this.style.backgroundColor='#f3f4f6'"
                                       onmouseout="this.style.backgroundColor='transparent'">
                                        <i class="fa-solid fa-box" style="width: 20px; margin-right: 8px; text-align: center;"></i> Đơn hàng
                                    </a>
                                </c:if>
                                <%-- === KẾT THÚC LOGIC MỚI === --%>
                                
                                <a href="${pageContext.request.contextPath}/logout"
                                   style="display:flex; align-items: center; padding:12px 16px;color:#111827;text-decoration:none;font-weight:600; transition: background-color 0.2s ease;"
                                   onmouseover="this.style.backgroundColor='#f3f4f6'"
                                   onmouseout="this.style.backgroundColor='transparent'">
                                    <i class="fa-solid fa-right-from-bracket" style="width: 20px; margin-right: 8px; text-align: center;"></i> Logout
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
                                if (accountMenu.style.display === "block") {
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
    </div>
</nav>
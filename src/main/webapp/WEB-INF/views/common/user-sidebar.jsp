<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ page import="com.aisthea.fashion.model.User" %>
            <%@ page import="com.aisthea.fashion.service.NotificationService" %>
                <%@ page import="java.math.BigDecimal" %>
                    <%@ page import="java.util.List" %>
                        <% User sessionUser=(User) session.getAttribute("user"); 
                           int points=0; 
                           String currentTier="MEMBER"; 
                           int nextTierPoints=200; 
                           String nextTierName="SILVER"; 
                           int progress=0; 
                           int unreadCount = 0;
                           String badgeBgClass="from-zinc-50 to-zinc-100 border-zinc-200/50"; 
                           String badgeTextClass="text-zinc-600"; 
                           
                           if (sessionUser != null) {
                                points = sessionUser.getMembershipPoints();
                                try {
                                    unreadCount = new NotificationService().getUnreadCount(sessionUser.getUserId());
                                } catch(Exception e) {}
                                
                                if (points >= 5000) {
                                    currentTier = "PLATINUM MEMBER";
                                    nextTierPoints = 5000;
                                    nextTierName = "MAX";
                                    progress = 100;
                                    badgeBgClass="from-indigo-50 to-indigo-100 border-indigo-200/50";
                                    badgeTextClass="text-indigo-600";
                                } else if (points >= 1000) {
                                    currentTier = "GOLD MEMBER";
                                    nextTierPoints = 5000;
                                    nextTierName = "PLATINUM";
                                    progress = ((points - 1000) * 100) / 4000;
                                    badgeBgClass="from-amber-50 to-amber-100 border-amber-200/50";
                                    badgeTextClass="text-amber-600";
                                } else if (points >= 200) {
                                    currentTier = "SILVER MEMBER";
                                    nextTierPoints = 1000;
                                    nextTierName = "GOLD";
                                    progress = ((points - 200) * 100) / 800;
                                    badgeBgClass="from-slate-100 to-slate-200 border-slate-300/50";
                                    badgeTextClass="text-slate-600";
                                } else {
                                    currentTier = "MEMBER";
                                    nextTierPoints = 200;
                                    nextTierName = "SILVER";
                                    if (points > 0) {
                                        progress = (points * 100) / 200;
                                    } else {
                                        progress = 0;
                                    }
                                    badgeBgClass="from-zinc-50 to-zinc-100 border-zinc-200/50";
                                    badgeTextClass="text-zinc-600";
                                }
                           }
                           request.setAttribute("userPoints", points);
                           request.setAttribute("currentTier", currentTier);
                           request.setAttribute("nextTierPoints", nextTierPoints);
                           request.setAttribute("nextTierName", nextTierName);
                           request.setAttribute("tierProgress", progress);
                           request.setAttribute("badgeBgClass", badgeBgClass);
                           request.setAttribute("badgeTextClass", badgeTextClass);
                           request.setAttribute("unreadCount", unreadCount);
                           request.setAttribute("pointsNeeded", nextTierPoints > points ? nextTierPoints - points : 0);
                        %>
                        <aside class="lg:w-1/4">
                            <div
                                class="glass-island rounded-[24px] p-6 sticky top-28 transition-transform hover:shadow-lg duration-500">
                                <!-- User Info Section -->
                                <div class="flex flex-col items-center mb-6 pb-6 border-b border-slate-200/60">
                                    <div class="relative w-24 h-24 mb-4 group">
                                        <div
                                            class="absolute inset-0 rounded-full gold-border-glow opacity-60 group-hover:opacity-100 transition-opacity duration-500">
                                        </div>
                                        <c:choose>
                                            <c:when
                                                test="${not empty sessionScope.user.avatar and sessionScope.user.avatar != 'images/ava_default.png'}">
                                                <img id="sidebar-avatar" alt="Profile Avatar"
                                                    class="w-full h-full rounded-full object-cover border-4 border-white shadow-md relative z-10"
                                                    src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}" />
                                            </c:when>
                                            <c:otherwise>
                                                <img id="sidebar-avatar" alt="Profile Avatar"
                                                    class="w-full h-full rounded-full object-cover border-4 border-white shadow-md relative z-10"
                                                    src="${pageContext.request.contextPath}/images/ava_default.png" />
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <h2
                                        class="font-display font-bold text-lg text-slate-900 mb-2 text-center leading-tight">
                                        <c:out value="${sessionScope.user.fullname}" default="Khách hàng" />
                                    </h2>
                                    <div
                                        class="flex items-center space-x-2 bg-gradient-to-r ${badgeBgClass} px-3 py-1 rounded-full border mb-4">
                                        <span
                                            class="material-symbols-outlined ${badgeTextClass} text-[16px]">loyalty</span>
                                        <span
                                            class="text-xs font-bold ${badgeTextClass} tracking-wide uppercase">${currentTier}</span>
                                    </div>
                                    <!-- Points Progress -->
                                    <div class="w-full px-2">
                                        <div class="flex justify-between items-end mb-1.5">
                                            <span
                                                class="text-[10px] font-medium text-slate-400 uppercase tracking-wider">Points</span>
                                            <span class="text-[10px] font-bold text-primary">${userPoints} /
                                                ${nextTierPoints}</span>
                                        </div>
                                        <div class="w-full bg-slate-100 rounded-full h-1.5 overflow-hidden">
                                            <div class="bg-gradient-to-r from-sky-300 via-primary to-accent-gold h-1.5 rounded-full"
                                                style="width: ${tierProgress}%"></div>
                                        </div>
                                        <c:if test="${nextTierName != 'MAX'}">
                                            <p class="mt-2 text-[10px] text-center text-slate-500 font-medium">
                                                ${pointsNeeded} points to <span
                                                    class="${badgeTextClass} font-bold">${nextTierName}</span>
                                            </p>
                                        </c:if>
                                        <c:if test="${nextTierName == 'MAX'}">
                                            <p class="mt-2 text-[10px] text-center text-slate-500 font-medium">
                                                Bạn đã đạt hạng cao nhất</p>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Navigation Links -->
                                <nav class="space-y-1">
                                    <c:set var="activeTab" value="${param.activeTab}" />

                                    <details class="group" open>
                                        <summary
                                            class="flex items-center justify-between px-4 py-3 rounded-lg cursor-pointer hover:bg-white/40 transition-colors">
                                            <div class="flex items-center text-slate-700 font-medium">
                                                <span
                                                    class="material-symbols-outlined mr-3 text-[20px] text-primary">person</span>
                                                <span class="text-sm tracking-wide">Tài khoản của tôi</span>
                                            </div>
                                            <span
                                                class="material-symbols-outlined text-[18px] text-slate-400 transition-transform duration-300 chevron">expand_more</span>
                                        </summary>
                                        <div class="pl-11 pr-2 pt-1 pb-2 space-y-1">
                                            <a class="block py-2 text-sm transition-colors hover:text-primary ${activeTab == 'profile' ? 'nav-subitem-active' : 'text-slate-500'}"
                                                href="${pageContext.request.contextPath}/profile">Hồ sơ cá
                                                nhân</a>
                                            <a class="block py-2 text-sm transition-colors hover:text-primary ${activeTab == 'address' ? 'nav-subitem-active' : 'text-slate-500'}"
                                                href="${pageContext.request.contextPath}/address">Địa chỉ</a>
                                            <a class="block py-2 text-sm transition-colors hover:text-primary ${activeTab == 'change_password' ? 'nav-subitem-active' : 'text-slate-500'}"
                                                href="${pageContext.request.contextPath}/change-password">Đổi
                                                mật khẩu</a>
                                            <a class="block py-2 text-sm transition-colors hover:text-primary ${activeTab == 'tier' ? 'nav-subitem-active' : 'text-slate-500'}"
                                                href="${pageContext.request.contextPath}/tier-details">Chi tiết
                                                hạng thành viên</a>
                                        </div>
                                    </details>

                                    <a class="flex items-center px-4 py-3 rounded-lg transition-all duration-300 group ${activeTab == 'order' ? 'nav-item-active' : 'text-slate-500 hover:text-slate-900 hover:bg-white/40'}"
                                        href="${pageContext.request.contextPath}/order">
                                        <span
                                            class="material-symbols-outlined mr-3 text-[20px] ${activeTab == 'order' ? 'text-primary' : 'group-hover:text-slate-700'}">history_edu</span>
                                        <span class="font-medium text-sm tracking-wide">Lịch sử đơn hàng</span>
                                    </a>

                                    <a class="flex items-center px-4 py-3 rounded-lg transition-all duration-300 group ${activeTab == 'notification' ? 'nav-item-active' : 'text-slate-500 hover:text-slate-900 hover:bg-white/40'}"
                                        href="${pageContext.request.contextPath}/notifications">
                                        <span
                                            class="material-symbols-outlined mr-3 text-[20px] group-hover:text-slate-700">notifications</span>
                                        <span class="font-medium text-sm tracking-wide">Thông báo</span>
                                        <c:if test="${unreadCount > 0}">
                                            <span
                                                class="ml-auto bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full shadow-sm">${unreadCount > 99 ? '99+' : unreadCount}</span>
                                        </c:if>
                                    </a>

                                    <a class="flex items-center px-4 py-3 rounded-lg text-red-500 hover:text-red-700 hover:bg-red-50/50 transition-all duration-300 group mt-4 border-t border-slate-100 pt-4"
                                        href="${pageContext.request.contextPath}/logout">
                                        <span class="material-symbols-outlined mr-3 text-[20px]">logout</span>
                                        <span class="font-medium text-sm tracking-wide">Đăng xuất</span>
                                    </a>
                                </nav>
                            </div>
                        </aside>
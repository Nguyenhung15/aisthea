<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <% if (session.getAttribute("user")==null) { response.sendRedirect(request.getContextPath() + "/login" );
            return; } %>

            <%-- Set default values if servlet hasn't set them (fallback) --%>
                <%-- ALWAYS calculate tier from session to prevent stale Tomcat servlet issues --%>
                    <c:set var="userPoints"
                        value="${sessionScope.user.membershipPoints != null ? sessionScope.user.membershipPoints : 0}" />
                    <c:set var="currentTier" value="MEMBER" />
                    <c:set var="currentTierKey" value="member" />
                    <c:set var="cardGradient" value="linear-gradient(135deg, #78909C 0%, #546E7A 50%, #37474F 100%)" />
                    <c:set var="cardShadow" value="0 10px 30px -5px rgba(84, 110, 122, 0.4)" />
                    <c:set var="accentColor" value="#546E7A" />
                    <c:set var="progressGradient" value="linear-gradient(to right, #78909C, #546E7A)" />
                    <c:set var="badgeBg" value="rgba(120, 144, 156, 0.15)" />
                    <c:set var="badgeColor" value="#37474F" />
                    <c:set var="badgeBorder" value="rgba(120, 144, 156, 0.3)" />
                    <c:set var="iconBg" value="rgba(120, 144, 156, 0.1)" />
                    <c:set var="iconColor" value="#546E7A" />
                    <c:set var="nextTierName" value="SILVER" />
                    <c:set var="nextTierPoints" value="200" />
                    <c:set var="tierProgress" value="${userPoints > 0 ? (userPoints * 100 / 200) : 0}" />
                    <c:set var="pointsNeeded" value="${200 - userPoints}" />

                    <%-- Recalculate tier from points --%>
                        <c:if test="${userPoints >= 5000}">
                            <c:set var="currentTier" value="PLATINUM" />
                            <c:set var="currentTierKey" value="platinum" />
                            <c:set var="cardGradient"
                                value="linear-gradient(135deg, #E8EAF6 0%, #7986CB 50%, #303F9F 100%)" />
                            <c:set var="cardShadow" value="0 10px 30px -5px rgba(63, 81, 181, 0.4)" />
                            <c:set var="accentColor" value="#5C6BC0" />
                            <c:set var="progressGradient"
                                value="linear-gradient(to right, #7986CB, #5C6BC0, #3F51B5)" />
                            <c:set var="iconBg" value="rgba(121, 134, 203, 0.1)" />
                            <c:set var="iconColor" value="#3F51B5" />
                            <c:set var="nextTierName" value="MAX" />
                            <c:set var="nextTierPoints" value="5000" />
                            <c:set var="tierProgress" value="100" />
                            <c:set var="pointsNeeded" value="0" />
                        </c:if>
                        <c:if test="${userPoints >= 1000 && userPoints < 5000}">
                            <c:set var="currentTier" value="GOLD" />
                            <c:set var="currentTierKey" value="gold" />
                            <c:set var="cardGradient"
                                value="linear-gradient(135deg, #F3E5C3 0%, #C5A059 50%, #8A6E2F 100%)" />
                            <c:set var="cardShadow" value="0 10px 30px -5px rgba(197, 160, 89, 0.4)" />
                            <c:set var="accentColor" value="#C5A059" />
                            <c:set var="progressGradient"
                                value="linear-gradient(to right, #C5A059, #F9A825, #FF8F00)" />
                            <c:set var="iconBg" value="rgba(197, 160, 89, 0.1)" />
                            <c:set var="iconColor" value="#C5A059" />
                            <c:set var="nextTierName" value="PLATINUM" />
                            <c:set var="nextTierPoints" value="5000" />
                            <c:set var="tierProgress" value="${(userPoints - 1000) * 100 / 4000}" />
                            <c:set var="pointsNeeded" value="${5000 - userPoints}" />
                        </c:if>
                        <c:if test="${userPoints >= 200 && userPoints < 1000}">
                            <c:set var="currentTier" value="SILVER" />
                            <c:set var="currentTierKey" value="silver" />
                            <c:set var="cardGradient"
                                value="linear-gradient(135deg, #B0BEC5 0%, #78909C 50%, #455A64 100%)" />
                            <c:set var="cardShadow" value="0 10px 30px -5px rgba(96, 125, 139, 0.4)" />
                            <c:set var="accentColor" value="#78909C" />
                            <c:set var="progressGradient" value="linear-gradient(to right, #B0BEC5, #78909C)" />
                            <c:set var="iconBg" value="rgba(144, 164, 174, 0.1)" />
                            <c:set var="iconColor" value="#607D8B" />
                            <c:set var="nextTierName" value="GOLD" />
                            <c:set var="nextTierPoints" value="1000" />
                            <c:set var="tierProgress" value="${(userPoints - 200) * 100 / 800}" />
                            <c:set var="pointsNeeded" value="${1000 - userPoints}" />
                        </c:if>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="utf-8" />
                            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                            <title>Chi tiết hạng thành viên | AISTHÉA</title>
                            <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&amp;family=Inter:wght@300;400;500;600&amp;display=swap"
                                rel="stylesheet" />
                            <link
                                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                                rel="stylesheet" />
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

                            <script>
                                tailwind.config = {
                                    darkMode: "class",
                                    theme: {
                                        extend: {
                                            colors: {
                                                primary: "#0056b3",
                                                "primary-dark": "#004494",
                                                "accent-gold": "#C5A059",
                                                "glass-light": "rgba(255, 255, 255, 0.7)",
                                                "glass-border": "rgba(255, 255, 255, 0.5)",
                                                "glass-input": "rgba(255, 255, 255, 0.4)",
                                            },
                                            fontFamily: {
                                                display: ["'Playfair Display'", "serif"],
                                                body: ["'Inter'", "sans-serif"],
                                            },
                                            backgroundImage: {
                                                'ethereal-sky': "linear-gradient(180deg, #F8FAFC 0%, #E0F2FE 100%)",
                                                'gold-shimmer': "linear-gradient(45deg, rgba(255,255,255,0) 40%, rgba(255,255,255,0.4) 50%, rgba(255,255,255,0) 60%)"
                                            },
                                            boxShadow: {
                                                'glass': '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
                                                'glass-sm': '0 4px 16px 0 rgba(31, 38, 135, 0.05)',
                                            },
                                        },
                                    },
                                };
                            </script>
                            <style>
                                .glass-island {
                                    background: rgba(255, 255, 255, 0.65);
                                    backdrop-filter: blur(20px);
                                    -webkit-backdrop-filter: blur(20px);
                                    border: 1px solid rgba(255, 255, 255, 0.8);
                                    box-shadow: 0 20px 40px -10px rgba(0, 86, 179, 0.05);
                                }

                                .marble-texture {
                                    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.05'/%3E%3C/svg%3E");
                                    opacity: 0.4;
                                    pointer-events: none;
                                }

                                .nav-subitem-active {
                                    color: #0056b3;
                                    font-weight: 600;
                                }

                                ::-webkit-scrollbar {
                                    width: 8px;
                                }

                                ::-webkit-scrollbar-track {
                                    background: transparent;
                                }

                                ::-webkit-scrollbar-thumb {
                                    background: rgba(0, 86, 179, 0.2);
                                    border-radius: 4px;
                                }

                                details>summary {
                                    list-style: none;
                                }

                                details>summary::-webkit-details-marker {
                                    display: none;
                                }

                                details[open] summary~* {
                                    animation: slideDown 0.3s ease-in-out;
                                }

                                @keyframes slideDown {
                                    0% {
                                        opacity: 0;
                                        transform: translateY(-10px);
                                    }

                                    100% {
                                        opacity: 1;
                                        transform: translateY(0);
                                    }
                                }

                                .chevron {
                                    transition: transform 0.3s ease;
                                }

                                details[open] summary .chevron {
                                    transform: rotate(180deg);
                                }

                                .card-shimmer {
                                    background-image: linear-gradient(45deg, rgba(255, 255, 255, 0) 40%, rgba(255, 255, 255, 0.4) 50%, rgba(255, 255, 255, 0) 60%);
                                    background-size: 200% 100%;
                                    animation: shimmer 5s infinite linear;
                                }

                                @keyframes shimmer {
                                    0% {
                                        background-position: 200% 0;
                                    }

                                    100% {
                                        background-position: -200% 0;
                                    }
                                }

                                .perk-card {
                                    transition: all 0.3s ease;
                                }

                                .perk-card:hover {
                                    transform: translateY(-5px);
                                    border-color: var(--hover-accent) !important;
                                    box-shadow: var(--hover-shadow) !important;
                                }

                                .custom-scrollbar::-webkit-scrollbar {
                                    width: 6px;
                                }

                                .custom-scrollbar::-webkit-scrollbar-track {
                                    background: rgba(241, 245, 249, 0.5);
                                    border-radius: 10px;
                                }

                                .custom-scrollbar::-webkit-scrollbar-thumb {
                                    background: rgba(0, 86, 179, 0.15);
                                    border-radius: 10px;
                                    transition: all 0.3s ease;
                                }

                                .custom-scrollbar::-webkit-scrollbar-thumb:hover {
                                    background: rgba(0, 86, 179, 0.3);
                                }
                            </style>
                        </head>

                        <body
                            class="bg-ethereal-sky font-body min-h-screen text-slate-800 relative selection:bg-primary/20 selection:text-primary">
                            <div class="fixed inset-0 z-0">
                                <div
                                    class="absolute inset-0 bg-gradient-to-br from-white via-sky-50 to-blue-100 opacity-80">
                                </div>
                                <div class="absolute inset-0 marble-texture"></div>
                                <div
                                    class="absolute top-0 right-0 w-[500px] h-[500px] bg-blue-200/20 rounded-full blur-3xl translate-x-1/2 -translate-y-1/2">
                                </div>
                                <div
                                    class="absolute bottom-0 left-0 w-[600px] h-[600px] bg-sky-100/30 rounded-full blur-3xl -translate-x-1/4 translate-y-1/4">
                                </div>
                            </div>

                            <!-- Header -->
                            <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                            <main class="relative z-10 max-w-7xl mx-auto px-4 pb-20 mt-8">
                                <div class="flex flex-col lg:flex-row gap-8">
                                    <!-- Sidebar -->
                                    <jsp:include page="/WEB-INF/views/common/user-sidebar.jsp">
                                        <jsp:param name="activeTab" value="tier" />
                                    </jsp:include>

                                    <section class="lg:w-3/4">
                                        <div
                                            class="glass-island rounded-[32px] p-8 lg:p-12 min-h-[700px] relative overflow-hidden flex flex-col">
                                            <div
                                                class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-amber-50/50 to-transparent rounded-bl-full pointer-events-none">
                                            </div>

                                            <header class="mb-10 border-b border-slate-200/60 pb-6">
                                                <h1
                                                    class="font-display font-bold text-3xl text-slate-900 mb-2 tracking-tight">
                                                    Chi tiết hạng thành viên</h1>
                                                <p class="text-slate-500 font-light text-sm tracking-wide">Theo dõi tiến
                                                    trình
                                                    và tận hưởng đặc quyền dành riêng cho bạn</p>
                                            </header>

                                            <div class="max-w-4xl mx-auto w-full flex-grow">

                                                <!-- ========== LOYALTY CARD ========== -->
                                                <div class="w-full relative rounded-2xl overflow-hidden mb-12 group transform transition-transform hover:scale-[1.01] duration-500"
                                                    style="box-shadow: ${cardShadow};">
                                                    <!-- Card gradient background - INLINE STYLE guaranteed to work -->
                                                    <div class="absolute inset-0"
                                                        style="background: ${cardGradient}; opacity: 0.95;"></div>
                                                    <div class="absolute inset-0 card-shimmer"></div>
                                                    <div class="absolute inset-0 marble-texture" style="opacity: 0.2;">
                                                    </div>

                                                    <div
                                                        class="relative z-10 p-8 md:p-10 flex flex-col justify-between text-white min-h-[220px]">
                                                        <div class="flex justify-between items-start w-full">
                                                            <div
                                                                class="bg-white/20 backdrop-blur-sm border border-white/30 px-4 py-1.5 rounded-full">
                                                                <span
                                                                    class="text-xs font-bold tracking-[0.2em] uppercase">${sessionScope.user.fullname}</span>
                                                            </div>
                                                            <span
                                                                class="font-display text-2xl font-bold tracking-widest opacity-80">AISTHÉA</span>
                                                        </div>
                                                        <div class="mt-8 md:mt-12 text-center md:text-left">
                                                            <div
                                                                class="text-sm font-medium opacity-80 mb-1 tracking-widest uppercase">
                                                                Current Tier</div>
                                                            <h2
                                                                class="font-display text-4xl md:text-5xl font-bold tracking-wider text-white drop-shadow-md">
                                                                ${currentTier}</h2>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- ========== PROGRESS BAR ========== -->
                                                <div class="mb-16 px-2">
                                                    <div class="flex justify-between items-end mb-4">
                                                        <div>
                                                            <span
                                                                class="block text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Tiến
                                                                trình thăng hạng</span>
                                                            <span
                                                                class="text-2xl font-display font-bold text-slate-800">${userPoints}
                                                                <span class="text-lg text-slate-400 font-normal">/
                                                                    ${nextTierPoints} điểm</span>
                                                            </span>
                                                        </div>
                                                        <div class="text-right">
                                                            <c:if test="${nextTierName != 'MAX'}">
                                                                <span
                                                                    class="text-xs font-medium px-3 py-1 rounded-full border"
                                                                    style="background: ${badgeBg}; color: ${badgeColor}; border-color: ${badgeBorder};">
                                                                    Next: ${nextTierName}
                                                                </span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <div
                                                        class="h-4 w-full bg-slate-100 rounded-full overflow-hidden shadow-inner">
                                                        <div class="h-full rounded-full relative"
                                                            style="width: ${tierProgress}%; background: ${progressGradient};">
                                                            <div
                                                                class="absolute inset-0 bg-white/20 w-full h-full animate-pulse">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <c:if test="${nextTierName != 'MAX'}">
                                                        <p class="mt-3 text-sm text-slate-500 text-right">Bạn cần thêm
                                                            <span class="font-bold text-slate-800">${pointsNeeded}
                                                                điểm</span>
                                                            để thăng hạng ${nextTierName}
                                                        </p>
                                                    </c:if>
                                                    <c:if test="${nextTierName == 'MAX'}">
                                                        <p class="mt-3 text-sm text-right font-bold"
                                                            style="color: ${accentColor};">
                                                            Bạn đã đạt hạng thẻ cao nhất!
                                                        </p>
                                                    </c:if>
                                                </div>

                                                <!-- ========== LỊCH SỬ TÍCH ĐIỂM ========== -->
                                                <div class="mb-12 px-2">
                                                    <h3 class="font-display font-bold text-xl text-slate-800 mb-6 flex items-center"
                                                        style="white-space: nowrap;">
                                                        <span class="flex-shrink-0"
                                                            style="width: 32px; height: 1px; background: ${accentColor}; margin-right: 16px;"></span>
                                                        Lịch sử tích điểm
                                                        <span class="flex-shrink-0 flex-grow"
                                                            style="height: 1px; background: #f1f5f9; margin-left: 16px;"></span>
                                                    </h3>
                                                    
                                                    <div class="bg-white/40 backdrop-blur-md border border-white/60 rounded-2xl shadow-sm overflow-hidden">
                                                        <div class="max-h-[400px] overflow-y-auto custom-scrollbar">
                                                            <table class="w-full text-left border-collapse">
                                                                <thead class="sticky top-0 z-20 bg-slate-50/95 backdrop-blur-sm shadow-sm">
                                                                    <tr class="text-slate-500 text-xs uppercase tracking-wider">
                                                                        <th class="px-6 py-4 font-semibold">Ngày giao dịch</th>
                                                                        <th class="px-6 py-4 font-semibold">Lý do</th>
                                                                        <th class="px-6 py-4 font-semibold text-right">Điểm cộng</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody class="divide-y divide-slate-100/50">
                                                                    <c:choose>
                                                                        <c:when test="${not empty pointHistory}">
                                                                            <c:forEach var="item" items="${pointHistory}">
                                                                                <tr class="hover:bg-white/30 transition-colors">
                                                                                    <td class="px-6 py-4 text-sm text-slate-600">
                                                                                        <c:set var="createdAt" value="${item.createdAt}" />
                                                                                        <fmt:formatDate value="${createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                                                    </td>
                                                                                    <td class="px-6 py-4 text-sm font-medium text-slate-700">
                                                                                        ${item.reason}
                                                                                    </td>
                                                                                    <td class="px-6 py-4 text-sm font-bold text-right" style="color: ${accentColor};">
                                                                                        +${item.pointsEarned}
                                                                                    </td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <tr>
                                                                                <td colspan="3" class="px-6 py-10 text-center text-slate-400 italic text-sm">
                                                                                    Chưa có lịch sử tích điểm nào.
                                                                                </td>
                                                                            </tr>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- ========== CÁCH TÍCH ĐIỂM ========== -->
                                                <div class="mb-12 px-2">
                                                    <div
                                                        class="bg-white/60 backdrop-blur-sm border border-slate-100 rounded-2xl p-6">
                                                        <h4
                                                            class="font-bold text-slate-700 mb-3 flex items-center gap-2">
                                                            <span class="material-symbols-outlined text-xl"
                                                                style="color: ${accentColor};">info</span>
                                                            Cách tích điểm
                                                        </h4>
                                                        <p class="text-sm text-slate-500 leading-relaxed">Mỗi <span
                                                                class="font-bold text-slate-700">10.000₫</span> bạn chi
                                                            tiêu mua
                                                            hàng sẽ tích được <span class="font-bold text-slate-700">1
                                                                điểm</span>. Điểm được cộng tự động sau khi đơn hàng
                                                            hoàn thành.
                                                        </p>
                                                        <div class="mt-3 p-3 rounded-xl bg-amber-50 border border-amber-100 flex items-start gap-3">
                                                            <span class="material-symbols-outlined text-amber-600 text-lg">event_repeat</span>
                                                            <p class="text-xs text-amber-800 leading-relaxed uppercase tracking-wider font-semibold">
                                                                Chu kỳ xếp hạng: Điểm tích lũy sẽ được làm mới (về 0) vào ngày 01/01 và 01/07 hàng năm để bắt đầu chu kỳ mới.
                                                            </p>
                                                        </div>
                                                        <div class="mt-4 grid grid-cols-2 md:grid-cols-4 gap-3">
                                                            <div class="text-center p-3 rounded-xl border"
                                                                style="background: ${currentTierKey == 'member' ? 'rgba(120,144,156,0.08)' : '#f8fafc'}; border-color: ${currentTierKey == 'member' ? 'rgba(120,144,156,0.3)' : '#f1f5f9'};">
                                                                <div class="text-xs uppercase tracking-wide mb-1"
                                                                    style="color: ${currentTierKey == 'member' ? '#37474F' : '#94a3b8'};">
                                                                    Member</div>
                                                                <div class="font-bold"
                                                                    style="color: ${currentTierKey == 'member' ? '#37474F' : '#64748b'};">
                                                                    0 - 199</div>
                                                                <div class="text-xs text-slate-400">điểm</div>
                                                            </div>
                                                            <div class="text-center p-3 rounded-xl border"
                                                                style="background: ${currentTierKey == 'silver' ? 'rgba(144,164,174,0.08)' : '#f8fafc'}; border-color: ${currentTierKey == 'silver' ? 'rgba(144,164,174,0.3)' : '#f1f5f9'};">
                                                                <div class="text-xs uppercase tracking-wide mb-1"
                                                                    style="color: ${currentTierKey == 'silver' ? '#455A64' : '#94a3b8'};">
                                                                    Silver</div>
                                                                <div class="font-bold"
                                                                    style="color: ${currentTierKey == 'silver' ? '#455A64' : '#64748b'};">
                                                                    200 - 999</div>
                                                                <div class="text-xs text-slate-400">điểm</div>
                                                            </div>
                                                            <div class="text-center p-3 rounded-xl border"
                                                                style="background: ${currentTierKey == 'gold' ? 'rgba(197,160,89,0.08)' : '#f8fafc'}; border-color: ${currentTierKey == 'gold' ? 'rgba(197,160,89,0.3)' : '#f1f5f9'};">
                                                                <div class="text-xs uppercase tracking-wide mb-1"
                                                                    style="color: ${currentTierKey == 'gold' ? '#8A6E2F' : '#94a3b8'};">
                                                                    Gold</div>
                                                                <div class="font-bold"
                                                                    style="color: ${currentTierKey == 'gold' ? '#8A6E2F' : '#64748b'};">
                                                                    1.000 - 4.999</div>
                                                                <div class="text-xs text-slate-400">điểm</div>
                                                            </div>
                                                            <div class="text-center p-3 rounded-xl border"
                                                                style="background: ${currentTierKey == 'platinum' ? 'rgba(121,134,203,0.08)' : '#f8fafc'}; border-color: ${currentTierKey == 'platinum' ? 'rgba(121,134,203,0.3)' : '#f1f5f9'};">
                                                                <div class="text-xs uppercase tracking-wide mb-1"
                                                                    style="color: ${currentTierKey == 'platinum' ? '#303F9F' : '#94a3b8'};">
                                                                    Platinum</div>
                                                                <div class="font-bold"
                                                                    style="color: ${currentTierKey == 'platinum' ? '#303F9F' : '#64748b'};">
                                                                    5.000+</div>
                                                                <div class="text-xs text-slate-400">điểm</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- ========== ĐẶC QUYỀN CỦA BẠN ========== -->
                                                <div>
                                                    <h3 class="font-display font-bold text-xl text-slate-800 mb-8 flex items-center"
                                                        style="white-space: nowrap;">
                                                        <span class="flex-shrink-0"
                                                            style="width: 32px; height: 1px; background: ${accentColor}; margin-right: 16px;"></span>
                                                        Đặc quyền của bạn
                                                        <span class="flex-shrink-0 flex-grow"
                                                            style="height: 1px; background: #f1f5f9; margin-left: 16px;"></span>
                                                    </h3>

                                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6"
                                                        style="--hover-accent: ${accentColor}; --hover-shadow: ${cardShadow};">

                                                        <!-- ==== MEMBER perks ==== -->
                                                        <c:if test="${currentTierKey == 'member'}">
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">loyalty</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Tích điểm cơ
                                                                    bản</h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Tích 1
                                                                    điểm
                                                                    cho mỗi 10.000₫ chi tiêu để nâng hạng thành viên.
                                                                </p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">campaign</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Thông báo
                                                                    khuyến mãi
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Nhận
                                                                    thông báo
                                                                    về các chương trình khuyến mãi mới nhất.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">support_agent</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Hỗ trợ tiêu
                                                                    chuẩn</h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Được
                                                                    hỗ trợ
                                                                    qua email và chat trong giờ hành chính.</p>
                                                            </div>
                                                        </c:if>

                                                        <!-- ==== SILVER perks ==== -->
                                                        <c:if test="${currentTierKey == 'silver'}">
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">percent</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Giảm 3% mọi
                                                                    đơn</h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Tự
                                                                    động áp
                                                                    dụng giảm giá 3% cho mọi đơn hàng.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">cake</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Quà sinh nhật
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Nhận
                                                                    voucher
                                                                    giảm 5% trong tháng sinh nhật của bạn.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">local_shipping</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Giảm phí ship
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Giảm
                                                                    50% phí
                                                                    vận chuyển cho đơn từ 500.000₫.</p>
                                                            </div>
                                                        </c:if>

                                                        <!-- ==== GOLD perks ==== -->
                                                        <c:if test="${currentTierKey == 'gold'}">
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">local_shipping</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Miễn phí vận
                                                                    chuyển
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Miễn
                                                                    phí ship
                                                                    cho mọi đơn hàng, không giới hạn giá trị.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">cake</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Giảm 10% sinh
                                                                    nhật
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">
                                                                    Voucher giảm
                                                                    giá 10% đặc biệt trong tháng sinh nhật.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">stars</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Ưu tiên săn
                                                                    Sale</h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Quyền
                                                                    truy cập
                                                                    sớm vào các chương trình khuyến mãi lớn.</p>
                                                            </div>
                                                        </c:if>

                                                        <!-- ==== PLATINUM perks ==== -->
                                                        <c:if test="${currentTierKey == 'platinum'}">
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">local_shipping</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Miễn phí vận
                                                                    chuyển
                                                                    VIP</h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Miễn
                                                                    phí ship
                                                                    ưu tiên + giao hàng nhanh express.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">redeem</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Giảm 15% sinh
                                                                    nhật
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">
                                                                    Voucher giảm
                                                                    giá 15% + quà tặng đặc biệt trong tháng sinh nhật.
                                                                </p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">diamond</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Tư vấn cá nhân
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Được
                                                                    tư vấn
                                                                    style và chăm sóc 1-1 bởi chuyên gia thời trang.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">stars</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Truy cập sớm
                                                                    BST mới
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Quyền
                                                                    mua sớm
                                                                    24h trước khi bộ sưu tập mới mở bán.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">percent</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Giảm 5% mọi
                                                                    đơn</h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Tự
                                                                    động áp
                                                                    dụng giảm giá 5% cho tất cả đơn hàng.</p>
                                                            </div>
                                                            <div
                                                                class="perk-card group p-6 rounded-2xl bg-white border border-slate-100 shadow-sm flex flex-col items-center text-center">
                                                                <div class="w-16 h-16 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300"
                                                                    style="background: ${iconBg};">
                                                                    <span
                                                                        class="material-symbols-outlined text-3xl font-light"
                                                                        style="color: ${iconColor};">celebration</span>
                                                                </div>
                                                                <h4 class="font-bold text-slate-800 mb-2">Sự kiện VIP
                                                                </h4>
                                                                <p class="text-xs text-slate-500 leading-relaxed">Được
                                                                    mời tham
                                                                    gia các sự kiện thời trang độc quyền.</p>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                </div>
                            </main>

                            <!-- Footer -->
                            <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                        </body>

                        </html>
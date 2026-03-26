<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8" />
            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
            <title>Thông báo | AISTHÉA</title>
            <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
            <link
                href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&amp;family=Inter:wght@300;400;500;600&amp;display=swap"
                rel="stylesheet" />
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                rel="stylesheet" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                            },
                            boxShadow: {
                                'glass': '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
                                'glass-sm': '0 4px 16px 0 rgba(31, 38, 135, 0.05)',
                                'glow-gold': '0 0 15px rgba(197, 160, 89, 0.3)',
                            }
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

                .gold-border-glow {
                    box-shadow: 0 0 0 1px #C5A059, 0 0 12px rgba(197, 160, 89, 0.4);
                }

                .marble-texture {
                    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.05'/%3E%3C/svg%3E");
                    opacity: 0.4;
                    pointer-events: none;
                }

                .nav-item-active {
                    color: #0056b3;
                    font-weight: 600;
                    background-color: rgba(255, 255, 255, 0.4);
                }

                .nav-subitem-active {
                    color: #0056b3;
                    font-weight: 500;
                }

                .notification-dot {
                    box-shadow: 0 0 8px #38bdf8;
                }

                details>summary {
                    list-style: none;
                }

                details>summary::-webkit-details-marker {
                    display: none;
                }

                details[open] summary .chevron {
                    transform: rotate(180deg);
                }
            </style>
        </head>

        <body
            class="bg-ethereal-sky font-body min-h-screen text-slate-800 relative selection:bg-primary/20 selection:text-primary">
            <div class="fixed inset-0 z-0">
                <div class="absolute inset-0 bg-gradient-to-br from-white via-sky-50 to-blue-100 opacity-80"></div>
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

            <main class="relative z-10 max-w-7xl mx-auto px-4 pb-20 mt-10">
                <div class="flex flex-col lg:flex-row gap-8">
                    <!-- Sidebar -->
                    <jsp:include page="/WEB-INF/views/common/user-sidebar.jsp">
                        <jsp:param name="activeTab" value="notification" />
                    </jsp:include>

                    <section class="lg:w-3/4">
                        <div class="glass-island rounded-[32px] p-8 lg:p-12 min-h-[700px] relative overflow-hidden">
                            <div
                                class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-blue-50/80 to-transparent rounded-bl-full pointer-events-none">
                            </div>
                            <div class="relative z-10 max-w-4xl mx-auto">
                                <header
                                    class="mb-10 border-b border-slate-200/60 pb-6 flex flex-col md:flex-row md:items-end justify-between gap-4">
                                    <div>
                                        <h1 class="font-display font-bold text-3xl text-slate-900 mb-2 tracking-tight">
                                            Thông báo</h1>
                                        <p class="text-slate-500 font-light text-sm tracking-wide">Cập nhật đơn hàng và
                                            các chương trình khuyến mãi mới nhất</p>
                                    </div>
                                    <div class="hidden md:block">
                                        <a href="${pageContext.request.contextPath}/notifications?action=markAllRead"
                                            class="text-xs text-primary hover:underline font-medium">Đánh
                                            dấu đã đọc tất cả</a>
                                    </div>
                                </header>

                                <c:if test="${not empty error}">
                                    <div class="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-xl mb-6 text-sm flex items-center">
                                        <span class="material-symbols-outlined mr-2">error</span>
                                        ${error}
                                    </div>
                                </c:if>

                                <c:if test="${not empty debugInfo}">
                                    <div class="bg-blue-50 border border-blue-200 text-blue-600 px-4 py-3 rounded-xl mb-6 text-xs font-mono">
                                        DEBUG: ${debugInfo}
                                    </div>
                                </c:if>

                                <div class="flex space-x-1 mb-8 bg-slate-100/50 p-1 rounded-xl w-fit">
                                    <a href="${pageContext.request.contextPath}/notifications?type=ALL"
                                        class="px-5 py-2 rounded-lg text-sm font-semibold ${activeType == 'ALL' ? 'text-primary bg-white shadow-sm' : 'text-slate-500 hover:text-slate-700 hover:bg-white/50'} transition-all duration-200">Tất
                                        cả</a>
                                    <a href="${pageContext.request.contextPath}/notifications?type=ORDER"
                                        class="px-5 py-2 rounded-lg text-sm font-semibold ${activeType == 'ORDER' ? 'text-primary bg-white shadow-sm' : 'text-slate-500 hover:text-slate-700 hover:bg-white/50'} transition-all duration-200">Cập
                                        nhật đơn hàng</a>
                                    <a href="${pageContext.request.contextPath}/notifications?type=PROMOTION"
                                        class="px-5 py-2 rounded-lg text-sm font-semibold ${activeType == 'PROMOTION' ? 'text-primary bg-white shadow-sm' : 'text-slate-500 hover:text-slate-700 hover:bg-white/50'} transition-all duration-200">Khuyến
                                        mãi</a>
                                    <a href="${pageContext.request.contextPath}/notifications?type=RETURN"
                                        class="px-5 py-2 rounded-lg text-sm font-semibold ${activeType == 'RETURN' ? 'text-primary bg-white shadow-sm' : 'text-slate-500 hover:text-slate-700 hover:bg-white/50'} transition-all duration-200">Hoàn trả</a>
                                </div>

                                <div class="space-y-1">
                                    <c:if test="${empty notifications}">
                                        <div class="flex flex-col items-center justify-center py-20 text-slate-400">
                                            <span class="material-symbols-outlined text-6xl mb-4 opacity-20">notifications_off</span>
                                            <p class="text-sm font-medium">Bạn chưa có thông báo nào</p>
                                        </div>
                                    </c:if>
                                    
                                    <c:forEach var="n" items="${notifications}">
                                        <div onclick="handleNotificationClick('${n.notificationId}', '${n.type}', this)"
                                            data-content="<c:out value='${n.content}' escapeXml='true'/>"
                                            class="group relative ${n.read ? 'bg-white/20' : 'bg-white/40'} hover:bg-white/80 rounded-2xl p-5 border border-slate-100 transition-all duration-300 hover:shadow-glass-sm flex gap-4 items-start cursor-pointer ${n.read ? 'opacity-80' : ''}">
                                            
                                            <c:if test="${!n.read}">
                                                <div class="absolute top-6 left-4 w-2 h-2 bg-sky-400 rounded-full notification-dot"></div>
                                            </c:if>

                                            <div class="w-12 h-12 rounded-full flex items-center justify-center flex-shrink-0 ml-3
                                                ${n.type == 'ORDER' ? 'bg-blue-50 text-primary border-blue-100' : 
                                                  n.type == 'PROMOTION' ? 'bg-amber-50 text-accent-gold border-amber-100' : 
                                                  n.type == 'RETURN' ? 'bg-red-50 text-red-500 border-red-100' : 
                                                  'bg-slate-50 text-slate-400 border-slate-100'} border">
                                                <span class="material-symbols-outlined text-[24px]">
                                                    ${n.type == 'ORDER' ? 'local_shipping' : 
                                                      n.type == 'PROMOTION' ? 'percent' : 
                                                      n.type == 'RETURN' ? 'assignment_return' : 
                                                      'info'}
                                                </span>
                                            </div>

                                            <div class="flex-1">
                                                <div class="flex justify-between items-start mb-1">
                                                    <h3 class="text-slate-900 font-bold text-sm">
                                                        <c:out value="${n.title}"/>
                                                    </h3>
                                                    <span class="text-[11px] text-slate-400 font-medium bg-slate-50 px-2 py-0.5 rounded-full border border-slate-100">
                                                        <fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </span>
                                                </div>
                                                <p class="text-slate-600 text-sm leading-relaxed mb-2">
                                                    <c:out value="${n.content}"/>
                                                </p>
                                                <span class="inline-block text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                                                    ${n.type == 'ORDER' ? 'Cập nhật đơn hàng' : 
                                                      n.type == 'PROMOTION' ? 'Khuyến mãi' : 
                                                      n.type == 'RETURN' ? 'Hoàn trả' : 
                                                      'Hệ thống'}
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="mt-8 flex justify-center">
                                    <button
                                        class="text-xs font-semibold text-slate-500 hover:text-primary uppercase tracking-widest transition-colors border-b border-transparent hover:border-primary pb-0.5">
                                        Xem các thông báo cũ hơn
                                    </button>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </main>

            <!-- Footer -->
            <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

            <script>
                function handleNotificationClick(id, type, element) {
                    let redirectUrl = "";
                    if (type === 'ORDER') {
                        const content = element.getAttribute('data-content');
                        // Lấy mã đơn hàng từ nội dung (VD: "Đơn hàng #123 - Trạng thái...")
                        const match = content.match(/#(\d+)/);
                        if (match && match[1]) {
                            const orderId = match[1];
                            redirectUrl = "&redirectUrl=" + encodeURIComponent("/order?action=view&id=" + orderId);
                        }
                    } else if (type === 'RETURN') {
                        const content = element.getAttribute('data-content');
                        const match = content.match(/#(\d+)/);
                        if (match && match[1]) {
                            const orderId = match[1];
                            redirectUrl = "&redirectUrl=" + encodeURIComponent("/order?action=view&id=" + orderId);
                        }
                    } else if (type === 'PROMOTION') {
                         redirectUrl = "&redirectUrl=" + encodeURIComponent("/home");
                    }
                    window.location.href = '${pageContext.request.contextPath}/notifications?action=markRead&id=' + id + redirectUrl;
                }
            </script>
        </body>

        </html>
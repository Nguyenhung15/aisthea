<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <% if (session.getAttribute("user")==null) { response.sendRedirect(request.getContextPath() + "/login" );
            return; } %>
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
                <!-- Font Awesome -->
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
                                    'gold-gradient': "linear-gradient(135deg, #F3E5C3 0%, #C5A059 50%, #8A6E2F 100%)",
                                    'gold-shimmer': "linear-gradient(45deg, rgba(255,255,255,0) 40%, rgba(255,255,255,0.4) 50%, rgba(255,255,255,0) 60%)"
                                },
                                boxShadow: {
                                    'glass': '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
                                    'glass-sm': '0 4px 16px 0 rgba(31, 38, 135, 0.05)',
                                    'glow-gold': '0 0 25px rgba(197, 160, 89, 0.5)',
                                    'card-gold': '0 10px 30px -5px rgba(197, 160, 89, 0.4)',
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

                    .glass-input {
                        background: rgba(255, 255, 255, 0.4);
                        backdrop-filter: blur(10px);
                        border: 1px solid rgba(255, 255, 255, 0.6);
                        transition: all 0.3s ease;
                    }

                    .gold-border-glow {
                        box-shadow: 0 0 0 1px #C5A059, 0 0 12px rgba(197, 160, 89, 0.4);
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
                                    <h1 class="font-display font-bold text-3xl text-slate-900 mb-2 tracking-tight">Chi
                                        tiết hạng thành
                                        viên</h1>
                                    <p class="text-slate-500 font-light text-sm tracking-wide">Theo dõi tiến trình và
                                        tận hưởng đặc
                                        quyền dành riêng cho bạn</p>
                                </header>
                                <div class="max-w-4xl mx-auto w-full flex-grow">
                                    <!-- Loyalty Card -->
                                    <div
                                        class="w-full relative rounded-2xl overflow-hidden shadow-card-gold mb-12 group transform transition-transform hover:scale-[1.01] duration-500">
                                        <div class="absolute inset-0 bg-gold-gradient opacity-90"></div>
                                        <div class="absolute inset-0 bg-gold-shimmer card-shimmer"></div>
                                        <div class="absolute inset-0 marble-texture opacity-30"></div>
                                        <div
                                            class="relative z-10 p-8 md:p-10 flex flex-col md:flex-row justify-between items-center md:items-start text-white h-full min-h-[220px]">
                                            <div class="flex flex-col justify-between h-full w-full">
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
                                                        Current
                                                        Tier</div>
                                                    <h2
                                                        class="font-display text-4xl md:text-5xl font-bold tracking-wider text-white drop-shadow-md">
                                                        ${currentTier}</h2>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Progress Bar -->
                                    <div class="mb-16 px-2">
                                        <div class="flex justify-between items-end mb-4">
                                            <div>
                                                <span
                                                    class="block text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Tiến
                                                    trình thăng hạng</span>
                                                <span
                                                    class="text-2xl font-display font-bold text-slate-800">${userPoints}
                                                    <span class="text-lg text-slate-400 font-normal">/ ${nextTierPoints}
                                                        điểm</span></span>
                                            </div>
                                            <div class="text-right">
                                                <c:if test="${nextTierName != 'MAX'}">
                                                    <span
                                                        class="text-xs font-medium text-accent-gold bg-accent-gold/10 px-3 py-1 rounded-full border border-accent-gold/20">Next:
                                                        ${nextTierName}</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="h-4 w-full bg-slate-100 rounded-full overflow-hidden shadow-inner">
                                            <div class="h-full bg-gradient-to-r from-accent-gold via-yellow-400 to-amber-500 rounded-full relative"
                                                style="width: ${tierProgress}%">
                                                <div class="absolute inset-0 bg-white/20 w-full h-full animate-pulse">
                                                </div>
                                            </div>
                                        </div>
                                        <c:if test="${nextTierName != 'MAX'}">
                                            <p class="mt-3 text-sm text-slate-500 text-right">Bạn cần thêm <span
                                                    class="font-bold text-slate-800">${pointsNeeded} điểm</span> để
                                                thăng hạng ${nextTierName}
                                            </p>
                                        </c:if>
                                        <c:if test="${nextTierName == 'MAX'}">
                                            <p
                                                class="mt-3 text-sm text-slate-500 text-right text-accent-gold font-bold">
                                                Bạn đã đạt hạng thẻ cao nhất!</p>
                                        </c:if>
                                    </div>

                                    <!-- Perks Section -->
                                    <div>
                                        <h3
                                            class="font-display font-bold text-xl text-slate-800 mb-8 flex items-center">
                                            <span class="w-8 h-[1px] bg-accent-gold mr-4"></span>
                                            Đặc quyền của bạn
                                            <span class="w-full h-[1px] bg-slate-100 ml-4"></span>
                                        </h3>
                                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                            <div
                                                class="group p-6 rounded-2xl bg-white border border-slate-100 hover:border-accent-gold/30 shadow-sm hover:shadow-glow-gold transition-all duration-300 flex flex-col items-center text-center">
                                                <div
                                                    class="w-16 h-16 rounded-full bg-amber-50 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300">
                                                    <span
                                                        class="material-symbols-outlined text-3xl text-accent-gold font-light">local_shipping</span>
                                                </div>
                                                <h4 class="font-bold text-slate-800 mb-2">Miễn phí vận chuyển</h4>
                                                <p class="text-xs text-slate-500 leading-relaxed">Áp dụng cho mọi đơn
                                                    hàng không giới
                                                    hạn giá trị tối thiểu.</p>
                                            </div>
                                            <div
                                                class="group p-6 rounded-2xl bg-white border border-slate-100 hover:border-accent-gold/30 shadow-sm hover:shadow-glow-gold transition-all duration-300 flex flex-col items-center text-center">
                                                <div
                                                    class="w-16 h-16 rounded-full bg-amber-50 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300">
                                                    <span
                                                        class="material-symbols-outlined text-3xl text-accent-gold font-light">cake</span>
                                                </div>
                                                <h4 class="font-bold text-slate-800 mb-2">Giảm giá 10% sinh nhật</h4>
                                                <p class="text-xs text-slate-500 leading-relaxed">Quà tặng đặc biệt
                                                    trong tháng sinh
                                                    nhật của bạn.</p>
                                            </div>
                                            <div
                                                class="group p-6 rounded-2xl bg-white border border-slate-100 hover:border-accent-gold/30 shadow-sm hover:shadow-glow-gold transition-all duration-300 flex flex-col items-center text-center">
                                                <div
                                                    class="w-16 h-16 rounded-full bg-amber-50 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300">
                                                    <span
                                                        class="material-symbols-outlined text-3xl text-accent-gold font-light">stars</span>
                                                </div>
                                                <h4 class="font-bold text-slate-800 mb-2">Ưu tiên săn Sale</h4>
                                                <p class="text-xs text-slate-500 leading-relaxed">Quyền truy cập sớm vào
                                                    các chương
                                                    trình khuyến mãi lớn.</p>
                                            </div>
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
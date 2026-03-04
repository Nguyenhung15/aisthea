<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <% if (session.getAttribute("user")==null) { response.sendRedirect(request.getContextPath() + "/login" );
                return; } %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="utf-8" />
                    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                    <title>Lịch sử đơn hàng | AISTHÉA</title>
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

                        .glass-input {
                            background: rgba(255, 255, 255, 0.4);
                            backdrop-filter: blur(10px);
                            border: 1px solid rgba(255, 255, 255, 0.6);
                            transition: all 0.3s ease;
                        }

                        .glass-input:focus {
                            background: rgba(255, 255, 255, 0.8);
                            border-color: #0056b3;
                            box-shadow: 0 0 0 4px rgba(0, 86, 179, 0.1);
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
                            background-color: rgba(255, 255, 255, 0.6);
                            box-shadow: 0 4px 16px 0 rgba(31, 38, 135, 0.05);
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

                        ::-webkit-scrollbar-thumb:hover {
                            background: rgba(0, 86, 179, 0.4);
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

                        .tab-underline {
                            position: relative;
                        }

                        .tab-underline::after {
                            content: '';
                            position: absolute;
                            bottom: -1px;
                            left: 0;
                            width: 100%;
                            height: 2px;
                            background-color: transparent;
                            transition: background-color 0.3s ease;
                        }

                        .tab-active {
                            color: #0056b3;
                            font-weight: 600;
                        }

                        .tab-active::after {
                            background-color: #0056b3;
                        }

                        .scrollbar-hide::-webkit-scrollbar {
                            display: none;
                        }

                        .scrollbar-hide {
                            -ms-overflow-style: none;
                            scrollbar-width: none;
                        }
                    </style>
                </head>

                <body
                    class="bg-ethereal-sky font-body min-h-screen text-slate-800 relative selection:bg-primary/20 selection:text-primary">
                    <div class="fixed inset-0 z-0">
                        <div class="absolute inset-0 bg-gradient-to-br from-white via-sky-50 to-blue-100 opacity-80">
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
                                <jsp:param name="activeTab" value="order" />
                            </jsp:include>

                            <section class="lg:w-3/4">
                                <div
                                    class="glass-island rounded-[32px] p-8 lg:p-10 min-h-[700px] relative overflow-hidden flex flex-col">
                                    <div
                                        class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-blue-50/80 to-transparent rounded-bl-full pointer-events-none">
                                    </div>
                                    <header class="relative z-10 mb-8">
                                        <h1 class="font-display font-bold text-3xl text-slate-900 mb-6 tracking-tight">
                                            Lịch sử đơn hàng</h1>
                                        <div
                                            class="flex flex-nowrap overflow-x-auto border-b border-slate-200/70 pb-0 gap-8 scrollbar-hide">
                                            <button data-status="All"
                                                class="whitespace-nowrap pb-3 px-1 text-sm tab-underline tab-active filter-tab">Tất
                                                cả</button>
                                            <button data-status="Pending"
                                                class="whitespace-nowrap pb-3 px-1 text-sm text-slate-500 hover:text-slate-800 tab-underline filter-tab">Chờ
                                                xác nhận</button>
                                            <button data-status="Shipped"
                                                class="whitespace-nowrap pb-3 px-1 text-sm text-slate-500 hover:text-slate-800 tab-underline filter-tab">Đang
                                                giao</button>
                                            <button data-status="Completed"
                                                class="whitespace-nowrap pb-3 px-1 text-sm text-slate-500 hover:text-slate-800 tab-underline filter-tab">Đã
                                                giao</button>
                                            <button data-status="Cancelled"
                                                class="whitespace-nowrap pb-3 px-1 text-sm text-slate-500 hover:text-slate-800 tab-underline filter-tab">Đã
                                                hủy</button>
                                        </div>
                                    </header>

                                    <div class="relative z-10 flex-1 space-y-6">
                                        <c:choose>
                                            <c:when test="${empty orderList}">
                                                <div
                                                    class="flex flex-col items-center justify-center py-20 text-center">
                                                    <div
                                                        class="w-24 h-24 bg-slate-100 rounded-full flex items-center justify-center mb-6">
                                                        <span
                                                            class="material-symbols-outlined text-4xl text-slate-300">shopping_basket</span>
                                                    </div>
                                                    <h3 class="text-xl font-display font-bold text-slate-800 mb-2">Bạn
                                                        chưa có đơn hàng nào</h3>
                                                    <p class="text-slate-500 max-w-xs mb-8">Hãy khám phá bộ sưu tập của
                                                        AISTHÉA để chọn cho mình những món đồ ưng ý nhất.</p>
                                                    <a href="${pageContext.request.contextPath}/product"
                                                        class="px-8 py-3 bg-primary text-white font-semibold rounded-full shadow-lg hover:bg-primary-dark transition-all duration-300">
                                                        Khám phá ngay
                                                    </a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="order" items="${orderList}">
                                                    <div data-status="${order.status}"
                                                        class="order-card bg-white/60 border border-white rounded-2xl p-6 shadow-glass-sm hover:shadow-glass transition-all duration-300">
                                                        <div
                                                            class="flex flex-col md:flex-row justify-between items-start md:items-center mb-4 pb-4 border-b border-slate-100">
                                                            <div class="flex flex-col">
                                                                <span
                                                                    class="font-bold text-slate-800 text-lg">#${order.orderid}</span>
                                                                <span class="text-xs text-slate-400 mt-1">
                                                                    <fmt:formatDate value="${order.createdat}"
                                                                        pattern="dd 'Tháng' MM, yyyy" />
                                                                </span>
                                                            </div>
                                                            <div class="mt-2 md:mt-0 flex items-center">
                                                                <c:choose>
                                                                    <c:when test="${order.status eq 'Pending'}">
                                                                        <span
                                                                            class="px-3 py-1 rounded-full text-xs font-semibold bg-amber-50 text-amber-600 border border-amber-100 flex items-center">
                                                                            <span
                                                                                class="w-1.5 h-1.5 rounded-full bg-amber-500 mr-2 animate-pulse"></span>
                                                                            Chờ xác nhận
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${order.status eq 'Shipped'}">
                                                                        <span
                                                                            class="px-3 py-1 rounded-full text-xs font-semibold bg-blue-50 text-blue-600 border border-blue-100 flex items-center">
                                                                            <span
                                                                                class="w-1.5 h-1.5 rounded-full bg-blue-500 mr-2 animate-pulse"></span>
                                                                            Đang giao
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${order.status eq 'Completed'}">
                                                                        <span
                                                                            class="px-3 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-600 border border-emerald-100">
                                                                            Đã giao
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${order.status eq 'Cancelled'}">
                                                                        <span
                                                                            class="px-3 py-1 rounded-full text-xs font-semibold bg-slate-100 text-slate-500 border border-slate-200">
                                                                            Đã hủy
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="px-3 py-1 rounded-full text-xs font-semibold bg-slate-50 text-slate-600 border border-slate-200">
                                                                            ${order.status}
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>

                                                        <div class="flex flex-col md:flex-row gap-6 mb-4">
                                                            <div
                                                                class="flex -space-x-3 overflow-hidden py-1 pl-1 ${order.status eq 'Cancelled' ? 'grayscale opacity-70' : ''}">
                                                                <c:forEach var="item" items="${order.items}"
                                                                    varStatus="status">
                                                                    <c:if test="${status.index < 3}">
                                                                        <img alt="${item.productName}"
                                                                            class="inline-block h-16 w-16 rounded-lg ring-2 ring-white object-cover shadow-sm bg-slate-50"
                                                                            src="${item.imageUrl}"
                                                                            onerror="this.src='https://via.placeholder.com/150'" />
                                                                    </c:if>
                                                                </c:forEach>
                                                                <c:if test="${order.items.size() > 3}">
                                                                    <div
                                                                        class="h-16 w-16 rounded-lg ring-2 ring-white bg-slate-100 flex items-center justify-center text-xs font-medium text-slate-500 shadow-sm z-10">
                                                                        +${order.items.size() - 3}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            <div class="flex-1 flex flex-col justify-center">
                                                                <p class="text-sm text-slate-600 line-clamp-2">
                                                                    <c:forEach var="item" items="${order.items}"
                                                                        varStatus="status">
                                                                        ${item.productName}${!status.last ? ', ' : ''}
                                                                    </c:forEach>
                                                                </p>
                                                            </div>
                                                        </div>

                                                        <div
                                                            class="flex justify-between items-end mt-4 pt-4 border-t border-slate-50">
                                                            <div>
                                                                <p
                                                                    class="text-xs text-slate-400 uppercase tracking-wider mb-1">
                                                                    Tổng tiền</p>
                                                                <p
                                                                    class="text-lg font-display font-bold ${order.status eq 'Cancelled' ? 'text-slate-500 line-through decoration-slate-400' : 'text-slate-900'}">
                                                                    <fmt:formatNumber value="${order.totalprice}"
                                                                        type="currency" currencyCode="VND"
                                                                        maxFractionDigits="0" />
                                                                </p>
                                                            </div>
                                                            <div class="flex items-center gap-3">
                                                                <c:if test="${order.status eq 'Completed'}">
                                                                    <a href="${pageContext.request.contextPath}/feedback?orderId=${order.orderid}"
                                                                        class="px-5 py-2 bg-emerald-500 text-white text-sm font-semibold rounded-lg shadow-sm hover:bg-emerald-600 transition-all duration-300 flex items-center gap-1.5">
                                                                        <i class="fa-regular fa-star text-xs"></i>
                                                                        Đánh giá
                                                                    </a>
                                                                </c:if>
                                                                <a href="${pageContext.request.contextPath}/order?action=view&id=${order.orderid}"
                                                                    class="px-5 py-2 bg-white border border-slate-200 text-slate-700 text-sm font-medium rounded-lg shadow-sm hover:bg-slate-50 hover:text-primary hover:border-primary/30 transition-all duration-300">
                                                                    Xem chi tiết
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </section>
                        </div>
                    </main>

                    <!-- Footer -->
                    <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const tabs = document.querySelectorAll('.filter-tab');
                            const orderCards = document.querySelectorAll('.order-card');
                            const emptyState = document.getElementById('empty-state');

                            tabs.forEach(tab => {
                                tab.addEventListener('click', function () {
                                    const filter = this.getAttribute('data-status');

                                    // Update active tab UI
                                    tabs.forEach(t => {
                                        t.classList.remove('tab-active');
                                        t.classList.add('text-slate-500');
                                    });
                                    this.classList.add('tab-active');
                                    this.classList.remove('text-slate-500');

                                    // Filter orders
                                    let visibleCount = 0;
                                    orderCards.forEach(card => {
                                        if (filter === 'All' || card.getAttribute('data-status') === filter) {
                                            card.style.display = 'block';
                                            visibleCount++;
                                        } else {
                                            card.style.display = 'none';
                                        }
                                    });

                                    // If we had a "no results for this tab" message, we'd show it here
                                    // For now, if someone has no orders at all, the empty state is already shown by JSTL
                                });
                            });
                        });
                    </script>
                </body>

                </html>
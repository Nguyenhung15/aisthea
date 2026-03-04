<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Sổ địa chỉ | AISTHÉA</title>
                <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet" />
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

                    .marble-texture {
                        background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.05'/%3E%3C/svg%3E");
                        opacity: 0.4;
                        pointer-events: none;
                    }

                    .nav-item-active {
                        color: #0056b3;
                        font-weight: 600;
                    }

                    .nav-subitem-active {
                        color: #0056b3 !important;
                        font-weight: 600 !important;
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

                    .rotate-chevron {
                        transform: rotate(180deg);
                    }

                    details[open] summary .chevron {
                        transform: rotate(180deg);
                    }

                    .gold-border-glow {
                        box-shadow: 0 0 0 1px #C5A059, 0 0 12px rgba(197, 160, 89, 0.4);
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

                <main class="relative z-10 max-w-7xl mx-auto px-4 pb-20 pt-10">
                    <div class="flex flex-col lg:flex-row gap-8">
                        <!-- Sidebar -->
                        <jsp:include page="/WEB-INF/views/common/user-sidebar.jsp">
                            <jsp:param name="activeTab" value="address" />
                        </jsp:include>
                        <section class="lg:w-3/4">
                            <div class="glass-island rounded-[32px] p-8 lg:p-12 min-h-[700px] relative overflow-hidden">
                                <div
                                    class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-blue-50/80 to-transparent rounded-bl-full pointer-events-none">
                                </div>
                                <div class="relative z-10">
                                    <div
                                        class="flex flex-col md:flex-row md:items-center justify-between mb-8 pb-6 border-b border-slate-200/60 gap-4">
                                        <div>
                                            <h1 class="font-display font-bold text-3xl text-slate-900 tracking-tight">Sổ
                                                địa chỉ</h1>
                                            <p class="text-slate-500 font-light text-sm tracking-wide mt-1">Quản lý danh
                                                sách địa chỉ nhận hàng của bạn</p>
                                        </div>
                                        <button
                                            class="flex items-center bg-primary text-white px-5 py-2.5 rounded-lg shadow-md hover:bg-primary-dark transition-all duration-300 group">
                                            <span
                                                class="material-symbols-outlined text-[20px] mr-2 transition-transform group-hover:rotate-90">add</span>
                                            <span class="text-sm font-semibold tracking-wide">Thêm địa chỉ mới</span>
                                        </button>
                                    </div>
                                    <div class="space-y-6">
                                        <!-- Default Address -->
                                        <div
                                            class="relative bg-white/80 rounded-lg p-6 border border-blue-100 shadow-sm hover:shadow-md transition-all duration-300">
                                            <div
                                                class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-4">
                                                <div class="flex items-center gap-3 mb-2 sm:mb-0">
                                                    <h3 class="font-bold text-slate-800 text-lg">Võ Hiền Nguyên Hưng
                                                    </h3>
                                                    <span
                                                        class="inline-flex items-center text-slate-500 text-sm border-l border-slate-300 pl-3">(+84)
                                                        973 596 868</span>
                                                </div>
                                                <div class="flex items-center gap-4">
                                                    <button
                                                        class="text-sm text-primary hover:text-primary-dark font-medium hover:underline decoration-primary/30 underline-offset-4">Cập
                                                        nhật</button>
                                                </div>
                                            </div>
                                            <div class="flex flex-col sm:flex-row justify-between items-start gap-4">
                                                <div class="text-slate-600 text-sm leading-relaxed max-w-2xl">
                                                    Số 15, Đường Lê Duẩn, Phường Bến Nghé, Quận 1, Thành phố Hồ Chí
                                                    Minh, Việt Nam
                                                </div>
                                                <span
                                                    class="inline-block px-3 py-1 rounded border border-accent-gold/40 bg-amber-50 text-accent-gold text-xs font-semibold uppercase tracking-wider whitespace-nowrap">
                                                    Mặc định
                                                </span>
                                            </div>
                                        </div>
                                        <!-- Secondary Address 1 -->
                                        <div
                                            class="relative bg-white/80 rounded-lg p-6 border border-slate-100 shadow-sm hover:shadow-md transition-all duration-300 hover:border-blue-100">
                                            <div
                                                class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-4">
                                                <div class="flex items-center gap-3 mb-2 sm:mb-0">
                                                    <h3 class="font-bold text-slate-800 text-lg">Văn phòng AISTHÉA</h3>
                                                    <span
                                                        class="inline-flex items-center text-slate-500 text-sm border-l border-slate-300 pl-3">(+84)
                                                        902 345 678</span>
                                                </div>
                                                <div class="flex items-center gap-4 text-sm">
                                                    <button
                                                        class="text-slate-500 hover:text-primary transition-colors">Chỉnh
                                                        sửa</button>
                                                    <button
                                                        class="text-slate-500 hover:text-red-500 transition-colors">Xóa</button>
                                                </div>
                                            </div>
                                            <div class="flex flex-col sm:flex-row justify-between items-start gap-4">
                                                <div class="text-slate-600 text-sm leading-relaxed max-w-2xl">
                                                    Tầng 12, Tòa nhà Bitexco Financial Tower, Số 2 Hải Triều, Quận 1,
                                                    Thành phố Hồ Chí Minh
                                                </div>
                                                <button
                                                    class="px-3 py-1 rounded border border-slate-200 text-slate-400 text-xs font-medium hover:border-primary hover:text-primary transition-colors whitespace-nowrap">
                                                    Thiết lập mặc định
                                                </button>
                                            </div>
                                        </div>
                                        <!-- Secondary Address 2 -->
                                        <div
                                            class="relative bg-white/80 rounded-lg p-6 border border-slate-100 shadow-sm hover:shadow-md transition-all duration-300 hover:border-blue-100">
                                            <div
                                                class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-4">
                                                <div class="flex items-center gap-3 mb-2 sm:mb-0">
                                                    <h3 class="font-bold text-slate-800 text-lg">Nhà riêng Hà Nội</h3>
                                                    <span
                                                        class="inline-flex items-center text-slate-500 text-sm border-l border-slate-300 pl-3">(+84)
                                                        912 345 789</span>
                                                </div>
                                                <div class="flex items-center gap-4 text-sm">
                                                    <button
                                                        class="text-slate-500 hover:text-primary transition-colors">Chỉnh
                                                        sửa</button>
                                                    <button
                                                        class="text-slate-500 hover:text-red-500 transition-colors">Xóa</button>
                                                </div>
                                            </div>
                                            <div class="flex flex-col sm:flex-row justify-between items-start gap-4">
                                                <div class="text-slate-600 text-sm leading-relaxed max-w-2xl">
                                                    Số 88, Phố Huế, Phường Ngô Thì Nhậm, Quận Hai Bà Trưng, Hà Nội
                                                </div>
                                                <button
                                                    class="px-3 py-1 rounded border border-slate-200 text-slate-400 text-xs font-medium hover:border-primary hover:text-primary transition-colors whitespace-nowrap">
                                                    Thiết lập mặc định
                                                </button>
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
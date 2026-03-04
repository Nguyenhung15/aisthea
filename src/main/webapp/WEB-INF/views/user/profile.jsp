<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <% if (session.getAttribute("user")==null) { response.sendRedirect(request.getContextPath() + "/login" );
            return; } %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Hồ sơ cá nhân | AISTHÉA</title>
                <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&amp;family=Inter:wght@300;400;500;600&amp;display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                    rel="stylesheet" />
                <!-- Font Awesome (for header) -->
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

                <script>
                    tailwind.config = {
                        darkMode: "class",
                        theme: {
                            extend: {
                                colors: {
                                    primary: "#0056b3", // Cerulean Blue
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
                        outline: none;
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

                    .rotate-chevron {
                        transform: rotate(180deg);
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

                <main class="relative z-10 max-w-7xl mx-auto px-4 pb-20 mt-8">
                    <div class="flex flex-col lg:flex-row gap-8">
                        <!-- Sidebar -->
                        <jsp:include page="/WEB-INF/views/common/user-sidebar.jsp">
                            <jsp:param name="activeTab" value="profile" />
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
                                            <h1
                                                class="font-display font-bold text-3xl text-slate-900 mb-2 tracking-tight">
                                                Hồ sơ cá nhân</h1>
                                            <p class="text-slate-500 font-light text-sm tracking-wide">Quản lý và bảo vệ
                                                thông tin tài khoản của bạn</p>
                                        </div>
                                    </header>

                                    <!-- Notification Banner Area -->
                                    <div id="notificationArea" class="mb-6 space-y-3">
                                        <c:if test="${param.success != null}">
                                            <div
                                                class="bg-emerald-50 border border-emerald-200 text-emerald-600 rounded-xl p-4 text-sm flex items-center shadow-sm animate-fadeIn">
                                                <span
                                                    class="material-symbols-outlined mr-3 text-[20px]">check_circle</span>
                                                <span class="font-medium">Cập nhật hồ sơ thành công!</span>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty sessionScope.changePassSuccess}">
                                            <div
                                                class="bg-emerald-50 border border-emerald-200 text-emerald-600 rounded-xl p-4 text-sm flex items-center shadow-sm animate-fadeIn">
                                                <span class="material-symbols-outlined mr-3 text-[20px]">verified</span>
                                                <span class="font-medium">${sessionScope.changePassSuccess}</span>
                                            </div>
                                            <c:remove var="changePassSuccess" scope="session" />
                                        </c:if>

                                        <c:if test="${not empty sessionScope.changePassError}">
                                            <div
                                                class="bg-red-50 border border-red-200 text-red-600 rounded-xl p-4 text-sm flex items-center shadow-sm animate-fadeIn">
                                                <span
                                                    class="material-symbols-outlined mr-3 text-[20px]">error_outline</span>
                                                <span class="font-medium">${sessionScope.changePassError}</span>
                                            </div>
                                            <c:remove var="changePassError" scope="session" />
                                        </c:if>
                                    </div>

                                    <form id="profileForm" action="${pageContext.request.contextPath}/updateProfile"
                                        method="post" enctype="multipart/form-data" class="space-y-8">
                                        <input type="file" id="avatarInput" name="avatar" accept="image/*"
                                            style="display:none;">

                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-8">

                                            <div class="space-y-2 group">
                                                <label
                                                    class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1"
                                                    for="fullName">Họ và tên</label>
                                                <div class="relative">
                                                    <input name="fullname"
                                                        class="w-full pl-5 pr-5 py-3.5 glass-input rounded-xl text-slate-800 placeholder-slate-400 outline-none font-medium"
                                                        id="fullName" type="text" value="${sessionScope.user.fullname}"
                                                        required />
                                                    <div
                                                        class="absolute right-4 top-3.5 text-primary opacity-0 group-hover:opacity-100 transition-opacity">
                                                        <span class="material-symbols-outlined text-[18px]">edit</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="space-y-2">
                                                <label
                                                    class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1"
                                                    for="email">Email</label>
                                                <div class="relative opacity-75">
                                                    <input
                                                        class="w-full pl-5 pr-12 py-3.5 bg-slate-100/50 border border-slate-200/60 rounded-xl text-slate-500 cursor-not-allowed font-medium"
                                                        disabled="" id="email" type="email"
                                                        value="${sessionScope.user.email}" />
                                                    <input type="hidden" name="email"
                                                        value="${sessionScope.user.email}" />
                                                    <span
                                                        class="material-symbols-outlined absolute right-4 top-3.5 text-slate-400 text-[20px]">lock</span>
                                                </div>
                                            </div>

                                            <div class="space-y-2">
                                                <label
                                                    class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1"
                                                    for="phone">Số điện thoại</label>
                                                <div class="relative group">
                                                    <input name="phone"
                                                        class="w-full pl-5 pr-5 py-3.5 glass-input rounded-xl text-slate-800 font-medium"
                                                        id="phone" type="tel" value="${sessionScope.user.phone}" />
                                                    <div
                                                        class="absolute right-4 top-3.5 text-primary opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
                                                        <span class="material-symbols-outlined text-[18px]">edit</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="space-y-2">
                                                <label
                                                    class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1"
                                                    for="gender">Giới tính</label>
                                                <div class="relative">
                                                    <select name="gender"
                                                        class="w-full pl-5 pr-12 py-3.5 glass-input rounded-xl text-slate-800 appearance-none cursor-pointer font-medium"
                                                        id="gender">
                                                        <option value="Male" ${sessionScope.user.gender=='Male'
                                                            ? 'selected' : '' }>Nam</option>
                                                        <option value="Female" ${sessionScope.user.gender=='Female'
                                                            ? 'selected' : '' }>Nữ</option>
                                                        <option value="Other" ${sessionScope.user.gender=='Other'
                                                            ? 'selected' : '' }>Khác</option>
                                                    </select>
                                                    <span
                                                        class="material-symbols-outlined absolute right-4 top-3.5 pointer-events-none text-slate-500 text-[20px]">expand_more</span>
                                                </div>
                                            </div>

                                            <div class="space-y-2 md:col-span-2 lg:col-span-1">
                                                <label
                                                    class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1"
                                                    for="birthday">Ngày sinh</label>
                                                <div class="relative">
                                                    <input name="birthday"
                                                        class="w-full pl-5 pr-5 py-3.5 glass-input rounded-xl text-slate-800 font-medium cursor-pointer"
                                                        id="birthday" type="date" value="1999-01-01" />
                                                    <span
                                                        class="material-symbols-outlined absolute right-4 top-3.5 pointer-events-none text-slate-500 text-[20px]">calendar_today</span>
                                                </div>
                                            </div>

                                        </div>

                                        <div
                                            class="pt-6 flex items-center justify-start gap-5 border-transparent mt-10">
                                            <button
                                                class="px-8 py-3.5 bg-primary text-white rounded-xl shadow-lg shadow-blue-500/20 hover:shadow-blue-500/40 hover:bg-primary-dark transition-all duration-300 transform hover:-translate-y-0.5"
                                                type="submit">
                                                <span
                                                    class="font-medium tracking-wide flex items-center justify-center text-sm uppercase">
                                                    <span class="material-symbols-outlined mr-2 text-[18px]">save</span>
                                                    Lưu thay đổi
                                                </span>
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </section>
                    </div>
                </main>

                <!-- Footer -->
                <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                <!-- Scripts -->
                <script>
                    // Preview Image when selecting avatar file
                    const avatarInput = document.getElementById("avatarInput");

                    if (avatarInput) {
                        avatarInput.addEventListener("change", e => {
                            const file = e.target.files[0];
                            if (file) {
                                let preview = document.getElementById("avatarPreview");
                                let placeholder = document.getElementById("avatarPlaceholder");

                                if (placeholder) {
                                    placeholder.classList.add("hidden");
                                }
                                preview.classList.remove("hidden");
                                preview.src = URL.createObjectURL(file);
                            }
                        });
                    }

                    // Success URL param handling
                    if (new URLSearchParams(window.location.search).get("success") !== null) {
                        window.history.replaceState({}, document.title, window.location.pathname);
                        // Optional: auto-hide notification after 5 seconds
                        setTimeout(() => {
                            const note = document.querySelector('.bg-emerald-50');
                            if (note) note.style.opacity = '0';
                        }, 5000);
                    }
                </script>
            </body>

            </html>
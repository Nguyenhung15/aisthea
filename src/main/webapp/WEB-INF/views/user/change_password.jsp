<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <% if (session.getAttribute("user")==null) { response.sendRedirect(request.getContextPath() + "/login" );
            return; } %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Đổi mật khẩu | AISTHÉA</title>
                <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&amp;family=Inter:wght@300;400;500;600&amp;display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                    rel="stylesheet" />
                <!-- Font Awesome (for icons used in avatar fallback) -->
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
                        <aside class="lg:w-1/4">
                            <div
                                class="glass-island rounded-[24px] p-6 sticky top-28 transition-transform hover:shadow-lg duration-500">
                                <div class="flex flex-col items-center mb-6 pb-6 border-b border-slate-200/60">
                                    <div class="relative w-24 h-24 mb-4 group cursor-pointer"
                                        onclick="document.getElementById('avatarInput').click();">
                                        <div
                                            class="absolute inset-0 rounded-full gold-border-glow opacity-60 group-hover:opacity-100 transition-opacity duration-500">
                                        </div>
                                        <form id="avatarForm" action="${pageContext.request.contextPath}/updateProfile"
                                            method="post" enctype="multipart/form-data">
                                            <input type="file" id="avatarInput" name="avatar" accept="image/*"
                                                style="display:none;"
                                                onchange="document.getElementById('avatarForm').submit();">
                                        </form>
                                        <c:choose>
                                            <c:when
                                                test="${not empty sessionScope.user.avatar and !sessionScope.user.avatar.equals('images/ava_default.png')}">
                                                <img alt="Profile Avatar"
                                                    class="w-full h-full rounded-full object-cover border-4 border-white shadow-md relative z-10"
                                                    src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}" />
                                            </c:when>
                                            <c:otherwise>
                                                <div
                                                    class="w-full h-full rounded-full border-4 border-white shadow-md relative z-10 bg-slate-200 flex items-center justify-center text-slate-400">
                                                    <i class="fa-solid fa-user text-4xl"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <button
                                            class="absolute bottom-1 right-1 z-20 bg-white text-primary p-1.5 rounded-full shadow-lg hover:bg-primary hover:text-white transition-colors border border-slate-100"
                                            onclick="document.getElementById('avatarInput').click();">
                                            <span
                                                class="material-symbols-outlined text-[14px] block pointer-events-none">edit</span>
                                        </button>
                                    </div>
                                    <h2
                                        class="font-display font-bold text-lg text-slate-900 mb-2 text-center leading-tight">
                                        ${sessionScope.user.fullname}</h2>
                                    <div
                                        class="flex items-center space-x-2 bg-gradient-to-r from-amber-50 to-amber-100 px-3 py-1 rounded-full border border-amber-200/50 mb-4">
                                        <span
                                            class="material-symbols-outlined text-accent-gold text-[16px]">stars</span>
                                        <span
                                            class="text-xs font-bold text-accent-gold tracking-wide uppercase">Member</span>
                                    </div>
                                    <div class="w-full px-2">
                                        <div class="flex justify-between items-end mb-1.5">
                                            <span
                                                class="text-[10px] font-medium text-slate-400 uppercase tracking-wider">Points</span>
                                            <span class="text-[10px] font-bold text-primary">1500 / 2000</span>
                                        </div>
                                        <div class="w-full bg-slate-100 rounded-full h-1.5 overflow-hidden">
                                            <div class="bg-gradient-to-r from-sky-300 via-primary to-accent-gold h-1.5 rounded-full"
                                                style="width: 75%"></div>
                                        </div>
                                        <p class="mt-2 text-[10px] text-center text-slate-500 font-medium">Cần thêm 500
                                            points to <span class="text-accent-gold font-bold">DIAMOND</span></p>
                                    </div>
                                </div>
                                <nav class="space-y-1">
                                    <details class="group" open="">
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
                                            <a class="block py-2 text-sm text-slate-500 hover:text-primary transition-colors"
                                                href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a>
                                            <a class="block py-2 text-sm nav-subitem-active transition-colors hover:text-primary"
                                                href="${pageContext.request.contextPath}/change-password">Đổi mật
                                                khẩu</a>
                                            <a class="block py-2 text-sm text-slate-500 hover:text-primary transition-colors"
                                                href="${pageContext.request.contextPath}/tier-details">Chi tiết hạng
                                                thành viên</a>
                                        </div>
                                    </details>
                                    <a class="flex items-center px-4 py-3 rounded-lg text-slate-500 hover:text-slate-900 hover:bg-white/40 transition-all duration-300 group"
                                        href="${pageContext.request.contextPath}/order">
                                        <span
                                            class="material-symbols-outlined mr-3 text-[20px] group-hover:text-slate-700">history_edu</span>
                                        <span class="font-medium text-sm tracking-wide">Lịch sử đơn hàng</span>
                                    </a>
                                    <a class="flex items-center px-4 py-3 rounded-lg text-slate-500 hover:text-slate-900 hover:bg-white/40 transition-all duration-300 group"
                                        href="#">
                                        <span
                                            class="material-symbols-outlined mr-3 text-[20px] group-hover:text-slate-700">notifications</span>
                                        <span class="font-medium text-sm tracking-wide">Thông báo</span>
                                        <span
                                            class="ml-auto bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full shadow-sm">3</span>
                                    </a>
                                    <a class="flex items-center px-4 py-3 rounded-lg text-red-500 hover:text-red-700 hover:bg-red-50/50 transition-all duration-300 group mt-4 border-t border-slate-100 pt-4"
                                        href="${pageContext.request.contextPath}/logout">
                                        <span class="material-symbols-outlined mr-3 text-[20px]">logout</span>
                                        <span class="font-medium text-sm tracking-wide">Đăng xuất</span>
                                    </a>
                                </nav>
                            </div>
                        </aside>
                        <section class="lg:w-3/4">
                            <div
                                class="glass-island rounded-[32px] p-8 lg:p-12 min-h-[700px] relative overflow-hidden flex flex-col justify-center">
                                <div
                                    class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-blue-50/80 to-transparent rounded-bl-full pointer-events-none">
                                </div>
                                <div class="relative z-10 w-full max-w-lg mx-auto">
                                    <header class="mb-10 border-b border-slate-200/60 pb-6 text-center">
                                        <h1 class="font-display font-bold text-3xl text-slate-900 mb-2 tracking-tight">
                                            Đổi mật khẩu</h1>
                                        <p class="text-slate-500 font-light text-sm tracking-wide">Bảo vệ tài khoản của
                                            bạn với mật khẩu an toàn</p>
                                    </header>
                                    <form action="${pageContext.request.contextPath}/change-password" method="post"
                                        class="space-y-6">
                                        <div class="space-y-2">
                                            <label
                                                class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1"
                                                for="current-password">Mật khẩu hiện tại</label>
                                            <div class="relative group">
                                                <input name="oldPassword" required
                                                    class="w-full pl-5 pr-12 py-3.5 glass-input rounded-xl text-slate-800 placeholder-slate-400 outline-none font-medium focus:ring-0"
                                                    id="current-password" placeholder="Nhập mật khẩu hiện tại"
                                                    type="password" />
                                                <button
                                                    class="absolute right-4 top-3.5 text-slate-400 hover:text-primary transition-colors focus:outline-none"
                                                    type="button" onclick="togglePassword('current-password', this)">
                                                    <span
                                                        class="material-symbols-outlined text-[20px]">visibility_off</span>
                                                </button>
                                            </div>
                                        </div>
                                        <div class="space-y-2">
                                            <label
                                                class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1"
                                                for="new-password">Mật khẩu mới</label>
                                            <div class="relative group">
                                                <input name="newPassword" required
                                                    class="w-full pl-5 pr-12 py-3.5 glass-input rounded-xl text-slate-800 placeholder-slate-400 outline-none font-medium border-emerald-500/50 focus:border-emerald-500 focus:shadow-[0_0_0_4px_rgba(16,185,129,0.1)]"
                                                    id="new-password" placeholder="Nhập mật khẩu mới" type="password"
                                                    oninput="checkPasswordStrength()" />
                                                <button
                                                    class="absolute right-4 top-3.5 text-slate-400 hover:text-primary transition-colors focus:outline-none"
                                                    type="button" onclick="togglePassword('new-password', this)">
                                                    <span
                                                        class="material-symbols-outlined text-[20px]">visibility_off</span>
                                                </button>
                                            </div>
                                            <p id="pwd-strength"
                                                class="text-[11px] text-slate-400 font-medium ml-1 mt-1 flex items-center hidden">
                                                <span class="material-symbols-outlined text-[14px] mr-1">info</span>
                                                Cần ít nhất 8 ký tự
                                            </p>
                                        </div>
                                        <div class="space-y-2">
                                            <label
                                                class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1"
                                                for="confirm-password">Xác nhận mật khẩu mới</label>
                                            <div class="relative group">
                                                <input name="confirmPassword" required
                                                    class="w-full pl-5 pr-12 py-3.5 glass-input rounded-xl text-slate-800 placeholder-slate-400 outline-none font-medium focus:border-primary focus:shadow-[0_0_0_4px_rgba(0,86,179,0.1)]"
                                                    id="confirm-password" placeholder="Nhập lại mật khẩu mới"
                                                    type="password" oninput="checkPasswordMatch()" />
                                                <button
                                                    class="absolute right-4 top-3.5 text-slate-400 hover:text-primary transition-colors focus:outline-none"
                                                    type="button" onclick="togglePassword('confirm-password', this)">
                                                    <span
                                                        class="material-symbols-outlined text-[20px]">visibility_off</span>
                                                </button>
                                            </div>
                                            <p id="pwd-match"
                                                class="text-[11px] text-red-500 font-medium ml-1 mt-1 flex items-center hidden">
                                                <span class="material-symbols-outlined text-[14px] mr-1">error</span>
                                                Mật khẩu không khớp
                                            </p>
                                        </div>

                                        <c:if test="${not empty sessionScope.changePassError}">
                                            <div
                                                class="bg-red-50 border border-red-200 text-red-600 rounded-lg p-3 text-sm flex items-center justify-center">
                                                <span class="material-symbols-outlined mr-2">error</span>
                                                ${sessionScope.changePassError}
                                            </div>
                                            <c:remove var="changePassError" scope="session" />
                                        </c:if>

                                        <c:if test="${not empty sessionScope.changePassSuccess}">
                                            <div
                                                class="bg-emerald-50 border border-emerald-200 text-emerald-600 rounded-lg p-3 text-sm flex items-center justify-center">
                                                <span
                                                    class="material-symbols-outlined mr-2 text-[18px]">check_circle</span>
                                                ${sessionScope.changePassSuccess}
                                            </div>
                                            <c:remove var="changePassSuccess" scope="session" />
                                        </c:if>

                                        <div class="pt-8">
                                            <button id="submitBtn"
                                                class="w-full py-4 bg-primary text-white rounded-xl shadow-lg shadow-blue-500/20 hover:shadow-blue-500/40 hover:bg-primary-dark transition-all duration-300 transform hover:-translate-y-0.5 group relative overflow-hidden"
                                                type="submit">
                                                <span
                                                    class="absolute inset-0 w-full h-full bg-gradient-to-r from-transparent via-white/10 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700"></span>
                                                <span
                                                    class="font-medium tracking-wide flex items-center justify-center text-sm uppercase relative z-10">
                                                    Cập nhật mật khẩu
                                                </span>
                                            </button>
                                            <button
                                                class="w-full mt-4 text-xs text-slate-500 hover:text-primary underline decoration-slate-300 hover:decoration-primary underline-offset-4 transition-all"
                                                type="button"
                                                onclick="window.location.href='${pageContext.request.contextPath}/forgot_password'">
                                                Quên mật khẩu?
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

                <script>
                    function togglePassword(inputId, btn) {
                        const input = document.getElementById(inputId);
                        const icon = btn.querySelector('span');
                        if (input.type === "password") {
                            input.type = "text";
                            icon.textContent = "visibility";
                        } else {
                            input.type = "password";
                            icon.textContent = "visibility_off";
                        }
                    }

                    function checkPasswordMatch() {
                        const newPwd = document.getElementById('new-password').value;
                        const confirmPwd = document.getElementById('confirm-password').value;
                        const msg = document.getElementById('pwd-match');
                        const input = document.getElementById('confirm-password');

                        if (confirmPwd.length > 0 && newPwd !== confirmPwd) {
                            msg.classList.remove('hidden');
                            input.classList.remove('focus:border-primary', 'focus:shadow-[0_0_0_4px_rgba(0,86,179,0.1)]');
                            input.classList.add('border-red-500/30', 'focus:border-red-500', 'focus:shadow-[0_0_0_4px_rgba(239,68,68,0.1)]');
                        } else {
                            msg.classList.add('hidden');
                            input.classList.add('focus:border-primary', 'focus:shadow-[0_0_0_4px_rgba(0,86,179,0.1)]');
                            input.classList.remove('border-red-500/30', 'focus:border-red-500', 'focus:shadow-[0_0_0_4px_rgba(239,68,68,0.1)]');
                        }
                    }

                    function checkPasswordStrength() {
                        const pwd = document.getElementById('new-password').value;
                        const input = document.getElementById('new-password');
                        const msg = document.getElementById('pwd-strength');

                        if (pwd.length > 0 && pwd.length < 8) {
                            msg.classList.remove('hidden', 'text-emerald-600');
                            msg.classList.add('text-slate-400');
                            msg.innerHTML = '<span class="material-symbols-outlined text-[14px] mr-1">info</span> Cần ít nhất 8 ký tự';

                            input.classList.remove('border-emerald-500/50', 'focus:border-emerald-500', 'focus:shadow-[0_0_0_4px_rgba(16,185,129,0.1)]');
                        } else if (pwd.length >= 8) {
                            msg.classList.remove('hidden', 'text-slate-400');
                            msg.classList.add('text-emerald-600');
                            msg.innerHTML = '<span class="material-symbols-outlined text-[14px] mr-1">check_circle</span> Mật khẩu hợp lệ';

                            input.classList.add('border-emerald-500/50', 'focus:border-emerald-500', 'focus:shadow-[0_0_0_4px_rgba(16,185,129,0.1)]');
                        } else {
                            msg.classList.add('hidden');
                        }
                        checkPasswordMatch();
                    }
                </script>


            </body>

            </html>
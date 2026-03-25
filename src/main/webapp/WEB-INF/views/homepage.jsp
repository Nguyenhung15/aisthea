<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
            <title>Home | AISTHÉA</title>
            <meta name="description"
                content="AISTHÉA — Curated luxury fashion. Discover premium knitwear, outerwear and more.">

            <%-- Fonts --%>
                <link href="https://fonts.googleapis.com" rel="preconnect" />
                <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600;700&amp;family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&amp;display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                    rel="stylesheet" />

                <%-- Font Awesome --%>
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                        rel="stylesheet" />

                    <%-- Tailwind --%>
                        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                        <script>
                            tailwind.config = {
                                theme: {
                                    extend: {
                                        colors: { primary: '#024acf' },
                                        fontFamily: {
                                            display: ['Manrope', 'sans-serif'],
                                            serif: ["'Playfair Display'", 'serif'],
                                        },
                                        keyframes: {
                                            liquidFlow: {
                                                '0%, 100%': { backgroundPosition: '0% 50%' },
                                                '50%': { backgroundPosition: '100% 50%' },
                                            }
                                        },
                                        animation: {
                                            liquidFlow: 'liquidFlow 20s ease infinite',
                                        }
                                    }
                                }
                            }
                        </script>

                        <style type="text/tailwindcss">
                            .glass-header {
                background: rgba(255, 255, 255, 0.92);
                backdrop-filter: blur(16px);
                -webkit-backdrop-filter: blur(16px);
                border: 1px solid rgba(2, 74, 207, 0.15);
                box-shadow: 0 4px 30px rgba(0, 0, 0, 0.08), 0 1px 3px rgba(0,0,0,0.06);
            }
            .glow-border {
                box-shadow: 0 4px 24px rgba(2, 74, 207, 0.12), inset 0 0 0 1px rgba(2, 74, 207, 0.2);
            }
            .liquid-bg {
                background: linear-gradient(125deg, #ffffff 0%, #E3F2FD 40%, #ffffff 70%, #BBDEFB 100%);
                background-size: 400% 400%;
            }
            .font-serif-display {
                font-family: 'Playfair Display', serif;
            }
            .nav-link-glow {
                position: relative;
            }
            .nav-link-glow::after {
                content: '';
                position: absolute;
                bottom: -4px;
                left: 0;
                width: 100%;
                height: 1px;
                background: #024acf;
                transform: scaleX(0);
                transform-origin: right;
                transition: transform 0.4s cubic-bezier(0.22, 1, 0.36, 1);
            }
            .nav-link-glow:hover::after {
                transform: scaleX(1);
                transform-origin: left;
            }
            .hero-image-shadow {
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            }
        </style>
        </head>

        <body
            class="font-display text-slate-800 liquid-bg animate-liquidFlow min-h-screen selection:bg-blue-100 selection:text-blue-900">

            <%--=====HEADER — ngoài wrapper để fixed positioning hoạt động=====--%>
                <jsp:include page="/WEB-INF/views/common/header-luxury.jsp" />

                <%-- Wrapper ngăn horizontal scroll nhưng không ảnh hưởng fixed nav --%>
                    <div style="overflow-x:clip">

                        <%--=====HERO SECTION=====--%>
                            <main class="relative pt-32 pb-20 px-6 min-h-screen flex flex-col justify-center">

                                <%-- Decorative SVG — bottom right --%>
                                    <div
                                        class="absolute bottom-8 right-8 z-40 opacity-80 mix-blend-multiply pointer-events-none hidden lg:block">
                                        <svg fill="none" height="120" viewBox="0 0 200 200" width="120"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <circle cx="100" cy="100" r="95" stroke="#C8A97E" stroke-width="2" />
                                            <circle cx="100" cy="100" r="88" stroke="#C8A97E" stroke-dasharray="4 4"
                                                stroke-width="1" />
                                            <path
                                                d="M60 140C60 140 50 80 65 60L90 85L110 85L135 60C150 80 140 140 140 140"
                                                stroke="#C8A97E" stroke-linecap="round" stroke-width="2" />
                                            <path d="M75 110L50 115M75 120L55 125" stroke="#C8A97E"
                                                stroke-linecap="round" stroke-width="1.5" />
                                            <path d="M125 110L150 115M125 120L145 125" stroke="#C8A97E"
                                                stroke-linecap="round" stroke-width="1.5" />
                                        </svg>
                                    </div>

                                    <div
                                        class="max-w-[1600px] mx-auto w-full grid grid-cols-1 lg:grid-cols-12 gap-12 items-center relative z-10">

                                        <%-- Left: Copy --%>
                                            <div class="lg:col-span-5 order-2 lg:order-1 relative z-20 mt-12 lg:mt-0">
                                                <div class="relative">
                                                    <span
                                                        class="block text-[#024acf] font-semibold tracking-[0.3em] text-sm mb-6 uppercase pl-1">
                                                        Winter Collection 2025
                                                    </span>
                                                    <h1
                                                        class="font-serif-display text-6xl md:text-8xl text-slate-900 leading-[0.9] mb-8">
                                                        THE ART <br />
                                                        <span class="italic font-light text-slate-500">of</span> <br />
                                                        WINTER
                                                    </h1>
                                                    <p
                                                        class="text-slate-600 text-lg md:text-xl font-light leading-relaxed max-w-md mb-10 pl-1">
                                                        Discover the harmony of texture and warmth. A curated selection
                                                        of
                                                        premium knitwear
                                                        designed for the modern silhouette.
                                                    </p>
                                                    <div class="flex items-center gap-8 pl-1">
                                                        <a class="group relative inline-flex items-center justify-center px-8 py-4 text-sm font-bold
                                   tracking-widest text-white uppercase bg-slate-900 overflow-hidden transition-all
                                   duration-300 hover:bg-[#024acf] hover:shadow-[0_0_20px_rgba(2,74,207,0.4)]"
                                                            href="${pageContext.request.contextPath}/product">
                                                            <span class="relative z-10">Explore Collection</span>
                                                        </a>
                                                        <a class="group flex items-center text-sm font-semibold tracking-widest uppercase
                                   text-slate-900 hover:text-[#024acf] transition-colors"
                                                            href="${pageContext.request.contextPath}/product?sort=newest">
                                                            <span
                                                                class="border-b border-slate-900 group-hover:border-[#024acf] pb-1 transition-colors">
                                                                View Lookbook
                                                            </span>
                                                            <span
                                                                class="material-symbols-outlined ml-2 text-lg transform group-hover:translate-x-1 transition-transform">
                                                                arrow_forward
                                                            </span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>

                                            <%-- Right: Hero images --%>
                                                <div
                                                    class="lg:col-span-7 order-1 lg:order-2 relative h-[60vh] lg:h-[80vh]">
                                                    <%-- Glow blob --%>
                                                        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px]
                             bg-blue-100/50 rounded-full blur-3xl -z-10"></div>

                                                        <%-- Main hero image — replace src with your own if needed --%>
                                                            <div class="absolute top-0 right-0 lg:right-10 w-3/4 h-5/6 overflow-hidden hero-image-shadow
                             transition-transform duration-700 hover:scale-[1.01]">
                                                                <img alt="Fashion Model Winter"
                                                                    class="w-full h-full object-cover"
                                                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuAdz8WHiKpWHF_Y6hI5PQx6oJp9Moo8RDrC1m6rMAO4YEFJbfBhEp8XN5m6hPdXdDldXgxH8WEZ6d6f2RCICNapZZ6-em5MwRocul7u_MJyi11gcag6P8wPngfbUzrx-x7oO9LUftvbkKdmSgLASiyHfbhpJnLv6TJHxk8eEyPoBDfZe09dtGo50Vz0U66_n-kUkHhvBZKyF2UBHbuUcIjMkQODARdMxTpIEE3Ys0g__kSxZ0sk_nf9yQq0V1oIteeoe2ysQMprHo6K" />
                                                                <div
                                                                    class="absolute inset-0 bg-gradient-to-t from-slate-900/20 to-transparent">
                                                                </div>
                                                            </div>

                                                            <%-- Secondary image card --%>
                                                                <div class="absolute bottom-10 left-0 lg:left-10 w-1/2 h-3/5 overflow-hidden hero-image-shadow
                             border-8 border-white/30 backdrop-blur-sm transition-transform duration-700
                             hover:-translate-y-4 z-20">
                                                                    <img alt="Fashion Detail"
                                                                        class="w-full h-full object-cover"
                                                                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuAuJzZMxyY3gX_HVMzjMXTKBCDxgvb2jdXxYrdxM_Se8_0rcx3jBFKhicESdSuNyUkRUbFzqkBswrtx6LqBWJoD0aI6We0rcJI73XKs3YVSDaYjzv69G2qClZFdApezWmrRWs3Err-P4RFUsDVCiEXF4Mi9BlfgPdpY9xlxfshDzf4hMyhsuGZ-fzrwHVJVjwNvuwKYNu7jiqEbB9GzUiho494AnzbIStxQRzI1Ogglp9PGFa56z9wwGzvnnq-nlj0NVMHTzmsrkfAG" />
                                                                    <div class="absolute bottom-6 right-6 bg-white/90 backdrop-blur px-4 py-2 flex items-center gap-3
                                 shadow-lg cursor-pointer group">
                                                                        <div class="flex flex-col">
                                                                            <span
                                                                                class="text-[10px] text-slate-500 uppercase tracking-wider">Featured</span>
                                                                            <span
                                                                                class="text-xs font-serif-display font-bold text-slate-900">Cashmere
                                                                                Coat</span>
                                                                        </div>
                                                                        <a href="${pageContext.request.contextPath}/product"
                                                                            class="w-6 h-6 rounded-full bg-slate-900 text-white flex items-center justify-center
                                   group-hover:bg-[#024acf] transition-colors">
                                                                            <span
                                                                                class="material-symbols-outlined text-[14px]">arrow_outward</span>
                                                                        </a>
                                                                    </div>
                                                                </div>

                                                                <%-- Decorative circle --%>
                                                                    <div class="absolute top-1/4 left-[15%] w-24 h-24 border border-[#024acf]/30 rounded-full z-30
                             animate-pulse hidden lg:block"></div>
                                                </div>
                                    </div>

                                    <%-- Scroll indicator --%>
                                        <div
                                            class="absolute bottom-8 left-1/2 transform -translate-x-1/2 flex flex-col items-center gap-2 opacity-60">
                                            <span class="text-[10px] tracking-[0.3em] uppercase">Scroll</span>
                                            <div class="w-[1px] h-12 bg-slate-400 overflow-hidden relative">
                                                <div
                                                    class="absolute top-0 left-0 w-full h-1/2 bg-slate-900 animate-bounce">
                                                </div>
                                            </div>
                                        </div>
                            </main>

                            <%--=====CATEGORY CARDS SECTION=====--%>
                                <section class="relative z-20 px-6 pb-28 -mt-10">
                                    <div class="max-w-7xl mx-auto">
                                        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">

                                            <a class="group relative block h-96 overflow-hidden"
                                                href="${pageContext.request.contextPath}/product?sort=newest">
                                                <img alt="New Arrivals"
                                                    class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                                                    src="https://i.pinimg.com/736x/d0/5a/b3/d05ab337a4721c7b6c8ce9c2c8ddb3e3.jpg" />
                                                <div
                                                    class="absolute inset-0 bg-black/20 group-hover:bg-black/10 transition-colors">
                                                </div>
                                                <div
                                                    class="absolute bottom-0 left-0 w-full p-8 bg-gradient-to-t from-black/60 to-transparent">
                                                    <h3
                                                        class="text-white font-serif-display text-3xl italic mb-1 group-hover:translate-x-2 transition-transform duration-300">
                                                        New Arrivals
                                                    </h3>
                                                    <p class="text-white/80 text-xs tracking-widest uppercase">Shop Now
                                                    </p>
                                                </div>
                                            </a>

                                            <a class="group relative block h-96 overflow-hidden mt-0 md:mt-16"
                                                href="${pageContext.request.contextPath}/product?genderid=2">
                                                <img alt="Women Collection"
                                                    class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuBvx_yjEykDLcifjvPxp2sbLdk8SW_sTZKymmYj45wiKOwVlEsZ5yFfb-9RuZu5pOUJqiKIXV1jHId-Wybho2lm45OrpPfzgYkRSSLtqOQNvZlHJZj7E4HTpK21J8-bgEHs4TYNyDSLi-j4w7IUqUhIfemmr52o6b87X4LJ9Nx3GX_QL2zNt8hvk3R-XvtpfZliLy04_44zo3xv9mWF2wdtyGUv8jmxkQp5pbRChraPNrfpTw6MPm6DnH9kWBexqtl-aYQD6MD44mXn" />
                                                <div
                                                    class="absolute inset-0 bg-black/20 group-hover:bg-black/10 transition-colors">
                                                </div>
                                                <div
                                                    class="absolute bottom-0 left-0 w-full p-8 bg-gradient-to-t from-black/60 to-transparent">
                                                    <h3
                                                        class="text-white font-serif-display text-3xl italic mb-1 group-hover:translate-x-2 transition-transform duration-300">
                                                        Women
                                                    </h3>
                                                    <p class="text-white/80 text-xs tracking-widest uppercase">View
                                                        Collection
                                                    </p>
                                                </div>
                                            </a>

                                            <a class="group relative block h-96 overflow-hidden"
                                                href="${pageContext.request.contextPath}/product?genderid=1">
                                                <img alt="Men Collection"
                                                    class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                                                    src="https://i.pinimg.com/736x/ce/4f/55/ce4f55708e83085c5b289c2c83d0225c.jpg" />
                                                <div
                                                    class="absolute inset-0 bg-black/20 group-hover:bg-black/10 transition-colors">
                                                </div>
                                                <div
                                                    class="absolute bottom-0 left-0 w-full p-10 bg-gradient-to-t from-black/60 to-transparent">
                                                    <h3
                                                        class="text-white font-serif-display text-3xl italic mb-1 group-hover:translate-x-2 transition-transform duration-300">
                                                        Men
                                                    </h3>
                                                    <p class="text-white/80 text-xs tracking-widest uppercase">Read More
                                                    </p>
                                                </div>
                                            </a>

                                        </div>
                                    </div>
                                </section>

                                <%--=====FOOTER=====--%>
                                    <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                    </div><%-- end overflow-x-hidden wrapper --%>

                        <%-- AI Chatbox Widget --%>
                            <jsp:include page="/WEB-INF/views/common/chatbox-widget.jsp" />

        </body>

        </html>
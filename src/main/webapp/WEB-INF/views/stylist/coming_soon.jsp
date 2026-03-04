<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
            <title>AISTHÉA STYLIST | Coming Soon</title>
            <!-- BEGIN: External Scripts -->
            <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
            <script>
                tailwind.config = {
                    theme: {
                        extend: {
                            colors: {
                                primary: "#024acf", // added primary to match header
                                'charcoal': '#0a0a0a',
                                'digital-blue': '#00f2ff',
                            },
                            fontFamily: {
                                'serif': ['"Playfair Display"', 'serif'],
                                'sans': ['Inter', 'sans-serif'],
                                'serif-display': ['"Playfair Display"', 'serif'],
                            },
                        }
                    }
                }
            </script>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL,GRAD,opsz@400,0,0,24"
                rel="stylesheet" />

            <!-- END: External Scripts -->
            <!-- BEGIN: Custom Styles -->
            <style data-purpose="google-fonts">
                @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400&family=Playfair+Display:ital,wght@0,400;0,700;1,400&display=swap');
            </style>
            <style data-purpose="animations">
                @keyframes scan {
                    0% {
                        top: 0%;
                        opacity: 0;
                    }

                    10% {
                        opacity: 1;
                    }

                    50% {
                        top: 100%;
                    }

                    90% {
                        opacity: 1;
                    }

                    100% {
                        top: 0%;
                        opacity: 0;
                    }
                }

                @keyframes scanline {
                    0% {
                        transform: translateY(-100%);
                        opacity: 0;
                    }

                    50% {
                        opacity: 1;
                    }

                    100% {
                        transform: translateY(100%);
                        opacity: 0;
                    }
                }

                @keyframes rotate {
                    from {
                        transform: rotate(0deg);
                    }

                    to {
                        transform: rotate(360deg);
                    }
                }

                @keyframes rotateHUD {
                    from {
                        transform: translate(-50%, -50%) rotate(0deg);
                    }

                    to {
                        transform: translate(-50%, -50%) rotate(360deg);
                    }
                }

                @keyframes pulse-glow {
                    0% {
                        opacity: 0.5;
                        text-shadow: 0 0 10px rgba(0, 242, 255, 0.5);
                    }

                    50% {
                        opacity: 1;
                        text-shadow: 0 0 25px rgba(0, 242, 255, 0.8);
                    }

                    100% {
                        opacity: 0.5;
                        text-shadow: 0 0 10px rgba(0, 242, 255, 0.5);
                    }
                }

                .scan-line {
                    position: absolute;
                    width: 100%;
                    height: 2px;
                    background: linear-gradient(90deg, transparent, #00f2ff, #ffffff, #00f2ff, transparent);
                    box-shadow: 0 0 20px #00f2ff;
                    animation: scan 6s ease-in-out infinite;
                    z-index: 30;
                }

                .scanner-line {
                    position: absolute;
                    width: 100%;
                    height: 2px;
                    background: linear-gradient(90deg, transparent, #00BFFF, transparent);
                    box-shadow: 0 0 15px #00BFFF;
                    animation: scanline 4s linear infinite;
                    z-index: 15;
                }

                .hud-ring {
                    position: absolute;
                    border: 1px solid rgba(0, 242, 255, 0.3);
                    border-radius: 50%;
                    animation: rotate 20s linear infinite;
                    pointer-events: none;
                }

                .hud-circle {
                    position: absolute;
                    border: 1px solid rgba(0, 191, 255, 0.4);
                    border-radius: 50%;
                    border-top: 1px solid transparent;
                    animation: rotateHUD 10s linear infinite;
                }

                .digital-universe {
                    background: radial-gradient(circle at center, #0a1128 0%, #02040a 100%);
                    overflow: hidden;
                }

                .perspective-grid {
                    position: absolute;
                    width: 200%;
                    height: 200%;
                    top: -50%;
                    left: -50%;
                    background-image:
                        linear-gradient(rgba(0, 242, 255, 0.1) 1px, transparent 1px),
                        linear-gradient(90deg, rgba(0, 242, 255, 0.1) 1px, transparent 1px);
                    background-size: 60px 60px;
                    transform: perspective(500px) rotateX(60deg);
                    z-index: 1;
                }

                .nebula {
                    position: absolute;
                    width: 100%;
                    height: 100%;
                    background: radial-gradient(circle at 20% 30%, rgba(0, 242, 255, 0.05) 0%, transparent 50%),
                        radial-gradient(circle at 80% 70%, rgba(138, 43, 226, 0.05) 0%, transparent 50%);
                    filter: blur(100px);
                    z-index: 0;
                }

                .glow-text {
                    animation: pulse-glow 4s ease-in-out infinite;
                }
            </style>
        </head>

        <body class="bg-charcoal text-white font-sans antialiased overflow-x-hidden">
            <div class="grain-overlay"></div>

            <!-- header include -->
            <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

            <main
                class="min-h-screen relative flex flex-col items-center justify-center pt-20 pb-32 digital-universe bg-black">
                <div class="perspective-grid"></div>
                <div class="nebula"></div>

                <!-- Hero Visual Section -->
                <div class="relative w-full max-w-2xl px-6 mb-16" data-purpose="visual-display">
                    <!-- Container for the mannequin and scan effect -->
                    <div class="relative w-[300px] h-[500px] md:w-[450px] md:h-[650px] mx-auto mb-8 group">
                        <!-- Digital Fashion Model -->
                        <img alt="AISTHÉA AI Model"
                            class="w-full h-full object-cover grayscale brightness-75 mix-blend-screen opacity-90 relative z-20"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuCS--nG6svslfeKtWqGCy7VC60ELEo5O-xa4qRITq5Vl0j9-IDcXuB3l6tjPZGLDnehvu9fBk7hDN3GiKpx0X8fXCi36lnEaO_GZj8hvrjE4KLTNLIYRxPehp-V_1wsg9K10WxQPtQB5PuD1QaUAw2qFR_xa-xNAY3YscSa6x5pC_7IYnBOW75bGC8K92EzjDH29nd3zzn86ktfzpwT631_MYLuhLZ054zajt31z3pHYgX1YhybgCHtvppWX53opZtePMnBHiXsGpfT" />
                        <!-- AI Scanning Overlays -->
                        <div class="scanner-line top-1/4"></div>
                        <div class="scanner-line top-2/3" style="animation-delay: 2s;"></div>
                        <!-- HUD Interface -->
                        <div class="hud-circle w-64 h-64 top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
                            style="opacity: 0.2;"></div>
                        <div class="hud-circle w-80 h-80 top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
                            style="opacity: 0.2;"></div>
                        <!-- Data Points Indicators -->
                        <div
                            class="absolute top-[20%] left-[30%] w-2 h-2 bg-electric-blue rounded-full shadow-[0_0_8px_#00BFFF] animate-pulse z-30">
                            <span
                                class="absolute left-4 top-[-10px] text-[10px] text-[color:#00f2ff] font-mono whitespace-nowrap">SHOULDER_AXIS:
                                42.4cm</span>
                        </div>
                        <div
                            class="absolute top-[50%] right-[25%] w-2 h-2 bg-electric-blue rounded-full shadow-[0_0_8_#00BFFF] animate-pulse z-30">
                            <span
                                class="absolute right-4 top-[-10px] text-[10px] text-[color:#00f2ff] font-mono whitespace-nowrap">WAIST_RATIO:
                                0.72</span>
                        </div>
                        <!-- Corner HUD -->
                        <div class="absolute inset-0 z-40 pointer-events-none p-6">
                            <div class="flex flex-col justify-between h-full">
                                <div class="flex justify-between items-start">
                                    <div class="w-4 h-4 border-t border-l border-digital-blue"></div>
                                    <div class="w-4 h-4 border-t border-r border-digital-blue"></div>
                                </div>
                                <div class="flex justify-between items-end">
                                    <div class="w-4 h-4 border-b border-l border-digital-blue"></div>
                                    <div class="w-4 h-4 border-b border-r border-digital-blue"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Digital Points Grid -->
                        <div class="absolute inset-0 opacity-20 z-30"
                            style="background-size: 40px 40px; background-image: radial-gradient(circle, #00f2ff 1px, transparent 1px);">
                        </div>
                    </div>
                </div>

                <!-- Typography & CTA Section -->
                <div class="text-center px-6 max-w-4xl z-10 relative" data-purpose="launch-info">
                    <h2 class="font-serif text-5xl md:text-8xl tracking-tight leading-none mb-8 glow-text">STYLIST IS
                        <br /><span class="italic font-light">COMING SOON</span>
                    </h2>
                    <p class="text-zinc-400 text-lg md:text-xl font-light tracking-wide max-w-xl mx-auto mb-12">Your
                        Virtual Personal Fitting Room – Powered by AI. <br /><span class="text-white">Experience fashion
                            like never before.</span></p>

                    <!-- BEGIN: CTA Section -->
                    <div class="flex flex-col sm:flex-row items-center justify-center gap-4"
                        data-purpose="newsletter-signup">
                        <input
                            class="bg-black/40 backdrop-blur-md border border-zinc-700 text-white px-6 py-4 w-full sm:w-80 text-xs tracking-widest focus:ring-1 focus:ring-digital-blue focus:border-digital-blue transition-all"
                            placeholder="ENTER YOUR EMAIL" type="email" />
                        <button
                            class="bg-white text-black px-12 py-4 text-xs tracking-[0.2em] font-bold hover:bg-digital-blue hover:text-white transition-all duration-300 w-full sm:w-auto shadow-[0_0_15px_rgba(255,255,255,0.3)]">
                            NOTIFY ME
                        </button>
                    </div>
                </div>

                <!-- Decorative Digital Accents -->
                <div class="absolute bottom-10 left-10 hidden lg:block" data-purpose="decorative-tech-data">
                    <p class="text-[10px] text-zinc-600 font-mono tracking-tighter uppercase leading-tight">
                        Protocol: AISTHEA_V1.0<br />
                        Neural_Engine: Active<br />
                        Fitting_Precision: 99.9%
                    </p>
                </div>
                <div class="absolute bottom-10 right-10 hidden lg:block" data-purpose="decorative-tech-data">
                    <p class="text-[10px] text-zinc-600 font-mono tracking-tighter uppercase text-right leading-tight">
                        2024 © All Rights Reserved<br />
                        Digital Atelier Tokyo/Paris<br />
                        High-End AI Experience
                    </p>
                </div>
            </main>

            <!-- footer include -->
            <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

        </body>

        </html>
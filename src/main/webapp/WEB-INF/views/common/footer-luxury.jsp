<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <%--============================================================footer-luxury.jsp New minimal luxury footer.
            Dependencies: Tailwind CDN + Font Awesome
            6.x============================================================--%>
            <footer class="bg-white border-t border-slate-200">
                <div
                    class="max-w-[1400px] mx-auto px-8 py-12 flex flex-col md:flex-row justify-between items-center gap-6">

                    <%-- Brand --%>
                        <a href="${pageContext.request.contextPath}/"
                            class="text-2xl font-serif-display font-bold tracking-widest text-slate-800 hover:text-[#024acf] transition-colors">
                            AISTHÉA
                        </a>

                        <%-- Copyright --%>
                            <div class="text-xs text-slate-500 tracking-wider text-center">
                                &copy; 2025 Aisthéa. All rights reserved.
                            </div>

                            <%-- Social links --%>
                                <div class="flex gap-6 text-slate-400">
                                    <a class="hover:text-[#024acf] transition-colors transform hover:scale-110 duration-200"
                                        href="#" aria-label="Instagram">
                                        <i class="fa-brands fa-instagram text-xl"></i>
                                    </a>
                                    <a class="hover:text-[#024acf] transition-colors transform hover:scale-110 duration-200"
                                        href="#" aria-label="Pinterest">
                                        <i class="fa-brands fa-pinterest text-xl"></i>
                                    </a>
                                    <a class="hover:text-[#024acf] transition-colors transform hover:scale-110 duration-200"
                                        href="#" aria-label="Twitter">
                                        <i class="fa-brands fa-twitter text-xl"></i>
                                    </a>
                                </div>
                </div>
            </footer>
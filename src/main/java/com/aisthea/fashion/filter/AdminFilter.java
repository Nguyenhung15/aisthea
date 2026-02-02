//package com.aisthea.fashion.filter;
//
//import com.aisthea.fashion.model.User;
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.*;
//
//import java.io.IOException;
//
//@WebFilter("/admin/*")
//public class AdminFilter implements Filter {
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//
//        HttpSession session = req.getSession(false);
//        User user = (session != null) ? (User) session.getAttribute("user") : null;
//
//        // ✅ Nếu chưa đăng nhập hoặc không phải admin → chặn
//        if (user == null) {
//            res.sendRedirect(req.getContextPath() + "/views/login.jsp");
//            return;
//        }
//
//        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
//            res.sendRedirect(req.getContextPath() + "/views/admin/dashboard.jsp");
//            return;
//        }
//
//        // ✅ Nếu là admin thì cho đi tiếp
//        chain.doFilter(request, response);
//    }
//}

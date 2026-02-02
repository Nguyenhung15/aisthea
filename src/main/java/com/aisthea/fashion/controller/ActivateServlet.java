package com.aisthea.fashion.controller;

import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ActivateServlet extends HttpServlet {

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        if (email != null && !email.isEmpty()) {

            boolean activated = userService.activateUser(email);

            if (activated) {
                request.setAttribute("message", "Tài khoản đã được kích hoạt! Bạn có thể đăng nhập.");
            } else {
                request.setAttribute("error", "Kích hoạt thất bại. Email không hợp lệ hoặc đã kích hoạt.");
            }
        } else {
            request.setAttribute("error", "Email không hợp lệ!");
        }
        request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
    }
}

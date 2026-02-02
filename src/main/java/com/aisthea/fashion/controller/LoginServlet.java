package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.LoginResult;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        LoginResult result = userService.login(email, password);

        if (result.isSuccess()) {
            User user = result.getUser();
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/views/homepage.jsp");

        } else {
            String errorMsg = result.getMessage();
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
        }
    }
}

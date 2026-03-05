package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.DBConnection;
import com.aisthea.fashion.model.LoginResult;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

public class LoginServlet extends HttpServlet {

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null)
            email = email.trim();
        if (password != null)
            password = password.trim();

        // === DEBUG: Test DB connection directly ===
        try (Connection testConn = DBConnection.getConnection()) {
            if (testConn == null) {
                request.setAttribute("error",
                        "LỖI: Không thể kết nối database từ Tomcat! Kiểm tra JDBC driver trong WEB-INF/lib.");
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("error", "LỖI KẾT NỐI DB: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        try {
            LoginResult result = userService.login(email, password);

            if (result.isSuccess()) {
                User user = result.getUser();
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("error", result.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "EXCEPTION: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
        }
    }
}

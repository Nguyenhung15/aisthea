package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ChangePasswordServlet extends HttpServlet {

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            session.setAttribute("changePassError", "Mật khẩu mới không khớp!");
            response.sendRedirect(request.getContextPath() + "/views/user/profile.jsp");
            return;
        }

        if (userService.changePassword(user.getUserId(), oldPassword, newPassword)) {
            session.setAttribute("changePassSuccess", "Đổi mật khẩu thành công!");
        } else {
            session.setAttribute("changePassError", "Mật khẩu cũ không đúng hoặc có lỗi xảy ra!");
        }

        response.sendRedirect(request.getContextPath() + "/views/user/profile.jsp");
    }
}

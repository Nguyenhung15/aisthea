package com.aisthea.fashion.controller;

import com.aisthea.fashion.service.IPasswordResetService;
import com.aisthea.fashion.service.PasswordResetService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ResetRequestServlet extends HttpServlet {

    private IPasswordResetService passwordResetService;

    @Override
    public void init() throws ServletException {
        this.passwordResetService = new PasswordResetService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jspPath = "/views/user/forgot_password.jsp";
        req.getRequestDispatcher(jspPath).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String jspPath = "/views/user/forgot_password.jsp";

        String appUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                + req.getContextPath();

        IPasswordResetService.RequestStatus status = passwordResetService.requestPasswordReset(email, appUrl);

        switch (status) {
            case SUCCESS:
                req.setAttribute("message", "Đã gửi link đặt lại mật khẩu đến email. Vui lòng kiểm tra hộp thư.");
                break;
            case USER_NOT_FOUND:
                req.setAttribute("error", "Email không tồn tại trong hệ thống.");
                break;
            case MAIL_ERROR:
            default:
                req.setAttribute("error", "Lỗi hệ thống, không thể gửi email. Vui lòng thử lại sau.");
                break;
        }

        req.getRequestDispatcher(jspPath).forward(req, resp);
    }
}
package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.EmailVerification;
import com.aisthea.fashion.dao.EmailVerificationDAO;
import com.aisthea.fashion.dao.IEmailVerificationDAO;
import com.aisthea.fashion.service.IPasswordResetService;
import com.aisthea.fashion.service.PasswordResetService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;

public class ResetPasswordServlet extends HttpServlet {

    private IPasswordResetService passwordResetService;
    private IEmailVerificationDAO evDAO;

    @Override
    public void init() throws ServletException {
        this.passwordResetService = new PasswordResetService();
        this.evDAO = new EmailVerificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        EmailVerification ev = evDAO.findByToken(token);

        if (ev == null || ev.isVerified()
                || (ev.getExpiresAt() != null && ev.getExpiresAt().isBefore(LocalDateTime.now()))) {
            req.setAttribute("error", "Liên kết không hợp lệ hoặc đã hết hạn.");
            req.getRequestDispatcher("/views/error.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("token", token);
        req.getRequestDispatcher("/views/user/reset_password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPassword = req.getParameter("password");
        String jspPath = "/views/user/reset_password.jsp";

        IPasswordResetService.ResetStatus status = passwordResetService.performPasswordReset(token, newPassword);

        switch (status) {
            case SUCCESS:
                req.setAttribute("message", "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập lại.");
                req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
                return;
            case TOKEN_EXPIRED:
                req.setAttribute("error", "Liên kết đã hết hạn. Vui lòng yêu cầu lại.");
                break;
            case TOKEN_INVALID:
                req.setAttribute("error", "Liên kết không hợp lệ hoặc đã được sử dụng.");
                break;
            case UPDATE_FAILED:
            default:
                req.setAttribute("error", "Có lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
                break;
        }

        req.setAttribute("token", token);
        req.getRequestDispatcher(jspPath).forward(req, resp);
    }
}

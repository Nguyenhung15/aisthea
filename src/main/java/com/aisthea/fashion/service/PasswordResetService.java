package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.EmailVerificationDAO;
import com.aisthea.fashion.dao.IEmailVerificationDAO;
import com.aisthea.fashion.dao.IUserDAO;
import com.aisthea.fashion.dao.UserDAO;
import com.aisthea.fashion.model.EmailVerification;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.util.BCryptUtil;
import com.aisthea.fashion.util.MailUtil;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.UUID;

public class PasswordResetService implements IPasswordResetService {

    private final IUserDAO userDAO;
    private final IEmailVerificationDAO evDAO;

    public PasswordResetService() {
        this.userDAO = new UserDAO();
        this.evDAO = new EmailVerificationDAO();
    }

    @Override
    public RequestStatus requestPasswordReset(String email, String appUrl) {
        User user = userDAO.findByEmail(email);
        if (user == null) {
            return RequestStatus.USER_NOT_FOUND;
        }

        String token = UUID.randomUUID().toString();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(30);

        boolean tokenSaved = evDAO.saveToken(user.getUserId(), token, expiresAt);
        if (!tokenSaved) {
            return RequestStatus.MAIL_ERROR;
        }

        String resetLink = appUrl + "/reset?token=" + token;
        String html = "<div style='font-family:Poppins, sans-serif'>"
                + "<h3>Xin chào " + (user.getFullname() != null ? user.getFullname() : user.getEmail()) + ",</h3>"
                + "<p>Bạn vừa yêu cầu đặt lại mật khẩu cho tài khoản AISTHÉA.</p>"
                + "<p>Nhấn vào liên kết dưới đây để đặt lại mật khẩu (hạn trong 30 phút):</p>"
                + "<p><a href='" + resetLink
                + "' style='background:#004c99;color:#fff;padding:8px 12px;border-radius:6px;text-decoration:none;'>Đặt lại mật khẩu</a></p>"
                + "<p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>"
                + "</div>";

        boolean mailSent = MailUtil.sendMail(email, "AISTHÉA - Đặt lại mật khẩu", html);
        if (!mailSent) {
            return RequestStatus.MAIL_ERROR;
        }

        return RequestStatus.SUCCESS;
    }

    @Override
    public ResetStatus performPasswordReset(String token, String newPassword) {
        EmailVerification ev = evDAO.findByToken(token);

        if (ev == null || ev.isVerified()) {
            return ResetStatus.TOKEN_INVALID;
        }

        if (ev.getExpiresAt() != null && ev.getExpiresAt().isBefore(LocalDateTime.now())) {
            return ResetStatus.TOKEN_EXPIRED;
        }

        String hashedPassword = BCryptUtil.hashPassword(newPassword);

        boolean passwordUpdated;
        try {
            passwordUpdated = userDAO.updatePassword(ev.getUserId(), hashedPassword);
        } catch (SQLException e) {
            e.printStackTrace();
            passwordUpdated = false;
        }

        if (!passwordUpdated) {
            return ResetStatus.UPDATE_FAILED;
        }

        evDAO.markVerified(token);
        return ResetStatus.SUCCESS;
    }
}

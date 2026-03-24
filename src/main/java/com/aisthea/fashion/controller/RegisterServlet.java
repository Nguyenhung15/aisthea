package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import com.aisthea.fashion.config.EmailConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = request.getParameter("email");
            String fullname = request.getParameter("fullname");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");

            if (email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || fullname == null || fullname.trim().isEmpty()) {

                request.setAttribute("registerError", "Vui lòng nhập đầy đủ email, họ tên và mật khẩu.");
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
                return;
            }

            User newUser = new User();
            newUser.setEmail(email.trim());
            newUser.setFullname(fullname.trim());
            newUser.setPassword(password);
            newUser.setGender(gender);
            newUser.setPhone(phone);
            // Avatar will be null by default - user can upload later

            try {
                userService.registerUser(newUser);

                String subject = "Kích hoạt tài khoản AISTHEA";
                // Tự động xây dựng URL từ request - không cần hardcode IP nữa
                String baseUrl = request.getScheme() + "://" +
                        request.getServerName() + ":" +
                        request.getServerPort() +
                        request.getContextPath();
                String activateLink = baseUrl + "/activate?email=" + email;
                String html = "<html><body>"
                        + "<h2>Chào " + fullname + "!</h2>"
                        + "<p>Bạn đã đăng ký tài khoản tại <b>AISTHEA FASHION</b>.</p>"
                        + "<p>Vui lòng nhấn vào nút bên dưới để kích hoạt tài khoản:</p>"
                        + "<a href='" + activateLink
                        + "' style='background:#4CAF50;color:white;padding:10px 15px;text-decoration:none;border-radius:5px;'>Kích hoạt ngay</a>"
                        + "<p>Nếu bạn không đăng ký, vui lòng bỏ qua email này.</p>"
                        + "</body></html>";

                EmailConfig.sendMail(email, subject, html,
                        EmailConfig.TYPE_REGISTER, 0);
                request.setAttribute("message",
                        "Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.");
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);

            } catch (com.aisthea.fashion.exception.BusinessException e) {
                request.setAttribute("registerError", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            } catch (com.aisthea.fashion.exception.DatabaseException e) {
                request.setAttribute("registerError", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("registerError", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("registerError", "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
        }
    }
}

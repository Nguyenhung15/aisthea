package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import com.aisthea.fashion.utils.MailUtil;
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
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
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
            String address = request.getParameter("address");

            if (email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || fullname == null || fullname.trim().isEmpty()) {

                request.setAttribute("error", "Vui lòng nhập đầy đủ email, họ tên và mật khẩu.");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                return;
            }

            User newUser = new User();
            newUser.setEmail(email.trim());
            newUser.setFullname(fullname.trim());
            newUser.setPassword(password);
            newUser.setGender(gender);
            newUser.setPhone(phone);
            newUser.setAddress(address);
            // Avatar will be null by default - user can upload later

            String result = userService.registerUser(newUser);

            switch (result) {
                case "SUCCESS":
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

                    MailUtil.sendMail(email, subject, html);
                    request.setAttribute("message",
                            "Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.");
                    request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
                    break;

                case "EMAIL_EXISTS":
                    request.setAttribute("error", "Đăng ký thất bại! Email này đã được sử dụng.");
                    request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                    break;

                case "USERNAME_EXISTS":
                    request.setAttribute("error", "Đăng ký thất bại! Tên đăng nhập (email) này đã tồn tại.");
                    request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                    break;

                case "DB_ERROR":
                case "SYSTEM_ERROR":
                default:
                    request.setAttribute("error", "Đăng ký thất bại! Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.");
                    request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }
}

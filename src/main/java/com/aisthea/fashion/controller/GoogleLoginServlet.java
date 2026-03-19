package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.UserDAO;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import com.aisthea.fashion.config.GoogleConfig;
import com.aisthea.fashion.util.BCryptUtil;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GoogleLoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GoogleLoginServlet.class.getName());
    private IUserService userService;
    private UserDAO userDAO;

    @Override
    public void init() {
        userService = new UserService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String credential = request.getParameter("credential");

        if (credential == null || credential.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login?error=Google+login+failed");
            return;
        }

        try {
            String clientId = GoogleConfig.getClientId();
            // Verify the Google ID token
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(),
                    new GsonFactory())
                    .setAudience(Collections.singletonList(clientId))
                    .build();

            GoogleIdToken idToken = verifier.verify(credential);

            if (idToken == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=Invalid+Google+Token");
                return;
            }

            GoogleIdToken.Payload payload = idToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            String pictureUrl = (String) payload.get("picture");

            // Check if user already exists by email
            User user = userService.getUserByEmail(email);

            if (user == null) {
                // New user – register them via Google
                user = new User();
                user.setEmail(email);
                user.setFullname(name != null ? name : email);
                user.setUsername(email);
                user.setAvatar(pictureUrl != null ? pictureUrl : "images/ava_default.png");
                user.setRole("USER");
                // Hash a random password since this is a Google OAuth user
                String randomPassword = UUID.randomUUID().toString();
                user.setPassword(BCryptUtil.hashPassword(randomPassword));
                user.setActive(true); // Google already verified the email

                try {
                    userDAO.insertUser(user);
                    // Activate immediately (since Google verified the email)
                    userService.activateUser(email);
                    // Reload to get the assigned userId
                    user = userService.getUserByEmail(email);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Failed to insert Google user into DB", e);
                    request.setAttribute("error",
                            "Đăng ký tài khoản Google thất bại. Vui lòng thử lại. (" + e.getMessage() + ")");
                    request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
                    return;
                }
            } else {
                // Existing user – auto-activate if not yet active (Google verified email)
                if (!user.isActive()) {
                    userService.activateUser(email);
                    user.setActive(true);
                }
            }

            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during Google login", e);
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
        }
    }
}

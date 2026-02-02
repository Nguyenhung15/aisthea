package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
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
import java.util.Collections;
import java.util.UUID;

public class GoogleLoginServlet extends HttpServlet {

    private static final String CLIENT_ID = "149895780747-i2o54c2tbv6vhg5kb71k8kfnd3n12jrj.apps.googleusercontent.com";
    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the ID token from the request
        String credential = request.getParameter("credential");

        if (credential == null || credential.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/user/login.jsp?error=Google login failed");
            return;
        }

        try {
            // 2. Verify the ID token
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(),
                    new GsonFactory())
                    .setAudience(Collections.singletonList(CLIENT_ID))
                    .build();

            GoogleIdToken idToken = verifier.verify(credential);

            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();

                // 3. Extract user info
                String email = payload.getEmail();
                String name = (String) payload.get("name");
                String pictureUrl = (String) payload.get("picture");

                // 4. Check if user exists
                User user = userService.getUserByEmail(email);

                if (user == null) {
                    // Register new user
                    user = new User();
                    user.setEmail(email);
                    user.setFullname(name);
                    user.setUsername(email); // Use email as username
                    user.setAvatar(pictureUrl != null ? pictureUrl : "images/ava_default.png");
                    user.setRole("USER");
                    // Generate a random password since they use Google
                    user.setPassword(UUID.randomUUID().toString());

                    // Register
                    String result = userService.registerUser(user);

                    if ("SUCCESS".equals(result)) {
                        // Auto activate
                        userService.activateUser(email);
                        // Reload user to get ID and correct state
                        user = userService.getUserByEmail(email);
                    } else {
                        request.setAttribute("error", "Failed to register Google user: " + result);
                        request.getRequestDispatcher("/views/user/login.jsp").forward(request, response);
                        return;
                    }
                } else {
                    // existing user, check if active?
                    if (!user.isActive()) {
                        // Assuming Google Login verifies email, we can auto-activate?
                        // Or require email activation.
                        // Let's auto-activate for better UX since Google verified the email.
                        userService.activateUser(email);
                        user.setActive(true);
                    }
                }

                // 5. Create Session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/views/homepage.jsp");

            } else {
                response.sendRedirect(request.getContextPath() + "/views/user/login.jsp?error=Invalid Google Token");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/user/login.jsp?error=System Error");
        }
    }
}

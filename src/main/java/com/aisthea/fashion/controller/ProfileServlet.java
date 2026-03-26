package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import com.aisthea.fashion.util.Constants;
import com.aisthea.fashion.util.ImageUploadHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles user profile viewing and updating, including avatar upload.
 *
 * <p>Avatar files are stored in {@code UPLOAD_DIR/avatars/} and served by
 * {@code ImageServlet} at {@code /uploads/avatars/{filename}}.
 * They are referenced in the DB as {@code "avatars/uuid.ext"}.
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB — spool to disk above this
    maxFileSize       = 5L * 1024 * 1024,   // 5 MB max
    maxRequestSize    = 10L * 1024 * 1024   // 10 MB total
)
@WebServlet(name = "ProfileServlet", urlPatterns = { "/profile", "/updateProfile" })
public class ProfileServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(ProfileServlet.class.getName());

    /** Sub-directory name inside UPLOAD_DIR for avatar files. */
    private static final String AVATAR_SUBDIR = "avatars";

    /** Default avatar stored in DB for new accounts. */
    private static final String DEFAULT_AVATAR = "images/ava_default.png";

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    // ─── GET: show profile page ───────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Refresh session user from DB so profile always shows latest data
        try {
            User user  = (User) session.getAttribute("user");
            User fresh = new com.aisthea.fashion.dao.UserDAO().selectUser(user.getUserId());
            if (fresh != null) {
                fresh.setPassword(null);
                session.setAttribute("user", fresh);
            }
        } catch (Exception e) {
            logger.warning("Could not refresh session user: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }

    // ─── POST: update profile ─────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ── Basic fields ─────────────────────────────────────────────────────
        user.setFullname(request.getParameter("fullname"));
        user.setEmail(request.getParameter("email"));
        user.setGender(request.getParameter("gender"));

        String phone = request.getParameter("phone");
        if (phone != null && !phone.isBlank()) {
            if (!phone.trim().matches("^[0-9]{10}$")) {
                response.sendRedirect(request.getContextPath() + "/profile?error=invalid_phone");
                return;
            }
            user.setPhone(phone.trim());
        } else {
            user.setPhone(null);
        }

        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.isBlank()) {
            try {
                user.setDob(java.sql.Date.valueOf(dobStr));
            } catch (IllegalArgumentException e) {
                logger.warning("Invalid DOB from user " + user.getUserId() + ": " + dobStr);
                // Keep existing DOB — do not null it on bad input
            }
        }

        // ── Avatar upload ─────────────────────────────────────────────────────
        try {
            String uploaded = ImageUploadHelper.save(request.getPart("avatar"), AVATAR_SUBDIR);
            if (uploaded != null) {
                // Delete old avatar file (skip default and external http URLs)
                String oldAvatar = user.getAvatar();
                if (oldAvatar != null && !oldAvatar.isBlank()
                        && !oldAvatar.equals(DEFAULT_AVATAR)
                        && !oldAvatar.startsWith("http")) {
                    try {
                        Files.deleteIfExists(Paths.get(Constants.UPLOAD_DIR, oldAvatar));
                    } catch (Exception ex) {
                        logger.warning("Could not delete old avatar: " + oldAvatar + " — " + ex.getMessage());
                    }
                }
                user.setAvatar(uploaded);
            }
        } catch (Exception e) {
            logger.log(Level.WARNING, "Avatar upload failed for user " + user.getUserId(), e);
        }

        // ── Persist ───────────────────────────────────────────────────────────
        boolean success = false;
        try {
            success = userService.updateUser(user);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to update user " + user.getUserId(), e);
        }

        if (success) {
            user.setPassword(null);
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/profile?success=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
        }
    }
}

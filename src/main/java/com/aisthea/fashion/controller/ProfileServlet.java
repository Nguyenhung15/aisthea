package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import com.aisthea.fashion.util.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles user profile viewing and updating, including avatar upload.
 *
 * <p>Uses NIO {@link Files#copy} instead of {@code Part.write()} to reliably
 * write uploaded files to an absolute path regardless of Tomcat's temp-dir
 * configuration.
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB — spool to disk above this
    maxFileSize       = 5L * 1024 * 1024, // 5 MB max per file
    maxRequestSize    = 10L * 1024 * 1024 // 10 MB max per request
)
@WebServlet(name = "ProfileServlet", urlPatterns = { "/profile" })
public class ProfileServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(ProfileServlet.class.getName());

    /** Allowed avatar file extensions (whitelist). */
    private static final Set<String> ALLOWED_EXTS = Set.of(".jpg", ".jpeg", ".png", ".gif", ".webp");

    /** Subfolder inside UPLOAD_DIR where avatar files are stored. */
    private static final String AVATAR_SUBDIR = "avatars";

    /** Default avatar path stored in DB for new / reset accounts. */
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

        // Refresh session user from DB so profile shows the latest data
        try {
            User user = (User) session.getAttribute("user");
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
        if (phone != null && !phone.trim().isEmpty()) {
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
                logger.warning("Invalid DOB format from user " + user.getUserId() + ": " + dobStr);
                // Keep existing DOB — do not null it on bad input
            }
        }
        // If dobStr is blank, keep whatever DOB is already on the user object.

        // ── Avatar upload ─────────────────────────────────────────────────────
        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            String submittedName = filePart.getSubmittedFileName();
            if (submittedName != null && !submittedName.isBlank()) {

                String originalName = Paths.get(submittedName).getFileName().toString();
                String ext = "";
                int dot = originalName.lastIndexOf('.');
                if (dot >= 0) ext = originalName.substring(dot).toLowerCase();

                if (!ALLOWED_EXTS.contains(ext)) {
                    logger.warning("Avatar upload rejected (extension '" + ext + "') for user " + user.getUserId());
                    response.sendRedirect(request.getContextPath() + "/profile?error=invalid_file_type");
                    return;
                }

                // Resolve and ensure avatar directory exists
                Path avatarDir = Paths.get(Constants.UPLOAD_DIR, AVATAR_SUBDIR);
                if (!Files.exists(avatarDir)) {
                    Files.createDirectories(avatarDir);
                    logger.info("Created avatar directory: " + avatarDir);
                }

                // Delete old avatar (skip default and external URLs)
                String oldAvatar = user.getAvatar();
                if (oldAvatar != null && !oldAvatar.isBlank()
                        && !oldAvatar.equals(DEFAULT_AVATAR)
                        && !oldAvatar.startsWith("http")) {
                    // Old avatars may be stored as "avatars/filename.jpg" or just "filename.jpg"
                    Path oldPath = Paths.get(Constants.UPLOAD_DIR, oldAvatar);
                    try {
                        Files.deleteIfExists(oldPath);
                    } catch (Exception e) {
                        logger.warning("Could not delete old avatar: " + oldPath + " -> " + e.getMessage());
                    }
                }

                // Save new avatar with UUID to prevent filename collisions
                String savedName = UUID.randomUUID().toString() + ext;
                Path targetPath = avatarDir.resolve(savedName);

                try (InputStream is = filePart.getInputStream()) {
                    Files.copy(is, targetPath, StandardCopyOption.REPLACE_EXISTING);
                    logger.info("Avatar saved: " + targetPath + " for user " + user.getUserId());
                }

                // Store as relative path "avatars/uuid.ext" in DB
                user.setAvatar(AVATAR_SUBDIR + "/" + savedName);
            }
        }

        // ── Persist changes ───────────────────────────────────────────────────
        boolean success = false;
        try {
            success = userService.updateUser(user);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to update user profile: " + user.getUserId(), e);
        }

        if (success) {
            // Refresh session with latest data
            user.setPassword(null);
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/profile?success=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
        }
    }
}

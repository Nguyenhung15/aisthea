package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class ProfileServlet extends HttpServlet {

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String jspPath = "/views/user/profile.jsp";

        request.getRequestDispatcher(jspPath).forward(request, response);
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

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        user.setFullname(fullname);
        user.setEmail(email);
        user.setGender(gender);
        user.setPhone(phone);
        user.setAddress(address);

        Part filePart = request.getPart("avatar");
        String oldAvatar = user.getAvatar();

        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = request.getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String defaultAvatarPath = "images/ava_default.png";

            if (oldAvatar != null && !oldAvatar.isEmpty() && !oldAvatar.equals(defaultAvatarPath)) {
                File oldFile = new File(uploadPath, oldAvatar);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            String fileName = new File(filePart.getSubmittedFileName()).getName();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

            filePart.write(uploadPath + File.separator + uniqueFileName);

            user.setAvatar(uniqueFileName);
        }

        boolean success = false;
        try {
            success = userService.updateUser(user);
        } catch (Exception e) {
            e.printStackTrace();
        }

        String redirectPath = "views/user/profile.jsp";

        if (success) {
            session.setAttribute("user", user);
            response.sendRedirect(redirectPath + "?success=true");
        } else {
            response.sendRedirect(redirectPath + "?error=true");
        }
    }
}

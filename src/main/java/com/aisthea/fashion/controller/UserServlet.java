package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IUserService;
import com.aisthea.fashion.service.UserService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class UserServlet extends HttpServlet {

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                case "toggleStatus":
                    toggleUserStatus(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            try {
                updateUser(request, response);
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            doGet(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userService.selectAllUsers();
        request.setAttribute("users", users);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/user/manage_users.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userService.selectUser(id);
        request.setAttribute("user", user);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/user/edit_user.jsp");
        dispatcher.forward(request, response);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int id = Integer.parseInt(request.getParameter("id"));
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        boolean active = "1".equals(request.getParameter("active"));
        boolean isBanned = "1".equals(request.getParameter("isBanned"));

        User user = userService.selectUser(id);
        if (user == null) {
            response.sendRedirect("user?action=list");
            return;
        }

        user.setFullname(fullname);
        user.setEmail(email);
        user.setGender(gender);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRole(role);
        user.setActive(active);
        user.setBanned(isBanned);

        userService.updateUser(user);
        response.sendRedirect("user?action=list");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userService.deleteUser(id);
        response.sendRedirect("user?action=list");
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userService.selectUser(id);
            if (user != null) {
                boolean result = userService.toggleUserStatus(id);
                if (result) {
                    boolean nowBanned = !user.isBanned();
                    String action = nowBanned ? "BANNED" : "UNBANNED";
                    request.getSession().setAttribute("successMsg",
                            "Account for " + user.getFullname() + " has been " + action + " successfully.");
                    request.getSession().setAttribute("actionName", nowBanned ? "banned" : "unbanned");
                } else {
                    request.getSession().setAttribute("errorMsg",
                            "Unable to update status for " + user.getFullname() + ".");
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/user?action=list");
    }
}

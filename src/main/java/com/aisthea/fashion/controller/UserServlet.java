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
                case "unban":
                    unbanUser(request, response);
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
        try {
            switch (action == null ? "" : action) {
                case "update":
                    updateUser(request, response);
                    break;
                case "ban":
                    banUser(request, response);
                    break;
                default:
                    doGet(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
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
        String role = request.getParameter("role");
        boolean active = "1".equals(request.getParameter("active"));

        User user = userService.selectUser(id);
        if (user == null) {
            response.sendRedirect("user?action=list");
            return;
        }

        user.setFullname(fullname);
        user.setEmail(email);
        user.setGender(gender);
        user.setPhone(phone);
        user.setRole(role);
        user.setActive(active);

        userService.updateUser(user);
        response.sendRedirect("user?action=list");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean ok = userService.deleteUser(id);
        HttpSession session = request.getSession();
        if (ok) {
            session.setAttribute("successMsg", "Xóa tài khoản thành công.");
            session.setAttribute("actionName", "deleted");
        } else {
            session.setAttribute("errorMsg", "Không thể xóa: Tài khoản này đã có lịch sử giao dịch (đơn hàng). Vui lòng khóa tài khoản (Ban) thay vì xóa để đảm bảo toàn vẹn dữ liệu hệ thống.");
        }
        response.sendRedirect("user?action=list");
    }

    private void banUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String reason = request.getParameter("banReason");
        if (reason == null || reason.trim().isEmpty())
            reason = "Vi phạm điều khoản sử dụng.";
        boolean ok = userService.banUser(id, reason.trim());
        
        HttpSession session = request.getSession();
        if (ok) {
            session.setAttribute("successMsg", "Đã khóa tài khoản thành công.");
            session.setAttribute("actionName", "banned");
        } else {
            session.setAttribute("errorMsg", "Khóa tài khoản thất bại.");
        }
        response.sendRedirect("user?action=list");
    }

    private void unbanUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean ok = userService.unbanUser(id);
        
        HttpSession session = request.getSession();
        if (ok) {
            session.setAttribute("successMsg", "Đã mở khóa tài khoản thành công.");
            session.setAttribute("actionName", "unbanned");
        } else {
            session.setAttribute("errorMsg", "Mở khóa tài khoản thất bại.");
        }
        response.sendRedirect("user?action=list");
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User u = userService.selectUser(id);
        boolean wasBanned = (u != null) && u.isBanned();
        
        boolean ok = userService.toggleUserStatus(id);
        HttpSession session = request.getSession();
        if (ok) {
            if (wasBanned) {
                session.setAttribute("successMsg", "Đã mở khóa tài khoản.");
                session.setAttribute("actionName", "unbanned");
            } else {
                session.setAttribute("successMsg", "Đã khóa tài khoản.");
                session.setAttribute("actionName", "banned");
            }
        } else {
            session.setAttribute("errorMsg", "Lỗi thao tác trạng thái tài khoản.");
        }
        response.sendRedirect("user?action=list");
    }
}

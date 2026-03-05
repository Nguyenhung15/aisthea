package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.DBConnection;
import com.aisthea.fashion.dao.IUserDAO;
import com.aisthea.fashion.dao.UserDAO;
import com.aisthea.fashion.model.LoginResult;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.utils.BCryptUtil;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserService implements IUserService {

    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());

    private final IUserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    @Override
    public String registerUser(User user) {
        if (isEmailExist(user.getEmail())) {
            LOGGER.log(Level.WARNING, "Registration failed: Email already exists - {0}", user.getEmail());
            return "EMAIL_EXISTS";
        }

        user.setUsername(user.getEmail());

        if (isUsernameExist(user.getUsername())) {
            LOGGER.log(Level.WARNING, "Registration failed: Username (derived from email) already exists - {0}",
                    user.getUsername());
            return "USERNAME_EXISTS";
        }

        String hashedPassword = BCryptUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
        user.setRole("USER");

        try {
            userDAO.insertUser(user);
            return "SUCCESS";
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting user into DB", e);
            return "DB_ERROR";
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Hashing or other error", ex);
            return "SYSTEM_ERROR";
        }
    }

    @Override
    public LoginResult login(String email, String password) {
        // Step 1: Check DB connection first
        try (Connection testConn = DBConnection.getConnection()) {
            if (testConn == null) {
                System.err.println("❌ LOGIN: Database connection is NULL!");
                return new LoginResult(null, "Lỗi kết nối cơ sở dữ liệu. Vui lòng thử lại.", false);
            }
        } catch (Exception e) {
            System.err.println("❌ LOGIN: Database connection test failed: " + e.getMessage());
            return new LoginResult(null, "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage(), false);
        }

        // Step 2: Find user by email
        System.out.println("LOG: Looking up user with email=[" + email + "]");
        User user = userDAO.findByEmail(email);

        if (user == null) {
            System.out.println("LOG: findByEmail returned NULL for email=[" + email + "]");
            return new LoginResult(null, "Tài khoản không tồn tại.", false);
        }

        System.out.println("LOG: Found user: id=" + user.getUserId() + ", email=" + user.getEmail() + ", active="
                + user.isActive());

        // Step 3: Check password
        if (!BCryptUtil.checkPassword(password, user.getPassword())) {
            System.out.println("LOG: Password mismatch for email=[" + email + "]");
            return new LoginResult(null, "Sai mật khẩu. Vui lòng thử lại.", false);
        }

        // Step 4: Check activation & ban
        if (!user.isActive()) {
            return new LoginResult(null, "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email.", false);
        }
        if (user.isBanned()) {
            return new LoginResult(null, "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.", false);
        }

        // Step 5: Success
        user.setPassword(null);
        System.out.println("LOG: Login SUCCESS for email=[" + email + "]");
        return new LoginResult(user, "Đăng nhập thành công.", true);
    }

    @Override
    public boolean isEmailExist(String email) {
        return userDAO.findByEmail(email) != null;
    }

    private boolean isUsernameExist(String username) {
        return userDAO.findByUsername(username) != null;
    }

    @Override
    public User selectUser(int userId) {
        User user = userDAO.selectUser(userId);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public List<User> selectAllUsers() {
        return userDAO.selectAllUsers();
    }

    @Override
    public boolean updateUser(User user) {
        try {
            return userDAO.updateUser(user);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user profile", e);
            return false;
        }
    }

    @Override
    public boolean changePassword(int userId, String newPassword) {
        // This method is used for Reset Password (no old password check)
        String hashedPassword = BCryptUtil.hashPassword(newPassword);

        try {
            return userDAO.updatePassword(userId, hashedPassword);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error changing user password", e);
            return false;
        }
    }

    @Override
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        User user = userDAO.selectUser(userId);
        if (user == null) {
            return false;
        }

        // Verify old password
        if (!BCryptUtil.checkPassword(oldPassword, user.getPassword())) {
            return false;
        }

        return changePassword(userId, newPassword);
    }

    @Override
    public boolean deleteUser(int userId) {
        try {
            return userDAO.deleteUser(userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting user", e);
            return false;
        }
    }

    @Override
    public boolean activateUser(String email) {
        try {
            return userDAO.activateUserByEmail(email);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error activating user", e);
            return false;
        }
    }

    @Override
    public User getUserByEmail(String email) {
        User user = userDAO.findByEmail(email);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public boolean toggleUserStatus(int userId) {
        try {
            return userDAO.toggleUserStatus(userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error toggling user status", e);
            return false;
        }
    }
}

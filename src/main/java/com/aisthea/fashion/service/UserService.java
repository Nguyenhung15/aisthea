package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.IUserDAO;
import com.aisthea.fashion.dao.UserDAO;
import com.aisthea.fashion.model.LoginResult;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.util.BCryptUtil;
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
    public void registerUser(User user) throws Exception {
        if (isEmailExist(user.getEmail())) {
            LOGGER.log(Level.WARNING, "Registration failed: Email already exists - {0}", user.getEmail());
            throw new com.aisthea.fashion.exception.BusinessException("Email này đã được sử dụng.");
        }

        user.setUsername(user.getEmail());

        if (isUsernameExist(user.getUsername())) {
            LOGGER.log(Level.WARNING, "Registration failed: Username (derived from email) already exists - {0}",
                    user.getUsername());
            throw new com.aisthea.fashion.exception.BusinessException("Tên đăng nhập (email) này đã tồn tại.");
        }

        String hashedPassword = BCryptUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
        user.setRole("USER");

        try {
            userDAO.insertUser(user);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting user into DB: SQLState=" + e.getSQLState() + ", ErrorCode="
                    + e.getErrorCode() + ", Msg=" + e.getMessage(), e);
            throw new com.aisthea.fashion.exception.DatabaseException("Đăng ký thất bại! Đã xảy ra lỗi hệ thống cơ sở dữ liệu.", e);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Hashing or other error", ex);
            throw new Exception("Đăng ký thất bại! Đã xảy ra lỗi xử lý ngoại lệ.", ex);
        }
    }

    @Override
    public LoginResult login(String identifier, String password) {
        // Try to find by email first
        User user = userDAO.findByEmail(identifier);
        
        // If not found by email, try to find by username
        if (user == null) {
            user = userDAO.findByUsername(identifier);
        }

        if (user == null) {
            return new LoginResult(null, "Tài khoản không tồn tại.", false);
        }

        if (!BCryptUtil.checkPassword(password, user.getPassword())) {
            return new LoginResult(null, "Sai mật khẩu. Vui lòng thử lại.", false);
        }

        if (!user.isActive()) {
            return new LoginResult(null, "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email.", false);
        }

        if (user.isBanned()) {
            String reason = user.getBanReason() != null ? user.getBanReason() : "Vi phạm điều khoản sử dụng.";
            return new LoginResult(null, "Tài khoản của bạn đã bị khóa. Lý do: " + reason, false);
        }

        user.setPassword(null);
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
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error toggling user status ID=" + userId, e);
            return false;
        }
    }

    @Override
    public boolean banUser(int userId, String reason) {
        try {
            return userDAO.banUser(userId, reason);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error banning user ID=" + userId, e);
            return false;
        }
    }

    @Override
    public boolean unbanUser(int userId) {
        try {
            return userDAO.unbanUser(userId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error unbanning user ID=" + userId, e);
            return false;
        }
    }
}

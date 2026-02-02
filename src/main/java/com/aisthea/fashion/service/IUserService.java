package com.aisthea.fashion.service;

import com.aisthea.fashion.model.LoginResult;
import com.aisthea.fashion.model.User;
import java.util.List;

public interface IUserService {

    String registerUser(User user);

    LoginResult login(String email, String password);

    boolean isEmailExist(String email);

    User selectUser(int userId);

    List<User> selectAllUsers();

    boolean updateUser(User user);

    boolean changePassword(int userId, String newPassword);

    boolean changePassword(int userId, String oldPassword, String newPassword);

    boolean deleteUser(int userId);

    boolean activateUser(String email);

    User getUserByEmail(String email);
}

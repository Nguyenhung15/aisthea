package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.User;
import java.sql.SQLException;
import java.util.List;

public interface IUserDAO {

    void insertUser(User user) throws SQLException;

    User selectUser(int id);

    User findByEmail(String email);

    User findByUsername(String username);

    List<User> selectAllUsers();

    boolean updateUser(User user) throws SQLException;

    boolean updatePassword(int userId, String hashedPassword) throws SQLException;

    boolean deleteUser(int id) throws SQLException;

    boolean activateUserByEmail(String email) throws SQLException;
}

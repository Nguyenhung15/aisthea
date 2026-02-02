package com.aisthea.fashion.model;

import com.aisthea.fashion.model.User;

public class LoginResult {

    private User user;
    private String message; // Để chứa "success" hoặc "tài khoản chưa kích hoạt"
    private boolean success;

    public LoginResult() {
    }

    public LoginResult(User user, String message, boolean success) {
        this.user = user;
        this.message = message;
        this.success = success;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

}

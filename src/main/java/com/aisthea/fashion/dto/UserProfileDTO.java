package com.aisthea.fashion.dto;

import com.aisthea.fashion.model.User;

/**
 * DTO for user profile information (safe to expose to frontend)
 * Does NOT include password or sensitive data
 */
public class UserProfileDTO {

    private int userId;
    private String username;
    private String fullname;
    private String email;
    private String gender;
    private String phone;
    private String role;
    private boolean active;
    private String avatar;

    public UserProfileDTO() {
    }

    public UserProfileDTO(User user) {
        if (user != null) {
            this.userId = user.getUserId();
            this.username = user.getUsername();
            this.fullname = user.getFullname();
            this.email = user.getEmail();
            this.gender = user.getGender();
            this.phone = user.getPhone();
            this.role = user.getRole();
            this.active = user.isActive();
            this.avatar = user.getAvatar();
        }
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
}

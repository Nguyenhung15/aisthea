package com.aisthea.fashion.validator;

import com.aisthea.fashion.config.SecurityConfig;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Validator for user-related input data
 */
public class UserValidator {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^0[0-9]{9}$" // Vietnamese phone number format
    );

    private static final Pattern USERNAME_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_]{3,20}$");

    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Validate phone number format
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone).matches();
    }

    /**
     * Validate username format
     */
    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username).matches();
    }

    /**
     * Validate password strength
     */
    public static List<String> validatePassword(String password) {
        List<String> errors = new ArrayList<>();

        if (password == null || password.isEmpty()) {
            errors.add("Mật khẩu không được để trống");
            return errors;
        }

        if (password.length() < SecurityConfig.MIN_PASSWORD_LENGTH) {
            errors.add("Mật khẩu phải có ít nhất " + SecurityConfig.MIN_PASSWORD_LENGTH + " ký tự");
        }

        if (password.length() > SecurityConfig.MAX_PASSWORD_LENGTH) {
            errors.add("Mật khẩu không được vượt quá " + SecurityConfig.MAX_PASSWORD_LENGTH + " ký tự");
        }

        // Check for at least one letter
        if (!password.matches(".*[a-zA-Z].*")) {
            errors.add("Mật khẩu phải chứa ít nhất một chữ cái");
        }

        // Check for at least one digit
        if (!password.matches(".*\\d.*")) {
            errors.add("Mật khẩu phải chứa ít nhất một số");
        }

        return errors;
    }

    /**
     * Validate registration data
     */
    public static List<String> validateRegistration(String email, String password, String confirmPassword,
            String fullName) {
        List<String> errors = new ArrayList<>();

        // Validate email
        if (!isValidEmail(email)) {
            errors.add("Email không hợp lệ");
        }

        // Validate password
        errors.addAll(validatePassword(password));

        // Confirm password match
        if (!password.equals(confirmPassword)) {
            errors.add("Mật khẩu xác nhận không khớp");
        }

        // Validate full name
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Họ tên không được để trống");
        } else if (fullName.trim().length() < 2) {
            errors.add("Họ tên phải có ít nhất 2 ký tự");
        }

        return errors;
    }

    private UserValidator() {
        // Private constructor to prevent instantiation
    }
}

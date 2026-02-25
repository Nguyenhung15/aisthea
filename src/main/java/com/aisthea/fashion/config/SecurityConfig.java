package com.aisthea.fashion.config;

/**
 * Security-related configuration constants
 */
public class SecurityConfig {

    // Password Configuration
    public static final int BCRYPT_ROUNDS = 12;
    public static final int MIN_PASSWORD_LENGTH = 8;
    public static final int MAX_PASSWORD_LENGTH = 100;

    // Token Configuration
    public static final int TOKEN_EXPIRY_HOURS = 24;
    public static final int VERIFICATION_TOKEN_LENGTH = 32;

    // Public URLs (no authentication required)
    public static final String[] PUBLIC_URLS = {
            "/login",
            "/register",
            "/forgot-password",
            "/reset-password",
            "/activate",
            "/google-login",
            "/assets/*",
            "/uploads/*"
    };

    // Admin URLs (require admin role)
    public static final String[] ADMIN_URLS = {
            "/admin/*",
            "/dashboard",
            "/category",
            "/user"
    };

    private SecurityConfig() {
        // Private constructor to prevent instantiation
    }
}

package com.aisthea.fashion.config;

/**
 * Security-related configuration.
 * Dynamically loads ALL values (including URL whitelists) from application.properties via AppConfig.
 */
public class SecurityConfig {

    // ─── Password Configuration ──────────────────────────────────────────────
    public static int getBcryptRounds() {
        return AppConfig.getPropertyAsInt("security.password.bcrypt.cost", 12);
    }
    
    public static int getMinPasswordLength() {
        return AppConfig.getPropertyAsInt("security.password.min.length", 8);
    }
    
    public static int getMaxPasswordLength() {
        return AppConfig.getPropertyAsInt("security.password.max.length", 100);
    }

    // ─── Token Configuration ─────────────────────────────────────────────────
    public static int getTokenExpiryHours() {
        return AppConfig.getPropertyAsInt("security.token.verify.expiry", 24);
    }
    
    public static int getTokenExpiryMinutes() {
        return AppConfig.getPropertyAsInt("security.token.reset.expiry", 30);
    }
    
    public static int getVerificationTokenLength() {
        return AppConfig.getPropertyAsInt("security.token.verify.length", 32);
    }

    // ─── URL Access Control (Dynamic Whitelists) ─────────────────────────────
    
    /**
     * Get the list of Public URLs that don't require authentication
     */
    public static String[] getPublicUrls() {
        String urls = AppConfig.getProperty("security.urls.public", 
                "/login,/register,/forgot-password,/reset-password,/activate,/google-login,/assets/*,/uploads/*");
        return urls.split(",");
    }

    /**
     * Get the list of Admin URLs that require ADMIN role
     */
    public static String[] getAdminUrls() {
        String urls = AppConfig.getProperty("security.urls.admin", 
                "/admin/*,/dashboard,/category,/user");
        return urls.split(",");
    }

    private SecurityConfig() {
        // Utility class
    }
}

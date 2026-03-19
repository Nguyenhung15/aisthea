package com.aisthea.fashion.config;

/**
 * Handles Google OAuth configuration.
 * All credentials are read from application.properties via AppConfig.
 */
public class GoogleConfig {

    /**
     * Get the Google Client ID
     */
    public static String getClientId() {
        return AppConfig.getProperty("google.client.id", "");
    }

    /**
     * Get the Google Client Secret
     */
    public static String getClientSecret() {
        return AppConfig.getProperty("google.client.secret", "");
    }

    /**
     * Get the Google Redirect URI
     */
    public static String getRedirectUri() {
        return AppConfig.getProperty("google.redirect.uri", "http://localhost:8080/FashionProject/google-login");
    }
}

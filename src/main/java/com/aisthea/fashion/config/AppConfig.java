package com.aisthea.fashion.config;

/**
 * Application-wide configuration constants
 */
public class AppConfig {

    // Database Configuration
    public static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=FashionDB;encrypt=true;trustServerCertificate=true";
    public static final String DB_USER = "sa";
    public static final String DB_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    // File Upload Configuration
    public static final String UPLOAD_DIR = "/uploads";
    public static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    public static final String[] ALLOWED_IMAGE_TYPES = { "jpg", "jpeg", "png", "gif", "webp" };

    // Pagination
    public static final int PRODUCTS_PER_PAGE = 12;
    public static final int ORDERS_PER_PAGE = 10;
    public static final int ADMIN_ITEMS_PER_PAGE = 20;

    // Session Configuration
    public static final int SESSION_TIMEOUT_MINUTES = 30;
    public static final String SESSION_USER_KEY = "user";
    public static final String SESSION_CART_KEY = "cart";

    // Application Info
    public static final String APP_NAME = "AISTHÉA Fashion";
    public static final String APP_VERSION = "1.0.0";

    private AppConfig() {
        // Private constructor to prevent instantiation
    }
}

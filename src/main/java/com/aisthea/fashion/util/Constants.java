package com.aisthea.fashion.util;

/**
 * Application Constants
 */
public class Constants {

    // User Roles
    public static final String ROLE_ADMIN = "admin";
    public static final String ROLE_USER = "user";
    public static final String ROLE_STAFF = "staff";

    // Session Attributes
    public static final String SESSION_USER = "user";
    public static final String SESSION_CART = "cart";
    public static final String SESSION_MESSAGE = "message";
    public static final String SESSION_ERROR = "error";

    // Request Attributes
    public static final String ATTR_ERROR_MESSAGE = "errorMessage";
    public static final String ATTR_SUCCESS_MESSAGE = "successMessage";
    public static final String ATTR_USER = "user";
    public static final String ATTR_PRODUCTS = "products";
    public static final String ATTR_CATEGORIES = "categories";

    // Email Subjects
    public static final String EMAIL_SUBJECT_ACTIVATION = "Kích hoạt tài khoản AISTHEA";
    public static final String EMAIL_SUBJECT_PASSWORD_RESET = "AISTHÉA - Đặt lại mật khẩu";
    public static final String EMAIL_SUBJECT_ORDER_CONFIRMATION = "Xác nhận đơn hàng";

    // Order Status
    public static final String ORDER_STATUS_PENDING = "PENDING";
    public static final String ORDER_STATUS_PROCESSING = "PROCESSING";
    public static final String ORDER_STATUS_SHIPPED = "SHIPPED";
    public static final String ORDER_STATUS_DELIVERED = "DELIVERED";
    public static final String ORDER_STATUS_CANCELLED = "CANCELLED";

    // Payment Methods
    public static final String PAYMENT_COD = "COD";
    public static final String PAYMENT_BANK_TRANSFER = "BANK_TRANSFER";
    public static final String PAYMENT_CREDIT_CARD = "CREDIT_CARD";

    // Product Status
    public static final String PRODUCT_STATUS_ACTIVE = "ACTIVE";
    public static final String PRODUCT_STATUS_INACTIVE = "INACTIVE";
    public static final String PRODUCT_STATUS_OUT_OF_STOCK = "OUT_OF_STOCK";

    // Gender
    public static final String GENDER_MALE = "Nam";
    public static final String GENDER_FEMALE = "Nữ";
    public static final String GENDER_UNISEX = "Unisex";

    // File Upload
    public static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    public static final String[] ALLOWED_IMAGE_EXTENSIONS = { "jpg", "jpeg", "png", "gif" };

    // Pagination
    public static final int DEFAULT_PAGE_SIZE = 12;
    public static final int DEFAULT_PAGE_NUMBER = 1;

    // Validation
    public static final int MIN_PASSWORD_LENGTH = 6;
    public static final int MAX_PASSWORD_LENGTH = 50;
    public static final int MIN_USERNAME_LENGTH = 3;
    public static final int MAX_USERNAME_LENGTH = 50;

    // Date Formats
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    public static final String DISPLAY_DATE_FORMAT = "dd/MM/yyyy";
    public static final String DISPLAY_DATETIME_FORMAT = "dd/MM/yyyy HH:mm";

    // Error Codes
    public static final String ERR_USER_NOT_FOUND = "ERR_USER_001";
    public static final String ERR_INVALID_CREDENTIALS = "ERR_USER_002";
    public static final String ERR_EMAIL_EXISTS = "ERR_USER_003";
    public static final String ERR_PRODUCT_NOT_FOUND = "ERR_PROD_001";
    public static final String ERR_INSUFFICIENT_STOCK = "ERR_PROD_002";
    public static final String ERR_ORDER_NOT_FOUND = "ERR_ORD_001";

    // Regex Patterns
    public static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@(.+)$";
    public static final String PHONE_PATTERN = "^[0-9]{10,11}$";

    private Constants() {
        // Prevent instantiation
        throw new IllegalStateException("Utility class");
    }
}

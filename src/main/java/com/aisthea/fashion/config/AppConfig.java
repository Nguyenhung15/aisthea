package com.aisthea.fashion.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Application Configuration Manager
 * Loads configuration from application.properties and environment-specific
 * files
 */
public class AppConfig {
    private static final Logger logger = LoggerFactory.getLogger(AppConfig.class);
    private static Properties properties;
    private static final String DEFAULT_CONFIG = "application.properties";

    static {
        loadConfiguration();
    }

    /**
     * Load configuration from properties file
     */
    private static void loadConfiguration() {
        properties = new Properties();

        try {
            // Load default configuration
            loadPropertiesFile(DEFAULT_CONFIG);

            // Load environment-specific configuration if available
            String environment = System.getProperty("app.environment", "development");
            String envConfig = "application-" + environment + ".properties";

            try {
                loadPropertiesFile(envConfig);
                logger.info("✅ Loaded environment-specific configuration: {}", envConfig);
            } catch (IOException e) {
                logger.info("No environment-specific configuration found for: {}", environment);
            }

            // Override with system properties (e.g., -Ddb.password=xxx)
            properties.putAll(System.getProperties());

            logger.info("✅ Application configuration loaded successfully");

        } catch (IOException e) {
            logger.error("❌ Failed to load application configuration", e);
            throw new RuntimeException("Failed to load application configuration", e);
        }
    }

    /**
     * Load properties from file
     */
    private static void loadPropertiesFile(String filename) throws IOException {
        try (InputStream input = AppConfig.class.getClassLoader().getResourceAsStream(filename)) {
            if (input == null) {
                throw new IOException("Unable to find " + filename);
            }
            properties.load(input);
        }
    }

    /**
     * Get property value
     */
    public static String getProperty(String key) {
        return properties.getProperty(key);
    }

    /**
     * Get property value with default
     */
    public static String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }

    /**
     * Get property as integer
     */
    public static int getPropertyAsInt(String key, int defaultValue) {
        String value = properties.getProperty(key);
        if (value != null) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                logger.warn("Invalid integer value for {}: {}", key, value);
            }
        }
        return defaultValue;
    }

    /**
     * Get property as boolean
     */
    public static boolean getPropertyAsBoolean(String key, boolean defaultValue) {
        String value = properties.getProperty(key);
        if (value != null) {
            return Boolean.parseBoolean(value);
        }
        return defaultValue;
    }

    /**
     * Get property as long
     */
    public static long getPropertyAsLong(String key, long defaultValue) {
        String value = properties.getProperty(key);
        if (value != null) {
            try {
                return Long.parseLong(value);
            } catch (NumberFormatException e) {
                logger.warn("Invalid long value for {}: {}", key, value);
            }
        }
        return defaultValue;
    }

    /**
     * Check if property exists
     */
    public static boolean hasProperty(String key) {
        return properties.containsKey(key);
    }

    /**
     * Get all properties
     */
    public static Properties getAllProperties() {
        return new Properties(properties);
    }

    // Convenience methods for common configurations

    public static String getEnvironment() {
        return getProperty("app.environment", "development");
    }

    public static String getAppName() {
        return getProperty("app.name", "AISTHEA Fashion");
    }

    public static String getAppVersion() {
        return getProperty("app.version", "1.0.0");
    }

    public static String getBaseUrl() {
        return getProperty("app.base.url", "http://localhost:8080/FashionProject");
    }

    public static String getUploadDir() {
        return getProperty("app.upload.dir", "uploads");
    }

    public static long getMaxUploadSize() {
        return getPropertyAsLong("app.max.upload.size", 10485760); // 10MB default
    }

    public static int getSessionTimeout() {
        return getPropertyAsInt("app.session.timeout", 30);
    }

    public static int getPasswordResetExpiration() {
        return getPropertyAsInt("app.password.reset.expiration", 30);
    }

    public static int getBcryptCost() {
        return getPropertyAsInt("app.bcrypt.cost", 12);
    }
}

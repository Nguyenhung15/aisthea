package com.aisthea.fashion.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Application-wide configuration constants and property accessor.
 * Reads from src/main/resources/application.properties at startup.
 * Supports ${ENV_VAR:defaultValue} placeholder syntax.
 */
public class AppConfig {

    // ─── Application Info ────────────────────────────────────────────────────
    public static final String APP_NAME    = "AISTHÉA Fashion";
    public static final String APP_VERSION = "1.0.0";
    
    // ─── Session Configuration ───────────────────────────────────────────────
    public static final String SESSION_USER_KEY = "user";
    public static final String SESSION_CART_KEY = "cart";
    public static final int SESSION_TIMEOUT_MIN = 30;

    // Pattern to match ${ENV_VAR:default} placeholders
    private static final Pattern PLACEHOLDER_PATTERN = Pattern.compile("\\$\\{([^}:]+)(?::([^}]*))?\\}");

    private static final Properties properties = new Properties();

    static {
        loadProperties();
    }

    private AppConfig() {
        // Utility class – prevent instantiation
    }

    // -----------------------------------------------------------------------
    // Property Loading
    // -----------------------------------------------------------------------

    private static void loadProperties() {
        try (InputStream input = AppConfig.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException e) {
            // Silently ignore – defaults will be used
        }
    }

    // -----------------------------------------------------------------------
    // Public Accessors
    // -----------------------------------------------------------------------

    /**
     * Get a property value by key.
     * Resolves ${ENV_VAR:default} placeholders automatically.
     */
    public static String getProperty(String key) {
        String raw = properties.getProperty(key);
        return raw != null ? resolvePlaceholder(raw) : null;
    }

    /**
     * Get a property value by key with fallback default value.
     */
    public static String getProperty(String key, String defaultValue) {
        String raw = properties.getProperty(key);
        if (raw == null) {
            return defaultValue;
        }
        String resolved = resolvePlaceholder(raw);
        return (resolved == null || resolved.isEmpty()) ? defaultValue : resolved;
    }

    /**
     * Get a property as int with fallback default value.
     */
    public static int getPropertyAsInt(String key, int defaultValue) {
        String value = getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Get a property as long with fallback default value.
     */
    public static long getPropertyAsLong(String key, long defaultValue) {
        String value = getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Long.parseLong(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Get current environment: development / staging / production.
     * Priority: system property "app.env" → env var "APP_ENV" → property file →
     * "production"
     */
    public static String getEnvironment() {
        String env = System.getProperty("app.env");
        if (env == null || env.isEmpty()) {
            env = System.getenv("APP_ENV");
        }
        if (env == null || env.isEmpty()) {
            env = getProperty("app.environment", "production");
        }
        return env;
    }

    // -----------------------------------------------------------------------
    // Internal Helpers
    // -----------------------------------------------------------------------

    /**
     * Resolve a single ${ENV_VAR:default} placeholder.
     * If the value contains no placeholder it is returned as-is.
     */
    private static String resolvePlaceholder(String value) {
        if (value == null) {
            return null;
        }
        Matcher matcher = PLACEHOLDER_PATTERN.matcher(value);
        if (!matcher.find()) {
            return value;
        }
        StringBuffer sb = new StringBuffer();
        matcher.reset();
        while (matcher.find()) {
            String envVarName = matcher.group(1);
            String envDefault = matcher.group(2); // may be null or empty

            String envValue = System.getenv(envVarName);
            if (envValue == null || envValue.isEmpty()) {
                envValue = System.getProperty(envVarName);
            }
            String replacement = (envValue != null && !envValue.isEmpty())
                    ? envValue
                    : (envDefault != null ? envDefault : "");
            matcher.appendReplacement(sb, Matcher.quoteReplacement(replacement));
        }
        matcher.appendTail(sb);
        return sb.toString();
    }
}

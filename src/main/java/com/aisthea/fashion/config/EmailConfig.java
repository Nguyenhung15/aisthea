package com.aisthea.fashion.config;

import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

/**
 * Email Configuration Manager
 * Provides configured JavaMail Session for sending emails
 */
public class EmailConfig {
    private static final Logger logger = LoggerFactory.getLogger(EmailConfig.class);
    private static Session mailSession;

    static {
        initializeMailSession();
    }

    /**
     * Initialize JavaMail Session
     */
    private static void initializeMailSession() {
        try {
            Properties props = new Properties();

            // SMTP Server settings
            props.put("mail.smtp.host", AppConfig.getProperty("mail.smtp.host"));
            props.put("mail.smtp.port", AppConfig.getProperty("mail.smtp.port"));
            props.put("mail.smtp.auth", AppConfig.getProperty("mail.smtp.auth", "true"));
            props.put("mail.smtp.starttls.enable",
                    AppConfig.getProperty("mail.smtp.starttls.enable", "true"));

            // SSL/TLS settings
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", "*");

            // Timeout settings
            props.put("mail.smtp.connectiontimeout", "5000");
            props.put("mail.smtp.timeout", "5000");
            props.put("mail.smtp.writetimeout", "5000");

            // Get credentials
            final String username = AppConfig.getProperty("mail.username", "");
            final String password = AppConfig.getProperty("mail.password", "");

            // Create session with authentication
            if (!username.isEmpty() && !password.isEmpty()) {
                mailSession = Session.getInstance(props, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });
                logger.info("✅ Email session initialized with authentication");
            } else {
                mailSession = Session.getInstance(props);
                logger.info("✅ Email session initialized without authentication (dev mode)");
            }

            // Enable debug mode in development
            if ("development".equals(AppConfig.getEnvironment())) {
                mailSession.setDebug(true);
            }

            logger.info("   - SMTP Host: {}", AppConfig.getProperty("mail.smtp.host"));
            logger.info("   - SMTP Port: {}", AppConfig.getProperty("mail.smtp.port"));
            logger.info("   - From Address: {}", getFromAddress());

        } catch (Exception e) {
            logger.error("❌ Failed to initialize email configuration", e);
            throw new RuntimeException("Failed to initialize email configuration", e);
        }
    }

    /**
     * Get configured mail session
     */
    public static Session getMailSession() {
        return mailSession;
    }

    /**
     * Get the configured 'from' email address
     */
    public static String getFromAddress() {
        return AppConfig.getProperty("mail.from", "noreply@aisthea.com");
    }

    /**
     * Get the configured 'from' name
     */
    public static String getFromName() {
        return AppConfig.getProperty("mail.from.name", "AISTHEA Fashion");
    }

    /**
     * Get SMTP host
     */
    public static String getSmtpHost() {
        return AppConfig.getProperty("mail.smtp.host");
    }

    /**
     * Get SMTP port
     */
    public static int getSmtpPort() {
        return AppConfig.getPropertyAsInt("mail.smtp.port", 587);
    }

    /**
     * Check if email is configured properly
     */
    public static boolean isConfigured() {
        String host = getSmtpHost();
        return host != null && !host.isEmpty();
    }

    /**
     * Get sender email (alias for getFromAddress)
     */
    public static String getSenderEmail() {
        return getFromAddress();
    }

    /**
     * Get sender name (alias for getFromName)
     */
    public static String getSenderName() {
        return getFromName();
    }
}

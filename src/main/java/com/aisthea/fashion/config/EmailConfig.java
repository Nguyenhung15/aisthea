package com.aisthea.fashion.config;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Properties;

/**
 * Combined Email Configuration and Utility Service.
 * Centralizes all SMTP settings and providing email sending methods.
 * All credentials are read dynamically from application.properties / environment variables via AppConfig.
 */
public class EmailConfig {
    private static final Logger logger = LoggerFactory.getLogger(EmailConfig.class);

    /**
     * Creates a Session using properties defined in application.properties
     */
    private static Session getSession() {
        Properties props = new Properties();
        
        // SMTP Settings from application.properties
        props.put("mail.smtp.host",             AppConfig.getProperty("mail.smtp.host",              "smtp.gmail.com"));
        props.put("mail.smtp.port",             AppConfig.getProperty("mail.smtp.port",              "587"));
        props.put("mail.smtp.auth",             AppConfig.getProperty("mail.smtp.auth",              "true"));
        props.put("mail.smtp.starttls.enable", AppConfig.getProperty("mail.smtp.starttls.enable", "true"));
        props.put("mail.smtp.ssl.trust",        AppConfig.getProperty("mail.smtp.host",              "smtp.gmail.com"));

        // Credentials from application.properties
        final String username = AppConfig.getProperty("mail.username", "");
        final String password = AppConfig.getProperty("mail.password", "");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
    }

    /**
     * Send an HTML email
     */
    public static boolean sendMail(String to, String subject, String htmlContent) {
        String from = AppConfig.getProperty("mail.username", "");
        String senderName = AppConfig.getProperty("mail.from.name", "AISTHEA Fashion");

        try {
            Session session = getSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, senderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            
            Transport.send(message);
            logger.info("✅ HTML Email sent successfully to: {}", to);
            return true;
        } catch (Exception e) {
            logger.error("❌ Failed to send HTML email to {}: {}", to, e.getMessage());
            return false;
        }
    }

    /**
     * Send a plain text email
     */
    public static boolean sendTextMail(String to, String subject, String textContent) {
        String from = AppConfig.getProperty("mail.username", "");
        String senderName = AppConfig.getProperty("mail.from.name", "AISTHEA Fashion");

        try {
            Session session = getSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, senderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(textContent);
            
            Transport.send(message);
            logger.info("✅ Text Email sent successfully to: {}", to);
            return true;
        } catch (Exception e) {
            logger.error("❌ Failed to send text email to {}: {}", to, e.getMessage());
            return false;
        }
    }
}

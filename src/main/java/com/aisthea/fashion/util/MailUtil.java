package com.aisthea.fashion.util;

import com.aisthea.fashion.config.EmailConfig;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Email utility for sending emails
 */
public class MailUtil {
    private static final Logger logger = LoggerFactory.getLogger(MailUtil.class);

    /**
     * Send an HTML email
     * 
     * @param to          Recipient email address
     * @param subject     Email subject
     * @param htmlContent HTML content of the email
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendMail(String to, String subject, String htmlContent) {
        try {
            Session session = EmailConfig.getMailSession();
            String from = EmailConfig.getSenderEmail();
            String senderName = EmailConfig.getSenderName();

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, senderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);

            logger.info("✅ Email sent successfully to: {}", to);
            return true;

        } catch (MessagingException e) {
            logger.error("❌ Failed to send email to {}: {}", to, e.getMessage(), e);
            return false;
        } catch (Exception e) {
            logger.error("❌ Unexpected error while sending email to {}: {}", to, e.getMessage(), e);
            return false;
        }
    }

    /**
     * Send a plain text email
     * 
     * @param to          Recipient email address
     * @param subject     Email subject
     * @param textContent Plain text content
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendTextMail(String to, String subject, String textContent) {
        try {
            Session session = EmailConfig.getMailSession();
            String from = EmailConfig.getSenderEmail();
            String senderName = EmailConfig.getSenderName();

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, senderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(textContent);

            Transport.send(message);

            logger.info("✅ Text email sent successfully to: {}", to);
            return true;

        } catch (Exception e) {
            logger.error("❌ Failed to send text email to {}: {}", to, e.getMessage(), e);
            return false;
        }
    }
}

package com.aisthea.fashion.config;

import com.aisthea.fashion.dao.EmailLogDAO;
import com.aisthea.fashion.model.EmailLog;
import jakarta.activation.DataHandler;
import jakarta.activation.FileDataSource;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.File;
import java.util.Map;
import java.util.Properties;

/**
 * Combined Email Configuration and Utility Service.
 * Centralizes all SMTP settings and provides email sending methods.
 * Automatically logs every send attempt to the emaillogs table in DB.
 * All credentials are read dynamically from application.properties via AppConfig.
 */
public class EmailConfig {
    private static final Logger logger = LoggerFactory.getLogger(EmailConfig.class);
    private static final EmailLogDAO emailLogDAO = new EmailLogDAO();

    // ─── Email Types ─────────────────────────────────────────────────────────
    public static final String TYPE_REGISTER       = "REGISTER";
    public static final String TYPE_PASSWORD_RESET = "PASSWORD_RESET";
    public static final String TYPE_ORDER_CONFIRM  = "ORDER_CONFIRM";
    public static final String TYPE_GENERAL        = "GENERAL";
    public static final String TYPE_PROMOTION      = "PROMOTION";

    // ─── Email Status ─────────────────────────────────────────────────────────
    public static final String STATUS_SENT   = "SENT";
    public static final String STATUS_FAILED = "FAILED";

    /**
     * Creates a Jakarta Mail Session from application.properties
     */
    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host",            AppConfig.getProperty("mail.smtp.host",             "smtp.gmail.com"));
        props.put("mail.smtp.port",            AppConfig.getProperty("mail.smtp.port",             "587"));
        props.put("mail.smtp.auth",            AppConfig.getProperty("mail.smtp.auth",             "true"));
        props.put("mail.smtp.starttls.enable", AppConfig.getProperty("mail.smtp.starttls.enable", "true"));
        props.put("mail.smtp.ssl.trust",       AppConfig.getProperty("mail.smtp.host",             "smtp.gmail.com"));

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
     * Send an HTML email and log the result to DB.
     *
     * @param to        recipient email
     * @param subject   email subject
     * @param html      HTML body content
     * @param emailType use EmailConfig.TYPE_* constants
     * @param userId    user ID linked to this email (0 if anonymous)
     * @return true if sent successfully
     */
    public static boolean sendMail(String to, String subject, String html, String emailType, int userId) {
        String from       = AppConfig.getProperty("mail.username", "");
        String senderName = AppConfig.getProperty("mail.from.name", "AISTHEA Fashion");
        boolean success   = false;

        try {
            Session session = getSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, senderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(html, "text/html; charset=UTF-8");
            Transport.send(message);
            logger.info("✅ Email [{}] sent to: {}", emailType, to);
            success = true;
        } catch (Exception e) {
            logger.error("❌ Failed to send email [{}] to {}: {}", emailType, to, e.getMessage());
        }

        // ─── Persist log to DB ────────────────────────────────────────────────
        EmailLog log = new EmailLog();
        log.setRecipientemail(to);
        log.setSubject(subject);
        log.setContent(html);
        log.setEmailtype(emailType != null ? emailType : TYPE_GENERAL);
        log.setStatus(success ? STATUS_SENT : STATUS_FAILED);
        log.setUserid(userId);
        emailLogDAO.save(log);

        return success;
    }

    /**
     * Convenience overload — sends HTML email without a userId (anonymous).
     */
    public static boolean sendMail(String to, String subject, String html) {
        return sendMail(to, subject, html, TYPE_GENERAL, 0);
    }

    /**
     * Convenience overload — sends plain text email.
     */
    public static boolean sendTextMail(String to, String subject, String text, String emailType, int userId) {
        String from       = AppConfig.getProperty("mail.username", "");
        String senderName = AppConfig.getProperty("mail.from.name", "AISTHEA Fashion");
        boolean success   = false;

        try {
            Session session = getSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, senderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(text);
            Transport.send(message);
            success = true;
        } catch (Exception e) {
            logger.error("❌ Failed to send text email to {}: {}", to, e.getMessage());
        }

        EmailLog log = new EmailLog();
        log.setRecipientemail(to);
        log.setSubject(subject);
        log.setContent(text);
        log.setEmailtype(emailType != null ? emailType : TYPE_GENERAL);
        log.setStatus(success ? STATUS_SENT : STATUS_FAILED);
        log.setUserid(userId);
        emailLogDAO.save(log);

        return success;
    }

    /**
     * Send an HTML email with inline (CID-embedded) images.
     * <p>
     * The HTML body should use {@code <img src="cid:KEY">} where KEY matches
     * a key in the {@code inlineImages} map.  The corresponding File is attached
     * inline so email clients display the image even when the server is not
     * publicly accessible (e.g. localhost).
     *
     * @param to           recipient email
     * @param subject      email subject
     * @param html         HTML body (use "cid:KEY" for inline images)
     * @param inlineImages map of contentId → local File (may be null or empty)
     * @param emailType    use EmailConfig.TYPE_* constants
     * @param userId       user ID linked to this email (0 if anonymous)
     * @return true if sent successfully
     */
    public static boolean sendMailWithInlineImages(String to, String subject, String html,
                                                    Map<String, File> inlineImages,
                                                    String emailType, int userId) {
        // If no inline images, fall back to simple send
        if (inlineImages == null || inlineImages.isEmpty()) {
            return sendMail(to, subject, html, emailType, userId);
        }

        String from       = AppConfig.getProperty("mail.username", "");
        String senderName = AppConfig.getProperty("mail.from.name", "AISTHEA Fashion");
        boolean success   = false;

        try {
            Session session = getSession();
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, senderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);

            // "related" multipart: HTML body + inline images bundled together
            MimeMultipart multipart = new MimeMultipart("related");

            // Part 1 — HTML body
            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(html, "text/html; charset=UTF-8");
            multipart.addBodyPart(htmlPart);

            // Part 2..N — Inline image attachments
            for (Map.Entry<String, File> entry : inlineImages.entrySet()) {
                File imgFile = entry.getValue();
                if (imgFile == null || !imgFile.exists()) continue;

                MimeBodyPart imagePart = new MimeBodyPart();
                FileDataSource fds = new FileDataSource(imgFile);
                imagePart.setDataHandler(new DataHandler(fds));
                imagePart.setHeader("Content-ID", "<" + entry.getKey() + ">");
                imagePart.setDisposition(MimeBodyPart.INLINE);
                imagePart.setFileName(imgFile.getName());
                multipart.addBodyPart(imagePart);
            }

            message.setContent(multipart);
            Transport.send(message);
            logger.info("✅ Email [{}] with {} inline image(s) sent to: {}",
                    emailType, inlineImages.size(), to);
            success = true;
        } catch (Exception e) {
            logger.error("❌ Failed to send email with inline images [{}] to {}: {}",
                    emailType, to, e.getMessage());
        }

        // ─── Persist log to DB ────────────────────────────────────────────────
        EmailLog log = new EmailLog();
        log.setRecipientemail(to);
        log.setSubject(subject);
        log.setContent(html);
        log.setEmailtype(emailType != null ? emailType : TYPE_GENERAL);
        log.setStatus(success ? STATUS_SENT : STATUS_FAILED);
        log.setUserid(userId);
        emailLogDAO.save(log);

        return success;
    }
}

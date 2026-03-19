package com.aisthea.fashion.controller;

import com.aisthea.fashion.config.EmailConfig;
import com.aisthea.fashion.dao.EmailLogDAO;
import com.aisthea.fashion.dao.IEmailLogDAO;
import com.aisthea.fashion.dao.UserDAO;
import com.aisthea.fashion.model.EmailLog;
import com.aisthea.fashion.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.Collectors;

/**
 * Admin Email Servlet — Email Management Hub.
 *
 * GET  /admin/emails → log table, filters, pagination, customer picker (name + email)
 * POST /admin/emails → send manual email to multiple recipients in PARALLEL
 */
@WebServlet("/admin/emails")
public class AdminEmailServlet extends HttpServlet {

    private static final int PAGE_SIZE    = 20;
    private static final int THREAD_POOL  = 10; // Max concurrent email sends

    private IEmailLogDAO emailLogDAO;
    private UserDAO      userDAO;
    private ExecutorService executor;

    // ─── Init / Destroy ──────────────────────────────────────────────────────

    @Override
    public void init() {
        emailLogDAO = new EmailLogDAO();
        userDAO     = new UserDAO();
        // Fixed thread pool: up to THREAD_POOL emails sent at the same time
        executor    = Executors.newFixedThreadPool(THREAD_POOL);
    }

    @Override
    public void destroy() {
        if (executor != null) executor.shutdown();
    }

    // ─── GET ─────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireAdmin(request, response)) return;

        int    page         = parsePage(request.getParameter("page"));
        String filterType   = normalize(request.getParameter("type"));
        String filterStatus = normalize(request.getParameter("status"));

        // Fetch email logs
        List<EmailLog> logs;
        int total;

        if (filterStatus != null) {
            logs  = emailLogDAO.findByStatus(filterStatus, page, PAGE_SIZE);
            total = emailLogDAO.countByStatus(filterStatus);
        } else if (filterType != null) {
            logs  = emailLogDAO.findByType(filterType, page, PAGE_SIZE);
            total = ((EmailLogDAO) emailLogDAO).countByType(filterType);
        } else {
            logs  = emailLogDAO.findAll(page, PAGE_SIZE);
            total = emailLogDAO.count();
        }

        // Fetch customer list (name + email) for the picker, excluding admins
        List<User> customers = userDAO.selectAllUsers().stream()
                .filter(u -> u.getEmail() != null && !u.getEmail().isBlank())
                .filter(u -> !"ADMIN".equalsIgnoreCase(u.getRole()))
                .sorted(Comparator.comparing(
                        u -> u.getFullname() != null ? u.getFullname() : ""))
                .collect(Collectors.toList());

        request.setAttribute("logs",         logs);
        request.setAttribute("customers",    customers);          // List<User>
        request.setAttribute("currentPage",  page);
        request.setAttribute("totalPages",   Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE)));
        request.setAttribute("totalRecords", total);
        request.setAttribute("totalSent",    emailLogDAO.countByStatus("SENT"));
        request.setAttribute("totalFailed",  emailLogDAO.countByStatus("FAILED"));
        request.setAttribute("filterType",   filterType   != null ? filterType   : "");
        request.setAttribute("filterStatus", filterStatus != null ? filterStatus : "");

        request.getRequestDispatcher("/WEB-INF/views/admin/email/email-hub.jsp")
               .forward(request, response);
    }

    // ─── POST ────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");

        String recipientRaw = trimOrNull(request.getParameter("recipient"));
        String subject      = trimOrNull(request.getParameter("subject"));
        String content      = trimOrNull(request.getParameter("content"));
        String emailType    = resolveEmailType(request.getParameter("emailType"));

        if (recipientRaw == null || subject == null || content == null) {
            redirect(response, request, "error=missing_fields");
            return;
        }

        // Deduplicate recipient list
        List<String> recipients = Arrays.stream(recipientRaw.split(","))
                .map(String::trim)
                .filter(e -> !e.isBlank() && isValidEmail(e))
                .distinct()
                .collect(Collectors.toList());

        if (recipients.isEmpty()) {
            redirect(response, request, "error=invalid_email");
            return;
        }

        String htmlBody = buildHtmlBody(content);

        // ── PARALLEL SEND via CompletableFuture ──────────────────────────────
        List<CompletableFuture<Boolean>> futures = recipients.stream()
                .map(email -> CompletableFuture.supplyAsync(
                        () -> EmailConfig.sendMail(email, subject, htmlBody, emailType, 0),
                        executor))
                .collect(Collectors.toList());

        // Wait for ALL sends to complete (max 30 seconds timeout per batch)
        CompletableFuture<Void> allDone = CompletableFuture.allOf(
                futures.toArray(new CompletableFuture[0]));

        int successCount = 0;
        int failCount    = 0;
        try {
            allDone.get(30, TimeUnit.SECONDS);
            for (CompletableFuture<Boolean> f : futures) {
                if (Boolean.TRUE.equals(f.getNow(false))) successCount++;
                else failCount++;
            }
        } catch (TimeoutException e) {
            // Count what finished within the timeout
            for (CompletableFuture<Boolean> f : futures) {
                if (f.isDone() && Boolean.TRUE.equals(f.getNow(false))) successCount++;
                else failCount++;
            }
        } catch (InterruptedException | ExecutionException e) {
            Thread.currentThread().interrupt();
            failCount = recipients.size();
        }

        if (failCount == 0) {
            redirect(response, request, "success=sent&count=" + successCount);
        } else if (successCount > 0) {
            redirect(response, request, "success=partial&s=" + successCount + "&f=" + failCount);
        } else {
            redirect(response, request, "error=send_failed");
        }
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private static int parsePage(String raw) {
        try { return Math.max(1, Integer.parseInt(raw)); }
        catch (Exception e) { return 1; }
    }

    private static String normalize(String s) {
        return (s == null || s.isBlank()) ? null : s.trim().toUpperCase();
    }

    private static String trimOrNull(String s) {
        return (s == null || s.isBlank()) ? null : s.trim();
    }

    private static String resolveEmailType(String raw) {
        if (raw == null) return EmailConfig.TYPE_GENERAL;
        return switch (raw.trim().toUpperCase()) {
            case "PROMOTION"     -> EmailConfig.TYPE_PROMOTION;
            case "ORDER_CONFIRM" -> EmailConfig.TYPE_ORDER_CONFIRM;
            default              -> EmailConfig.TYPE_GENERAL;
        };
    }

    private static boolean isValidEmail(String email) {
        return email != null &&
               email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    private static String buildHtmlBody(String text) {
        return "<div style='font-family:Inter,sans-serif;line-height:1.8;color:#333;" +
               "max-width:600px;padding:28px;background:#fff;'>"
               + text.replace("\n", "<br>")
               + "</div>";
    }

    private static void redirect(HttpServletResponse res, HttpServletRequest req, String query)
            throws IOException {
        res.sendRedirect(req.getContextPath() + "/admin/emails?" + query);
    }
}

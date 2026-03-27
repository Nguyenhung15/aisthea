package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Feedback;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.FeedbackService;
import com.aisthea.fashion.service.IFeedbackService;
import com.aisthea.fashion.util.ImageUploadHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles all feedback operations for users:
 * <ul>
 *   <li>GET  ?action=myFeedbacks  — user's feedback history</li>
 *   <li>GET  ?orderId={id}        — feedback form for a specific order</li>
 *   <li>POST action=submitAll     — submit/update all feedbacks for an order</li>
 *   <li>POST action=update        — update a single feedback (from my-feedbacks page)</li>
 *   <li>POST action=delete        — delete a feedback</li>
 *   <li>POST action=incrementHelpful — mark a feedback as helpful (AJAX)</li>
 * </ul>
 *
 * <p>Image uploads are handled by {@link ImageUploadHelper} and stored under
 * {@code UPLOAD_DIR/feedback/}. The {@code ImageServlet} serves them at
 * {@code /uploads/feedback/{filename}}.
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB — spool to disk above this
    maxFileSize       = 5L * 1024 * 1024,   // 5 MB max per file
    maxRequestSize    = 20L * 1024 * 1024   // 20 MB total (multiple images per order)
)
@WebServlet(name = "FeedbackServlet", urlPatterns = { "/feedback" })
public class FeedbackServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedbackServlet.class.getName());

    /** Sub-directory name inside UPLOAD_DIR for feedback images. */
    private static final String FEEDBACK_SUBDIR = "feedback";

    private IFeedbackService feedbackService;

    @Override
    public void init() {
        this.feedbackService = new FeedbackService();
    }

    // ─── GET ─────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        // My feedback history page
        if ("myFeedbacks".equals(action)) {
            User user = (User) session.getAttribute("user");
            request.setAttribute("myFeedbacks",
                    feedbackService.getFeedbacksByUserId(user.getUserId()));
            request.getRequestDispatcher("/WEB-INF/views/user/my-feedbacks.jsp")
                   .forward(request, response);
            return;
        }

        // Feedback form for a specific order
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        request.setAttribute("orderId", orderIdStr);

        try {
            int orderId = Integer.parseInt(orderIdStr);
            User user   = (User) session.getAttribute("user");

            // Load distinct products in this order
            List<Map<String, Object>> orderItems = new ArrayList<>();
            try (Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "SELECT DISTINCT pcs.productid, p.name AS product_name, oi.image_url " +
                         "FROM orderitems oi " +
                         "JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid " +
                         "JOIN products p ON pcs.productid = p.productid " +
                         "WHERE oi.orderid = ?")) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> item = new LinkedHashMap<>();
                        item.put("productId",   rs.getInt("productid"));
                        item.put("productName", rs.getString("product_name"));
                        item.put("imageUrl",    rs.getString("image_url"));
                        orderItems.add(item);
                    }
                }
            }

            // Load existing feedbacks for this order (per-order scoped)
            com.aisthea.fashion.dao.FeedbackDAO fbDao = new com.aisthea.fashion.dao.FeedbackDAO();
            Map<Integer, Feedback> existingFeedbackMap = new HashMap<>();
            StringBuilder productIdsCsv = new StringBuilder();

            for (Map<String, Object> item : orderItems) {
                int pid = (Integer) item.get("productId");
                Feedback existing = fbDao.getFeedbackByUserAndProductForOrder(
                        user.getUserId(), pid, orderId);
                if (existing != null) existingFeedbackMap.put(pid, existing);
                if (productIdsCsv.length() > 0) productIdsCsv.append(",");
                productIdsCsv.append(pid);
            }

            request.setAttribute("orderItems",         orderItems);
            request.setAttribute("productIdsCsv",      productIdsCsv.toString());
            request.setAttribute("existingFeedbackMap", existingFeedbackMap);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading feedback form for orderId=" + orderIdStr, e);
        }

        request.getRequestDispatcher("/WEB-INF/views/user/feedback.jsp")
               .forward(request, response);
    }

    // ─── POST ────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User   user   = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        // ── Mark helpful (AJAX) ──────────────────────────────────────────────
        if ("incrementHelpful".equals(action)) {
            handleIncrementHelpful(request, response, session);
            return;
        }

        // ── Delete ───────────────────────────────────────────────────────────
        if ("delete".equals(action)) {
            handleDelete(request, response, user);
            return;
        }

        // ── Update single feedback (from my-feedbacks page) ──────────────────
        if ("update".equals(action)) {
            handleUpdate(request, response, user);
            return;
        }

        // ── Submit / update all feedbacks for an order ───────────────────────
        if ("submitAll".equals(action)) {
            handleSubmitAll(request, response, user);
            return;
        }

        // ── Fallback: single feedback submit (from product-detail page) ───────
        handleSingleSubmit(request, response, user);
    }

    // ─── Handlers ─────────────────────────────────────────────────────────────

    private void handleIncrementHelpful(HttpServletRequest request,
                                        HttpServletResponse response,
                                        HttpSession session) throws IOException {
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            boolean isUnlikeRequest = "true".equals(request.getParameter("isUnlike"));

            @SuppressWarnings("unchecked")
            Map<Integer, Boolean> likedMap =
                    (Map<Integer, Boolean>) session.getAttribute("likedMap");
            if (likedMap == null) likedMap = new HashMap<>();

            boolean ok;
            boolean nowLiked;

            if (isUnlikeRequest) {
                // Unlike: decrement count
                com.aisthea.fashion.dao.FeedbackDAO dao = new com.aisthea.fashion.dao.FeedbackDAO();
                ok = dao.decrementHelpfulCount(feedbackId);
                if (ok) likedMap.remove(feedbackId);
                nowLiked = false;
            } else {
                // Like: increment count
                ok = feedbackService.incrementHelpfulCount(feedbackId);
                if (ok) likedMap.put(feedbackId, true);
                nowLiked = true;
            }

            session.setAttribute("likedMap", likedMap);

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":" + ok + ",\"liked\":" + nowLiked + "}");

        } catch (Exception e) {
            logger.log(Level.WARNING, "toggleHelpful failed", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    /**
     * Deletes a user's own feedback and redirects.
     */
    private void handleDelete(HttpServletRequest request,
                              HttpServletResponse response,
                              User user) throws IOException {
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            feedbackService.deleteFeedback(feedbackId, user.getUserId());
        } catch (Exception e) {
            logger.log(Level.WARNING, "Delete feedback failed", e);
        }

        String redirectUrl = request.getParameter("redirectUrl");
        response.sendRedirect(
                (redirectUrl != null && !redirectUrl.isBlank())
                ? redirectUrl
                : request.getContextPath() + "/feedback?action=myFeedbacks");
    }

    /**
     * Updates a single feedback (rating + comment + optional image).
     * Called from the my-feedbacks page.
     */
    private void handleUpdate(HttpServletRequest request,
                              HttpServletResponse response,
                              User user) throws IOException, ServletException {
        try {
            int    feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            int    rating     = Integer.parseInt(request.getParameter("rating"));
            String comment    = request.getParameter("comment");

            // Resolve image: new upload > keep existing
            String imageUrl = resolveImageUrl(
                    request.getPart("feedbackImage"),
                    request.getParameter("existingImageUrl"));

            feedbackService.updateFeedback(feedbackId, user.getUserId(), rating, comment, imageUrl);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Update feedback failed", e);
        }

        String redirectUrl = request.getParameter("redirectUrl");
        response.sendRedirect(
                (redirectUrl != null && !redirectUrl.isBlank())
                ? redirectUrl
                : request.getContextPath() + "/feedback?action=myFeedbacks&updated=1");
    }

    /**
     * Submits or updates all feedbacks for a given order at once.
     * Skips products where the user gave rating = 0 (not rated).
     */
    private void handleSubmitAll(HttpServletRequest request,
                                 HttpServletResponse response,
                                 User user) throws IOException, ServletException {

        String productIdsStr = request.getParameter("productIds");
        String orderId       = request.getParameter("orderId");

        if (productIdsStr != null && !productIdsStr.isBlank()) {
            for (String pidStr : productIdsStr.split(",")) {
                try {
                    int    pid       = Integer.parseInt(pidStr.trim());
                    String ratingStr = request.getParameter("rating_" + pid);

                    // Skip unrated products
                    if (ratingStr == null || ratingStr.isEmpty() || "0".equals(ratingStr)) continue;

                    int    rating         = Integer.parseInt(ratingStr);
                    String comment        = request.getParameter("comment_" + pid);
                    String feedbackIdStr  = request.getParameter("feedbackId_" + pid);

                    // Resolve image: new upload > keep existing
                    String imageUrl = resolveImageUrl(
                            request.getPart("feedbackImage_" + pid),
                            request.getParameter("existingImageUrl_" + pid));

                    if (feedbackIdStr != null && !feedbackIdStr.isBlank()) {
                        // UPDATE existing review
                        feedbackService.updateFeedback(
                                Integer.parseInt(feedbackIdStr),
                                user.getUserId(), rating, comment, imageUrl);
                    } else {
                        // INSERT new review
                        Feedback fb = new Feedback();
                        fb.setUserid(user.getUserId());
                        fb.setProductid(pid);
                        fb.setRating(rating);
                        fb.setComment(comment != null ? comment : "");
                        fb.setImageUrl(imageUrl);
                        fb.setStatus("Visible");
                        feedbackService.addFeedback(fb);
                    }

                } catch (Exception e) {
                    logger.log(Level.WARNING, "submitAll: error for pid=" + pidStr, e);
                }
            }
        }

        String redirect = (orderId != null && !orderId.isBlank())
                ? request.getContextPath() + "/order?action=view&id=" + orderId + "&feedback=success"
                : request.getContextPath() + "/order?action=history&feedback=success";
        response.sendRedirect(redirect);
    }

    /**
     * Handles a single-product feedback submit from the product-detail page.
     */
    private void handleSingleSubmit(HttpServletRequest request,
                                    HttpServletResponse response,
                                    User user) throws IOException, ServletException {

        String productIdStr = request.getParameter("productId");
        String ratingStr    = request.getParameter("rating");
        String comment      = request.getParameter("comment");

        if (productIdStr == null || productIdStr.isBlank()) {
            logger.warning("[FeedbackServlet] handleSingleSubmit: productId is empty.");
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr.trim());
            int rating    = (ratingStr != null && !ratingStr.isEmpty())
                            ? Integer.parseInt(ratingStr) : 1;

            String imageUrl = resolveImageUrl(request.getPart("feedbackImage"), null);

            Feedback feedback = new Feedback();
            feedback.setUserid(user.getUserId());
            feedback.setProductid(productId);
            feedback.setRating(rating);
            feedback.setComment(comment != null ? comment : "");
            feedback.setImageUrl(imageUrl);
            feedback.setStatus("Visible");

            boolean saved = feedbackService.addFeedback(feedback);
            logger.info("[FeedbackServlet] Single submit saved=" + saved
                    + " user=" + user.getUserId() + " product=" + productId);

            String orderId = request.getParameter("orderId");
            String redirect = (orderId != null && !orderId.isBlank())
                    ? request.getContextPath() + "/order?action=view&id=" + orderId + "&feedback=success"
                    : request.getContextPath() + "/product?action=view&id=" + productId + "&feedback=success";
            response.sendRedirect(redirect);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "[FeedbackServlet] Single submit failed", e);
            response.sendRedirect(request.getContextPath() + "/order?action=history");
        }
    }

    // ─── Image helper ─────────────────────────────────────────────────────────

    /**
     * Resolves the final image URL to store in the database:
     * <ol>
     *   <li>If a new file was uploaded and is valid → save and return its path.</li>
     *   <li>Otherwise → return {@code existingImageUrl} (may be null or blank → null).</li>
     * </ol>
     */
    private String resolveImageUrl(Part filePart, String existingImageUrl)
            throws IOException {
        try {
            String uploaded = ImageUploadHelper.save(filePart, FEEDBACK_SUBDIR);
            if (uploaded != null) return uploaded;
        } catch (IOException e) {
            logger.log(Level.WARNING, "Image upload failed, keeping existing", e);
        }
        return (existingImageUrl != null && !existingImageUrl.isBlank())
               ? existingImageUrl : null;
    }
}

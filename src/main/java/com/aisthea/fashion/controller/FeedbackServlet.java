package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Feedback;
import com.aisthea.fashion.util.Constants;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.FeedbackService;
import com.aisthea.fashion.service.IFeedbackService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize       = 5 * 1024 * 1024,  // 5 MB mỗi file
    maxRequestSize    = 10 * 1024 * 1024  // 10 MB tổng request
)
@WebServlet(name = "FeedbackServlet", urlPatterns = { "/feedback" })
public class FeedbackServlet extends HttpServlet {

    private IFeedbackService feedbackService;

    @Override
    public void init() {
        this.feedbackService = new FeedbackService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== DEBUG MODE =====
        if ("1".equals(request.getParameter("debug"))) {
            response.setContentType("text/html;charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();
            out.println("<html><body style='font-family:monospace;padding:24px'>");
            out.println("<h2>🛠 Feedback Debug - DB Management (V2.0 - SAFE DAO)</h2>");

            try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection()) {
                // Test DAO directly
                out.println("<h3>DAO Test:</h3>");
                try {
                    List<Feedback> testList = feedbackService.getFeedbacksByProductId(14);
                    out.println("getFeedbacksByProductId(14) returned: <b>" + testList.size() + "</b> rows<br/>");
                    for (Feedback f : testList) {
                        out.println("- ID=" + f.getFeedbackid() + " | Rating=" + f.getRating() + " | Comment="
                                + f.getComment() + " | User=" + f.getUsername() + "<br/>");
                    }

                    List<Feedback> allList = feedbackService.getAllFeedbacks();
                    out.println("getAllFeedbacks() returned: <b>" + allList.size() + "</b> rows<br/>");
                } catch (Exception e) {
                    out.println("<pre style='color:red'>DAO Error: " + e.getMessage() + "\n");
                    e.printStackTrace(out);
                    out.println("</pre>");
                }

                out.println("<hr/>");

                // RUN MIGRATION IF REQUESTED
                if ("migrate".equals(request.getParameter("cmd"))) {
                    out.println(
                            "<div style='background:#fef3c7;padding:12px;border:1px solid #f59e0b;margin-bottom:20px'>");
                    out.println("<b>Running Migration...</b><br/>");
                    String[] queries = {
                            "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'is_verified') ALTER TABLE [feedback] ADD [is_verified] BIT DEFAULT 0;",
                            "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'image_url') ALTER TABLE [feedback] ADD [image_url] NVARCHAR(500) NULL;",
                            "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'helpful_count') ALTER TABLE [feedback] ADD [helpful_count] INT DEFAULT 0;",
                            "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'admin_reply') ALTER TABLE [feedback] ADD [admin_reply] NVARCHAR(MAX) NULL;",
                            "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'replied_at') ALTER TABLE [feedback] ADD [replied_at] DATETIME NULL;",
                            "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'updatedat') ALTER TABLE [feedback] ADD [updatedat] DATETIME DEFAULT GETDATE();"
                    };
                    for (String q : queries) {
                        try (java.sql.Statement s = conn.createStatement()) {
                            s.execute(q);
                            out.println("✅ Executed: " + q.substring(0, Math.min(60, q.length())) + "...<br/>");
                        } catch (Exception ex) {
                            out.println("❌ Failed: " + q + " | Error: " + ex.getMessage() + "<br/>");
                        }
                    }
                    out.println("</div>");
                }

                out.println(
                        "<a href='?debug=1&cmd=migrate' style='background:#2563eb;color:white;padding:8px 16px;text-decoration:none;border-radius:4px'>Run Schema Migration</a>");
                out.println("<hr/>");

                // Schema info
                java.sql.ResultSetMetaData meta = null;
                out.println("<h3>Bảng Feedback - All Columns:</h3>");
                try (java.sql.PreparedStatement ps = conn.prepareStatement("SELECT TOP 1 * FROM feedback");
                        java.sql.ResultSet rs = ps.executeQuery()) {
                    meta = rs.getMetaData();
                    out.println("<p><b>Columns:</b> ");
                    for (int i = 1; i <= meta.getColumnCount(); i++) {
                        out.print(meta.getColumnName(i) + (i < meta.getColumnCount() ? ", " : ""));
                    }
                    out.println("</p>");
                }

                // All feedback records
                out.println("<h3>Tất cả records trong bảng feedback:</h3>");
                out.println("<table border='1' cellpadding='6' style='border-collapse:collapse'>");
                out.println("<tr style='background:#e5e7eb'>");
                if (meta != null) {
                    for (int i = 1; i <= meta.getColumnCount(); i++) {
                        out.println("<th>" + meta.getColumnName(i) + "</th>");
                    }
                }
                out.println("</tr>");

                try (java.sql.PreparedStatement ps = conn
                        .prepareStatement("SELECT * FROM feedback ORDER BY feedbackid DESC");
                        java.sql.ResultSet rs = ps.executeQuery()) {
                    int cnt = 0;
                    while (rs.next()) {
                        cnt++;
                        out.println("<tr>");
                        if (meta != null) {
                            for (int i = 1; i <= meta.getColumnCount(); i++) {
                                out.println("<td>" + rs.getObject(i) + "</td>");
                            }
                        }
                        out.println("</tr>");
                    }
                    out.println("</table><p><b>Total: " + cnt + " rows</b></p>");
                }
                // Status distinct
                out.println("<h3>Distinct status values:</h3>");
                try (java.sql.PreparedStatement ps2 = conn
                        .prepareStatement("SELECT DISTINCT status, COUNT(*) as cnt FROM feedback GROUP BY status");
                        java.sql.ResultSet rs2 = ps2.executeQuery()) {
                    while (rs2.next()) {
                        out.println("status='" + rs2.getString("status") + "' | count=" + rs2.getInt("cnt") + "<br/>");
                    }
                }
            } catch (Exception e) {
                out.println("<pre style='color:red'>ERROR: " + e.getMessage() + "</pre>");
            }
            out.println("</body></html>");
            return;
        }
        // ===== END DEBUG =====

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        // ── Trang quản lý feedback của user ──
        if ("myFeedbacks".equals(action)) {
            User currentUser = (User) session.getAttribute("user");
            List<com.aisthea.fashion.model.Feedback> myList =
                    feedbackService.getFeedbacksByUserId(currentUser.getUserId());
            request.setAttribute("myFeedbacks", myList);
            request.getRequestDispatcher("/WEB-INF/views/user/my-feedbacks.jsp").forward(request, response);
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        request.setAttribute("orderId", orderIdStr);

        // Load danh sách sản phẩm trong đơn hàng để hiển thị dropdown chọn SP
        try {
            int orderId = Integer.parseInt(orderIdStr);
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
                        item.put("productId", rs.getInt("productid"));
                        item.put("productName", rs.getString("product_name"));
                        item.put("imageUrl", rs.getString("image_url"));
                        orderItems.add(item);
                    }
                }
            }

            request.setAttribute("orderItems", orderItems);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/user/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("incrementHelpful".equals(action)) {
            try {
                int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
                
                // Track liked status in Session
                Map<Integer, Boolean> likedMap = (Map<Integer, Boolean>) session.getAttribute("likedMap");
                if (likedMap == null) {
                    likedMap = new java.util.HashMap<>();
                }
                
                // Prevent duplicate likes
                if (likedMap.containsKey(feedbackId)) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"message\": \"Already liked\"}");
                    return;
                }

                boolean success = feedbackService.incrementHelpfulCount(feedbackId);
                if (success) {
                    likedMap.put(feedbackId, true);
                    session.setAttribute("likedMap", likedMap);
                }
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": " + success + "}");
                return;
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
        }

        // ── Xóa feedback ──
        if ("delete".equals(action)) {
            try {
                int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
                feedbackService.deleteFeedback(feedbackId, user.getUserId());
            } catch (Exception e) {
                e.printStackTrace();
            }
            String redirectUrl = request.getParameter("redirectUrl");
            if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/feedback?action=myFeedbacks");
            }
            return;
        }

        // ── Sửa feedback ──
        if ("update".equals(action)) {
            try {
                int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                feedbackService.updateFeedback(feedbackId, user.getUserId(), rating, comment != null ? comment : "");
            } catch (Exception e) {
                e.printStackTrace();
            }
            String redirectUrl = request.getParameter("redirectUrl");
            if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/feedback?action=myFeedbacks&updated=1");
            }
            return;
        }

        try {
            String productIdStr = request.getParameter("productId");
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");

            java.util.logging.Logger log = java.util.logging.Logger.getLogger("FeedbackServlet");
            log.info("[Feedback] userId=" + user.getUserId()
                    + " productId=" + productIdStr
                    + " rating=" + ratingStr
                    + " comment=" + comment);

            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                log.warning("[Feedback] productId is empty, aborting.");
                response.sendRedirect(request.getContextPath() + "/order?action=history");
                return;
            }

            int productId = Integer.parseInt(productIdStr.trim());
            int rating = (ratingStr != null && !ratingStr.isEmpty()) ? Integer.parseInt(ratingStr) : 1;

            // ── Xử lý upload ảnh ──
            String imageUrl = null;
            try {
                Part filePart = request.getPart("feedbackImage");
                if (filePart != null && filePart.getSize() > 0) {
                    String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String ext = "";
                    int dotIdx = originalName.lastIndexOf('.');
                    if (dotIdx >= 0) ext = originalName.substring(dotIdx).toLowerCase();

                    String savedName = UUID.randomUUID().toString() + ext;

                    // Lưu vào Constants.UPLOAD_DIR/feedback/ — cùng nơi ImageServlet tìm file
                    File feedbackDir = new File(Constants.UPLOAD_DIR, "feedback");
                    if (!feedbackDir.exists()) feedbackDir.mkdirs();

                    File savedFile = new File(feedbackDir, savedName);
                    try (InputStream is = filePart.getInputStream()) {
                        Files.copy(is, savedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }

                    // imageUrl lưu vào DB dạng "feedback/uuid.jpg"
                    // ImageServlet sẽ serve từ: GET /uploads/feedback/uuid.jpg
                    imageUrl = "feedback/" + savedName;
                    java.util.logging.Logger.getLogger("FeedbackServlet")
                        .info("[Feedback] Image saved to: " + savedFile.getAbsolutePath() + " | DB url=" + imageUrl);
                }
            } catch (Exception uploadEx) {
                java.util.logging.Logger.getLogger("FeedbackServlet").warning("[Feedback] Image upload failed: " + uploadEx.getMessage());
            }

            Feedback feedback = new Feedback();
            feedback.setUserid(user.getUserId());
            feedback.setProductid(productId);
            feedback.setRating(rating);
            feedback.setComment(comment != null ? comment : "");
            feedback.setImageUrl(imageUrl);
            feedback.setStatus("Visible");

            boolean saved = feedbackService.addFeedback(feedback);
            log.info("[Feedback] saved=" + saved);

            String orderId = request.getParameter("orderId");
            if (orderId != null && !orderId.isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/order?action=view&id=" + orderId + "&feedback=success");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/product?action=view&id=" + productId + "&feedback=success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/order?action=history");
        }
    }
}

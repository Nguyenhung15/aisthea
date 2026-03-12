package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.User;
import com.aisthea.fashion.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class TierDetailServlet extends HttpServlet {

    private static final int SILVER_THRESHOLD = 200;
    private static final int GOLD_THRESHOLD = 1000;
    private static final int PLATINUM_THRESHOLD = 5000;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Refresh user data from DB to get latest membership_points
        try {
            UserDAO userDAO = new UserDAO();

            // --- Auto Migration for Point History ---
            if ("migrate".equals(request.getParameter("cmd"))) {
                try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                        java.sql.Statement stmt = conn.createStatement()) {
                    String sql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'membership_point') " +
                            "CREATE TABLE [dbo].[membership_point] (" +
                            "[history_id] INT IDENTITY(1,1) PRIMARY KEY, " +
                            "[userid] INT NOT NULL, " +
                            "[points_earned] INT NOT NULL, " +
                            "[reason] NVARCHAR(255) NULL, " +
                            "[createdat] DATETIME DEFAULT GETDATE(), " +
                            "CONSTRAINT FK_MembershipPoint_User FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE"
                            +
                            ");";
                    stmt.execute(sql);
                    System.out.println("[TierDetailServlet] Migration executed successfully.");
                } catch (Exception e) {
                    System.err.println("[TierDetailServlet] Migration failed: " + e.getMessage());
                }
            }
            // ----------------------------------------

            User freshUser = userDAO.selectUser(user.getUserId());

            // --- HỆ THỐNG TỰ ĐỘNG RESET ĐIỂM 6 THÁNG ---
            // Quy tắc: Reset vào 01/01 và 01/07 hàng năm
            java.util.Calendar cal = java.util.Calendar.getInstance();
            int year = cal.get(java.util.Calendar.YEAR);
            int month = cal.get(java.util.Calendar.MONTH); // 0-indexed (0=Jan, 6=July)

            java.util.Calendar windowStart = java.util.Calendar.getInstance();
            windowStart.set(year, month < 6 ? 0 : 6, 1, 0, 0, 0);
            windowStart.set(java.util.Calendar.MILLISECOND, 0);

            try {
                java.sql.Timestamp lastReset = userDAO.getLastSystemResetDate();
                if (lastReset == null || lastReset.before(windowStart.getTime())) {
                    String reason = "PERIODIC_SYSTEM_RESET_CYCLE_" + (month < 6 ? "01_01_" : "01_07_") + year;
                    userDAO.resetMembershipPoints(reason);
                    // After reset, re-fetch user
                    freshUser = userDAO.selectUser(user.getUserId());
                    System.out.println("[SYSTEM] Membership points reset automatic successfully.");
                } else {
                    // --- RECOVERY LOGIC: Recoup points from missed orders in current cycle ---
                    if (freshUser != null) {
                        try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection()) {
                            // Find all completed/paid orders this cycle for this user
                            java.util.List<Integer> recoveredOrderIds = new java.util.ArrayList<>();
                            try (java.sql.PreparedStatement ps = conn.prepareStatement(
                                    "SELECT orderid, totalprice FROM Orders " +
                                    "WHERE userid = ? AND (status = 'Completed' OR status = 'Paid') " +
                                    "AND createdat >= ?")) {
                                ps.setInt(1, user.getUserId());
                                ps.setTimestamp(2, new java.sql.Timestamp(windowStart.getTimeInMillis()));
                                try (java.sql.ResultSet rs = ps.executeQuery()) {
                                    while (rs.next()) {
                                        int oid = rs.getInt("orderid");
                                        // Check if this specific order is already in history
                                        try (java.sql.PreparedStatement checkPs = conn.prepareStatement(
                                                "SELECT history_id FROM membership_point WHERE userid = ? AND reason LIKE ?")) {
                                            checkPs.setInt(1, user.getUserId());
                                            checkPs.setString(2, "%Order #" + oid + "%");
                                            try (java.sql.ResultSet checkRs = checkPs.executeQuery()) {
                                                if (!checkRs.next()) {
                                                    // Order not logged! Award points.
                                                    int pointsToAdd = rs.getBigDecimal("totalprice").divide(new java.math.BigDecimal("10000"), 0, java.math.RoundingMode.DOWN).intValue();
                                                    if (pointsToAdd > 0) {
                                                        userDAO.updateMembershipPoints(user.getUserId(), pointsToAdd, "Recovered points from Order #" + oid);
                                                        System.out.println("[SYSTEM] Auto-recovered " + pointsToAdd + " points for Order #" + oid);
                                                        recoveredOrderIds.add(oid);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // If we recovered anything OR if points table doesn't match history sum, sync it
                            int totalInHistory = 0;
                            try (java.sql.PreparedStatement ps = conn.prepareStatement(
                                    "SELECT SUM(points_earned) FROM membership_point " +
                                    "WHERE userid = ? AND createdat >= ? AND reason NOT LIKE 'PERIODIC_SYSTEM_RESET%'")) {
                                ps.setInt(1, user.getUserId());
                                ps.setTimestamp(2, new java.sql.Timestamp(windowStart.getTimeInMillis()));
                                try (java.sql.ResultSet rs = ps.executeQuery()) {
                                    if (rs.next()) totalInHistory = rs.getInt(1);
                                }
                            }

                            if (freshUser.getMembershipPoints() != totalInHistory) {
                                try (java.sql.PreparedStatement ups = conn.prepareStatement(
                                        "UPDATE Users SET membership_points = ?, updatedat = GETDATE() WHERE userid = ?")) {
                                    ups.setInt(1, totalInHistory);
                                    ups.setInt(2, user.getUserId());
                                    ups.executeUpdate();
                                    freshUser.setMembershipPoints(totalInHistory);
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("[SYSTEM] Error checking/resetting membership points: " + e.getMessage());
            }
            // ------------------------------------------

            if (freshUser != null) {
                // Do not store password hash in session for security reasons
                freshUser.setPassword(null);
                user = freshUser;
                session.setAttribute("user", freshUser);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        int points = user.getMembershipPoints();

        // Determine current tier
        String currentTier;
        String currentTierKey; // for CSS/color mapping
        // Inline style colors for the card gradient
        String cardGradient;
        String cardShadow;
        String accentColor;
        String progressGradient;
        String badgeBg;
        String badgeColor;
        String badgeBorder;
        String iconBg;
        String iconColor;

        if (points >= PLATINUM_THRESHOLD) {
            currentTier = "PLATINUM";
            currentTierKey = "platinum";
            cardGradient = "linear-gradient(135deg, #E8EAF6 0%, #7986CB 50%, #303F9F 100%)";
            cardShadow = "0 10px 30px -5px rgba(63, 81, 181, 0.4)";
            accentColor = "#5C6BC0";
            progressGradient = "linear-gradient(to right, #7986CB, #5C6BC0, #3F51B5)";
            badgeBg = "rgba(121, 134, 203, 0.15)";
            badgeColor = "#303F9F";
            badgeBorder = "rgba(121, 134, 203, 0.3)";
            iconBg = "rgba(121, 134, 203, 0.1)";
            iconColor = "#3F51B5";
        } else if (points >= GOLD_THRESHOLD) {
            currentTier = "GOLD";
            currentTierKey = "gold";
            cardGradient = "linear-gradient(135deg, #F3E5C3 0%, #C5A059 50%, #8A6E2F 100%)";
            cardShadow = "0 10px 30px -5px rgba(197, 160, 89, 0.4)";
            accentColor = "#C5A059";
            progressGradient = "linear-gradient(to right, #C5A059, #F9A825, #FF8F00)";
            badgeBg = "rgba(197, 160, 89, 0.15)";
            badgeColor = "#8A6E2F";
            badgeBorder = "rgba(197, 160, 89, 0.3)";
            iconBg = "rgba(197, 160, 89, 0.1)";
            iconColor = "#C5A059";
        } else if (points >= SILVER_THRESHOLD) {
            currentTier = "SILVER";
            currentTierKey = "silver";
            cardGradient = "linear-gradient(135deg, #B0BEC5 0%, #78909C 50%, #455A64 100%)";
            cardShadow = "0 10px 30px -5px rgba(96, 125, 139, 0.4)";
            accentColor = "#78909C";
            progressGradient = "linear-gradient(to right, #B0BEC5, #78909C)";
            badgeBg = "rgba(144, 164, 174, 0.15)";
            badgeColor = "#455A64";
            badgeBorder = "rgba(144, 164, 174, 0.3)";
            iconBg = "rgba(144, 164, 174, 0.1)";
            iconColor = "#607D8B";
        } else {
            currentTier = "MEMBER";
            currentTierKey = "member";
            cardGradient = "linear-gradient(135deg, #78909C 0%, #546E7A 50%, #37474F 100%)";
            cardShadow = "0 10px 30px -5px rgba(84, 110, 122, 0.4)";
            accentColor = "#546E7A";
            progressGradient = "linear-gradient(to right, #78909C, #546E7A)";
            badgeBg = "rgba(120, 144, 156, 0.15)";
            badgeColor = "#37474F";
            badgeBorder = "rgba(120, 144, 156, 0.3)";
            iconBg = "rgba(120, 144, 156, 0.1)";
            iconColor = "#546E7A";
        }

        // Determine next tier
        String nextTierName;
        int nextTierPoints;
        int tierProgress;

        if (points >= PLATINUM_THRESHOLD) {
            nextTierName = "MAX";
            nextTierPoints = PLATINUM_THRESHOLD;
            tierProgress = 100;
        } else if (points >= GOLD_THRESHOLD) {
            nextTierName = "PLATINUM";
            nextTierPoints = PLATINUM_THRESHOLD;
            tierProgress = (int) (((double) (points - GOLD_THRESHOLD) / (PLATINUM_THRESHOLD - GOLD_THRESHOLD)) * 100);
        } else if (points >= SILVER_THRESHOLD) {
            nextTierName = "GOLD";
            nextTierPoints = GOLD_THRESHOLD;
            tierProgress = (int) (((double) (points - SILVER_THRESHOLD) / (GOLD_THRESHOLD - SILVER_THRESHOLD)) * 100);
        } else {
            nextTierName = "SILVER";
            nextTierPoints = SILVER_THRESHOLD;
            tierProgress = (int) (((double) points / SILVER_THRESHOLD) * 100);
        }

        int pointsNeeded = nextTierPoints - points;
        if (pointsNeeded < 0)
            pointsNeeded = 0;

        // Set all attributes
        request.setAttribute("currentTier", currentTier);
        request.setAttribute("currentTierKey", currentTierKey);
        request.setAttribute("userPoints", points);
        request.setAttribute("nextTierName", nextTierName);
        request.setAttribute("nextTierPoints", nextTierPoints);
        request.setAttribute("tierProgress", tierProgress);
        request.setAttribute("pointsNeeded", pointsNeeded);

        // Style attributes for inline styling
        request.setAttribute("cardGradient", cardGradient);
        request.setAttribute("cardShadow", cardShadow);
        request.setAttribute("accentColor", accentColor);
        request.setAttribute("progressGradient", progressGradient);
        request.setAttribute("badgeBg", badgeBg);
        request.setAttribute("badgeColor", badgeColor);
        request.setAttribute("badgeBorder", badgeBorder);
        request.setAttribute("iconBg", iconBg);
        // Fetch point history
        try {
            com.aisthea.fashion.dao.PointHistoryDAO historyDAO = new com.aisthea.fashion.dao.PointHistoryDAO();
            java.util.List<com.aisthea.fashion.model.PointHistory> history = historyDAO
                    .getPointHistoryByUserId(user.getUserId());
            request.setAttribute("pointHistory", history);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/user/tier_details.jsp").forward(request, response);
    }
}

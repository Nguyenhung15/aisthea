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

    // Tier thresholds (points)
    private static final int SILVER_THRESHOLD = 2000;
    private static final int GOLD_THRESHOLD = 5000;
    private static final int PLATINUM_THRESHOLD = 15000;

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
            User freshUser = userDAO.selectUser(user.getUserId());
            if (freshUser != null) {
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
        request.setAttribute("iconColor", iconColor);

        request.getRequestDispatcher("/WEB-INF/views/user/tier_details.jsp").forward(request, response);
    }
}

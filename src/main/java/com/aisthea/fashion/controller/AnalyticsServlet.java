package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.AnalyticsDAO;
import com.aisthea.fashion.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AnalyticsServlet", urlPatterns = { "/admin/analytics" })
public class AnalyticsServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AnalyticsServlet.class.getName());
    private AnalyticsDAO analyticsDAO;

    @Override
    public void init() {
        this.analyticsDAO = new AnalyticsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 1. Metrics
            BigDecimal totalRevenue = analyticsDAO.getTotalRevenue();
            BigDecimal revenueThisMonth = analyticsDAO.getRevenueThisMonth();
            BigDecimal revenueToday = analyticsDAO.getRevenueToday();
            BigDecimal revenuePrevMonth = analyticsDAO.getRevenuePreviousMonth();

            double revenueGrowth = 0;
            if (revenuePrevMonth.compareTo(BigDecimal.ZERO) > 0) {
                revenueGrowth = revenueThisMonth.subtract(revenuePrevMonth)
                        .divide(revenuePrevMonth, 4, RoundingMode.HALF_UP)
                        .multiply(new BigDecimal(100)).doubleValue();
            }

            // 2. Collections
            List<Map<String, Object>> topProducts = analyticsDAO.getTopSellingProducts(5);
            List<Map<String, Object>> topCustomers = analyticsDAO.getTopCustomersBySpending(5);
            List<Map<String, Object>> lowStockProducts = analyticsDAO.getLowStockProducts(5);

            // 3. Statuses
            int newCustomers = analyticsDAO.getNewCustomersThisMonth();
            int totalCustomers = analyticsDAO.getTotalCustomers();
            int totalOrders = analyticsDAO.getTotalOrderCount();
            int completedOrders = analyticsDAO.getCompletedOrderCount();

            // 4. Charts
            LinkedHashMap<String, Integer> ordersPerDay = analyticsDAO.getOrderCountsByDay(7);
            LinkedHashMap<String, BigDecimal> revenueByMonth = analyticsDAO.getRevenueByMonth(12);
            LinkedHashMap<String, Integer> orderStatusData = analyticsDAO.getOrderStatusCounts();

            // Set Attributes
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("revenueThisMonth", revenueThisMonth);
            request.setAttribute("revenueToday", revenueToday);
            request.setAttribute("revenueGrowth", (int) revenueGrowth);
            request.setAttribute("newCustomers", newCustomers);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("completedOrders", completedOrders);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("topCustomers", topCustomers);
            request.setAttribute("lowStockProducts", lowStockProducts);

            // JSON for Charts - Chronological Order (Oldest to Newest)
            request.setAttribute("revenueByMonthLabels", toJsonArray(revenueByMonth.keySet()));
            request.setAttribute("revenueByMonthData", toJsonNumberArray(revenueByMonth.values()));
            request.setAttribute("orderStatusLabels", toJsonStatusArray(orderStatusData.keySet()));
            request.setAttribute("orderStatusData", toJsonStatusNumberArray(orderStatusData.values()));
            request.setAttribute("ordersPerDayLabels", toJsonArray(ordersPerDay.keySet()));
            request.setAttribute("ordersPerDayData", toJsonNumberArray(ordersPerDay.values()));

            request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in AnalyticsServlet", e);
            request.setAttribute("error", "Error loading analytics: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp").forward(request, response);
        }
    }

    private String toJsonArray(Collection<String> col) {
        StringBuilder sb = new StringBuilder("[");
        List<String> list = new ArrayList<>(col);
        Collections.reverse(list); // Reverse to chronological
        int i = 0;
        for (String s : list) {
            sb.append("\"").append(s.replace("\"", "\\\"")).append("\"");
            if (++i < list.size()) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String toJsonNumberArray(Collection<? extends Number> col) {
        StringBuilder sb = new StringBuilder("[");
        List<Number> list = new ArrayList<>(col);
        Collections.reverse(list); // Reverse to chronological
        int i = 0;
        for (Number n : list) {
            sb.append(n != null ? n.toString() : "0");
            if (++i < list.size()) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
    
    // Status charts don't need reverse
    private String toJsonStatusArray(Collection<String> col) {
        StringBuilder sb = new StringBuilder("[");
        int i = 0;
        for (String s : col) {
            sb.append("\"").append(s.replace("\"", "\\\"")).append("\"");
            if (++i < col.size()) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String toJsonStatusNumberArray(Collection<? extends Number> col) {
        StringBuilder sb = new StringBuilder("[");
        int i = 0;
        for (Number n : col) {
            sb.append(n != null ? n.toString() : "0");
            if (++i < col.size()) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
}

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

        String filterType = request.getParameter("type"); // YEAR, MONTH, DAY
        String filterValue = request.getParameter("value"); // e.g., "2024", "2024-03", "2024-03-17"

        try {
            // 1. Metrics & Data - Filtered if applicable
            BigDecimal totalRevenue;
            int totalOrders;
            int completedOrders;
            List<Map<String, Object>> topProducts;
            List<Map<String, Object>> topCustomers;
            LinkedHashMap<String, Integer> orderStatusData;
            int totalCustomersInPeriod;
            
            if (filterType != null && filterValue != null && !filterValue.trim().isEmpty()) {
                totalRevenue = analyticsDAO.getFilteredRevenue(filterType, filterValue);
                totalOrders = analyticsDAO.getFilteredOrderCount(filterType, filterValue);
                completedOrders = analyticsDAO.getFilteredCompletedOrderCount(filterType, filterValue);
                topProducts = analyticsDAO.getFilteredTopSellingProducts(5, filterType, filterValue);
                topCustomers = analyticsDAO.getFilteredTopCustomersBySpending(5, filterType, filterValue);
                orderStatusData = analyticsDAO.getFilteredOrderStatusCounts(filterType, filterValue);
                totalCustomersInPeriod = analyticsDAO.getFilteredCustomerCount(filterType, filterValue);
            } else {
                totalRevenue = analyticsDAO.getTotalRevenue();
                totalOrders = analyticsDAO.getTotalOrderCount();
                completedOrders = analyticsDAO.getCompletedOrderCount();
                topProducts = analyticsDAO.getTopSellingProducts(5);
                topCustomers = analyticsDAO.getTopCustomersBySpending(5);
                orderStatusData = analyticsDAO.getOrderStatusCounts();
                totalCustomersInPeriod = analyticsDAO.getTotalCustomers();
            }

            BigDecimal revenueThisMonth = analyticsDAO.getRevenueThisMonth();
            BigDecimal revenueToday = analyticsDAO.getRevenueToday();
            
            // 2. Additional data
            List<Map<String, Object>> lowStockProducts = analyticsDAO.getLowStockProducts(5);
            int newCustomers = analyticsDAO.getNewCustomersThisMonth();
            int totalCustomers = analyticsDAO.getTotalCustomers();

            // 3. Charts - Dynamic based on filter
            LinkedHashMap<String, BigDecimal> revenueBreakdown;
            LinkedHashMap<String, Integer> orderBreakdown;
            String chartSubtitle = "Monthly revenue over the last 12 months";
            
            if ("YEAR".equalsIgnoreCase(filterType) && filterValue != null && !filterValue.trim().isEmpty()) {
                revenueBreakdown = analyticsDAO.getRevenueBreakdown("YEAR", filterValue);
                orderBreakdown = analyticsDAO.getOrderBreakdown("YEAR", filterValue);
                chartSubtitle = "Monthly breakdown for year " + filterValue;
            } else if ("MONTH".equalsIgnoreCase(filterType) && filterValue != null && !filterValue.trim().isEmpty()) {
                revenueBreakdown = analyticsDAO.getRevenueBreakdown("MONTH", filterValue);
                orderBreakdown = analyticsDAO.getOrderBreakdown("MONTH", filterValue);
                chartSubtitle = "Daily breakdown for " + filterValue;
            } else if ("DAY".equalsIgnoreCase(filterType) && filterValue != null && !filterValue.trim().isEmpty()) {
                revenueBreakdown = analyticsDAO.getRevenueBreakdown("DAY", filterValue);
                orderBreakdown = analyticsDAO.getOrderBreakdown("DAY", filterValue);
                chartSubtitle = "Hourly breakdown for " + filterValue;
            } else {
                revenueBreakdown = analyticsDAO.getRevenueByMonth(12);
                orderBreakdown = analyticsDAO.getOrderCountsByDay(7);
            }
            
            // 4. Calculate Growth
            BigDecimal revenuePrevMonth = analyticsDAO.getRevenuePreviousMonth();
            double revenueGrowth = 0;
            if (revenuePrevMonth.compareTo(BigDecimal.ZERO) > 0) {
                revenueGrowth = revenueThisMonth.subtract(revenuePrevMonth)
                        .divide(revenuePrevMonth, 4, RoundingMode.HALF_UP)
                        .multiply(new BigDecimal(100)).doubleValue();
            }

            // Set Attributes
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("revenueThisMonth", revenueThisMonth);
            request.setAttribute("revenueToday", revenueToday);
            request.setAttribute("revenueGrowth", (int) revenueGrowth);
            request.setAttribute("newCustomers", newCustomers);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("completedOrders", completedOrders);
            request.setAttribute("totalCustomersInPeriod", totalCustomersInPeriod);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("topCustomers", topCustomers);
            request.setAttribute("lowStockProducts", lowStockProducts);
            
            request.setAttribute("filterType", filterType);
            request.setAttribute("filterValue", filterValue);
            request.setAttribute("chartSubtitle", chartSubtitle);

            // JSON for Charts
            request.setAttribute("revenueLabels", toJsonArrayNoReverse(revenueBreakdown.keySet()));
            request.setAttribute("revenueData", toJsonNumberArrayNoReverse(revenueBreakdown.values()));
            request.setAttribute("orderLabels", toJsonArrayNoReverse(orderBreakdown.keySet()));
            request.setAttribute("orderData", toJsonNumberArrayNoReverse(orderBreakdown.values()));
            
            request.setAttribute("orderStatusLabels", toJsonStatusArray(orderStatusData.keySet()));
            request.setAttribute("orderStatusData", toJsonStatusNumberArray(orderStatusData.values()));

            request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in AnalyticsServlet", e);
            request.setAttribute("error", "Error loading analytics: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp").forward(request, response);
        }
    }

    private String toJsonArrayNoReverse(Collection<String> col) {
        StringBuilder sb = new StringBuilder("[");
        int i = 0;
        for (String s : col) {
            sb.append("\"").append(s.replace("\"", "\\\"")).append("\"");
            if (++i < col.size()) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String toJsonNumberArrayNoReverse(Collection<? extends Number> col) {
        StringBuilder sb = new StringBuilder("[");
        int i = 0;
        for (Number n : col) {
            sb.append(n != null ? n.toString() : "0");
            if (++i < col.size()) sb.append(",");
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

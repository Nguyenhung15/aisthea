package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.AnalyticsDAO;
import com.aisthea.fashion.listener.SessionListener;
import com.aisthea.fashion.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DashboardServlet", urlPatterns = { "/dashboard", "/admin/dashboard" })
public class DashboardServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(DashboardServlet.class.getName());
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
            // 1. Basic Stats
            int totalUsers = analyticsDAO.getTotalCustomers();
            int totalProducts = analyticsDAO.getTotalProductCount();
            int totalOrders = analyticsDAO.getTotalOrderCount();
            BigDecimal totalRevenue = analyticsDAO.getTotalRevenue();

            // Ensure the current admin is in the online list (Self-correction if server
            // restarted)
            if (user != null) {
                String identifier = user.getUsername();
                if (identifier == null || identifier.isEmpty())
                    identifier = user.getEmail();
                if (identifier != null && !identifier.isEmpty()) {
                    SessionListener.getOnlineUsers().add(identifier);
                }
            }
            Set<String> onlineUsers = SessionListener.getOnlineUsers();

            // 2. Revenue Contexts
            BigDecimal revenueToday = analyticsDAO.getRevenueToday();
            BigDecimal revenueThisWeek = analyticsDAO.getRevenueThisWeek();
            BigDecimal revenueThisMonth = analyticsDAO.getRevenueThisMonth();
            BigDecimal revenuePrevMonth = analyticsDAO.getRevenuePreviousMonth();

            double revenueGrowth = 0;
            if (revenuePrevMonth.compareTo(BigDecimal.ZERO) > 0) {
                revenueGrowth = revenueThisMonth.subtract(revenuePrevMonth)
                        .divide(revenuePrevMonth, 4, RoundingMode.HALF_UP)
                        .multiply(new BigDecimal(100)).doubleValue();
            }

            // 3. Performance
            String topProduct = analyticsDAO.getTopSellingProductName();

            // 4. Chart Content (Default Weekly)
            LinkedHashMap<String, BigDecimal> chartMap = analyticsDAO.getRevenueByDay(7);

            // Set attributes
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("onlineUsers", onlineUsers);

            request.setAttribute("revenueToday", revenueToday);
            request.setAttribute("revenueThisWeek", revenueThisWeek);
            request.setAttribute("revenueThisMonth", revenueThisMonth);
            request.setAttribute("revenueGrowth", (int) revenueGrowth);

            request.setAttribute("topProduct", topProduct);

            // Chart data conversion for initial load
            request.setAttribute("chartLabels", toJsonArray(chartMap.keySet()));
            request.setAttribute("chartData", toJsonNumberArray(chartMap.values()));

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in DashboardServlet GET", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String period = request.getParameter("period");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            LinkedHashMap<String, BigDecimal> data;
            BigDecimal total = BigDecimal.ZERO;

            if ("monthly".equals(period)) {
                data = analyticsDAO.getRevenueByDay(30);
            } else if ("yearly".equals(period)) {
                data = analyticsDAO.getRevenueByMonth(12);
            } else {
                data = analyticsDAO.getRevenueByDay(7);
            }

            for (BigDecimal val : data.values()) {
                total = total.add(val != null ? val : BigDecimal.ZERO);
            }

            String json = String.format(
                    "{\"labels\": %s, \"data\": %s, \"total\": \"$%s\"}",
                    toJsonArray(data.keySet()),
                    toJsonNumberArray(data.values()),
                    NumberFormat.getNumberInstance(Locale.US).format(total));
            out.print(json);
            out.flush();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in DashboardServlet POST", e);
            response.setStatus(500);
        }
    }

    private String toJsonArray(Collection<String> collection) {
        StringBuilder sb = new StringBuilder("[");
        List<String> list = new ArrayList<>(collection);
        Collections.reverse(list); // Reverse to show oldest to newest in Chart
        int i = 0;
        for (String item : list) {
            sb.append("\"").append(item).append("\"");
            if (++i < list.size())
                sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String toJsonNumberArray(Collection<? extends Number> collection) {
        StringBuilder sb = new StringBuilder("[");
        List<Number> list = new ArrayList<>(collection);
        Collections.reverse(list); // Chronological order
        int i = 0;
        for (Number item : list) {
            sb.append(item != null ? item.toString() : "0");
            if (++i < list.size())
                sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
}
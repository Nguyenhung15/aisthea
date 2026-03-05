package com.aisthea.fashion.dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AnalyticsDAO {
    private static final Logger logger = Logger.getLogger(AnalyticsDAO.class.getName());

    private BigDecimal getBigDecimal(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BigDecimal b = rs.getBigDecimal(1);
                return b != null ? b : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getBigDecimal: " + sql, e);
        }
        return BigDecimal.ZERO;
    }

    private int getInt(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getInt: " + sql, e);
        }
        return 0;
    }

    public BigDecimal getTotalRevenue() {
        return getBigDecimal("SELECT SUM(totalprice) FROM orders WHERE status = 'Completed'");
    }

    public BigDecimal getRevenueThisMonth() {
        return getBigDecimal("SELECT SUM(totalprice) FROM orders WHERE status = 'Completed' AND MONTH(createdat) = MONTH(GETDATE()) AND YEAR(createdat) = YEAR(GETDATE())");
    }

    public BigDecimal getRevenueToday() {
        return getBigDecimal("SELECT SUM(totalprice) FROM orders WHERE status = 'Completed' AND CAST(createdat AS DATE) = CAST(GETDATE() AS DATE)");
    }

    public BigDecimal getRevenuePreviousMonth() {
        return getBigDecimal("SELECT SUM(totalprice) FROM orders WHERE status = 'Completed' AND createdat >= DATEADD(month, DATEDIFF(month, 0, GETDATE()) - 1, 0) AND createdat < DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)");
    }

    public BigDecimal getRevenueThisWeek() {
        return getBigDecimal("SELECT SUM(totalprice) FROM orders WHERE status = 'Completed' AND createdat >= DATEADD(day, -7, GETDATE())");
    }

    public LinkedHashMap<String, Integer> getOrderCountsByDay(int days) {
        LinkedHashMap<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT TOP (?) CAST(createdat AS DATE) as d, COUNT(*) as counts FROM orders GROUP BY CAST(createdat AS DATE) ORDER BY d DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.put(rs.getString("d"), rs.getInt("counts"));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getOrderCountsByDay", e);
        }
        return result;
    }

    public LinkedHashMap<String, BigDecimal> getRevenueByMonth(int months) {
        LinkedHashMap<String, BigDecimal> result = new LinkedHashMap<>();
        String sql = "SELECT TOP (?) FORMAT(createdat, 'yyyy-MM') as m, SUM(totalprice) as r FROM orders WHERE status = 'Completed' GROUP BY FORMAT(createdat, 'yyyy-MM') ORDER BY m DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, months);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.put(rs.getString("m"), rs.getBigDecimal("r"));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getRevenueByMonth", e);
        }
        return result;
    }

    public LinkedHashMap<String, BigDecimal> getRevenueByDay(int days) {
        LinkedHashMap<String, BigDecimal> result = new LinkedHashMap<>();
        String sql = "SELECT TOP (?) CAST(createdat AS DATE) as d, SUM(totalprice) as rev FROM orders WHERE status = 'Completed' GROUP BY CAST(createdat AS DATE) ORDER BY d DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.put(rs.getString("d"), rs.getBigDecimal("rev"));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getRevenueByDay", e);
        }
        return result;
    }

    public LinkedHashMap<String, Integer> getOrderStatusCounts() {
        LinkedHashMap<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) as c FROM orders GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) result.put(rs.getString("status"), rs.getInt("c"));
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getOrderStatusCounts", e);
        }
        return result;
    }

    public int getTotalOrderCount() {
        return getInt("SELECT COUNT(*) FROM orders");
    }

    public int getCompletedOrderCount() {
        return getInt("SELECT COUNT(*) FROM orders WHERE status = 'Completed'");
    }

    public int getTotalProductCount() {
        return getInt("SELECT COUNT(*) FROM Products");
    }

    public List<Map<String, Object>> getTopSellingProducts(int top) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) product_name, SUM(quantity) as t_qty, SUM(quantity * price) as t_rev FROM orderitems GROUP BY product_name ORDER BY t_qty DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, top);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("name", rs.getString("product_name"));
                    m.put("totalQty", rs.getInt("t_qty"));
                    m.put("totalRevenue", rs.getBigDecimal("t_rev"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getTopSellingProducts", e);
        }
        return list;
    }

    public String getTopSellingProductName() {
        String sql = "SELECT TOP 1 product_name FROM orderitems GROUP BY product_name ORDER BY SUM(quantity) DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getString(1);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getTopSellingProductName", e);
        }
        return "\u2014";
    }

    public List<Map<String, Object>> getLowStockProducts(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.name, pcs.color, pcs.size, pcs.stock FROM Products p JOIN product_color_size pcs ON p.productid = pcs.productid WHERE pcs.stock < 20 ORDER BY pcs.stock ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("productName", rs.getString("name"));
                    m.put("color", rs.getString("color"));
                    m.put("size", rs.getString("size"));
                    m.put("stock", rs.getInt("stock"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getLowStockProducts", e);
        }
        return list;
    }

    public int getNewCustomersThisMonth() {
        return getInt("SELECT COUNT(*) FROM users WHERE MONTH(createdat) = MONTH(GETDATE()) AND YEAR(createdat) = YEAR(GETDATE())");
    }

    public int getTotalCustomers() {
        return getInt("SELECT COUNT(*) FROM users WHERE role = 'USER'");
    }

    public List<Map<String, Object>> getTopCustomersBySpending(int top) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) u.fullname, u.email, COUNT(o.orderid) as o_cnt, SUM(o.totalprice) as t_spent FROM orders o JOIN users u ON o.userid = u.userid WHERE o.status = 'Completed' GROUP BY u.fullname, u.email ORDER BY t_spent DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, top);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("fullname", rs.getString("fullname"));
                    m.put("email", rs.getString("email"));
                    m.put("orderCount", rs.getInt("o_cnt"));
                    m.put("totalSpent", rs.getBigDecimal("t_spent"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getTopCustomersBySpending", e);
        }
        return list;
    }
}

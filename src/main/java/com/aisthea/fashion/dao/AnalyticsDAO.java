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
        String sql = "SELECT * FROM (SELECT TOP (?) CAST(createdat AS DATE) as d, COUNT(*) as counts FROM orders GROUP BY CAST(createdat AS DATE) ORDER BY d DESC) AS t ORDER BY d ASC";
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
        String sql = "SELECT * FROM (SELECT TOP (?) LEFT(CONVERT(VARCHAR, createdat, 120), 7) as m, SUM(totalprice) as r FROM orders WHERE status = 'Completed' GROUP BY LEFT(CONVERT(VARCHAR, createdat, 120), 7) ORDER BY m DESC) AS t ORDER BY m ASC";
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
        String sql = "SELECT * FROM (SELECT TOP (?) CAST(createdat AS DATE) as d, SUM(totalprice) as rev FROM orders WHERE status = 'Completed' GROUP BY CAST(createdat AS DATE) ORDER BY d DESC) AS t ORDER BY d ASC";
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
        String sql = "SELECT TOP (?) COALESCE(p.name, oi.product_name) as display_name, "
                + "SUM(oi.quantity) as t_qty, SUM(oi.quantity * oi.price) as t_rev "
                + "FROM orderitems oi "
                + "LEFT JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid "
                + "LEFT JOIN Products p ON pcs.productid = p.productid "
                + "GROUP BY COALESCE(p.name, oi.product_name) "
                + "ORDER BY t_qty DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, top);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("name", rs.getString("display_name"));
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
        String sql = "SELECT TOP 1 COALESCE(p.name, oi.product_name) "
                + "FROM orderitems oi "
                + "LEFT JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid "
                + "LEFT JOIN Products p ON pcs.productid = p.productid "
                + "GROUP BY COALESCE(p.name, oi.product_name) "
                + "ORDER BY SUM(oi.quantity) DESC";
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

    // --- New Filtering Methods ---

    public BigDecimal getFilteredRevenue(String type, String value) {
        String sql;
        if ("YEAR".equalsIgnoreCase(type)) {
            sql = "SELECT SUM(totalprice) FROM orders WHERE status = 'Completed' AND YEAR(createdat) = ?";
        } else if ("MONTH".equalsIgnoreCase(type)) {
            sql = "SELECT SUM(totalprice) FROM orders WHERE status = 'Completed' AND YEAR(createdat) = ? AND MONTH(createdat) = ?";
        } else if ("DAY".equalsIgnoreCase(type)) {
            sql = "SELECT SUM(totalprice) FROM orders WHERE status = 'Completed' AND CAST(createdat AS DATE) = ?";
        } else {
            return getTotalRevenue();
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if ("YEAR".equalsIgnoreCase(type)) {
                ps.setInt(1, Integer.parseInt(value));
            } else if ("MONTH".equalsIgnoreCase(type)) {
                String[] parts = value.split("-");
                ps.setInt(1, Integer.parseInt(parts[0]));
                ps.setInt(2, Integer.parseInt(parts[1]));
            } else if ("DAY".equalsIgnoreCase(type)) {
                ps.setDate(1, java.sql.Date.valueOf(value));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal b = rs.getBigDecimal(1);
                    return b != null ? b : BigDecimal.ZERO;
                }
            }
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getFilteredRevenue", e);
        }
        return BigDecimal.ZERO;
    }

    public int getFilteredOrderCount(String type, String value) {
        String sql;
        if ("YEAR".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM orders WHERE YEAR(createdat) = ?";
        } else if ("MONTH".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM orders WHERE YEAR(createdat) = ? AND MONTH(createdat) = ?";
        } else if ("DAY".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM orders WHERE CAST(createdat AS DATE) = ?";
        } else {
            return getTotalOrderCount();
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if ("YEAR".equalsIgnoreCase(type)) {
                ps.setInt(1, Integer.parseInt(value));
            } else if ("MONTH".equalsIgnoreCase(type)) {
                String[] parts = value.split("-");
                ps.setInt(1, Integer.parseInt(parts[0]));
                ps.setInt(2, Integer.parseInt(parts[1]));
            } else if ("DAY".equalsIgnoreCase(type)) {
                ps.setDate(1, java.sql.Date.valueOf(value));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getFilteredOrderCount", e);
        }
        return 0;
    }

    public int getFilteredCompletedOrderCount(String type, String value) {
        String sql;
        if ("YEAR".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM orders WHERE status = 'Completed' AND YEAR(createdat) = ?";
        } else if ("MONTH".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM orders WHERE status = 'Completed' AND YEAR(createdat) = ? AND MONTH(createdat) = ?";
        } else if ("DAY".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM orders WHERE status = 'Completed' AND CAST(createdat AS DATE) = ?";
        } else {
            return getCompletedOrderCount();
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if ("YEAR".equalsIgnoreCase(type)) {
                ps.setInt(1, Integer.parseInt(value));
            } else if ("MONTH".equalsIgnoreCase(type)) {
                String[] parts = value.split("-");
                ps.setInt(1, Integer.parseInt(parts[0]));
                ps.setInt(2, Integer.parseInt(parts[1]));
            } else if ("DAY".equalsIgnoreCase(type)) {
                ps.setDate(1, java.sql.Date.valueOf(value));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getFilteredCompletedOrderCount", e);
        }
        return 0;
    }

    public LinkedHashMap<String, BigDecimal> getRevenueBreakdown(String type, String value) {
        LinkedHashMap<String, BigDecimal> result = new LinkedHashMap<>();
        String sql = "";
        if ("YEAR".equalsIgnoreCase(type)) {
            sql = "SELECT LEFT(CONVERT(VARCHAR, createdat, 120), 7) as m, SUM(totalprice) as r FROM orders WHERE status = 'Completed' AND YEAR(createdat) = ? GROUP BY LEFT(CONVERT(VARCHAR, createdat, 120), 7) ORDER BY m ASC";
        } else if ("MONTH".equalsIgnoreCase(type)) {
            sql = "SELECT CAST(createdat AS DATE) as d, SUM(totalprice) as r FROM orders WHERE status = 'Completed' AND YEAR(createdat) = ? AND MONTH(createdat) = ? GROUP BY CAST(createdat AS DATE) ORDER BY d ASC";
        } else if ("DAY".equalsIgnoreCase(type)) {
            sql = "SELECT DATEPART(HOUR, createdat) as h, SUM(totalprice) as r FROM orders WHERE status = 'Completed' AND CAST(createdat AS DATE) = ? GROUP BY DATEPART(HOUR, createdat) ORDER BY h ASC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (sql.isEmpty()) return result;
            if ("YEAR".equalsIgnoreCase(type)) {
                ps.setInt(1, Integer.parseInt(value));
            } else if ("MONTH".equalsIgnoreCase(type)) {
                String[] parts = value.split("-");
                ps.setInt(1, Integer.parseInt(parts[0]));
                ps.setInt(2, Integer.parseInt(parts[1]));
            } else if ("DAY".equalsIgnoreCase(type)) {
                ps.setDate(1, java.sql.Date.valueOf(value));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String label;
                    if ("YEAR".equalsIgnoreCase(type)) label = rs.getString("m");
                    else if ("MONTH".equalsIgnoreCase(type)) label = rs.getString("d");
                    else label = rs.getString("h") + ":00";
                    result.put(label, rs.getBigDecimal("r"));
                }
            }
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getRevenueBreakdown", e);
        }
        return result;
    }

    public LinkedHashMap<String, Integer> getOrderBreakdown(String type, String value) {
        LinkedHashMap<String, Integer> result = new LinkedHashMap<>();
        String sql = "";
        if ("YEAR".equalsIgnoreCase(type)) {
            sql = "SELECT LEFT(CONVERT(VARCHAR, createdat, 120), 7) as m, COUNT(*) as c FROM orders WHERE YEAR(createdat) = ? GROUP BY LEFT(CONVERT(VARCHAR, createdat, 120), 7) ORDER BY m ASC";
        } else if ("MONTH".equalsIgnoreCase(type)) {
            sql = "SELECT CAST(createdat AS DATE) as d, COUNT(*) as c FROM orders WHERE YEAR(createdat) = ? AND MONTH(createdat) = ? GROUP BY CAST(createdat AS DATE) ORDER BY d ASC";
        } else if ("DAY".equalsIgnoreCase(type)) {
            sql = "SELECT DATEPART(HOUR, createdat) as h, COUNT(*) as c FROM orders WHERE CAST(createdat AS DATE) = ? GROUP BY DATEPART(HOUR, createdat) ORDER BY h ASC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (sql.isEmpty()) return result;
            if ("YEAR".equalsIgnoreCase(type)) {
                ps.setInt(1, Integer.parseInt(value));
            } else if ("MONTH".equalsIgnoreCase(type)) {
                String[] parts = value.split("-");
                ps.setInt(1, Integer.parseInt(parts[0]));
                ps.setInt(2, Integer.parseInt(parts[1]));
            } else if ("DAY".equalsIgnoreCase(type)) {
                ps.setDate(1, java.sql.Date.valueOf(value));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String label;
                    if ("YEAR".equalsIgnoreCase(type)) label = rs.getString("m");
                    else if ("MONTH".equalsIgnoreCase(type)) label = rs.getString("d");
                    else label = rs.getString("h") + ":00";
                    result.put(label, rs.getInt("c"));
                }
            }
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getOrderBreakdown", e);
        }
        return result;
    }

    public LinkedHashMap<String, Integer> getFilteredOrderStatusCounts(String type, String value) {
        LinkedHashMap<String, Integer> result = new LinkedHashMap<>();
        String sql;
        if ("YEAR".equalsIgnoreCase(type)) {
            sql = "SELECT status, COUNT(*) as c FROM orders WHERE YEAR(createdat) = ? GROUP BY status";
        } else if ("MONTH".equalsIgnoreCase(type)) {
            sql = "SELECT status, COUNT(*) as c FROM orders WHERE YEAR(createdat) = ? AND MONTH(createdat) = ? GROUP BY status";
        } else if ("DAY".equalsIgnoreCase(type)) {
            sql = "SELECT status, COUNT(*) as c FROM orders WHERE CAST(createdat AS DATE) = ? GROUP BY status";
        } else {
            return getOrderStatusCounts();
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if ("YEAR".equalsIgnoreCase(type)) {
                ps.setInt(1, Integer.parseInt(value));
            } else if ("MONTH".equalsIgnoreCase(type)) {
                String[] parts = value.split("-");
                ps.setInt(1, Integer.parseInt(parts[0]));
                ps.setInt(2, Integer.parseInt(parts[1]));
            } else if ("DAY".equalsIgnoreCase(type)) {
                ps.setDate(1, java.sql.Date.valueOf(value));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.put(rs.getString("status"), rs.getInt("c"));
            }
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getFilteredOrderStatusCounts", e);
        }
        return result;
    }

    public List<Map<String, Object>> getFilteredTopSellingProducts(int top, String type, String value) {
        List<Map<String, Object>> list = new ArrayList<>();
        String filterClause = "";
        if ("YEAR".equalsIgnoreCase(type)) filterClause = "AND YEAR(o.createdat) = ?";
        else if ("MONTH".equalsIgnoreCase(type)) filterClause = "AND YEAR(o.createdat) = ? AND MONTH(o.createdat) = ?";
        else if ("DAY".equalsIgnoreCase(type)) filterClause = "AND CAST(o.createdat AS DATE) = ?";

        String sql = "SELECT TOP (?) COALESCE(p.name, oi.product_name) as display_name, "
                + "SUM(oi.quantity) as t_qty, SUM(oi.quantity * oi.price) as t_rev "
                + "FROM orderitems oi "
                + "JOIN orders o ON oi.orderid = o.orderid "
                + "LEFT JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid "
                + "LEFT JOIN Products p ON pcs.productid = p.productid "
                + "WHERE o.status = 'Completed' " + filterClause + " "
                + "GROUP BY COALESCE(p.name, oi.product_name) "
                + "ORDER BY t_qty DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, top);
            if (!filterClause.isEmpty()) {
                if ("YEAR".equalsIgnoreCase(type)) {
                    ps.setInt(2, Integer.parseInt(value));
                } else if ("MONTH".equalsIgnoreCase(type)) {
                    String[] parts = value.split("-");
                    ps.setInt(2, Integer.parseInt(parts[0]));
                    ps.setInt(3, Integer.parseInt(parts[1]));
                } else if ("DAY".equalsIgnoreCase(type)) {
                    ps.setDate(2, java.sql.Date.valueOf(value));
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("name", rs.getString("display_name"));
                    m.put("totalQty", rs.getInt("t_qty"));
                    m.put("totalRevenue", rs.getBigDecimal("t_rev"));
                    list.add(m);
                }
            }
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getFilteredTopSellingProducts", e);
        }
        return list;
    }

    public List<Map<String, Object>> getFilteredTopCustomersBySpending(int top, String type, String value) {
        List<Map<String, Object>> list = new ArrayList<>();
        String filterClause = "";
        if ("YEAR".equalsIgnoreCase(type)) filterClause = "AND YEAR(o.createdat) = ?";
        else if ("MONTH".equalsIgnoreCase(type)) filterClause = "AND YEAR(o.createdat) = ? AND MONTH(o.createdat) = ?";
        else if ("DAY".equalsIgnoreCase(type)) filterClause = "AND CAST(o.createdat AS DATE) = ?";

        String sql = "SELECT TOP (?) u.fullname, u.email, COUNT(o.orderid) as o_cnt, SUM(o.totalprice) as t_spent "
                + "FROM orders o JOIN users u ON o.userid = u.userid "
                + "WHERE o.status = 'Completed' " + filterClause + " "
                + "GROUP BY u.fullname, u.email ORDER BY t_spent DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, top);
            if (!filterClause.isEmpty()) {
                if ("YEAR".equalsIgnoreCase(type)) {
                    ps.setInt(2, Integer.parseInt(value));
                } else if ("MONTH".equalsIgnoreCase(type)) {
                    String[] parts = value.split("-");
                    ps.setInt(2, Integer.parseInt(parts[0]));
                    ps.setInt(3, Integer.parseInt(parts[1]));
                } else if ("DAY".equalsIgnoreCase(type)) {
                    ps.setDate(2, java.sql.Date.valueOf(value));
                }
            }
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
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getFilteredTopCustomersBySpending", e);
        }
        return list;
    }

    public int getFilteredCustomerCount(String type, String value) {
        String sql;
        if ("YEAR".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM users WHERE role = 'USER' AND YEAR(createdat) = ?";
        } else if ("MONTH".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM users WHERE role = 'USER' AND YEAR(createdat) = ? AND MONTH(createdat) = ?";
        } else if ("DAY".equalsIgnoreCase(type)) {
            sql = "SELECT COUNT(*) FROM users WHERE role = 'USER' AND CAST(createdat AS DATE) = ?";
        } else {
            return getTotalCustomers();
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if ("YEAR".equalsIgnoreCase(type)) {
                ps.setInt(1, Integer.parseInt(value));
            } else if ("MONTH".equalsIgnoreCase(type)) {
                String[] parts = value.split("-");
                ps.setInt(1, Integer.parseInt(parts[0]));
                ps.setInt(2, Integer.parseInt(parts[1]));
            } else if ("DAY".equalsIgnoreCase(type)) {
                ps.setDate(1, java.sql.Date.valueOf(value));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException | NumberFormatException e) {
            logger.log(Level.SEVERE, "Error in getFilteredCustomerCount", e);
        }
        return 0;
    }
}

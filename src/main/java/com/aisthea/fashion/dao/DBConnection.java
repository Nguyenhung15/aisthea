package com.aisthea.fashion.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static String url = "jdbc:sqlserver://localhost:1433;databaseName=AISTHEA;encrypt=false";
    private static String username = "sa";
    private static String password = "12345";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            System.err.println("❌ DB DRIVER NOT FOUND: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ DB CONNECTION FAILED: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }

    // 👉 Thêm cái này để test
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("🎉 Test connection SUCCESS");
        } else {
            System.out.println("❌ Connection FAILED");
        }
    }
}

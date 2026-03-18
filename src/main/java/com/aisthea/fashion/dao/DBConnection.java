package com.aisthea.fashion.dao;

import com.aisthea.fashion.config.DatabaseConfig;
import java.sql.Connection;

public class DBConnection {

    public static Connection getConnection() {
        try {
            return DatabaseConfig.getConnection();
        } catch (Exception e) {
            System.err.println("❌ DB CONNECTION FAILED: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
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

package com.aisthea.fashion.listener;

import com.aisthea.fashion.config.DatabaseConfig;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;

@WebListener
public class AppConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🚀 AppConfigListener: Đang khởi tạo các cấu hình hệ thống (Initializes Config)...");
        try {
            // Trigger DatabaseConfig initialization
            Connection conn = DatabaseConfig.getConnection();
            if (conn != null) {
                System.out.println("✅ AppConfigListener: Cấu hình Database Pool (HikariCP) khởi tạo thành công!");
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("❌ AppConfigListener: Khởi tạo DatabaseConfig thất bại!");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("🛑 AppConfigListener: Đóng các cấu hình hệ thống và giải phóng tài nguyên...");
        DatabaseConfig.closeDataSource();
    }
}

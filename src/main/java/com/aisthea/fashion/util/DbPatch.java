package com.aisthea.fashion.util;

import com.aisthea.fashion.dao.DBConnection;
import java.sql.*;

public class DbPatch {
    public static void main(String[] args) {
        System.out.println("🚀 Starting DB Patch...");
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement()) {

            checkAndAddColumn(conn, "feedback", "is_verified", "BIT DEFAULT 0");
            checkAndAddColumn(conn, "feedback", "image_url", "NVARCHAR(MAX)");
            checkAndAddColumn(conn, "feedback", "helpful_count", "INT DEFAULT 0");
            checkAndAddColumn(conn, "feedback", "admin_reply", "NVARCHAR(MAX)");
            checkAndAddColumn(conn, "feedback", "replied_at", "DATETIME");
            checkAndAddColumn(conn, "feedback", "updatedat", "DATETIME DEFAULT GETDATE()");

            System.out.println("✅ DB Patch completed successfully!");

        } catch (Exception e) {
            System.err.println("❌ DB Patch FAILED: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void checkAndAddColumn(Connection conn, String tableName, String columnName, String type)
            throws SQLException {
        DatabaseMetaData meta = conn.getMetaData();
        try (ResultSet rs = meta.getColumns(null, null, tableName, columnName)) {
            if (!rs.next()) {
                System.out.println("➕ Adding column " + columnName + " to " + tableName);
                String sql = "ALTER TABLE " + tableName + " ADD " + columnName + " " + type;
                try (Statement s = conn.createStatement()) {
                    s.execute(sql);
                }
            } else {
                System.out.println("✔ Column " + columnName + " already exists in " + tableName);
            }
        }
    }
}

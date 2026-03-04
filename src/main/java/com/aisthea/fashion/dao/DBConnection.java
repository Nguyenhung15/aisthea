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
            System.out.println("✅ Connected to SQL Server");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}

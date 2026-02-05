package com.aisthea.fashion.dao;

import com.aisthea.fashion.config.DatabaseConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Database Connection Manager
 * Now uses DatabaseConfig with HikariCP connection pooling
 * 
 * @deprecated Consider using DatabaseConfig.getConnection() directly for better
 *             clarity
 */
public class DBConnection {
    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);

    /**
     * Get a database connection from the pool
     * This method now delegates to DatabaseConfig which uses HikariCP
     * 
     * @return Database connection from the pool
     */
    public static Connection getConnection() {
        try {
            Connection conn = DatabaseConfig.getConnection();
            logger.debug("✅ Database connection acquired successfully");
            return conn;
        } catch (SQLException e) {
            logger.error("❌ Failed to get database connection", e);
            throw new RuntimeException("Failed to get database connection", e);
        }
    }
}

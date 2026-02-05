package com.aisthea.fashion.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Database Configuration with Connection Pooling
 * Uses HikariCP for efficient connection management
 */
public class DatabaseConfig {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseConfig.class);
    private static HikariDataSource dataSource;

    static {
        initializeDataSource();
    }

    /**
     * Initialize HikariCP DataSource
     */
    private static void initializeDataSource() {
        try {
            HikariConfig config = new HikariConfig();

            // Database connection settings
            config.setJdbcUrl(AppConfig.getProperty("db.url"));
            config.setUsername(AppConfig.getProperty("db.username"));
            config.setPassword(AppConfig.getProperty("db.password"));
            config.setDriverClassName(AppConfig.getProperty("db.driver",
                    "com.microsoft.sqlserver.jdbc.SQLServerDriver"));

            // Connection pool settings
            config.setMinimumIdle(AppConfig.getPropertyAsInt("db.pool.minimumIdle", 5));
            config.setMaximumPoolSize(AppConfig.getPropertyAsInt("db.pool.maximumPoolSize", 20));
            config.setConnectionTimeout(AppConfig.getPropertyAsLong("db.pool.connectionTimeout", 30000));
            config.setIdleTimeout(AppConfig.getPropertyAsLong("db.pool.idleTimeout", 600000));
            config.setMaxLifetime(AppConfig.getPropertyAsLong("db.pool.maxLifetime", 1800000));

            // Performance and reliability settings
            config.setConnectionTestQuery("SELECT 1");
            config.setPoolName("AistheaHikariPool");
            config.setAutoCommit(true);

            // Leak detection (for development)
            if ("development".equals(AppConfig.getEnvironment())) {
                config.setLeakDetectionThreshold(60000); // 60 seconds
            }

            dataSource = new HikariDataSource(config);

            logger.info("✅ Database connection pool initialized successfully");
            logger.info("   - JDBC URL: {}", maskPassword(config.getJdbcUrl()));
            logger.info("   - Pool Size: {} - {}", config.getMinimumIdle(), config.getMaximumPoolSize());
            logger.info("   - Environment: {}", AppConfig.getEnvironment());

        } catch (Exception e) {
            logger.error("❌ Failed to initialize database connection pool", e);
            throw new RuntimeException("Failed to initialize database connection pool", e);
        }
    }

    /**
     * Get a database connection from the pool
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource is not initialized");
        }

        Connection conn = dataSource.getConnection();
        logger.debug("Connection acquired from pool. Active connections: {}",
                dataSource.getHikariPoolMXBean().getActiveConnections());

        return conn;
    }

    /**
     * Get the DataSource instance
     */
    public static DataSource getDataSource() {
        return dataSource;
    }

    /**
     * Close the connection pool (call on application shutdown)
     */
    public static void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            logger.info("✅ Database connection pool closed");
        }
    }

    /**
     * Get pool statistics (for monitoring)
     */
    public static String getPoolStats() {
        if (dataSource != null) {
            return String.format(
                    "Pool Stats - Active: %d, Idle: %d, Total: %d, Waiting: %d",
                    dataSource.getHikariPoolMXBean().getActiveConnections(),
                    dataSource.getHikariPoolMXBean().getIdleConnections(),
                    dataSource.getHikariPoolMXBean().getTotalConnections(),
                    dataSource.getHikariPoolMXBean().getThreadsAwaitingConnection());
        }
        return "DataSource not initialized";
    }

    /**
     * Mask password in JDBC URL for logging
     */
    private static String maskPassword(String jdbcUrl) {
        return jdbcUrl.replaceAll("password=[^;]+", "password=***");
    }

    /**
     * Test database connectivity
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            boolean isValid = conn.isValid(5);
            logger.info("Database connection test: {}", isValid ? "SUCCESS" : "FAILED");
            return isValid;
        } catch (SQLException e) {
            logger.error("Database connection test failed", e);
            return false;
        }
    }
}

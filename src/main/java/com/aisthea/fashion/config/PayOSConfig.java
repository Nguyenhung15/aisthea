package com.aisthea.fashion.config;

import vn.payos.PayOS;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Configuration for PayOS payment gateway.
 * All credentials are read dynamically from application.properties via AppConfig.
 */
public class PayOSConfig {

    private static PayOS payOS;

    /**
     * Get the PayOS client ID
     */
    public static String getClientId() {
        return AppConfig.getProperty("payment.payos.client.id", "");
    }

    /**
     * Get the PayOS API key
     */
    public static String getApiKey() {
        return AppConfig.getProperty("payment.payos.api.key", "");
    }

    /**
     * Get the PayOS Checksum key
     */
    public static String getChecksumKey() {
        return AppConfig.getProperty("payment.payos.checksum.key", "");
    }

    /**
     * Get the singleton instance of PayOS
     */
    public static PayOS getPayOS() {
        if (payOS == null) {
            String clientId = getClientId().trim();
            String apiKey = getApiKey().trim();
            String checksumKey = getChecksumKey().trim();
            payOS = new PayOS(clientId, apiKey, checksumKey);
        }
        return payOS;
    }

    /**
     * Utility to get the base URL of the application
     */
    public static String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);

        if ((scheme.equals("http") && serverPort != 80) || (scheme.equals("https") && serverPort != 443)) {
            url.append(":").append(serverPort);
        }

        url.append(contextPath);
        return url.toString();
    }
}

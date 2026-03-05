package com.aisthea.fashion.utils;

import vn.payos.PayOS;
import jakarta.servlet.http.HttpServletRequest;

public class PayOSConfig {
    public static final String CLIENT_ID = "524c7ee3-ecba-4145-840a-287cfaeb11e8";
    public static final String API_KEY = "d9566a21-54ac-49fb-84b4-82f925c74b9e";
    public static final String CHECKSUM_KEY = "3e20efca9bf18e92b05569bc74936cc686ce777540553ad8b766d620302fdd2c";

    private static PayOS payOS;

    public static PayOS getPayOS() {
        if (payOS == null) {
            payOS = new PayOS(CLIENT_ID.trim(), API_KEY.trim(), CHECKSUM_KEY.trim());
        }
        return payOS;
    }

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

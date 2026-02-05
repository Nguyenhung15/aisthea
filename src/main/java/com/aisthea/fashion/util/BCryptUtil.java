package com.aisthea.fashion.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * BCrypt password hashing utility
 */
public class BCryptUtil {

    /**
     * Hash a plain text password using BCrypt
     * 
     * @param plainText The plain text password
     * @return BCrypt hashed password, or null if input is null/empty
     */
    public static String hashPassword(String plainText) {
        if (plainText == null || plainText.isEmpty()) {
            return null;
        }
        return BCrypt.hashpw(plainText, BCrypt.gensalt(12)); // cost factor 12
    }

    /**
     * Verify a plain text password against a BCrypt hash
     * 
     * @param plainText The plain text password to check
     * @param hashed    The BCrypt hash to verify against
     * @return true if password matches, false otherwise
     */
    public static boolean checkPassword(String plainText, String hashed) {
        if (plainText == null || hashed == null) {
            return false;
        }

        try {
            return BCrypt.checkpw(plainText, hashed);
        } catch (IllegalArgumentException ex) {
            // Hash format is invalid
            System.err.println("Invalid BCrypt hash format: " + ex.getMessage());
            return false;
        }
    }
}

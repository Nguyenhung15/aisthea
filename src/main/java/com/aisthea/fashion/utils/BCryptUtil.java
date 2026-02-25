package com.aisthea.fashion.utils;

import org.mindrot.jbcrypt.BCrypt;

public class BCryptUtil {

    // Mã hoá mật khẩu
    public static String hashPassword(String plainText) {
        if (plainText == null || plainText.isEmpty()) return null;
        return BCrypt.hashpw(plainText, BCrypt.gensalt(12)); // cost 12
    }

    // Kiểm tra mật khẩu nhập vào với mật khẩu hash trong DB
    public static boolean checkPassword(String plainText, String hashed) {
        if (plainText == null || hashed == null) return false;
        // BCrypt.checkpw sẽ throw IllegalArgumentException nếu hashed không phải định dạng BCrypt hợp lệ
        try {
            return BCrypt.checkpw(plainText, hashed);
        } catch (IllegalArgumentException ex) {
            // log để debug nếu hash trong DB bị hỏng/thiếu ký tự
            ex.printStackTrace();
            return false;
        }
    }
}

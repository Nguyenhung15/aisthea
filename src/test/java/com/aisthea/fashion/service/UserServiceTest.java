package com.aisthea.fashion.service;

import com.aisthea.fashion.model.LoginResult;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class UserServiceTest {

    private UserService userService;

    @BeforeEach
    public void setup() {
        userService = new UserService();
    }

    @Test
    public void testLogin_SaiMatKhau_KiemTraThongBaoLoi() {
        System.out.println(">>> [Bắt đầu Test] Đang gọi UserService.login() với Password sai...");
        
        // Dữ liệu đầu vào: Email đúng nhưng Password sai
        String email = "admin@aisthea.com"; 
        String wrongPassword = "SaiPassword123!";

        // Thực thi hàm login 
        LoginResult result = userService.login(email, wrongPassword);

        // Kì vọng: Login thất bại, Trả về đúng câu cảnh báo trong UserService.java
        assertFalse(result.isSuccess(), "Trạng thái Success phải là false");
        assertEquals("Sai mật khẩu. Vui lòng thử lại.", result.getMessage(), "Hệ thống báo câu lỗi không khớp");
        
        System.out.println(">>> [Hoàn thành Test] Logic bắt lỗi mật khẩu hoạt động hoàn hảo: " + result.getMessage());
    }
}

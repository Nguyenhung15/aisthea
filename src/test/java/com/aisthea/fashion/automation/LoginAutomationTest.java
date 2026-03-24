package com.aisthea.fashion.automation;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import java.time.Duration;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class LoginAutomationTest {

    @Test
    public void testLogin_PasswordKhongHopLe_UiHienThiLoi() throws InterruptedException {
        WebDriver driver = new ChromeDriver();
        
        try {
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            driver.manage().window().maximize();
            
            System.out.println(">>> Mở trang Đăng Nhập Hệ thống Aisthea Fashion...");
            driver.get("http://localhost:8080/AistheaFashion/login"); 
            
            Thread.sleep(1500);

            System.out.println(">>> Tự động điền Form Đăng Nhập...");
            // Bản FIX: Chỉ định rỏ lấy ô input của class sign-in-container (Vì DOM có 2 thẻ name="email")
            driver.findElement(By.cssSelector(".sign-in-container input[name='email']"))
                  .sendKeys("testtuyennq@google.com");
            Thread.sleep(1000); 
            
            driver.findElement(By.cssSelector(".sign-in-container input[name='password']"))
                  .sendKeys("SaiMatKhauTungTe123");
            Thread.sleep(1000); 
            
            System.out.println(">>> Tự động Click Đăng nhập!");
            driver.findElement(By.xpath("//div[contains(@class, 'sign-in-container')]//button[@type='submit' and contains(text(), 'Đăng nhập')]")).click();

            Thread.sleep(2000); 

            String pageSource = driver.getPageSource();
            assertTrue(pageSource.contains("class=\"error\""), "Lỗi đỏ không hiện trên giao diện!");
            
            System.out.println(">>> Test Kịch bản Đăng Nhập Thất bại: PASS!");
        } finally {
            Thread.sleep(1000); 
            driver.quit(); 
        }
    }
}

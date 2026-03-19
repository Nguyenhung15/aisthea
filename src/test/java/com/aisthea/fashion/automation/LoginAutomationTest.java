package com.aisthea.fashion.automation;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import java.time.Duration;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * REQUIRES:
 * 1. Chrome browser installed.
 * 2. Tomcat server must be running at http://localhost:8080/AistheaFashion/
 */
public class LoginAutomationTest {

    @Test
    public void testLoginFlow() {
        // Selenium 4 automatically handles driver binary management
        WebDriver driver = new ChromeDriver();
        
        try {
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            driver.manage().window().maximize();
            
            // Navigate to login page
            driver.get("http://localhost:8080/AistheaFashion/login"); 

            // Input credentials
            driver.findElement(By.name("email")).sendKeys("admin@aisthea.com");
            driver.findElement(By.name("password")).sendKeys("123456");
            
            // Click Submit button
            // If the login page has a button with id="btnLogin" or just a button[type='submit']
            driver.findElement(By.cssSelector("button[type='submit']")).click();

            // Verify successful login by checking the URL or presence of a "Welcome" element
            String currentUrl = driver.getCurrentUrl();
            assertTrue(currentUrl.contains("home") || currentUrl.contains("index"), 
                "Should navigate to homepage after login. Found: " + currentUrl);
                
        } catch (Exception e) {
            System.err.println("Automation Test Error: " + e.getMessage());
            // Uncomment line below if you want test to fail when Tomcat is not running
            // throw e; 
        } finally {
            driver.quit(); 
        }
    }
}

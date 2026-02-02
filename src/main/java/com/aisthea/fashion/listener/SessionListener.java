package com.aisthea.fashion.listener;

import com.aisthea.fashion.model.User;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionAttributeListener;
import jakarta.servlet.http.HttpSessionBindingEvent;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@WebListener
public class SessionListener implements HttpSessionListener, HttpSessionAttributeListener {

    private static final AtomicInteger activeSessions = new AtomicInteger(0);
    // Dùng ConcurrentHashMap để thread-safe
    private static final Set<String> onlineUsers = ConcurrentHashMap.newKeySet();

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        activeSessions.incrementAndGet();
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        if (activeSessions.get() > 0) {
            activeSessions.decrementAndGet();
        }

        // Khi session hủy, cố gắng lấy user để remove khỏi danh sách online
        removeUserFromOnlineList(se.getSession());
    }

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        addUserToOnlineList(event);
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        removeUserFromOnlineList(event.getSession());
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        // Khi user đăng nhập lại hoặc thay đổi thông tin trong session
        // Remove user cũ (giá trị trước khi replace)
        if ("user".equals(event.getName()) || "username".equals(event.getName())) {
            Object oldVal = event.getValue();
            String oldUsername = extractUsername(oldVal);
            if (oldUsername != null) {
                onlineUsers.remove(oldUsername);
            }

            // Add user mới (giá trị hiện tại trong session)
            addUserToOnlineList(event);
        }
    }

    // --- Helper Methods ---
    private void addUserToOnlineList(HttpSessionBindingEvent event) {
        String username = null;
        // Kiểm tra nếu attribute là "user" (object) hoặc "username" (string)
        if ("user".equals(event.getName())) {
            User user = (User) event.getValue();
            if (user != null) {
                username = user.getUsername(); // Hoặc user.getFullname() tùy bạn
            }
        } else if ("username".equals(event.getName())) {
            username = (String) event.getValue();
        }

        if (username != null) {
            onlineUsers.add(username);
        }
    }

    private void removeUserFromOnlineList(HttpSession session) {
        // Thử lấy cả "user" và "username" để remove cho chắc chắn
        try {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                onlineUsers.remove(user.getUsername());
            }

            String username = (String) session.getAttribute("username");
            if (username != null) {
                onlineUsers.remove(username);
            }
        } catch (Exception e) {
            // Session có thể đã invalidated, bỏ qua lỗi
        }
    }

    private String extractUsername(Object val) {
        if (val instanceof User) {
            return ((User) val).getUsername();
        }
        if (val instanceof String) {
            return (String) val;
        }
        return null;
    }

    // --- Static Getters cho DashboardServlet ---
    public static int getActiveUsers() { // Giữ tên hàm này để khớp với DashboardServlet
        return activeSessions.get();
    }

    public static Set<String> getOnlineUsers() {
        return onlineUsers;
    }
}

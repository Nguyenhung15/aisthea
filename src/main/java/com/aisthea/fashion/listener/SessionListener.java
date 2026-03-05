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
        String identifier = null;
        if ("user".equals(event.getName())) {
            User user = (User) event.getValue();
            if (user != null) {
                // Ưu tiên username, sau đó email, cuối cùng là fullname
                identifier = user.getUsername();
                if (identifier == null || identifier.trim().isEmpty()) {
                    identifier = user.getEmail();
                }
                if (identifier == null || identifier.trim().isEmpty()) {
                    identifier = user.getFullname();
                }
            }
        } else if ("username".equals(event.getName())) {
            identifier = (String) event.getValue();
        }

        if (identifier != null && !identifier.trim().isEmpty()) {
            onlineUsers.add(identifier);
            System.out.println(
                    "LOG: User added to online list: " + identifier + ". Current total: " + onlineUsers.size());
        }
    }

    private void removeUserFromOnlineList(HttpSession session) {
        try {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                onlineUsers.remove(user.getUsername());
                onlineUsers.remove(user.getEmail());
                onlineUsers.remove(user.getFullname());
            }

            String username = (String) session.getAttribute("username");
            if (username != null) {
                onlineUsers.remove(username);
            }
        } catch (Exception e) {
            // Session invalidated
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

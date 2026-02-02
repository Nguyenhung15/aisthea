package com.aisthea.fashion.controller;

import com.aisthea.fashion.listener.SessionListener;
import com.aisthea.fashion.model.Order;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

public class DashboardServlet extends HttpServlet {

    private IOrderService orderService;
    private IProductService productService;
    private IUserService userService;

    @Override
    public void init() {
        this.orderService = new OrderService();
        this.productService = new ProductService();
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().equalsIgnoreCase("USER")) { 
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int totalUsers = userService.selectAllUsers().size(); 
        int totalProducts = productService.getAllProducts().size();
        int totalOrders = orderService.getTotalOrderCount();
        BigDecimal totalRevenue = orderService.getTotalRevenue();
        List<Order> recentOrders = orderService.getRecentOrders(5);
        
        Set<String> onlineUsers = SessionListener.getOnlineUsers();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("onlineUsers", onlineUsers);
        request.setAttribute("activeSessions", SessionListener.getActiveUsers());

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
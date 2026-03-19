package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.util.CartStore;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            // Save cart to in-memory store for logged-in customers only.
            // Guest carts are not persisted (no userId to key on).
            User user = (User) session.getAttribute("user");
            if (user != null) {
                Cart cart = (Cart) session.getAttribute("cart");
                CartStore.save(user.getUserId(), cart);
            }

            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

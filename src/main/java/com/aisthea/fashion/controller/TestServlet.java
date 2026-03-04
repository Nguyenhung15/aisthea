package com.aisthea.fashion.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "TestServlet", urlPatterns = { "/test" })
public class TestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Test Servlet to verify new JSP deployment
        request.setAttribute("testMessage", "This is the NEW VERSION!");
        request.getRequestDispatcher("/WEB-INF/views/product/product-list-new.jsp").forward(request, response);
    }
}

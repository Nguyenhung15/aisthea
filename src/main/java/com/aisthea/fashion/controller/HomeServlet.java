package com.aisthea.fashion.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for handling homepage requests.
 * Maps to "/" — must skip static resource requests so they are served by the
 * default servlet.
 */
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // Let the default servlet handle static files (css, js, images, fonts, uploads,
        // etc.)
        if (path != null && (path.startsWith("/assets") ||
                path.startsWith("/css") ||
                path.startsWith("/js") ||
                path.startsWith("/images") ||
                path.startsWith("/uploads") ||
                path.startsWith("/fonts") ||
                path.endsWith(".css") ||
                path.endsWith(".js") ||
                path.endsWith(".png") ||
                path.endsWith(".jpg") ||
                path.endsWith(".jpeg") ||
                path.endsWith(".gif") ||
                path.endsWith(".svg") ||
                path.endsWith(".ico") ||
                path.endsWith(".woff") ||
                path.endsWith(".woff2") ||
                path.endsWith(".ttf") ||
                path.endsWith(".map"))) {
            // Forward to default servlet to serve static file
            request.getServletContext().getNamedDispatcher("default").forward(request, response);
            return;
        }

        // Forward to homepage JSP
        request.getRequestDispatcher("/WEB-INF/views/homepage.jsp").forward(request, response);
    }
}

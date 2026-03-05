package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Feedback;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.FeedbackService;
import com.aisthea.fashion.service.IFeedbackService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminFeedbackServlet", urlPatterns = { "/admin/feedback" })
public class AdminFeedbackServlet extends HttpServlet {

    private IFeedbackService feedbackService;

    @Override
    public void init() {
        this.feedbackService = new FeedbackService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "list":
                listFeedback(request, response);
                break;
            default:
                listFeedback(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            updateStatus(request, response);
        } else if ("reply".equals(action)) {
            reply(request, response);
        }
    }

    private void listFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/WEB-INF/views/admin/feedback/manage_feedback.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        feedbackService.updateFeedbackStatus(id, status);
        response.sendRedirect(request.getContextPath() + "/admin/feedback");
    }

    private void reply(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String reply = request.getParameter("reply");
        feedbackService.replyToFeedback(id, reply);
        response.sendRedirect(request.getContextPath() + "/admin/feedback");
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null)
            return false;
        User user = (User) session.getAttribute("user");
        return "ADMIN".equalsIgnoreCase(user.getRole()) || "STAFF".equalsIgnoreCase(user.getRole());
    }
}

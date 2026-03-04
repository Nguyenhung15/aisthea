package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.FeedbackDAO;
import com.aisthea.fashion.dao.IFeedbackDAO;
import com.aisthea.fashion.model.Feedback;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FeedbackService implements IFeedbackService {

    private final IFeedbackDAO feedbackDAO;
    private static final Logger logger = Logger.getLogger(FeedbackService.class.getName());

    public FeedbackService() {
        this.feedbackDAO = new FeedbackDAO();
    }

    @Override
    public List<Feedback> getFeedbacksByProductId(int productId) {
        try {
            return feedbackDAO.getFeedbacksByProductId(productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting feedbacks", e);
            return new ArrayList<>();
        }
    }

    @Override
    public boolean addFeedback(Feedback feedback) {
        try {
            return feedbackDAO.addFeedback(feedback);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding feedback", e);
            return false;
        }
    }

    @Override
    public boolean canUserReview(int userId, int productId) {
        try {
            return feedbackDAO.hasUserPurchasedProduct(userId, productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking purchase status", e);
            return false;
        }
    }
}

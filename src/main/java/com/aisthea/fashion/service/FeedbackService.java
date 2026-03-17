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

    @Override
    public List<Feedback> getAllFeedbacks() {
        try {
            return feedbackDAO.getAllFeedbacks();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all feedbacks", e);
            return new ArrayList<>();
        }
    }

    @Override
    public boolean updateFeedbackStatus(int feedbackId, String status) {
        try {
            return feedbackDAO.updateFeedbackStatus(feedbackId, status);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating feedback status", e);
            return false;
        }
    }

    @Override
    public boolean replyToFeedback(int feedbackId, String reply) {
        try {
            return feedbackDAO.replyToFeedback(feedbackId, reply);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error replying to feedback", e);
            return false;
        }
    }

    @Override
    public boolean incrementHelpfulCount(int feedbackId) {
        try {
            return feedbackDAO.incrementHelpfulCount(feedbackId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error incrementing helpful count", e);
            return false;
        }
    }

    @Override
    public double[] getAvgRatingForProduct(int productId) {
        try {
            return ((FeedbackDAO) feedbackDAO).getAvgRatingForProduct(productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting avg rating for product " + productId, e);
            return new double[]{0.0, 0};
        }
    }

    @Override
    public List<Feedback> getFeedbacksByUserId(int userId) {
        try {
            return feedbackDAO.getFeedbacksByUserId(userId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting feedbacks for userId=" + userId, e);
            return new ArrayList<>();
        }
    }

    @Override
    public boolean updateFeedback(int feedbackId, int userId, int rating, String comment) {
        try {
            return feedbackDAO.updateFeedback(feedbackId, userId, rating, comment);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating feedback id=" + feedbackId, e);
            return false;
        }
    }

    @Override
    public boolean deleteFeedback(int feedbackId, int userId) {
        try {
            return feedbackDAO.deleteFeedback(feedbackId, userId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting feedback id=" + feedbackId, e);
            return false;
        }
    }
}


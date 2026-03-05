package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Feedback;
import java.sql.SQLException;
import java.util.List;

public interface IFeedbackDAO {
    List<Feedback> getFeedbacksByProductId(int productId) throws SQLException;

    boolean addFeedback(Feedback feedback) throws SQLException;

    boolean hasUserPurchasedProduct(int userId, int productId) throws SQLException;

    List<Feedback> getAllFeedbacks() throws SQLException;

    boolean updateFeedbackStatus(int feedbackId, String status) throws SQLException;

    boolean replyToFeedback(int feedbackId, String reply) throws SQLException;

    boolean incrementHelpfulCount(int feedbackId) throws SQLException;
}

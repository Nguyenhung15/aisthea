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

    /** Returns all feedbacks belonging to a specific user. */
    List<Feedback> getFeedbacksByUserId(int userId) throws SQLException;

    /**
     * Updates a user's own feedback (rating + comment only).
     * Use {@link #updateFeedbackWithImage} when image may also change.
     */
    boolean updateFeedback(int feedbackId, int userId, int rating, String comment) throws SQLException;

    /**
     * Updates a user's own feedback including the image URL.
     *
     * @param imageUrl relative path stored in DB (e.g. "feedback/uuid.jpg"),
     *                 or {@code null} to clear the image.
     */
    boolean updateFeedbackWithImage(int feedbackId, int userId,
                                    int rating, String comment,
                                    String imageUrl) throws SQLException;

    /** Deletes a user's own feedback. */
    boolean deleteFeedback(int feedbackId, int userId) throws SQLException;
}

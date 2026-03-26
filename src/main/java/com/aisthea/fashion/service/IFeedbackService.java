package com.aisthea.fashion.service;

import com.aisthea.fashion.model.Feedback;
import java.util.List;

public interface IFeedbackService {

    List<Feedback> getFeedbacksByProductId(int productId);

    boolean addFeedback(Feedback feedback);

    boolean canUserReview(int userId, int productId);

    List<Feedback> getAllFeedbacks();

    boolean updateFeedbackStatus(int feedbackId, String status);

    boolean replyToFeedback(int feedbackId, String reply);

    boolean incrementHelpfulCount(int feedbackId);

    /** Returns all feedbacks submitted by a specific user. */
    List<Feedback> getFeedbacksByUserId(int userId);

    /**
     * Updates a user's own feedback — rating, comment, AND image URL.
     *
     * @param imageUrl relative path stored in DB (e.g. "feedback/uuid.jpg"),
     *                 or {@code null} to keep/clear the existing image.
     */
    boolean updateFeedback(int feedbackId, int userId, int rating, String comment, String imageUrl);

    /** Deletes a user's own feedback. */
    boolean deleteFeedback(int feedbackId, int userId);

    /** Returns [avgRating, reviewCount] for the given product. */
    double[] getAvgRatingForProduct(int productId);
}

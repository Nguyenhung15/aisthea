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
}

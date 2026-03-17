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

    /** Lấy tất cả feedbacks của 1 user (cho trang quản lý) */
    List<Feedback> getFeedbacksByUserId(int userId);

    /** Sửa feedback (chỉ owner mới được) */
    boolean updateFeedback(int feedbackId, int userId, int rating, String comment);

    /** Xóa feedback (chỉ owner mới được) */
    boolean deleteFeedback(int feedbackId, int userId);

    /** Returns [avgRating, reviewCount] for the given product */
    double[] getAvgRatingForProduct(int productId);
}


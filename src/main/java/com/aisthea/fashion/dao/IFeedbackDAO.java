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

    /** Lấy tất cả feedbacks của 1 user */
    List<Feedback> getFeedbacksByUserId(int userId) throws SQLException;

    /** User sửa feedback của chính mình (verify by userId) */
    boolean updateFeedback(int feedbackId, int userId, int rating, String comment) throws SQLException;

    /** User xóa feedback của chính mình (verify by userId) */
    boolean deleteFeedback(int feedbackId, int userId) throws SQLException;
}

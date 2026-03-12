package com.aisthea.fashion.model;

import java.sql.Timestamp;

public class PointHistory {
    private int historyId;
    private int userId;
    private int pointsEarned;
    private String reason;
    private Timestamp createdAt;

    public PointHistory() {
    }

    public PointHistory(int userId, int pointsEarned, String reason) {
        this.userId = userId;
        this.pointsEarned = pointsEarned;
        this.reason = reason;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getPointsEarned() {
        return pointsEarned;
    }

    public void setPointsEarned(int pointsEarned) {
        this.pointsEarned = pointsEarned;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

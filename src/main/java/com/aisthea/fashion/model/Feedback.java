package com.aisthea.fashion.model;

import java.util.Date;

public class Feedback {

    private int feedbackid;
    private int userid;
    private int productid;
    private int rating;
    private String comment;
    private String username;
    private String status;
    private String imageUrl;
    private int helpfulCount;
    private String adminReply;
    private Date createdat;
    private Date updatedat;
    private Date repliedAt;
    private boolean isVerified;
    private String productName; // transient — populated from JOIN

    // Constructors
    public Feedback() {
    }

    public Feedback(int feedbackid, int userid, int productid, int rating, String comment, Date createdat,
            Date updatedat) {
        this.feedbackid = feedbackid;
        this.userid = userid;
        this.productid = productid;
        this.rating = rating;
        this.comment = comment;
        this.createdat = createdat;
        this.updatedat = updatedat;
    }

    // Getters and Setters
    public int getFeedbackid() {
        return feedbackid;
    }

    public void setFeedbackid(int feedbackid) {
        this.feedbackid = feedbackid;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public int getProductid() {
        return productid;
    }

    public void setProductid(int productid) {
        this.productid = productid;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getHelpfulCount() {
        return helpfulCount;
    }

    public void setHelpfulCount(int helpfulCount) {
        this.helpfulCount = helpfulCount;
    }

    public String getAdminReply() {
        return adminReply;
    }

    public void setAdminReply(String adminReply) {
        this.adminReply = adminReply;
    }

    public Date getCreatedat() {
        return createdat;
    }

    public void setCreatedat(Date createdat) {
        this.createdat = createdat;
    }

    public Date getUpdatedat() {
        return updatedat;
    }

    public void setUpdatedat(Date updatedat) {
        this.updatedat = updatedat;
    }

    public Date getRepliedAt() {
        return repliedAt;
    }

    public void setRepliedAt(Date repliedAt) {
        this.repliedAt = repliedAt;
    }

    public boolean isVerified() {
        return isVerified;
    }

    public void setVerified(boolean isVerified) {
        this.isVerified = isVerified;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    @Override
    public String toString() {
        return "Feedback{"
                + "feedbackid=" + feedbackid
                + ", userid=" + userid
                + ", productid=" + productid
                + ", rating=" + rating
                + ", comment='" + comment + '\''
                + ", status='" + status + '\''
                + ", helpfulCount=" + helpfulCount
                + '}';
    }
}

package com.aisthea.fashion.model;

import java.util.Date;

public class Feedback {

    private int feedbackid;
    private int userid;
    private int productid;
    private int rating;
    private String comment;
    private Date createdat;
    private Date updatedat;

    // Constructors
    public Feedback() {
    }

    public Feedback(int feedbackid, int userid, int productid, int rating, String comment, Date createdat, Date updatedat) {
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

    @Override
    public String toString() {
        return "Feedback{"
                + "feedbackid=" + feedbackid
                + ", userid=" + userid
                + ", productid=" + productid
                + ", rating=" + rating
                + ", comment='" + comment + '\''
                + ", createdat=" + createdat
                + ", updatedat=" + updatedat
                + '}';
    }
}

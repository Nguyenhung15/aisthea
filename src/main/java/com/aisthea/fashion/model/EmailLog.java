package com.aisthea.fashion.model;

import java.util.Date;

public class EmailLog {

    private int emailid;
    private int userid;
    private String subject;
    private String content;
    private Date sentat;
    private String status;
    private String emailtype;
    private String recipientemail;

    // Constructors
    public EmailLog() {
    }

    public EmailLog(int emailid, int userid, String subject, String content, Date sentat, String status, String emailtype, String recipientemail) {
        this.emailid = emailid;
        this.userid = userid;
        this.subject = subject;
        this.content = content;
        this.sentat = sentat;
        this.status = status;
        this.emailtype = emailtype;
        this.recipientemail = recipientemail;
    }

    // Getters and Setters
    public int getEmailid() {
        return emailid;
    }

    public void setEmailid(int emailid) {
        this.emailid = emailid;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getSentat() {
        return sentat;
    }

    public void setSentat(Date sentat) {
        this.sentat = sentat;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEmailtype() {
        return emailtype;
    }

    public void setEmailtype(String emailtype) {
        this.emailtype = emailtype;
    }

    public String getRecipientemail() {
        return recipientemail;
    }

    public void setRecipientemail(String recipientemail) {
        this.recipientemail = recipientemail;
    }

    @Override
    public String toString() {
        return "EmailLog{"
                + "emailid=" + emailid
                + ", userid=" + userid
                + ", subject='" + subject + '\''
                + ", content='" + content + '\''
                + ", sentat=" + sentat
                + ", status='" + status + '\''
                + ", emailtype='" + emailtype + '\''
                + ", recipientemail='" + recipientemail + '\''
                + '}';
    }
}

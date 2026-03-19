package com.aisthea.fashion.model;

import java.sql.Timestamp;

/**
 * Model for emaillogs table
 */
public class EmailLog {

    private int     emailid;
    private Integer userid;          // nullable — not all emails are tied to a logged-in user
    private String  subject;
    private String  content;
    private Timestamp sentat;        // use Timestamp to match SQL Server DATETIME
    private String  status;          // "SENT" | "FAILED"
    private String  emailtype;       // "REGISTER" | "PASSWORD_RESET" | "ORDER_CONFIRM" | "GENERAL"
    private String  recipientemail;

    // Constructors
    public EmailLog() {}

    // Getters & Setters
    public int getEmailid()                   { return emailid; }
    public void setEmailid(int emailid)       { this.emailid = emailid; }

    public Integer getUserid()                { return userid; }
    public void setUserid(Integer userid)     { this.userid = userid; }

    public String getSubject()                { return subject; }
    public void setSubject(String subject)    { this.subject = subject; }

    public String getContent()                { return content; }
    public void setContent(String content)    { this.content = content; }

    public Timestamp getSentat()              { return sentat; }
    public void setSentat(Timestamp sentat)   { this.sentat = sentat; }

    public String getStatus()                 { return status; }
    public void setStatus(String status)      { this.status = status; }

    public String getEmailtype()              { return emailtype; }
    public void setEmailtype(String type)     { this.emailtype = type; }

    public String getRecipientemail()         { return recipientemail; }
    public void setRecipientemail(String r)   { this.recipientemail = r; }

    @Override
    public String toString() {
        return "EmailLog{id=" + emailid + ", to=" + recipientemail
               + ", type=" + emailtype + ", status=" + status + ", sent=" + sentat + "}";
    }
}

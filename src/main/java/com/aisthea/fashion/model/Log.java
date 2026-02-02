package com.aisthea.fashion.model;

import java.util.Date;

public class Log {

    private int logid;
    private int userid;
    private String action;
    private String ipaddress;
    private Date createdat;

    // Constructors
    public Log() {
    }

    public Log(int logid, int userid, String action, String ipaddress, Date createdat) {
        this.logid = logid;
        this.userid = userid;
        this.action = action;
        this.ipaddress = ipaddress;
        this.createdat = createdat;
    }

    // Getters and Setters
    public int getLogid() {
        return logid;
    }

    public void setLogid(int logid) {
        this.logid = logid;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getIpaddress() {
        return ipaddress;
    }

    public void setIpaddress(String ipaddress) {
        this.ipaddress = ipaddress;
    }

    public Date getCreatedat() {
        return createdat;
    }

    public void setCreatedat(Date createdat) {
        this.createdat = createdat;
    }

    @Override
    public String toString() {
        return "Log{"
                + "logid=" + logid
                + ", userid=" + userid
                + ", action='" + action + '\''
                + ", ipaddress='" + ipaddress + '\''
                + ", createdat=" + createdat
                + '}';
    }
}

package com.aisthea.fashion.model;

import java.sql.Timestamp;

/**
 * Model for the 'conversations' table.
 * Represents a chat session between a customer and AI/Staff.
 */
public class Conversation {

    private int conversationId;
    private int customerId;
    private Integer staffId;       // nullable — null when AI-only
    private String chatType;       // 'AI' or 'STAFF'
    private String status;         // 'OPEN', 'CLOSED'
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined fields for admin views
    private String customerName;
    private String customerUsername;
    private String customerAvatar;
    private int messageCount;
    private String lastMessage;

    public Conversation() {}

    // Getters & Setters
    public int getConversationId() { return conversationId; }
    public void setConversationId(int conversationId) { this.conversationId = conversationId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public Integer getStaffId() { return staffId; }
    public void setStaffId(Integer staffId) { this.staffId = staffId; }

    public String getChatType() { return chatType; }
    public void setChatType(String chatType) { this.chatType = chatType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerUsername() { return customerUsername; }
    public void setCustomerUsername(String customerUsername) { this.customerUsername = customerUsername; }

    public String getCustomerAvatar() { return customerAvatar; }
    public void setCustomerAvatar(String customerAvatar) { this.customerAvatar = customerAvatar; }

    public int getMessageCount() { return messageCount; }
    public void setMessageCount(int messageCount) { this.messageCount = messageCount; }

    public String getLastMessage() { return lastMessage; }
    public void setLastMessage(String lastMessage) { this.lastMessage = lastMessage; }
}

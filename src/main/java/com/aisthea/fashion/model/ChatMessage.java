package com.aisthea.fashion.model;

import java.sql.Timestamp;

/**
 * Model for the 'messages' table.
 * Each message belongs to a conversation.
 */
public class ChatMessage {

    private int messageId;
    private int conversationId;
    private String sender;         // 'CUSTOMER', 'AI', 'STAFF'
    private String content;
    private Timestamp createdAt;

    // Joined fields
    private String senderName;

    public ChatMessage() {}

    public ChatMessage(int conversationId, String sender, String content) {
        this.conversationId = conversationId;
        this.sender = sender;
        this.content = content;
    }

    // Getters & Setters
    public int getMessageId() { return messageId; }
    public void setMessageId(int messageId) { this.messageId = messageId; }

    public int getConversationId() { return conversationId; }
    public void setConversationId(int conversationId) { this.conversationId = conversationId; }

    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }
}

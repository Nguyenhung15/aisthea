package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.EmailLog;

import java.util.List;

/**
 * Interface for EmailLog Data Access Object
 */
public interface IEmailLogDAO {

    /**
     * Save a new email log entry
     */
    boolean save(EmailLog log);

    /**
     * Get all email logs (newest first), with optional pagination
     */
    List<EmailLog> findAll(int page, int pageSize);

    /**
     * Get total count of email logs
     */
    int count();

    /**
     * Get logs filtered by email type
     */
    List<EmailLog> findByType(String emailType, int page, int pageSize);

    /**
     * Get logs filtered by status (SENT / FAILED)
     */
    List<EmailLog> findByStatus(String status, int page, int pageSize);

    /**
     * Get summary stats: total sent, total failed
     */
    int countByStatus(String status);
}

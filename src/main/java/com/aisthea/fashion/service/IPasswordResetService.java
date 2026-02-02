package com.aisthea.fashion.service;

public interface IPasswordResetService {

    enum RequestStatus {
        SUCCESS,
        USER_NOT_FOUND,
        MAIL_ERROR
    }

    enum ResetStatus {
        SUCCESS,
        TOKEN_INVALID,
        TOKEN_EXPIRED,
        UPDATE_FAILED
    }

    RequestStatus requestPasswordReset(String email, String appUrl);

    ResetStatus performPasswordReset(String token, String newPassword);

}

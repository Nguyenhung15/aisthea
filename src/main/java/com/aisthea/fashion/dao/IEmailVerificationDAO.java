package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.EmailVerification;
import java.time.LocalDateTime;

public interface IEmailVerificationDAO {

    boolean saveToken(int userId, String token, LocalDateTime expiresAt);

    EmailVerification findByToken(String token);

    boolean markVerified(String token);
}

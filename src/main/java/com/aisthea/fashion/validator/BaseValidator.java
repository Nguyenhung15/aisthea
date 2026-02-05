package com.aisthea.fashion.validator;

import com.aisthea.fashion.exception.ValidationException;
import com.aisthea.fashion.util.StringUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * Base validator with common validation logic
 */
public abstract class BaseValidator<T> {

    protected List<String> errors = new ArrayList<>();

    /**
     * Validate object
     */
    public abstract boolean validate(T object);

    /**
     * Get validation errors
     */
    public List<String> getErrors() {
        return errors;
    }

    /**
     * Check if there are errors
     */
    public boolean hasErrors() {
        return !errors.isEmpty();
    }

    /**
     * Throw ValidationException if there are errors
     */
    public void throwIfInvalid() {
        if (hasErrors()) {
            throw new ValidationException(errors);
        }
    }

    /**
     * Clear errors
     */
    protected void clearErrors() {
        errors.clear();
    }

    /**
     * Add error message
     */
    protected void addError(String error) {
        errors.add(error);
    }

    /**
     * Validate required field
     */
    protected boolean isRequired(String value, String fieldName) {
        if (StringUtil.isEmpty(value)) {
            addError(fieldName + " là bắt buộc");
            return false;
        }
        return true;
    }

    /**
     * Validate min length
     */
    protected boolean minLength(String value, int minLength, String fieldName) {
        if (value != null && value.length() < minLength) {
            addError(fieldName + " phải có ít nhất " + minLength + " ký tự");
            return false;
        }
        return true;
    }

    /**
     * Validate max length
     */
    protected boolean maxLength(String value, int maxLength, String fieldName) {
        if (value != null && value.length() > maxLength) {
            addError(fieldName + " không được vượt quá " + maxLength + " ký tự");
            return false;
        }
        return true;
    }

    /**
     * Validate email format
     */
    protected boolean isValidEmail(String email) {
        if (!StringUtil.isValidEmail(email)) {
            addError("Email không đúng định dạng");
            return false;
        }
        return true;
    }

    /**
     * Validate phone format
     */
    protected boolean isValidPhone(String phone) {
        if (!StringUtil.isValidPhone(phone)) {
            addError("Số điện thoại không đúng định dạng");
            return false;
        }
        return true;
    }
}

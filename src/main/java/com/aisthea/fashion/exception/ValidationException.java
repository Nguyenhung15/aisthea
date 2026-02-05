package com.aisthea.fashion.exception;

import java.util.ArrayList;
import java.util.List;

/**
 * Exception for validation errors
 */
public class ValidationException extends RuntimeException {
    private List<String> errors;

    public ValidationException(String message) {
        super(message);
        this.errors = new ArrayList<>();
        this.errors.add(message);
    }

    public ValidationException(List<String> errors) {
        super(errors.isEmpty() ? "Validation failed" : errors.get(0));
        this.errors = errors;
    }

    public List<String> getErrors() {
        return errors;
    }

    public void addError(String error) {
        this.errors.add(error);
    }
}

package com.aisthea.fashion.validator;

import java.util.ArrayList;
import java.util.List;

/**
 * Validator for product-related input data
 */
public class ProductValidator {

    /**
     * Validate product name
     */
    public static boolean isValidProductName(String name) {
        return name != null && !name.trim().isEmpty() && name.length() <= 200;
    }

    /**
     * Validate product price
     */
    public static boolean isValidPrice(Double price) {
        return price != null && price > 0;
    }

    /**
     * Validate product quantity
     */
    public static boolean isValidQuantity(Integer quantity) {
        return quantity != null && quantity >= 0;
    }

    /**
     * Validate product data
     */
    public static List<String> validateProduct(String name, Double price, Integer categoryId, String description) {
        List<String> errors = new ArrayList<>();

        if (!isValidProductName(name)) {
            errors.add("Tên sản phẩm không hợp lệ");
        }

        if (!isValidPrice(price)) {
            errors.add("Giá sản phẩm phải lớn hơn 0");
        }

        if (categoryId == null || categoryId <= 0) {
            errors.add("Danh mục sản phẩm không hợp lệ");
        }

        if (description != null && description.length() > 5000) {
            errors.add("Mô tả sản phẩm quá dài");
        }

        return errors;
    }

    private ProductValidator() {
        // Private constructor to prevent instantiation
    }
}

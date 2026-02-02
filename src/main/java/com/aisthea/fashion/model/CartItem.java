package com.aisthea.fashion.model;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class CartItem {

    private int productId;
    private int productColorSizeId;
    private String productName;
    private String productImageUrl;
    private String color;
    private String size;
    private BigDecimal price;
    private int quantity;

    public CartItem() {
    }

    public CartItem(CartItem oldItem) {
        this.productId = oldItem.productId;
        this.productColorSizeId = oldItem.productColorSizeId;
        this.productName = oldItem.productName;
        this.productImageUrl = oldItem.productImageUrl;
        this.color = oldItem.color;
        this.size = oldItem.size;
        this.price = oldItem.price;
        this.quantity = oldItem.quantity;
    }

    public BigDecimal getSubtotal() {
        if (price == null) {
            return BigDecimal.ZERO;
        }
        return price.multiply(new BigDecimal(quantity)).setScale(2, RoundingMode.HALF_UP);
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getProductColorSizeId() {
        return productColorSizeId;
    }

    public void setProductColorSizeId(int productColorSizeId) {
        this.productColorSizeId = productColorSizeId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImageUrl() {
        return productImageUrl;
    }

    public void setProductImageUrl(String productImageUrl) {
        this.productImageUrl = productImageUrl;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
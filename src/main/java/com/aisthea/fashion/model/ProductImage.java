package com.aisthea.fashion.model;

import java.util.Date;

public class ProductImage {

    private int imageId;        // ID ảnh
    private Product product;    // Sản phẩm liên quan (một đối tượng của lớp Product)
    private String color;       // Màu sắc của sản phẩm
    private String imageUrl;    // Đường dẫn hình ảnh
    private boolean isPrimary;  // Ảnh chính hay phụ (true nếu chính, false nếu phụ)
    private Date createdAt;     // Thời gian tạo ảnh
    private Date updatedAt;     // Thời gian cập nhật ảnh

    // Constructor
    
    public ProductImage() {
    }

    public ProductImage(int imageId, Product product, String color, String imageUrl, boolean isPrimary, Date createdAt, Date updatedAt) {
        this.imageId = imageId;
        this.product = product;
        this.color = color;
        this.imageUrl = imageUrl;
        this.isPrimary = isPrimary;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters và Setters
    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "ProductImage{"
                + "imageId=" + imageId
                + ", product=" + product.getName()
                + // Sử dụng getName() để hiển thị tên sản phẩm
                ", color='" + color + '\''
                + ", imageUrl='" + imageUrl + '\''
                + ", isPrimary=" + isPrimary
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + '}';
    }
}

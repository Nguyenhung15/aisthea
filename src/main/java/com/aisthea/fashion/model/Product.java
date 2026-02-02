package com.aisthea.fashion.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Product {

    private int productId;
    private String name;
    private String description;
    private BigDecimal price;
    private Category category;
    private String brand;
    private BigDecimal discount;
    private List<ProductColorSize> colorSizes;
    private List<ProductImage> images;
    private Date createdAt;
    private Date updatedAt;

    public Product() {
    }

    public Product(int productId, String name, String description, BigDecimal price,
            Category category, String brand, BigDecimal discount,
            List<ProductColorSize> colorSizes, List<ProductImage> images,
            Date createdAt, Date updatedAt) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.brand = brand;
        this.discount = discount;
        this.colorSizes = colorSizes;
        this.images = images;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Product(String name, String description, BigDecimal price, String brand, BigDecimal discount, Date createdAt, Date updatedAt) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.brand = brand;
        this.discount = discount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Product(int productId, String name, String description, BigDecimal price, String brand, BigDecimal discount, Date createdAt, Date updatedAt) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.brand = brand;
        this.discount = discount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
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

    public List<ProductColorSize> getColorSizes() {
        return colorSizes;
    }

    public void setColorSizes(List<ProductColorSize> colorSizes) {
        this.colorSizes = colorSizes;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }
}

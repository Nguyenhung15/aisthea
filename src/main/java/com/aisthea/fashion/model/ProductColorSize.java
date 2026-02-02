package com.aisthea.fashion.model;

public class ProductColorSize {

    private int productColorSizeId;  // ID sự kết hợp màu và kích thước
    private Product product;         // Sản phẩm liên quan (một đối tượng của lớp Product)
    private String color;            // Màu sắc của sản phẩm
    private String size;             // Kích thước sản phẩm (S, M, L, XL, v.v.)
    private int stock;               // Số lượng tồn kho cho sự kết hợp này

    // Constructor
    public ProductColorSize() {
    }

    public ProductColorSize(int productColorSizeId, Product product, String color, String size, int stock) {
        this.productColorSizeId = productColorSizeId;
        this.product = product;
        this.color = color;
        this.size = size;
        this.stock = stock;
    }

    // Getters và Setters
    public int getProductColorSizeId() {
        return productColorSizeId;
    }

    public void setProductColorSizeId(int productColorSizeId) {
        this.productColorSizeId = productColorSizeId;
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

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    @Override
    public String toString() {
        return "ProductColorSize{"
                + "productColorSizeId=" + productColorSizeId
                + ", product=" + product.getName()
                + // Sử dụng getName() để hiển thị tên sản phẩm
                ", color='" + color + '\''
                + ", size='" + size + '\''
                + ", stock=" + stock
                + '}';
    }
}

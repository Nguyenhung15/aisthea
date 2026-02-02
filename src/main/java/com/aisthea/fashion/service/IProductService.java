package com.aisthea.fashion.service;

import com.aisthea.fashion.model.Product;
import com.aisthea.fashion.model.ProductColorSize;
import com.aisthea.fashion.model.ProductImage;
import java.sql.SQLException;
import java.util.List;

public interface IProductService {

    boolean addProduct(Product product) throws SQLException;

    Product getProductById(int productId);

    List<Product> getAllProducts();
    
    boolean updateProduct(Product product) throws SQLException;

    boolean deleteProduct(int productId);

    List<ProductColorSize> getColorSizesByProductId(int productId);

    boolean addColorSize(ProductColorSize pcs, int productId);

    void updateStock(int productColorSizeId, int newStock);

    void deleteColorSize(int productColorSizeId);

    List<ProductImage> getImagesByProductId(int productId);

    ProductImage getPrimaryImage(int productId);

    boolean addProductImage(ProductImage img, int productId);

    void updateProductImage(ProductImage img);

    void deleteImagesByProductId(int productId);
    
    List<Product> getProductsByParentCategory(String parentIndex, int genderId);
}
package com.aisthea.fashion.service;

import com.aisthea.fashion.model.Product;
import com.aisthea.fashion.model.ProductColorSize;
import com.aisthea.fashion.model.ProductImage;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public interface IProductService {

    boolean addProduct(Product product) throws SQLException;

    Product getProductById(int productId);

    List<Product> getAllProducts();

    /**
     * Filter products at SQL level for maximum performance.
     * All parameters are optional (null = no filter applied).
     */
    List<Product> getFilteredProducts(
            Integer categoryId,
            String categoryIndex,
            Integer genderId,
            String color,
            String size,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            String keyword,
            String sortBy
    );

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

    List<Product> getAdminProducts(int page, int pageSize, String sortCol, String sortDir, String search);

    int countAdminProducts(String search);

    boolean toggleProductStatus(int productId);
}
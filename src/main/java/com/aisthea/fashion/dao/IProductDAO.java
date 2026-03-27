package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Product;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public interface IProductDAO {

    boolean addProduct(Product product) throws SQLException;

    Product getProductById(int productId) throws SQLException;

    List<Product> getAllProducts() throws SQLException;

    /**
     * Filter products directly at SQL level for performance.
     * All parameters are optional (pass null to skip that filter).
     *
     * @param categoryId    filter by exact category id (null = no filter)
     * @param categoryIndex filter by parent-category index name (null = no filter)
     * @param genderId      filter by gender (null = no filter)
     * @param color         filter by color keyword in product_color_size (null = no filter)
     * @param size          filter by exact size in product_color_size with stock>0 (null = no filter)
     * @param minPrice      minimum price inclusive (null = 0)
     * @param maxPrice      maximum price inclusive (null = unlimited)
     * @param keyword       search keyword in name/brand/description (null = no filter)
     * @param sortBy        "price_asc"|"price_desc"|"newest"|null (null = default/featured)
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
    ) throws SQLException;

    boolean updateProduct(Product product) throws SQLException;

    boolean deleteProduct(int productId) throws SQLException;

    List<Product> getTopExpensiveProducts(int limit) throws SQLException;

    String getInventorySummary() throws SQLException;

    // Phân trang & Quản lý Admin
    List<Product> getAdminProducts(int page, int pageSize, String sortCol, String sortDir, String search) throws SQLException;
    List<Product> getAdminProducts(int page, int pageSize, String sortCol, String sortDir, String search, Integer statusFilter, Integer genderId, String parentCategory, Integer subCategoryId) throws SQLException;
    int countAdminProducts(String search) throws SQLException;
    int countAdminProducts(String search, Integer statusFilter, Integer genderId, String parentCategory, Integer subCategoryId) throws SQLException;
    boolean toggleProductStatus(int productId) throws SQLException;
    
    // Quick Update
    boolean updateProductPrice(int productId, BigDecimal newPrice) throws SQLException;
    
    // Báo cáo Low Stock toàn hệ thống
    List<Product> getLowStockProducts(int stockThreshold) throws SQLException;

}

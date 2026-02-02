package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.ProductImage;
import java.sql.SQLException;
import java.util.List;

public interface IProductImageDAO {

    List<ProductImage> getByProductId(int productId) throws SQLException;

    boolean addProductImage(ProductImage image, int productId) throws SQLException;

    void deleteByProductId(int productId) throws SQLException;

    void updateImage(ProductImage image) throws SQLException;
    
    ProductImage getPrimaryImageByProductId(int productId) throws SQLException;
}

package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Category;
import com.aisthea.fashion.model.Product;
import com.aisthea.fashion.model.ProductColorSize;
import com.aisthea.fashion.model.ProductImage;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface IProductDAO {

    boolean addProduct(Product product) throws SQLException;

    Product getProductById(int productId) throws SQLException;

    List<Product> getAllProducts() throws SQLException;

    boolean updateProduct(Product product) throws SQLException;

    boolean deleteProduct(int productId) throws SQLException;

    List<Product> getProductsByParentCategory(String parentIndex, int genderId) throws SQLException;

}

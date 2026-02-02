package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.ProductColorSize;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface IProductColorSizeDAO {

    public List<ProductColorSize> getByProductId(int productId) throws SQLException;

    public boolean addProductColorSize(ProductColorSize pcs, int productId) throws SQLException;

    public void deleteByProductId(int productId) throws SQLException;

    public void updateStock(int productColorSizeId, int newStock) throws SQLException;

    public void deleteById(int productColorSizeId) throws SQLException;

    boolean decreaseStock(Connection conn, int pcsId, int quantity) throws SQLException;

}

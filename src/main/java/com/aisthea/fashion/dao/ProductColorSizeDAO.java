package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Product;
import com.aisthea.fashion.model.ProductColorSize;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductColorSizeDAO implements IProductColorSizeDAO {

    private static final Logger logger = Logger.getLogger(ProductColorSizeDAO.class.getName());
    private static final String INSERT_SQL
            = "INSERT INTO product_color_size (productid, color, size, stock) VALUES (?, ?, ?, ?)";
    private static final String SELECT_BY_PRODUCTID
            = "SELECT * FROM product_color_size WHERE productid = ?";
    private static final String DELETE_BY_PRODUCTID
            = "DELETE FROM product_color_size WHERE productid = ?";
    private static final String UPDATE_STOCK
            = "UPDATE product_color_size SET stock = ? WHERE productcolorsizeid = ?";
    private static final String DELETE_BY_PRODUCTCOLORSIZEID
            = "DELETE FROM product_color_size WHERE productcolorsizeid = ?";
    private static final String DECREASE_STOCK_SQL = """
                UPDATE product_color_size 
                SET stock = stock - ? 
                WHERE productcolorsizeid = ? AND stock >= ?
            """;

    @Override
    public List<ProductColorSize> getByProductId(int productId) throws SQLException {
        List<ProductColorSize> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_BY_PRODUCTID)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductColorSize pcs = new ProductColorSize();
                    pcs.setProductColorSizeId(rs.getInt("productcolorsizeid"));
                    pcs.setColor(rs.getString("color"));
                    pcs.setSize(rs.getString("size"));
                    pcs.setStock(rs.getInt("stock"));
                    list.add(pcs);
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return list;
    }

    @Override
    public boolean addProductColorSize(ProductColorSize pcs, int productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setInt(1, productId);
            ps.setString(2, pcs.getColor());
            ps.setString(3, pcs.getSize());
            ps.setInt(4, pcs.getStock());
            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                logger.info("Inserted color-size successfully: " + pcs.getColor() + " / " + pcs.getSize());
            }
            return rowsInserted > 0;
        } catch (SQLException e) {
            printSQLException(e);
            return false;
        }
    }

    @Override
    public void deleteByProductId(int productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_BY_PRODUCTID)) {
            ps.setInt(1, productId);
            int rowsDeleted = ps.executeUpdate();
            if (rowsDeleted > 0) {
                logger.info("Deleted successfully!");
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    @Override
    public void updateStock(int productColorSizeId, int newStock) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_STOCK)) {
            ps.setInt(1, newStock);
            ps.setInt(2, productColorSizeId);
            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                logger.info("Updated successfully!");
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    @Override
    public void deleteById(int productColorSizeId) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_BY_PRODUCTCOLORSIZEID)) {
            ps.setInt(1, productColorSizeId);
            ps.executeUpdate();
            logger.info("Deleted color-size ID=" + productColorSizeId);
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                logger.log(Level.SEVERE, "SQL Error", e);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.err.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }

    @Override
    public boolean decreaseStock(Connection conn, int pcsId, int quantity) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(DECREASE_STOCK_SQL)) {
            ps.setInt(1, quantity);
            ps.setInt(2, pcsId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        }
    }
}

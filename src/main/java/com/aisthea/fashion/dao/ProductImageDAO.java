package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Product;
import com.aisthea.fashion.model.ProductImage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductImageDAO implements IProductImageDAO {

    private static final Logger logger = Logger.getLogger(ProductImageDAO.class.getName());

    private static final String INSERT_SQL = """
        INSERT INTO product_image (productid, color, imageurl, isprimary, createdat, updatedat)
        VALUES (?, ?, ?, ?, GETDATE(), GETDATE())
    """;
    private static final String SELECT_BY_PRODUCTID
            = "SELECT * FROM product_image WHERE productid = ?";
    private static final String DELETE_BY_PRODUCTID
            = "DELETE FROM product_image WHERE productid = ?";
    private static final String UPDATE_SQL = """
        UPDATE product_image
        SET color = ?, imageurl = ?, isprimary = ?, updatedat = GETDATE()
        WHERE imageid = ?
    """;
    private static final String SELECT_PRIMARY_IMAGE = """
        SELECT TOP 1 *
        FROM product_image
        WHERE productid = ? AND isprimary = 1
    """;

    private IProductDAO productDAO;

    public ProductImageDAO() {
    }

    public void setProductDAO(IProductDAO productDAO) {
        this.productDAO = productDAO;
    }

    @Override
    public List<ProductImage> getByProductId(int productId) throws SQLException {
        List<ProductImage> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_BY_PRODUCTID)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {

                Product product = null;
                boolean productFetched = false;

                while (rs.next()) {
                    if (!productFetched && productDAO != null) {
                        productFetched = true;
                    }

                    ProductImage image = new ProductImage();
                    image.setImageId(rs.getInt("imageid"));

                    image.setProduct(null);

                    image.setColor(rs.getString("color"));
                    image.setImageUrl(rs.getString("imageurl"));
                    image.setPrimary(rs.getBoolean("isprimary"));
                    image.setCreatedAt(rs.getTimestamp("createdat"));
                    image.setUpdatedAt(rs.getTimestamp("updatedat"));
                    list.add(image);
                }
            }

        } catch (SQLException e) {
            logSQLException(e);
            throw e;
        }

        return list;
    }

    @Override
    public boolean addProductImage(ProductImage image, int productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {

            ps.setInt(1, productId);
            ps.setString(2, image.getColor());
            ps.setString(3, image.getImageUrl());
            ps.setBoolean(4, image.isPrimary());

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            logSQLException(e);
            throw e;
        }
    }

    @Override
    public void deleteByProductId(int productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_BY_PRODUCTID)) {

            ps.setInt(1, productId);
            int rowsDeleted = ps.executeUpdate();
            logger.info("Deleted " + rowsDeleted + " images for productId = " + productId);

        } catch (SQLException e) {
            logSQLException(e);
            throw e;
        }
    }

    @Override
    public void updateImage(ProductImage image) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {

            ps.setString(1, image.getColor());
            ps.setString(2, image.getImageUrl());
            ps.setBoolean(3, image.isPrimary());
            ps.setInt(4, image.getImageId());

            int rowsUpdated = ps.executeUpdate();
            logger.info("Updated " + rowsUpdated + " image(s) for imageId = " + image.getImageId());

        } catch (SQLException e) {
            logSQLException(e);
            throw e;
        }
    }

    @Override
    public ProductImage getPrimaryImageByProductId(int productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_PRIMARY_IMAGE)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductImage image = new ProductImage();
                    image.setImageId(rs.getInt("imageid"));
                    image.setProduct(null);
                    image.setColor(rs.getString("color"));
                    image.setImageUrl(rs.getString("imageurl"));
                    image.setPrimary(rs.getBoolean("isprimary"));
                    image.setCreatedAt(rs.getTimestamp("createdat"));
                    image.setUpdatedAt(rs.getTimestamp("updatedat"));
                    return image;
                }
            }

        } catch (SQLException e) {
            logSQLException(e);
            throw e;
        }

        return null;
    }

    private void logSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException sqlEx) {
                logger.log(Level.SEVERE, "SQL Error", sqlEx);
                logger.severe("SQLState: " + sqlEx.getSQLState());
                logger.severe("Error Code: " + sqlEx.getErrorCode());
                logger.severe("Message: " + sqlEx.getMessage());
            }
        }
    }
}

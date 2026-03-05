package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.*;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductDAO implements IProductDAO {

    private final ICategoryDAO categoryDAO;
    private IProductColorSizeDAO colorSizeDAO;
    private final IProductImageDAO imageDAO;

    private static final Logger logger = Logger.getLogger(ProductDAO.class.getName());
    private static final String INSERT_SQL = """
                INSERT INTO Products (name, description, price, categoryid, brand, discount, is_bestseller, createdat, updatedat)
                VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())
            """;
    private static final String SELECT_BY_ID = "SELECT * FROM Products WHERE productid = ?";
    private static final String SELECT_ALL = "SELECT * FROM Products";
    private static final String SELECT_ALL_OPTIMIZED = """
            SELECT
                p.productid, p.name, p.description, p.price, p.brand, p.discount, p.is_bestseller,
                p.createdat, p.updatedat, p.categoryid,
                c.name AS category_name, c.type AS category_type,
                c.genderid AS category_genderid, c.parentid AS category_parentid,
                c.INDEX_name AS category_index,
                img.imageid AS image_id, img.imageurl AS image_url, img.color AS image_color, img.isprimary AS image_isprimary,
                img.createdat AS image_createdat, img.updatedat AS image_updatedat,
                (SELECT COALESCE(SUM(pcs.stock), 0) FROM product_color_size pcs WHERE pcs.productid = p.productid) AS total_stock
            FROM
                Products p
            LEFT JOIN
                Categories c ON p.categoryid = c.categoryid
            LEFT JOIN
                product_image img ON p.productid = img.productid
            ORDER BY p.productid
            """;
    private static final String UPDATE_SQL = """
                UPDATE Products
                SET name = ?, description = ?, price = ?, categoryid = ?, brand = ?, discount = ?, is_bestseller = ?, updatedat = GETDATE()
                WHERE productid = ?
            """;
    private static final String DELETE_SQL = "DELETE FROM Products WHERE productid = ?";
    private static final String SELECT_BY_PARENT_CATEGORY_OPTIMIZED = """
            SELECT
                p.productid, p.name, p.description, p.price, p.brand, p.discount, p.is_bestseller,
                p.createdat, p.updatedat, p.categoryid,
                c.name AS category_name, c.type AS category_type,
                c.genderid AS category_genderid, c.parentid AS category_parentid,
                c.INDEX_name AS category_index,
                img.imageid AS image_id, img.imageurl AS image_url, img.color AS image_color, img.isprimary AS image_isprimary,
                img.createdat AS image_createdat, img.updatedat AS image_updatedat,
                (SELECT COALESCE(SUM(pcs.stock), 0) FROM product_color_size pcs WHERE pcs.productid = p.productid) AS total_stock
            FROM
                Products p
            JOIN
                Categories c ON p.categoryid = c.categoryid
            LEFT JOIN
                product_image img ON p.productid = img.productid
            WHERE
                c.genderid = ?
                AND (c.INDEX_name = ? OR c.parentid = ?)
            ORDER BY p.productid
            """;

    public ProductDAO() {
        this.categoryDAO = new CategoryDAO();
        this.colorSizeDAO = new ProductColorSizeDAO();
        this.imageDAO = new ProductImageDAO();
    }

    @Override
    public boolean addProduct(Product product) throws SQLException {
        boolean inserted = false;
        Connection conn = null;
        int newProductId = -1;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, product.getName());
                ps.setString(2, product.getDescription());
                ps.setBigDecimal(3, product.getPrice());
                ps.setInt(4, product.getCategory().getCategoryid());
                ps.setString(5, product.getBrand());
                ps.setBigDecimal(6, product.getDiscount());
                ps.setBoolean(7, product.isBestseller());

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        newProductId = rs.getInt(1);
                        product.setProductId(newProductId);
                    }
                }
            }

            if (newProductId == -1) {
                logger.warning("Failed to insert product, no ID generated.");
                conn.rollback();
                return false;
            }

            if (product.getColorSizes() != null && !product.getColorSizes().isEmpty()) {
                String insertStockSQL = "INSERT INTO product_color_size (productid, color, size, stock) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psInsertStock = conn.prepareStatement(insertStockSQL)) {
                    for (ProductColorSize pcs : product.getColorSizes()) {
                        psInsertStock.setInt(1, newProductId);
                        psInsertStock.setString(2, pcs.getColor());
                        psInsertStock.setString(3, pcs.getSize());
                        psInsertStock.setInt(4, pcs.getStock());
                        psInsertStock.addBatch();
                    }
                    psInsertStock.executeBatch();
                }
            }

            if (product.getImages() != null && !product.getImages().isEmpty()) {
                String insertImageSQL = "INSERT INTO product_image (productid, color, imageurl, isprimary) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psInsertImage = conn.prepareStatement(insertImageSQL)) {
                    for (ProductImage img : product.getImages()) {
                        psInsertImage.setInt(1, newProductId);
                        psInsertImage.setString(2, img.getColor());
                        psInsertImage.setString(3, img.getImageUrl());
                        psInsertImage.setBoolean(4, img.isPrimary());
                        psInsertImage.addBatch();
                    }
                    psInsertImage.executeBatch();
                }
            }

            conn.commit();
            inserted = true;
            logger.info("✅ Product inserted successfully (with batch images/stock): " + product.getName());

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            printSQLException(e);
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
            }
        }
        return inserted;
    }

    @Override
    public Product getProductById(int productId) throws SQLException {
        Product product = null;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int categoryId = rs.getInt("categoryid");
                    Category category = categoryDAO.selectCategory(categoryId);
                    product = new Product();
                    product.setProductId(rs.getInt("productid"));
                    product.setName(rs.getString("name"));
                    product.setDescription(rs.getString("description"));
                    product.setPrice(rs.getBigDecimal("price"));
                    product.setBrand(rs.getString("brand"));
                    product.setDiscount(rs.getBigDecimal("discount"));
                    product.setBestseller(rs.getBoolean("is_bestseller"));
                    product.setCreatedAt(rs.getTimestamp("createdat"));
                    product.setUpdatedAt(rs.getTimestamp("updatedat"));
                    product.setCategory(category);
                    product.setColorSizes(colorSizeDAO.getByProductId(productId));
                    product.setImages(imageDAO.getByProductId(productId));
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return product;
    }

    @Override
    public List<Product> getAllProducts() throws SQLException {
        List<Product> list = new ArrayList<>();
        java.util.Map<Integer, Product> productMap = new java.util.LinkedHashMap<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_ALL_OPTIMIZED);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int productId = rs.getInt("productid");
                Product p = productMap.get(productId);
                if (p == null) {
                    p = new Product();
                    p.setProductId(productId);
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setBrand(rs.getString("brand"));
                    p.setDiscount(rs.getBigDecimal("discount"));
                    p.setBestseller(rs.getBoolean("is_bestseller"));
                    p.setCreatedAt(rs.getTimestamp("createdat"));
                    p.setUpdatedAt(rs.getTimestamp("updatedat"));
                    p.setTotalStock(rs.getInt("total_stock"));

                    Category category = new Category();
                    category.setCategoryid(rs.getInt("categoryid"));
                    category.setName(rs.getString("category_name"));
                    category.setType(rs.getString("category_type"));
                    category.setGenderid(rs.getInt("category_genderid"));
                    category.setParentid(rs.getString("category_parentid"));
                    category.setIndexName(rs.getString("category_index"));
                    p.setCategory(category);

                    p.setImages(new ArrayList<>());
                    p.setColorSizes(new ArrayList<>());
                    productMap.put(productId, p);
                }

                // Add image if exists
                String imageUrl = rs.getString("image_url");
                if (imageUrl != null && !imageUrl.isBlank()) {
                    ProductImage img = new ProductImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setImageUrl(imageUrl);
                    img.setColor(rs.getString("image_color"));
                    img.setPrimary(rs.getBoolean("image_isprimary"));
                    img.setCreatedAt(rs.getTimestamp("image_createdat"));
                    img.setUpdatedAt(rs.getTimestamp("image_updatedat"));
                    img.setProduct(p);
                    p.getImages().add(img);
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        list.addAll(productMap.values());
        return list;
    }

    @Override
    public List<Product> getProductsByParentCategory(String parentIndex, int genderId) throws SQLException {
        List<Product> list = new ArrayList<>();
        java.util.Map<Integer, Product> productMap = new java.util.LinkedHashMap<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(SELECT_BY_PARENT_CATEGORY_OPTIMIZED)) {

            ps.setInt(1, genderId);
            ps.setString(2, parentIndex);
            ps.setString(3, parentIndex);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("productid");
                    Product p = productMap.get(productId);
                    if (p == null) {
                        p = new Product();
                        p.setProductId(productId);
                        p.setName(rs.getString("name"));
                        p.setDescription(rs.getString("description"));
                        p.setPrice(rs.getBigDecimal("price"));
                        p.setBrand(rs.getString("brand"));
                        p.setDiscount(rs.getBigDecimal("discount"));
                        p.setBestseller(rs.getBoolean("is_bestseller"));
                        p.setCreatedAt(rs.getTimestamp("createdat"));
                        p.setUpdatedAt(rs.getTimestamp("updatedat"));
                        p.setTotalStock(rs.getInt("total_stock"));

                        Category category = new Category();
                        category.setCategoryid(rs.getInt("categoryid"));
                        category.setName(rs.getString("category_name"));
                        category.setType(rs.getString("category_type"));
                        category.setGenderid(rs.getInt("category_genderid"));
                        category.setParentid(rs.getString("category_parentid"));
                        category.setIndexName(rs.getString("category_index"));
                        p.setCategory(category);

                        p.setImages(new ArrayList<>());
                        p.setColorSizes(new ArrayList<>());
                        productMap.put(productId, p);
                    }

                    // Add image if exists
                    String imageUrl = rs.getString("image_url");
                    if (imageUrl != null && !imageUrl.isBlank()) {
                        ProductImage img = new ProductImage();
                        img.setImageId(rs.getInt("image_id"));
                        img.setImageUrl(imageUrl);
                        img.setColor(rs.getString("image_color"));
                        img.setPrimary(rs.getBoolean("image_isprimary"));
                        img.setCreatedAt(rs.getTimestamp("image_createdat"));
                        img.setUpdatedAt(rs.getTimestamp("image_updatedat"));
                        img.setProduct(p);
                        p.getImages().add(img);
                    }
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        list.addAll(productMap.values());
        return list;
    }

    @Override
    public boolean updateProduct(Product product) throws SQLException {
        boolean updated = false;
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
                ps.setString(1, product.getName());
                ps.setString(2, product.getDescription());
                ps.setBigDecimal(3, product.getPrice());
                ps.setInt(4, product.getCategory().getCategoryid());
                ps.setString(5, product.getBrand());
                ps.setBigDecimal(6, product.getDiscount());
                ps.setBoolean(7, product.isBestseller());
                ps.setInt(8, product.getProductId());

                int rows = ps.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            int productId = product.getProductId();

            try (PreparedStatement psDeleteStock = conn
                    .prepareStatement("DELETE FROM product_color_size WHERE productid = ?")) {
                psDeleteStock.setInt(1, productId);
                psDeleteStock.executeUpdate();
            }

            try (PreparedStatement psDeleteImages = conn
                    .prepareStatement("DELETE FROM product_image WHERE productid = ?")) {
                psDeleteImages.setInt(1, productId);
                psDeleteImages.executeUpdate();
            }

            if (product.getColorSizes() != null && !product.getColorSizes().isEmpty()) {
                String insertStockSQL = "INSERT INTO product_color_size (productid, color, size, stock) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psInsertStock = conn.prepareStatement(insertStockSQL)) {
                    for (ProductColorSize pcs : product.getColorSizes()) {
                        psInsertStock.setInt(1, productId);
                        psInsertStock.setString(2, pcs.getColor());
                        psInsertStock.setString(3, pcs.getSize());
                        psInsertStock.setInt(4, pcs.getStock());
                        psInsertStock.addBatch();
                    }
                    psInsertStock.executeBatch();
                }
            }

            if (product.getImages() != null && !product.getImages().isEmpty()) {
                String insertImageSQL = "INSERT INTO product_image (productid, color, imageurl, isprimary) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psInsertImage = conn.prepareStatement(insertImageSQL)) {
                    for (ProductImage img : product.getImages()) {
                        psInsertImage.setInt(1, productId);
                        psInsertImage.setString(2, img.getColor());
                        psInsertImage.setString(3, img.getImageUrl());
                        psInsertImage.setBoolean(4, img.isPrimary());
                        psInsertImage.addBatch();
                    }
                    psInsertImage.executeBatch();
                }
            }

            conn.commit();
            updated = true;
            logger.info("✅ Product updated successfully (with images/stock): ID=" + product.getProductId());

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            printSQLException(e);
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
            }
        }
        return updated;
    }

    @Override
    public boolean deleteProduct(int productId) throws SQLException {
        boolean deleted = false;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, productId);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                deleted = true;
                logger.info("✅ Product deleted successfully: ID=" + productId);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return deleted;
    }

    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException sqlEx) {
                logger.log(Level.SEVERE, "SQL Error", sqlEx);
                System.err.println("SQLState: " + sqlEx.getSQLState());
                System.err.println("Error Code: " + sqlEx.getErrorCode());
                System.err.println("Message: " + sqlEx.getMessage());
                Throwable t = sqlEx.getCause();
                while (t != null) {
                    System.err.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}

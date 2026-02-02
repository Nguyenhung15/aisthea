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
        INSERT INTO Products (name, description, price, categoryid, brand, discount, createdat, updatedat)
        VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())
    """;
    private static final String SELECT_BY_ID = "SELECT * FROM Products WHERE productid = ?";
    private static final String SELECT_ALL = "SELECT * FROM Products";
    private static final String UPDATE_SQL = """
        UPDATE Products
        SET name = ?, description = ?, price = ?, categoryid = ?, brand = ?, discount = ?, updatedat = GETDATE()
        WHERE productid = ?
    """;
    private static final String DELETE_SQL = "DELETE FROM Products WHERE productid = ?";
    private static final String SELECT_BY_PARENT_CATEGORY_OPTIMIZED = """
    SELECT
        p.productid, p.name, p.description, p.price, p.brand, p.discount,
        p.createdat, p.updatedat, p.categoryid,
        c.name AS category_name, c.type AS category_type, 
        c.genderid AS category_genderid, c.parentid AS category_parentid, 
        c.INDEX_name AS category_index,
        img.imageurl AS primary_image_url
    FROM
        Products p
    JOIN
        Categories c ON p.categoryid = c.categoryid
    LEFT JOIN
        product_image img ON p.productid = img.productid AND img.isprimary = 1
    WHERE
        c.genderid = ? 
        AND (c.INDEX_name = ? OR c.parentid = ?)
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
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
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
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ALL); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int productId = rs.getInt("productid");
                if (productId == 0) {
                    System.out.println("Warning: productId is 0 for a product. Check your data!");
                }

                String name = rs.getString("name");
                String description = rs.getString("description");
                BigDecimal price = rs.getBigDecimal("price");
                String brand = rs.getString("brand");
                BigDecimal discount = rs.getBigDecimal("discount");
                Date createdAt = rs.getTimestamp("createdat");
                Date updatedAt = rs.getTimestamp("updatedat");
                Product p = new Product(productId, name, description, price, brand, discount, createdAt, updatedAt);

                int categoryId = rs.getInt("categoryid");
                Category category = categoryDAO.selectCategory(categoryId);
                p.setCategory(category);
                p.setColorSizes(colorSizeDAO.getByProductId(productId));
                p.setImages(imageDAO.getByProductId(productId));
                list.add(p);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return list;
    }

    @Override
    public List<Product> getProductsByParentCategory(String parentIndex, int genderId) throws SQLException {
        List<Product> list = new ArrayList<>();

        // Sử dụng truy vấn SQL mới
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_BY_PARENT_CATEGORY_OPTIMIZED)) {

            // Gán các tham số cho câu lệnh WHERE
            ps.setInt(1, genderId);    // c.genderid = ?
            ps.setString(2, parentIndex); // c.INDEX_name = ?
            ps.setString(3, parentIndex); // c.parentid = ?

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // 1. Tạo đối tượng Product
                    Product p = new Product();
                    p.setProductId(rs.getInt("productid"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setBrand(rs.getString("brand"));
                    p.setDiscount(rs.getBigDecimal("discount"));
                    p.setCreatedAt(rs.getTimestamp("createdat"));
                    p.setUpdatedAt(rs.getTimestamp("updatedat"));

                    // 2. Tạo đối tượng Category (từ các cột đã JOIN)
                    Category category = new Category();
                    category.setCategoryid(rs.getInt("categoryid"));
                    category.setName(rs.getString("category_name"));
                    category.setType(rs.getString("category_type"));
                    category.setGenderid(rs.getInt("category_genderid"));
                    category.setParentid(rs.getString("category_parentid"));
                    category.setIndexName(rs.getString("category_index"));

                    p.setCategory(category);

                    // 3. Xử lý ảnh đại diện (từ cột đã JOIN)
                    String primaryImageUrl = rs.getString("primary_image_url");
                    List<ProductImage> images = new ArrayList<>();
                    if (primaryImageUrl != null && !primaryImageUrl.isBlank()) {
                        ProductImage primaryImg = new ProductImage();
                        primaryImg.setImageUrl(primaryImageUrl);
                        primaryImg.setPrimary(true);
                        primaryImg.setProduct(p);
                        images.add(primaryImg);
                    }

                    p.setImages(images);

                    // 4. Bỏ qua ColorSizes cho trang danh sách
                    p.setColorSizes(new ArrayList<>());

                    list.add(p);
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
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
                ps.setInt(7, product.getProductId());

                int rows = ps.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            int productId = product.getProductId();

            try (PreparedStatement psDeleteStock = conn.prepareStatement("DELETE FROM product_color_size WHERE productid = ?")) {
                psDeleteStock.setInt(1, productId);
                psDeleteStock.executeUpdate();
            }

            try (PreparedStatement psDeleteImages = conn.prepareStatement("DELETE FROM product_image WHERE productid = ?")) {
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

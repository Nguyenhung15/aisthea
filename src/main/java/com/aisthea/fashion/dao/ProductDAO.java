package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
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
                    int[] batchResults = psInsertStock.executeBatch();
                    logger.info("Batch stock insert result: " + batchResults.length + " rows.");
                } catch (BatchUpdateException bue) {
                    logger.log(Level.SEVERE, "Lỗi khi chèn loạt biến thể (Stock Batch): " + bue.getMessage(), bue);
                    throw new SQLException("Lỗi biến thể sản phẩm: " + bue.getMessage(), bue);
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
                    int[] batchResults = psInsertImage.executeBatch();
                    logger.info("Batch images insert result: " + batchResults.length + " rows.");
                } catch (BatchUpdateException bue) {
                    logger.log(Level.SEVERE, "Lỗi khi chèn loạt hình ảnh (Image Batch): " + bue.getMessage(), bue);
                    throw new SQLException("Lỗi hình ảnh sản phẩm: " + bue.getMessage(), bue);
                }
            }

            conn.commit();
            inserted = true;
            logger.info("✅ Product inserted successfully: " + product.getName() + " (ID: " + newProductId + ")");

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
    public List<Product> getFilteredProducts(
            Integer categoryId,
            String categoryIndex,
            Integer genderId,
            String color,
            String size,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            String keyword,
            String sortBy
    ) throws SQLException {

        List<Product> list = new ArrayList<>();
        Map<Integer, Product> productMap = new LinkedHashMap<>();

        StringBuilder sql = new StringBuilder("""
            SELECT
                p.productid, p.name, p.description, p.price, p.brand, p.discount, p.is_bestseller,
                p.createdat, p.updatedat, p.categoryid,
                c.name AS category_name, c.type AS category_type,
                c.genderid AS category_genderid, c.parentid AS category_parentid,
                c.INDEX_name AS category_index,
                img.imageid AS image_id, img.imageurl AS image_url,
                img.color AS image_color, img.isprimary AS image_isprimary,
                img.createdat AS image_createdat, img.updatedat AS image_updatedat,
                (SELECT COALESCE(SUM(pcs2.stock),0)
                 FROM product_color_size pcs2
                 WHERE pcs2.productid = p.productid) AS total_stock
            FROM Products p
            LEFT JOIN Categories c ON p.categoryid = c.categoryid
            LEFT JOIN product_image img ON p.productid = img.productid
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        // -- CATEGORY filters --
        if (categoryId != null) {
            // Show products in this category OR any child category whose parentid = this category's index
            sql.append("""
                AND (
                    p.categoryid = ?
                    OR p.categoryid IN (
                        SELECT c2.categoryid FROM Categories c2
                        JOIN Categories cp ON c2.parentid = cp.INDEX_name
                        WHERE cp.categoryid = ?
                    )
                )
            """);
            params.add(categoryId);
            params.add(categoryId);
        } else if (categoryIndex != null && !categoryIndex.isBlank()) {
            // Parent category index filter (e.g. navigating to /men/ao_thun)
            sql.append("""
                AND c.genderid = ?
                AND (c.INDEX_name = ? OR c.parentid = ?)
            """);
            params.add(genderId != null ? genderId : 1);
            params.add(categoryIndex);
            params.add(categoryIndex);
        } else if (genderId != null) {
            // Gender-only filter
            sql.append(" AND c.genderid = ? ");
            params.add(genderId);
        }

        // -- KEYWORD search --
        // Bỏ tiền tố loại quần áo nếu có từ phía sau
        // VD: "áo khoác" → tìm "khoác" | "quần jeans" → tìm "jeans" | "áo" (1 từ) → tìm "áo"
        if (keyword != null && !keyword.isBlank()) {
            String effectiveKeyword = keyword.trim();
            String[] CLOTHING_PREFIXES = {"áo", "quần", "váy", "đầm", "đồ", "bộ", "set"};
            String[] parts = effectiveKeyword.toLowerCase().split("\\s+");
            if (parts.length > 1) {
                for (String prefix : CLOTHING_PREFIXES) {
                    if (parts[0].equals(prefix)) {
                        // Bỏ từ đầu, chỉ giữ phần còn lại
                        effectiveKeyword = effectiveKeyword.substring(parts[0].length()).trim();
                        break;
                    }
                }
            }
            sql.append(" AND (p.name LIKE ? OR c.name LIKE ?) ");
            String kw = "%" + effectiveKeyword + "%";
            params.add(kw); params.add(kw);
        }

        // -- PRICE range --
        if (minPrice != null && minPrice.compareTo(BigDecimal.ZERO) > 0) {
            sql.append(" AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND p.price <= ? ");
            params.add(maxPrice);
        }

        // -- COLOR filter --
        if (color != null && !color.isBlank()) {
            sql.append("""
                AND EXISTS (
                    SELECT 1 FROM product_color_size pcs
                    WHERE pcs.productid = p.productid
                    AND LOWER(pcs.color) LIKE LOWER(?)
                )
            """);
            params.add("%" + color.trim() + "%");
        }

        // -- SIZE filter --
        if (size != null && !size.isBlank()) {
            sql.append("""
                AND EXISTS (
                    SELECT 1 FROM product_color_size pcs
                    WHERE pcs.productid = p.productid
                    AND UPPER(pcs.size) = UPPER(?)
                    AND pcs.stock > 0
                )
            """);
            params.add(size.trim());
        }

        // -- SORT --
        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc"  -> sql.append(" ORDER BY p.price ASC, p.productid ");
                case "price_desc" -> sql.append(" ORDER BY p.price DESC, p.productid ");
                case "newest"     -> sql.append(" ORDER BY p.productid DESC ");
                default           -> sql.append(" ORDER BY p.productid ");
            }
        } else {
            sql.append(" ORDER BY p.productid ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer)       ps.setInt(i + 1, (Integer) p);
                else if (p instanceof BigDecimal) ps.setBigDecimal(i + 1, (BigDecimal) p);
                else                             ps.setString(i + 1, (String) p);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("productid");
                    Product product = productMap.get(productId);
                    if (product == null) {
                        product = new Product();
                        product.setProductId(productId);
                        product.setName(rs.getString("name"));
                        product.setDescription(rs.getString("description"));
                        product.setPrice(rs.getBigDecimal("price"));
                        product.setBrand(rs.getString("brand"));
                        product.setDiscount(rs.getBigDecimal("discount"));
                        product.setBestseller(rs.getBoolean("is_bestseller"));
                        product.setCreatedAt(rs.getTimestamp("createdat"));
                        product.setUpdatedAt(rs.getTimestamp("updatedat"));
                        product.setTotalStock(rs.getInt("total_stock"));

                        Category category = new Category();
                        category.setCategoryid(rs.getInt("categoryid"));
                        category.setName(rs.getString("category_name"));
                        category.setType(rs.getString("category_type"));
                        category.setGenderid(rs.getInt("category_genderid"));
                        category.setParentid(rs.getString("category_parentid"));
                        category.setIndexName(rs.getString("category_index"));
                        product.setCategory(category);

                        product.setImages(new ArrayList<>());
                        product.setColorSizes(new ArrayList<>());
                        productMap.put(productId, product);
                    }

                    String imageUrl = rs.getString("image_url");
                    if (imageUrl != null && !imageUrl.isBlank()) {
                        ProductImage img = new ProductImage();
                        img.setImageId(rs.getInt("image_id"));
                        img.setImageUrl(imageUrl);
                        img.setColor(rs.getString("image_color"));
                        img.setPrimary(rs.getBoolean("image_isprimary"));
                        img.setCreatedAt(rs.getTimestamp("image_createdat"));
                        img.setUpdatedAt(rs.getTimestamp("image_updatedat"));
                        product.getImages().add(img);
                    }
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
        }

        // Load colorSizes for each product (needed for swatch rendering on listing page)
        for (Product p : productMap.values()) {
            try {
                p.setColorSizes(colorSizeDAO.getByProductId(p.getProductId()));
            } catch (SQLException e) {
                logger.warning("Could not load colorSizes for product " + p.getProductId());
            }
            list.add(p);
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
                    int[] results = psInsertStock.executeBatch();
                    logger.info("Batch stock update result: " + results.length + " rows.");
                } catch (BatchUpdateException bue) {
                    logger.log(Level.SEVERE, "Lỗi cập nhật loạt biến thể (Stock Update Batch): " + bue.getMessage(), bue);
                    throw new SQLException("Lỗi biến thể sản phẩm: " + bue.getMessage(), bue);
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
                    int[] results = psInsertImage.executeBatch();
                    logger.info("Batch images update result: " + results.length + " rows.");
                } catch (BatchUpdateException bue) {
                    logger.log(Level.SEVERE, "Lỗi cập nhật loạt hình ảnh (Image Update Batch): " + bue.getMessage(), bue);
                    throw new SQLException("Lỗi hình ảnh sản phẩm: " + bue.getMessage(), bue);
                }
            }

            conn.commit();
            updated = true;
            logger.info("✅ Product updated successfully: ID=" + product.getProductId());

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

    @Override
    public List<Product> getTopExpensiveProducts(int limit) throws SQLException {
        String sql = "SELECT TOP " + limit + " p.*, c.name as category_name "
                + "FROM Products p JOIN Categories c ON p.categoryid = c.categoryid "
                + "ORDER BY p.price DESC";
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("productid"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setBrand(rs.getString("brand"));
                Category c = new Category();
                c.setName(rs.getString("category_name"));
                p.setCategory(c);
                list.add(p);
            }
        }
        return list;
    }

    @Override
    public String getInventorySummary() throws SQLException {
        // Giảm xuống TOP 12 để ưu tiên tính năng "đổi màu hiện ảnh" mà không lo hết token (6000 limit)
        String sql = "SELECT TOP 12 p.productid, p.name, p.price, p.is_bestseller, c.name as cat_name, "
                + "(SELECT COALESCE(SUM(oi.quantity), 0) FROM orderitems oi "
                + " JOIN product_color_size pcs ON oi.productcolorsizeid = pcs.productcolorsizeid "
                + " WHERE pcs.productid = p.productid) as sold_qty "
                + "FROM Products p JOIN Categories c ON p.categoryid = c.categoryid "
                + "ORDER BY sold_qty DESC, p.updatedat DESC";
        
        StringBuilder sb = new StringBuilder();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                int pid = rs.getInt("productid");
                StringBuilder colorMap = new StringBuilder("[");
                
                String imgSql = "SELECT imageurl, color FROM product_image WHERE productid = ? ORDER BY isprimary DESC";
                try (PreparedStatement ips = conn.prepareStatement(imgSql)) {
                    ips.setInt(1, pid);
                    try (ResultSet irs = ips.executeQuery()) {
                        while (irs.next()) {
                            String color = irs.getString("color");
                            String url = irs.getString("imageurl");
                            colorMap.append(color != null && !color.isEmpty() ? color : "Default").append(":").append(url).append(",");
                        }
                    }
                }
                
                sb.append("ID:").append(pid)
                  .append("|").append(rs.getString("name"))
                  .append("|").append(String.format("%.0f", rs.getBigDecimal("price")))
                  .append("|S:").append(rs.getInt("sold_qty"))
                  .append("|M-A:").append(colorMap.toString())
                  .append("\n");
            }
        }
        return sb.toString();
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

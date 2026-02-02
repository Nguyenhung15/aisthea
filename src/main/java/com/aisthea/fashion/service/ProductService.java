package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.*;
import com.aisthea.fashion.model.*;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductService implements IProductService {

    private static final Logger logger = Logger.getLogger(ProductService.class.getName());

    private final IProductDAO productDAO;
    private final IProductColorSizeDAO colorSizeDAO;
    private final IProductImageDAO imageDAO;

    public ProductService() {
        this.productDAO = new ProductDAO();
        this.colorSizeDAO = new ProductColorSizeDAO();
        this.imageDAO = new ProductImageDAO();

        if (imageDAO instanceof ProductImageDAO imgDAO && productDAO instanceof ProductDAO pDAO) {
            imgDAO.setProductDAO(pDAO);
        }
    }

    @Override
    public Product getProductById(int id) {
        try {
            return productDAO.getProductById(id);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching product by ID: " + id, e);
            return null;
        }
    }

    @Override
    public List<Product> getAllProducts() {
        try {
            return productDAO.getAllProducts();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching all products", e);
            return List.of();
        }
    }

    @Override
    public boolean addProduct(Product product) throws SQLException {
        try {
            return productDAO.addProduct(product);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi Service khi thêm sản phẩm", e);
            throw e;
        }
    }

    @Override
    public boolean updateProduct(Product product) throws SQLException {
        try {
            return productDAO.updateProduct(product);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi Service khi cập nhật sản phẩm", e);
            throw e;
        }
    }

    @Override
    public boolean deleteProduct(int id) {
        try {
            return productDAO.deleteProduct(id);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting product ID=" + id, e);
            return false;
        }
    }

    @Override
    public List<ProductColorSize> getColorSizesByProductId(int productId) {
        try {
            return colorSizeDAO.getByProductId(productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching color-size list", e);
            return List.of();
        }
    }

    @Override
    public boolean addColorSize(ProductColorSize pcs, int productId) {
        try {
            return colorSizeDAO.addProductColorSize(pcs, productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding color-size", e);
            return false;
        }
    }

    @Override
    public void updateStock(int productColorSizeId, int newStock) {
        try {
            colorSizeDAO.updateStock(productColorSizeId, newStock);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating stock", e);
        }
    }

    @Override
    public void deleteColorSize(int productColorSizeId) {
        try {
            colorSizeDAO.deleteById(productColorSizeId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting color-size", e);
        }
    }

    @Override
    public List<ProductImage> getImagesByProductId(int productId) {
        try {
            return imageDAO.getByProductId(productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching images", e);
            return List.of();
        }
    }

    @Override
    public ProductImage getPrimaryImage(int productId) {
        try {
            return imageDAO.getPrimaryImageByProductId(productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching primary image", e);
            return null;
        }
    }

    @Override
    public boolean addProductImage(ProductImage img, int productId) {
        try {
            return imageDAO.addProductImage(img, productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding product image", e);
            return false;
        }
    }

    @Override
    public void updateProductImage(ProductImage img) {
        try {
            imageDAO.updateImage(img);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating product image", e);
        }
    }

    @Override
    public void deleteImagesByProductId(int productId) {
        try {
            imageDAO.deleteByProductId(productId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting product images", e);
        }
    }

    @Override
    public List<Product> getProductsByParentCategory(String parentIndex, int genderId) {
        try {
            return productDAO.getProductsByParentCategory(parentIndex, genderId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching products by parent category: " + parentIndex, e);
            return List.of();
        }
    }
}

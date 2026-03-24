package com.aisthea.fashion.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.CartItem;

public class CartDAO {

    public Integer getCartId(Integer userId, String sessionId) {
        String sql = userId != null
                ? "SELECT cartid FROM cart WHERE userid = ?"
                : "SELECT cartid FROM cart WHERE sessionid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, sessionId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cartid");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createCart(Integer userId, String sessionId) {
        String insertSql = userId != null
                ? "INSERT INTO cart (userid, createdat) VALUES (?, GETDATE())"
                : "INSERT INTO cart (sessionid, createdat) VALUES (?, GETDATE())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, sessionId);
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Cart getCart(Integer userId, String sessionId) {
        Cart cart = new Cart();
        Integer cartId = getCartId(userId, sessionId);
        if (cartId == null) {
            return cart;
        }

        String sql = "SELECT ci.quantity, ci.productcolorsizeid, p.productid, p.name, " +
                "p.price - (p.price * ISNULL(p.discount, 0) / 100.0) AS actualPrice, " +
                "pcs.color, pcs.size, " +
                "(SELECT TOP 1 imageurl FROM product_image pi WHERE pi.productid = p.productid AND pi.isprimary = 1) AS thumbnail, " +
                "(SELECT TOP 1 imageurl FROM product_image pi WHERE pi.productid = p.productid) AS anyimage " +
                "FROM cart_items ci " +
                "JOIN product_color_size pcs ON ci.productcolorsizeid = pcs.productcolorsizeid " +
                "JOIN Products p ON pcs.productid = p.productid " +
                "WHERE ci.cartid = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setProductId(rs.getInt("productid"));
                    item.setProductColorSizeId(rs.getInt("productcolorsizeid"));
                    item.setProductName(rs.getString("name"));
                    item.setColor(rs.getString("color"));
                    item.setSize(rs.getString("size"));
                    item.setPrice(rs.getBigDecimal("actualPrice"));
                    item.setQuantity(rs.getInt("quantity"));
                    
                    String img = rs.getString("thumbnail");
                    if (img == null) img = rs.getString("anyimage");
                    item.setProductImageUrl(img);

                    cart.addItem(item); // this just puts it in the map
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cart;
    }

    public void addOrUpdateItem(int cartId, CartItem item) {
        String checkSql = "SELECT quantity FROM cart_items WHERE cartid = ? AND productcolorsizeid = ?";
        String updateSql = "UPDATE cart_items SET quantity = ? WHERE cartid = ? AND productcolorsizeid = ?";
        String insertSql = "INSERT INTO cart_items (cartid, productcolorsizeid, quantity, createdat) VALUES (?, ?, ?, GETDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, cartId);
            checkPs.setInt(2, item.getProductColorSizeId());
            boolean exists = false;
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    exists = true;
                }
            }

            if (exists) {
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setInt(1, item.getQuantity());
                    updatePs.setInt(2, cartId);
                    updatePs.setInt(3, item.getProductColorSizeId());
                    updatePs.executeUpdate();
                }
            } else {
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, cartId);
                    insertPs.setInt(2, item.getProductColorSizeId());
                    insertPs.setInt(3, item.getQuantity());
                    insertPs.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void removeItem(int cartId, int pcsId) {
        String sql = "DELETE FROM cart_items WHERE cartid = ? AND productcolorsizeid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, pcsId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void clearCart(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cartid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void mergeCarts(String sessionId, Integer userId) {
        Integer guestCartId = getCartId(null, sessionId);
        if (guestCartId == null) {
            return;
        }

        Integer userCartId = getCartId(userId, null);
        if (userCartId == null) {
            // User doesn't have a cart, turn guest cart into user cart
            String sql = "UPDATE cart SET userid = ?, sessionid = NULL WHERE cartid = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, guestCartId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            // User already has a cart, merge items from guest cart into user cart
            String mergeSql = "SELECT productcolorsizeid, quantity FROM cart_items WHERE cartid = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(mergeSql)) {
                ps.setInt(1, guestCartId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        CartItem dummy = new CartItem();
                        dummy.setProductColorSizeId(rs.getInt("productcolorsizeid"));
                        dummy.setQuantity(rs.getInt("quantity"));
                        // First check if item exists in user cart, if so, add quantity. Otherwise map insert.
                        // To keep it simple, we load the user's cart from DB to see if we add or update:
                        addQuantityToCart(userCartId, dummy.getProductColorSizeId(), dummy.getQuantity());
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            // Finally delete the guest cart and its items
            clearCart(guestCartId);
            String delCartSql = "DELETE FROM cart WHERE cartid = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(delCartSql)) {
                ps.setInt(1, guestCartId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Helper to safely increment quantity during merge
    private void addQuantityToCart(int cartId, int pcsId, int qtyToAdd) throws SQLException {
        String checkSql = "SELECT quantity FROM cart_items WHERE cartid = ? AND productcolorsizeid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, pcsId);
            int currentQty = -1;
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    currentQty = rs.getInt("quantity");
                }
            }
            if (currentQty >= 0) {
                String updateSql = "UPDATE cart_items SET quantity = ? WHERE cartid = ? AND productcolorsizeid = ?";
                try (PreparedStatement ups = conn.prepareStatement(updateSql)) {
                    ups.setInt(1, currentQty + qtyToAdd);
                    ups.setInt(2, cartId);
                    ups.setInt(3, pcsId);
                    ups.executeUpdate();
                }
            } else {
                String insertSql = "INSERT INTO cart_items (cartid, productcolorsizeid, quantity, createdat) VALUES (?, ?, ?, GETDATE())";
                try (PreparedStatement ips = conn.prepareStatement(insertSql)) {
                    ips.setInt(1, cartId);
                    ips.setInt(2, pcsId);
                    ips.setInt(3, qtyToAdd);
                    ips.executeUpdate();
                }
            }
        }
    }
}

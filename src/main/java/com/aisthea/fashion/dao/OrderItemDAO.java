package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.OrderItem;
import com.aisthea.fashion.dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO implements IOrderItemDAO {

    private static final String INSERT_ORDER_ITEM = "INSERT INTO orderitems (orderid, productcolorsizeid, color, size, quantity, price, image_url, product_name) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ITEMS_BY_ORDERID = "SELECT * FROM orderitems WHERE orderid = ?";
    private static final String UPDATE_STOCK = "UPDATE product_color_size SET stock = stock - ? "
            + "WHERE productcolorsizeid = ? AND stock >= ?";
    private static final String RESTORE_STOCK = "UPDATE product_color_size SET stock = stock + ? WHERE productcolorsizeid = ?";

    @Override
    public void addOrderItem(OrderItem item, Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(INSERT_ORDER_ITEM)) {
            ps.setInt(1, item.getOrderid());
            ps.setInt(2, item.getProductcolorsizeid());
            ps.setString(3, item.getColor());
            ps.setString(4, item.getSize());
            ps.setInt(5, item.getQuantity());
            ps.setBigDecimal(6, item.getPrice());
            ps.setString(7, item.getImageUrl());
            ps.setString(8, item.getProductName());

            ps.executeUpdate();
        }
    }

    @Override
    public boolean updateStock(OrderItem item, Connection conn) throws SQLException {
        try (PreparedStatement psStock = conn.prepareStatement(UPDATE_STOCK)) {
            psStock.setInt(1, item.getQuantity());
            psStock.setInt(2, item.getProductcolorsizeid());
            psStock.setInt(3, item.getQuantity());
            int rowsAffected = psStock.executeUpdate();
            return rowsAffected > 0;
        }
    }

    @Override
    public boolean increaseStock(OrderItem item, Connection conn) throws SQLException {
        try (PreparedStatement psStock = conn.prepareStatement(RESTORE_STOCK)) {
            psStock.setInt(1, item.getQuantity());
            psStock.setInt(2, item.getProductcolorsizeid());
            int rowsAffected = psStock.executeUpdate();
            return rowsAffected > 0;
        }
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ITEMS_BY_ORDERID)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderitemid(rs.getInt("orderitemid"));
                item.setOrderid(rs.getInt("orderid"));
                item.setProductcolorsizeid(rs.getInt("productcolorsizeid"));
                item.setColor(rs.getString("color"));
                item.setSize(rs.getString("size"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setImageUrl(rs.getString("image_url"));
                item.setProductName(rs.getString("product_name"));

                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (e instanceof SQLException) {
                throw (SQLException) e;
            }
        }
        return items;
    }
}

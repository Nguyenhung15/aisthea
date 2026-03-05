package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.UserAddress;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserAddressDAO {

    public List<UserAddress> getByUserId(int userId) {
        List<UserAddress> addresses = new ArrayList<>();
        String sql = "SELECT * FROM UserAddresses WHERE UserID = ? ORDER BY IsDefault DESC, CreatedAt DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    addresses.add(extractFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return addresses;
    }

    public UserAddress getById(int addressId, int userId) {
        String sql = "SELECT * FROM UserAddresses WHERE AddressID = ? AND UserID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(UserAddress address) throws SQLException {
        String sql = "INSERT INTO UserAddresses (UserID, FullName, Phone, DetailedAddress, IsDefault, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getFullName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getDetailedAddress());
            ps.setBoolean(5, address.isDefault());
            ps.executeUpdate();
        }
    }

    public void update(UserAddress address) throws SQLException {
        String sql = "UPDATE UserAddresses SET FullName = ?, Phone = ?, DetailedAddress = ?, IsDefault = ?, UpdatedAt = GETDATE() WHERE AddressID = ? AND UserID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, address.getFullName());
            ps.setString(2, address.getPhone());
            ps.setString(3, address.getDetailedAddress());
            ps.setBoolean(4, address.isDefault());
            ps.setInt(5, address.getAddressId());
            ps.setInt(6, address.getUserId());
            ps.executeUpdate();
        }
    }

    public void delete(int addressId, int userId) throws SQLException {
        String sql = "DELETE FROM UserAddresses WHERE AddressID = ? AND UserID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void setAsDefault(int addressId, int userId) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Clear old defaults for user
                String clearSql = "UPDATE UserAddresses SET IsDefault = 0 WHERE UserID = ?";
                try (PreparedStatement psClear = conn.prepareStatement(clearSql)) {
                    psClear.setInt(1, userId);
                    psClear.executeUpdate();
                }

                // Set new default
                String setSql = "UPDATE UserAddresses SET IsDefault = 1 WHERE AddressID = ? AND UserID = ?";
                try (PreparedStatement psSet = conn.prepareStatement(setSql)) {
                    psSet.setInt(1, addressId);
                    psSet.setInt(2, userId);
                    psSet.executeUpdate();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public void clearDefault(int userId) throws SQLException {
        String sql = "UPDATE UserAddresses SET IsDefault = 0 WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    private UserAddress extractFromResultSet(ResultSet rs) throws SQLException {
        UserAddress address = new UserAddress();
        address.setAddressId(rs.getInt("AddressID"));
        address.setUserId(rs.getInt("UserID"));
        address.setFullName(rs.getString("FullName"));
        address.setPhone(rs.getString("Phone"));
        address.setDetailedAddress(rs.getString("DetailedAddress"));
        address.setDefault(rs.getBoolean("IsDefault"));
        address.setCreatedAt(rs.getTimestamp("CreatedAt"));
        address.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return address;
    }
}

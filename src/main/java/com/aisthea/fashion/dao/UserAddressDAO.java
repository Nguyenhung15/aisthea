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
        String sql = "INSERT INTO UserAddresses (UserID, FullName, Phone, DetailedAddress, IsDefault, CreatedAt, UpdatedAt, " +
                     "ProvinceID, ProvinceName, DistrictID, DistrictName, WardCode, WardName) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getFullName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getDetailedAddress());
            ps.setBoolean(5, address.isDefault());
            
            ps.setInt(6, address.getProvinceId() != 0 ? address.getProvinceId() : 201); // Default to Da Nang if 0
            if (address.getProvinceName() != null) ps.setString(7, address.getProvinceName()); else ps.setNull(7, java.sql.Types.NVARCHAR);
            if (address.getDistrictId() != 0) ps.setInt(8, address.getDistrictId()); else ps.setNull(8, java.sql.Types.INTEGER);
            if (address.getDistrictName() != null) ps.setString(9, address.getDistrictName()); else ps.setNull(9, java.sql.Types.NVARCHAR);
            if (address.getWardCode() != null) ps.setString(10, address.getWardCode()); else ps.setNull(10, java.sql.Types.VARCHAR);
            if (address.getWardName() != null) ps.setString(11, address.getWardName()); else ps.setNull(11, java.sql.Types.NVARCHAR);
            
            ps.executeUpdate();
        }
    }

    public void update(UserAddress address) throws SQLException {
        String sql = "UPDATE UserAddresses SET FullName = ?, Phone = ?, DetailedAddress = ?, IsDefault = ?, UpdatedAt = GETDATE(), " +
                     "ProvinceID = ?, ProvinceName = ?, DistrictID = ?, DistrictName = ?, WardCode = ?, WardName = ? " +
                     "WHERE AddressID = ? AND UserID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, address.getFullName());
            ps.setString(2, address.getPhone());
            ps.setString(3, address.getDetailedAddress());
            ps.setBoolean(4, address.isDefault());
            
            ps.setInt(5, address.getProvinceId() != 0 ? address.getProvinceId() : 201);
            if (address.getProvinceName() != null) ps.setString(6, address.getProvinceName()); else ps.setNull(6, java.sql.Types.NVARCHAR);
            if (address.getDistrictId() != 0) ps.setInt(7, address.getDistrictId()); else ps.setNull(7, java.sql.Types.INTEGER);
            if (address.getDistrictName() != null) ps.setString(8, address.getDistrictName()); else ps.setNull(8, java.sql.Types.NVARCHAR);
            if (address.getWardCode() != null) ps.setString(9, address.getWardCode()); else ps.setNull(9, java.sql.Types.VARCHAR);
            if (address.getWardName() != null) ps.setString(10, address.getWardName()); else ps.setNull(10, java.sql.Types.NVARCHAR);
            
            ps.setInt(11, address.getAddressId());
            ps.setInt(12, address.getUserId());
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

    private UserAddress extractFromResultSet(ResultSet rs) {
        UserAddress address = new UserAddress();
        try {
            address.setAddressId(rs.getInt("AddressID"));
            address.setUserId(rs.getInt("UserID"));
            address.setFullName(rs.getString("FullName"));
            address.setPhone(rs.getString("Phone"));
            address.setDetailedAddress(rs.getString("DetailedAddress"));
            address.setDefault(rs.getBoolean("IsDefault"));
            address.setCreatedAt(rs.getTimestamp("CreatedAt"));
            address.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
            
            // New geographic fields (might throw if columns don't exist yet, we catch to ensure backwards compatibility)
            address.setProvinceId(rs.getInt("ProvinceID"));
            address.setProvinceName(rs.getString("ProvinceName"));
            address.setDistrictId(rs.getInt("DistrictID"));
            address.setDistrictName(rs.getString("DistrictName"));
            address.setWardCode(rs.getString("WardCode"));
            address.setWardName(rs.getString("WardName"));
        } catch (SQLException ignore) {
            // Geographic columns might not exist if migration hasn't run yet
        }
        return address;
    }
}

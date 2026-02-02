package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Category;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO implements ICategoryDAO {

    private static final String INSERT_CATEGORY = "INSERT INTO Categories (name, type, genderid, parentid, INDEX_name, createdat, updatedat) "
            + "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
    private static final String GET_ALL_CATEGORY = "SELECT * FROM Categories";
    private static final String GET_CATEGORY_BY_ID = "SELECT * FROM Categories WHERE categoryid = ?";
    private static final String UPDATE_CATEGORY = "UPDATE Categories SET name = ?, type = ?, genderid = ?, parentid = ?, INDEX_name = ?, updatedat = GETDATE() WHERE categoryid = ?";
    private static final String DELETE_CATEGORY = "DELETE FROM Categories WHERE categoryid = ?";
    private static final String GET_PARENTS_BY_GENDER
            = "SELECT * FROM Categories WHERE parentid IS NULL AND genderid = ?";

    @Override
    public void insertCategory(Category cate) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                PreparedStatement ps = conn.prepareStatement(INSERT_CATEGORY);
                ps.setString(1, cate.getName());
                ps.setString(2, cate.getType());
                ps.setInt(3, cate.getGenderid());
                ps.setString(4, cate.getParentid());
                ps.setString(5, cate.getIndexName());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public Category selectCategory(int id) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                PreparedStatement ps = conn.prepareStatement(GET_CATEGORY_BY_ID);
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int categoryid = rs.getInt("categoryid");
                        String name = rs.getString("name");
                        String type = rs.getString("type");
                        int genderid = rs.getInt("genderid");
                        String parentid = rs.getString("parentid");
                        String indexName = rs.getString("INDEX_name");
                        Date createdat = rs.getDate("createdat");
                        Date updatedat = rs.getDate("updatedat");

                        return new Category(
                                categoryid,
                                name.trim(),
                                (type == null ? null : type.trim()),
                                genderid,
                                (parentid == null ? null : parentid.trim()),
                                (indexName == null ? null : indexName.trim()),
                                createdat,
                                updatedat
                        );
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Category> selectAllCategories() {
        List<Category> categories = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                PreparedStatement preparedStatement = con.prepareStatement(GET_ALL_CATEGORY);
                ResultSet rs = preparedStatement.executeQuery();
                while (rs.next()) {
                    int categoryid = rs.getInt("categoryid");
                    String name = rs.getString("name");
                    String type = rs.getString("type");
                    int genderid = rs.getInt("genderid");
                    String parentid = rs.getString("parentid");
                    String indexName = rs.getString("INDEX_name");
                    Date createdat = rs.getDate("createdat");
                    Date updatedat = rs.getDate("updatedat");

                    // SỬA LỖI: Kiểm tra NULL trước khi .trim()
                    categories.add(new Category(
                            categoryid,
                            name.trim(),
                            (type == null ? null : type.trim()),
                            genderid,
                            (parentid == null ? null : parentid.trim()),
                            (indexName == null ? null : indexName.trim()),
                            createdat,
                            updatedat
                    ));
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return categories;
    }

    @Override
    public boolean updateCategory(Category cate) throws SQLException {
        boolean rowUpdated = false;
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                PreparedStatement ps = conn.prepareStatement(UPDATE_CATEGORY);
                ps.setString(1, cate.getName());
                ps.setString(2, cate.getType());
                ps.setInt(3, cate.getGenderid());
                ps.setString(4, cate.getParentid());
                ps.setString(5, cate.getIndexName());
                ps.setInt(6, cate.getCategoryid());
                rowUpdated = ps.executeUpdate() > 0;
            }
        }
        return rowUpdated;
    }

    @Override
    public boolean deleteCategory(int id) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(DELETE_CATEGORY);
            ptm.setInt(1, id);
            return ptm.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Category> selectParentsByGender(int genderId) throws SQLException {
        List<Category> categories = new ArrayList<>();
        // Dùng SQL WHERE...
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_PARENTS_BY_GENDER)) {

            ps.setInt(1, genderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Tái sử dụng logic extract của bạn
                    categories.add(new Category(
                            rs.getInt("categoryid"),
                            rs.getString("name").trim(),
                            (rs.getString("type") == null ? null : rs.getString("type").trim()),
                            rs.getInt("genderid"),
                            (rs.getString("parentid") == null ? null : rs.getString("parentid").trim()),
                            (rs.getString("INDEX_name") == null ? null : rs.getString("INDEX_name").trim()),
                            rs.getDate("createdat"),
                            rs.getDate("updatedat")
                    ));
                }
            }
        } catch (SQLException e) {
            printSQLException(e); // In lỗi
            throw e; // Ném lỗi để Service xử lý
        }
        return categories;
    }

    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
    
    
    
        
        private static final String SELECT_BY_INDEX_AND_GENDER = "SELECT * FROM Categories WHERE INDEX_name = ? AND genderid = ?";
@Override
public Category selectCategoryByIndexAndGender(String indexName, int genderId) throws SQLException {
    Category category = null;
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(SELECT_BY_INDEX_AND_GENDER)) {
        
        ps.setString(1, indexName);
        ps.setInt(2, genderId);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                category = new Category();
                category.setCategoryid(rs.getInt("categoryid"));
                category.setName(rs.getString("name"));
                category.setType(rs.getString("type"));
                category.setGenderid(rs.getInt("genderid"));
                category.setParentid(rs.getString("parentid"));
                
                category.setIndexName(rs.getString("INDEX_name")); 
                
                category.setCreatedat(rs.getTimestamp("createdat"));
                category.setUpdatedat(rs.getTimestamp("updatedat"));
            }
        }
    } catch (SQLException e) {
        System.err.println("Lỗi SQL trong selectCategoryByIndexAndGender: " + e.getMessage());
        throw e;
    }
    return category;
}
}

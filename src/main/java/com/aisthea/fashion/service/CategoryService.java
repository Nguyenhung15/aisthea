package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.CategoryDAO;
import com.aisthea.fashion.dao.ICategoryDAO;
import com.aisthea.fashion.model.Category;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class CategoryService implements ICategoryService {

    private ICategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    @Override
    public void addCategory(Category category) throws SQLException {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên danh mục không được để trống");
        }
        categoryDAO.insertCategory(category);
    }

    @Override
    public Category getCategoryById(int id) {
        return categoryDAO.selectCategory(id);
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryDAO.selectAllCategories();
    }

    @Override
    public boolean removeCategory(int id) throws SQLException {
        return categoryDAO.deleteCategory(id);
    }

    @Override
    public boolean modifyCategory(Category category) throws SQLException {
        return categoryDAO.updateCategory(category);
    }

    private List<Category> filterCategories(Predicate<Category> condition) {
        List<Category> all = categoryDAO.selectAllCategories();
        if (all == null) {
            return new ArrayList<>();
        }
        try {
            // Lọc an toàn
            return all.stream().filter(condition).collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Lỗi khi lọc danh mục (filterCategories): " + e.getMessage());
            return new ArrayList<>(); // Trả về rỗng nếu có lỗi
        }
    }

    @Override
    public List<Category> getParentCategoriesByGender(int genderid) {
        try {
            return categoryDAO.selectParentsByGender(genderid);
        } catch (SQLException e) {
            System.err.println("Lỗi khi tải danh mục cha: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    @Override
    public List<Category> getChildCategories(String parentIndexName) {
        // SỬA LỖI: Kiểm tra null và bỏ logic mâu thuẫn
        if (parentIndexName == null || parentIndexName.isBlank()) {
            return new ArrayList<>();
        }
        return filterCategories(c
                -> c.getParentid() != null && parentIndexName.equalsIgnoreCase(c.getParentid())
        );
    }

    @Override
    public Category findCategoryByIndexNameAndGender(String indexName, int genderId) {
        try {
            return categoryDAO.selectCategoryByIndexAndGender(indexName, genderId);
        } catch (Exception e) {
            System.err.println("Lỗi khi tìm danh mục bằng index và gender: " + e.getMessage());
            return null;
        }
    }

    @Override
    public List<Category> searchCategories(
            Integer genderId, String parentIndexName, Boolean isParent, String type) {

        return filterCategories(c -> {
            boolean match = true;
            if (genderId != null) {
                match &= (c.getGenderid() == genderId);
            }
            if (isParent != null) {
                match &= (isParent ? c.getParentid() == null : c.getParentid() != null);
            }
            if (parentIndexName != null && !parentIndexName.isEmpty()) {
                // SỬA LỖI: Thêm kiểm tra 'c.getParentid() != null'
                match &= (c.getParentid() != null && parentIndexName.equalsIgnoreCase(c.getParentid()));
            }
            if (type != null && !type.isEmpty()) {
                // SỬA LỖI: Thêm kiểm tra 'c.getType() != null'
                match &= (c.getType() != null && type.equalsIgnoreCase(c.getType()));
            }
            return match;
        });
    }
}

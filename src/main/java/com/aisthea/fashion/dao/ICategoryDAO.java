package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.Category;
import java.sql.SQLException;
import java.util.List;

public interface ICategoryDAO {

    public void insertCategory(Category cate);

    public Category selectCategory(int id);

    public List<Category> selectAllCategories();

    public boolean deleteCategory(int id);

    public boolean updateCategory(Category cate) throws SQLException;

    List<Category> selectParentsByGender(int genderId) throws SQLException;

    Category selectCategoryByIndexAndGender(String indexName, int genderId) throws SQLException;

}

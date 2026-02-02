package com.aisthea.fashion.service;

import com.aisthea.fashion.model.Category;
import java.sql.SQLException;
import java.util.List;
import java.util.function.Predicate;

public interface ICategoryService {

    public void addCategory(Category category) throws SQLException;

    public Category getCategoryById(int id);

    public List<Category> getAllCategories();

    public boolean removeCategory(int id) throws SQLException;

    public boolean modifyCategory(Category category) throws SQLException;

    public List<Category> getParentCategoriesByGender(int genderid);

    public List<Category> getChildCategories(String parentIndexName);

    public Category findCategoryByIndexNameAndGender(String indexName, int genderid);

    public List<Category> searchCategories(
            Integer genderId, String parentIndexName, Boolean isParent, String type);

}

package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Category;
import com.aisthea.fashion.service.CategoryService;
import com.aisthea.fashion.service.ICategoryService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import com.google.gson.Gson;
import java.util.logging.Logger;

public class CategoryServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CategoryServlet.class.getName());
    private final Gson gson = new Gson();
    private ICategoryService categoryService;

    @Override
    public void init() {
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    listCategory(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "insert":
                    insertCategory(request, response);
                    break;
                case "update":
                    updateCategory(request, response);
                    break;
                default:
                    listCategory(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> list = categoryService.getAllCategories();
        request.setAttribute("list", list);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/category/manage_category.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> allCategories = categoryService.getAllCategories();
        request.setAttribute("allCategories", allCategories);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/category/edit_category.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Category existing = categoryService.getCategoryById(id);
        List<Category> allCategories = categoryService.getAllCategories();
        request.setAttribute("allCategories", allCategories);
        request.setAttribute("category", existing);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/category/edit_category.jsp");
        dispatcher.forward(request, response);
    }

    private void insertCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            int genderid = Integer.parseInt(request.getParameter("genderid"));
            String parentid = request.getParameter("parentid");
            String indexName = request.getParameter("indexName");

            categoryService.addCategory(new Category(name, type, genderid, parentid, indexName));
            response.sendRedirect("category");
        } catch (Exception e) {
            request.setAttribute("errorMsg", "Lỗi khi thêm danh mục: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/category/category-form.jsp").forward(request, response);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            int genderid = Integer.parseInt(request.getParameter("genderid"));
            String parentid = request.getParameter("parentid");
            String indexName = request.getParameter("indexName");

            Category category = new Category(id, name, type, genderid, parentid, indexName, null, null);
            categoryService.modifyCategory(category);
            response.sendRedirect("category");
        } catch (Exception e) {
            request.setAttribute("errorMsg", "Lỗi khi cập nhật danh mục: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/category/edit_category.jsp").forward(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        categoryService.removeCategory(id);
        response.sendRedirect("category");
    }
}

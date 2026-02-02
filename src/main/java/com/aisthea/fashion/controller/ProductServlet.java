package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.*;
import com.aisthea.fashion.service.CategoryService;
import com.aisthea.fashion.service.ICategoryService;
import com.aisthea.fashion.service.IProductService;
import com.aisthea.fashion.service.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.annotation.WebServlet;
import java.util.stream.Collectors;

public class ProductServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(ProductServlet.class.getName());
    private IProductService productService;
    private ICategoryService categoryService;

    @Override
    public void init() {
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new" ->
                    showNewForm(request, response);
                case "edit" ->
                    showEditForm(request, response);
                case "delete" ->
                    deleteProduct(request, response);
                case "view" ->
                    viewProductDetail(request, response);
                case "manage" ->
                    manageProducts(request, response);
                default ->
                    listProducts(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi doGet ProductServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi trên server: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String jspPage = "/views/admin/product/edit_product.jsp";
        Product productForRollback = null;

        try {
            switch (action) {
                case "insert":
                    productForRollback = extractProductFromRequest(request);
                    if (productService.addProduct(productForRollback)) {
                        response.sendRedirect(request.getContextPath() + "/product?action=manage");
                    } else {
                        throw new Exception("productService.addProduct trả về false.");
                    }
                    break;

                case "update":
                    int id = Integer.parseInt(request.getParameter("id"));
                    productForRollback = extractProductFromRequest(request);
                    productForRollback.setProductId(id);

                    if (productService.updateProduct(productForRollback)) {
                        response.sendRedirect(request.getContextPath() + "/product?action=manage");
                    } else {
                        throw new Exception("productService.updateProduct trả về false (Lỗi logic/DAO).");
                    }
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/product?action=manage");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi doPost ProductServlet (action=" + action + ")", e);

            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.setAttribute("product", productForRollback);
            request.setAttribute("allCategories", categoryService.getAllCategories());

            if (productForRollback != null && productForRollback.getCategory() != null) {
                String parentIndexName = productForRollback.getCategory().getParentid();
                if (parentIndexName != null && !parentIndexName.isEmpty()) {
                    Category parentCategory = categoryService.findCategoryByIndexNameAndGender(
                            parentIndexName,
                            productForRollback.getCategory().getGenderid()
                    );
                    request.setAttribute("parentCategory", parentCategory);
                }
            }

            request.getRequestDispatcher(jspPage).forward(request, response);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryIndex = request.getParameter("categoryIndex");
        String genderIdParam = request.getParameter("genderid");
        List<Product> list;

        if (categoryIndex != null && genderIdParam != null) {
            int genderId = Integer.parseInt(genderIdParam);
            Category displayCategory = categoryService.findCategoryByIndexNameAndGender(categoryIndex, genderId);
            request.setAttribute("displayCategory", displayCategory);
            list = productService.getProductsByParentCategory(categoryIndex, genderId);
        } else {
            list = productService.getAllProducts();
        }

        request.setAttribute("productList", list);
        request.getRequestDispatcher("views/product/product-list-page.jsp").forward(request, response);
    }

    private void manageProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String searchName = request.getParameter("searchName");

        List<Product> list = productService.getAllProducts();

        if (searchName != null && !searchName.trim().isEmpty()) {
            String searchLower = searchName.trim().toLowerCase();

            list = list.stream()
                    .filter(p -> p.getName() != null && p.getName().toLowerCase().contains(searchLower))
                    .collect(Collectors.toList());
        }

        request.setAttribute("productList", list);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/product/manage_products.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("allCategories", categoryService.getAllCategories());
        request.getRequestDispatcher("/views/admin/product/edit_product.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productService.getProductById(id);

        if (product != null && product.getCategory() != null) {
            Category childCategory = product.getCategory();
            String parentIndexName = childCategory.getParentid();
            if (parentIndexName != null && !parentIndexName.isEmpty()) {
                Category parentCategory = categoryService.findCategoryByIndexNameAndGender(
                        parentIndexName,
                        childCategory.getGenderid()
                );
                request.setAttribute("parentCategory", parentCategory);
            }
        }

        request.setAttribute("product", product);
        request.setAttribute("allCategories", categoryService.getAllCategories());
        request.getRequestDispatcher("/views/admin/product/edit_product.jsp").forward(request, response);
    }

    private void viewProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("product", productService.getProductById(id));
        request.setAttribute("colorSizes", productService.getColorSizesByProductId(id));
        request.setAttribute("images", productService.getImagesByProductId(id));
        request.getRequestDispatcher("views/product/product-detail.jsp").forward(request, response);
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        productService.deleteProduct(id);
        response.sendRedirect(request.getContextPath() + "/product?action=manage");
    }

    private Product extractProductFromRequest(HttpServletRequest request)
            throws IOException, ServletException, NumberFormatException {

        Product product = new Product();

        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setBrand(request.getParameter("brand"));
        product.setPrice(parseBigDecimal(request.getParameter("price")));
        product.setDiscount(parseBigDecimal(request.getParameter("discount")));

        String categoryIdParam = request.getParameter("categoryid");
        if (categoryIdParam == null || categoryIdParam.isBlank()) {
            throw new ServletException("Danh mục con (categoryid) không được rỗng. Vui lòng chọn lại danh mục.");
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdParam);
        } catch (NumberFormatException e) {
            throw new ServletException("Lỗi: categoryid không phải là số. Giá trị nhận được: " + categoryIdParam);
        }

        product.setCategory(categoryService.getCategoryById(categoryId));

        List<ProductColorSize> colorSizeList = new ArrayList<>();
        String[] colors = request.getParameterValues("stock_color");
        String[] sizes = request.getParameterValues("stock_size");
        String[] stocks = request.getParameterValues("stock_stock");

        if (colors != null && sizes != null && stocks != null) {
            int rowCount = Math.min(colors.length, Math.min(sizes.length, stocks.length));
            for (int i = 0; i < rowCount; i++) {
                String color = colors[i];
                String size = sizes[i];
                String stockStr = stocks[i];

                if (color != null && !color.isBlank()
                        && size != null && !size.isBlank()
                        && stockStr != null && !stockStr.isBlank()) {

                    ProductColorSize pcs = new ProductColorSize();
                    pcs.setColor(color);
                    pcs.setSize(size);
                    try {
                        pcs.setStock(Integer.parseInt(stockStr));
                    } catch (NumberFormatException e) {
                        pcs.setStock(0);
                    }
                    pcs.setProduct(product);
                    colorSizeList.add(pcs);
                }
            }
        }
        product.setColorSizes(colorSizeList);

        List<ProductImage> imageList = new ArrayList<>();
        String[] urls = request.getParameterValues("image_url");
        String[] imgColors = request.getParameterValues("image_color");
        String primaryImageIndex = request.getParameter("image_isprimary");

        if (urls != null && imgColors != null) {
            int imageRowCount = Math.min(urls.length, imgColors.length);

            for (int i = 0; i < imageRowCount; i++) {
                String url = urls[i];
                if (url != null && !url.isBlank()) {
                    ProductImage img = new ProductImage();
                    img.setImageUrl(url);
                    img.setColor(imgColors[i]);
                    img.setPrimary(String.valueOf(i).equals(primaryImageIndex));
                    img.setProduct(product);
                    imageList.add(img);
                }
            }
        }
        product.setImages(imageList);

        return product;
    }

    private BigDecimal parseBigDecimal(String value) {
        try {
            if (value == null || value.isBlank()) {
                return BigDecimal.ZERO;
            }
            return new BigDecimal(value);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }
}

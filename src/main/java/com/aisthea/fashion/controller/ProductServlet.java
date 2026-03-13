package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.*;
import com.aisthea.fashion.service.CategoryService;
import com.aisthea.fashion.service.ICategoryService;
import com.aisthea.fashion.service.IProductService;
import com.aisthea.fashion.service.ProductService;
import com.aisthea.fashion.service.FeedbackService;
import com.aisthea.fashion.service.IFeedbackService;
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

@WebServlet(name = "ProductServlet", urlPatterns = { "/product" })
public class ProductServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(ProductServlet.class.getName());
    private IProductService productService;
    private ICategoryService categoryService;
    private IFeedbackService feedbackService;

    @Override
    public void init() {
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
        this.feedbackService = new FeedbackService();
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
                case "quickview" ->
                    viewProductQuickview(request, response);
                case "manage" ->
                    manageProducts(request, response);
                default ->
                    listProducts(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi doGet ProductServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Đã xảy ra lỗi trên server: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String jspPage = "/WEB-INF/views/admin/product/edit_product.jsp";
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
                            productForRollback.getCategory().getGenderid());
                    request.setAttribute("parentCategory", parentCategory);
                }
            }

            request.getRequestDispatcher(jspPage).forward(request, response);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filter parameters
        String categoryIdParam = request.getParameter("categoryId");
        String categoryIndexParam = request.getParameter("categoryIndex");
        String genderIdParam = request.getParameter("genderid");
        String maxPriceParam = request.getParameter("maxPrice");
        String minPriceParam = request.getParameter("minPrice");
        String sortParam = request.getParameter("sort");
        String colorParam = request.getParameter("color");
        String sizeParam = request.getParameter("size");
        String searchParam = request.getParameter("search");

        List<Product> list;

        try {
            // Priority 1: General Keyword Search
            if (searchParam != null && !searchParam.isBlank()) {
                final String keyword = searchParam.trim().toLowerCase();
                list = productService.getAllProducts().stream()
                        .filter(p -> {
                            // Match by product name
                            if (p.getName() != null && p.getName().toLowerCase().contains(keyword))
                                return true;
                            // Match by brand
                            if (p.getBrand() != null && p.getBrand().toLowerCase().contains(keyword))
                                return true;
                            // Match by description
                            if (p.getDescription() != null && p.getDescription().toLowerCase().contains(keyword))
                                return true;
                            // Match by category name
                            if (p.getCategory() != null && p.getCategory().getName() != null
                                    && p.getCategory().getName().toLowerCase().contains(keyword))
                                return true;
                            return false;
                        })
                        .collect(Collectors.toList());
                request.setAttribute("pageTitle", "KẾT QUẢ TÌM KIẾM: \"" + searchParam + "\"");
            }
            // Priority 2: If categoryIndex + genderid from UrlRewriteFilter (e.g.
            // /men/ao_thun)
            else if (categoryIndexParam != null && !categoryIndexParam.isBlank()
                    && genderIdParam != null && !genderIdParam.isBlank()) {
                int genderId = Integer.parseInt(genderIdParam);
                list = productService.getProductsByParentCategory(categoryIndexParam, genderId);
                // Look up and set the real category name from DB for proper display
                Category foundCategory = categoryService.findCategoryByIndexNameAndGender(categoryIndexParam, genderId);
                if (foundCategory != null) {
                    request.setAttribute("displayCategory", foundCategory);
                    request.setAttribute("genderLabel", genderId == 1 ? "Men" : "Women");
                    request.setAttribute("genderId", genderId);
                    request.setAttribute("pageTitle", foundCategory.getName());
                } else {
                    request.setAttribute("displayCategoryName", categoryIndexParam.replace("_", " "));
                }
            }
            // If categoryId filter (from form submission)
            else if (categoryIdParam != null && !categoryIdParam.isBlank()) {
                int categoryId = Integer.parseInt(categoryIdParam);
                Category selectedCategory = categoryService.getCategoryById(categoryId);
                request.setAttribute("displayCategory", selectedCategory);

                if (selectedCategory != null) {
                    int catGenderId = selectedCategory.getGenderid();
                    request.setAttribute("genderLabel", catGenderId == 1 ? "Men" : "Women");
                    request.setAttribute("genderId", catGenderId);
                    request.setAttribute("pageTitle", selectedCategory.getName());

                    // If this is a CHILD category, also fetch the parent for the breadcrumb
                    boolean isChildCategory = selectedCategory.getParentid() != null
                            && !selectedCategory.getParentid().isBlank();
                    if (isChildCategory) {
                        Category parentCategory = categoryService
                                .findCategoryByIndexNameAndGender(selectedCategory.getParentid(), catGenderId);
                        if (parentCategory != null) {
                            request.setAttribute("parentCategory", parentCategory);
                        }
                    }
                }

                List<Product> allProducts = productService.getAllProducts();

                // Determine if this is a parent category (parentid is null or empty)
                boolean isParentCategory = selectedCategory != null
                        && (selectedCategory.getParentid() == null || selectedCategory.getParentid().isBlank());

                if (isParentCategory && selectedCategory.getIndexName() != null) {
                    final String parentIndexName = selectedCategory.getIndexName();
                    final int genderId = selectedCategory.getGenderid();
                    List<Category> childCategories = categoryService.getChildCategoriesByGender(parentIndexName,
                            genderId);
                    final java.util.Set<Integer> childCategoryIds = new java.util.HashSet<>();
                    for (Category child : childCategories) {
                        childCategoryIds.add(child.getCategoryid());
                    }
                    list = allProducts.stream()
                            .filter(p -> p.getCategory() != null
                                    && (p.getCategory().getCategoryid() == categoryId
                                            || childCategoryIds.contains(p.getCategory().getCategoryid())))
                            .collect(Collectors.toList());
                } else {
                    // Child (leaf) category selected: show only its products
                    list = allProducts.stream()
                            .filter(p -> p.getCategory() != null && p.getCategory().getCategoryid() == categoryId)
                            .collect(Collectors.toList());
                }
            }
            // Only genderid given (clicking NAM / NỮ from navbar)
            else if (genderIdParam != null && !genderIdParam.isBlank()) {
                int genderId = Integer.parseInt(genderIdParam);
                String genderLbl = genderId == 1 ? "Men" : "Women";
                request.setAttribute("genderLabel", genderLbl);
                request.setAttribute("genderId", genderId);
                request.setAttribute("pageTitle", genderId == 1 ? "Men's Collection" : "Women's Collection");
                // Filter all products by gender via their category
                List<Category> genderCategories = categoryService.getParentCategoriesByGender(genderId);
                genderCategories.addAll(categoryService.getChildCategoriesByGender(null, genderId) != null
                        ? new java.util.ArrayList<>()
                        : new java.util.ArrayList<>());
                // Simpler: get all products, filter by category.genderid
                list = productService.getAllProducts().stream()
                        .filter(p -> p.getCategory() != null && p.getCategory().getGenderid() == genderId)
                        .collect(Collectors.toList());
            }
            // No filter - show all
            else {
                list = productService.getAllProducts();
                request.setAttribute("pageTitle", "BỘ SƯU TẬP");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading products", e);
            list = new ArrayList<>();
        }

        // Apply price range filter (minPrice and/or maxPrice)
        // Defaults: minPrice = 0, maxPrice = 500_000_000 (slider max = no limit)
        final BigDecimal SLIDER_MAX = new BigDecimal("500000000");
        boolean hasPriceFilter = false;
        BigDecimal filteredMin = BigDecimal.ZERO;
        BigDecimal filteredMax = SLIDER_MAX;
        try {
            if (minPriceParam != null && !minPriceParam.isBlank()) {
                BigDecimal parsed = new BigDecimal(minPriceParam.trim());
                if (parsed.compareTo(BigDecimal.ZERO) > 0) { filteredMin = parsed; hasPriceFilter = true; }
            }
        } catch (NumberFormatException e) { logger.warning("Invalid minPrice: " + minPriceParam); }
        try {
            if (maxPriceParam != null && !maxPriceParam.isBlank()) {
                BigDecimal parsed = new BigDecimal(maxPriceParam.trim());
                if (parsed.compareTo(SLIDER_MAX) < 0) { filteredMax = parsed; hasPriceFilter = true; }
            }
        } catch (NumberFormatException e) { logger.warning("Invalid maxPrice: " + maxPriceParam); }
        if (hasPriceFilter) {
            final BigDecimal fMin = filteredMin;
            final BigDecimal fMax = filteredMax;
            list = list.stream()
                    .filter(p -> p.getPrice() != null
                            && p.getPrice().compareTo(fMin) >= 0
                            && p.getPrice().compareTo(fMax) <= 0)
                    .collect(Collectors.toList());
        }


        // Apply color filter (check product images or colorSizes)
        if (colorParam != null && !colorParam.isBlank()) {
            final String colorFilter = colorParam.trim().toLowerCase();
            list = list.stream()
                    .filter(p -> {
                        // Check in images
                        if (p.getImages() != null) {
                            for (var img : p.getImages()) {
                                if (img.getColor() != null
                                        && img.getColor().trim().toLowerCase().contains(colorFilter)) {
                                    return true;
                                }
                            }
                        }
                        // Check in colorSizes
                        if (p.getColorSizes() != null) {
                            for (var cs : p.getColorSizes()) {
                                if (cs.getColor() != null && cs.getColor().trim().toLowerCase().contains(colorFilter)) {
                                    return true;
                                }
                            }
                        }
                        return false;
                    })
                    .collect(Collectors.toList());
        }

        // Apply size filter
        if (sizeParam != null && !sizeParam.isBlank()) {
            final String sizeFilter = sizeParam.trim().toUpperCase();
            list = list.stream()
                    .filter(p -> {
                        if (p.getColorSizes() != null) {
                            for (var cs : p.getColorSizes()) {
                                if (cs.getSize() != null && cs.getSize().trim().toUpperCase().equals(sizeFilter)
                                        && cs.getStock() > 0) {
                                    return true;
                                }
                            }
                        }
                        return false;
                    })
                    .collect(Collectors.toList());
        }

        // Apply sorting
        // Apply sorting
        if (sortParam != null) {
            switch (sortParam) {
                case "price_asc":
                    list.sort((p1, p2) -> p1.getPrice().compareTo(p2.getPrice()));
                    break;
                case "price_desc":
                    list.sort((p1, p2) -> p2.getPrice().compareTo(p1.getPrice()));
                    break;
                case "newest":
                    list.sort((p1, p2) -> Integer.compare(p2.getProductId(), p1.getProductId()));
                    break;
                default: // featured
                    break;
            }
        }

        // Pagination
        int page = 1;
        int recordsPerPage = 12; // 12 items per page
        if (request.getParameter("page") != null && !request.getParameter("page").isBlank()) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception e) {
                page = 1;
            }
        }

        int totalRecords = list.size();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        int start = (page - 1) * recordsPerPage;
        int end = Math.min(start + recordsPerPage, totalRecords);

        List<Product> listForPage;
        if (start < 0 || start >= totalRecords) {
            // handle empty list or out of bounds (but if list is empty, totalRecords=0,
            // start=0, end=0 -> subList(0,0) is fine)
            if (totalRecords == 0)
                listForPage = new ArrayList<>();
            else
                listForPage = new ArrayList<>(); // weird out of bound
        } else {
            listForPage = new ArrayList<>(list.subList(start, end)); // Use ArrayList copy to avoid serialization issues
                                                                     // with subList
        }

        // Handle empty list case correctly
        if (totalRecords > 0 && start < totalRecords) {
            listForPage = new ArrayList<>(list.subList(start, end));
        } else {
            listForPage = new ArrayList<>();
        }

        // Populate rating data for the displayed products
        if (listForPage != null) {
            for (Product p : listForPage) {
                double[] ratingData = feedbackService.getAvgRatingForProduct(p.getProductId());
                p.setAvgRating(ratingData[0]);
                p.setReviewCount((int) ratingData[1]);
            }
        }

        // Set attributes
        request.setAttribute("productList", listForPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("categories", categoryService.getAllCategories());
        request.setAttribute("parentCategoriesMale", categoryService.getParentCategoriesByGender(1));
        request.setAttribute("parentCategoriesFemale", categoryService.getParentCategoriesByGender(2));
        request.getRequestDispatcher("/WEB-INF/views/product/product-list-page.jsp").forward(request, response);
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
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/product/manage_products.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("allCategories", categoryService.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/views/admin/product/edit_product.jsp").forward(request, response);
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
                        childCategory.getGenderid());
                request.setAttribute("parentCategory", parentCategory);
            }
        }

        request.setAttribute("product", product);
        request.setAttribute("allCategories", categoryService.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/views/admin/product/edit_product.jsp").forward(request, response);
    }

    private void viewProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productService.getProductById(id);

        request.setAttribute("product", product);
        request.setAttribute("colorSizes", productService.getColorSizesByProductId(id));
        request.setAttribute("images", productService.getImagesByProductId(id));
        request.setAttribute("feedbacks", feedbackService.getFeedbacksByProductId(id));

        // Build breadcrumb data (same pattern as product list page)
        if (product != null && product.getCategory() != null) {
            Category category = product.getCategory();
            int genderId = category.getGenderid();
            request.setAttribute("genderLabel", genderId == 1 ? "Men" : "Women");
            request.setAttribute("genderId", genderId);

            // If this product's category is a child, fetch its parent too
            if (category.getParentid() != null && !category.getParentid().isBlank()) {
                Category parentCat = categoryService.findCategoryByIndexNameAndGender(
                        category.getParentid(), genderId);
                if (parentCat != null) {
                    request.setAttribute("parentCategory", parentCat);
                }
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/product/product-detail.jsp").forward(request, response);
    }

    /**
     * Returns product data as JSON for the Quick Add to Cart modal.
     * Endpoint: GET /product?action=quickview&id=N
     * Expected by fetch() with X-Requested-With: XMLHttpRequest header.
     */
    private void viewProductQuickview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        java.io.PrintWriter out = response.getWriter();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = productService.getProductById(id);
            if (p == null) {
                out.print("{\"error\":\"Product not found\"}");
                return;
            }
            List<ProductColorSize> colorSizes = productService.getColorSizesByProductId(id);
            List<com.aisthea.fashion.model.ProductImage> images = productService.getImagesByProductId(id);

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"productId\":").append(p.getProductId()).append(",");
            json.append("\"name\":").append(jsonStr(p.getName())).append(",");
            json.append("\"brand\":").append(jsonStr(p.getBrand())).append(",");
            json.append("\"price\":").append(p.getPrice() != null ? p.getPrice().toPlainString() : "0").append(",");
            json.append("\"discount\":").append(p.getDiscount() != null ? p.getDiscount().toPlainString() : "0")
                    .append(",");
            json.append("\"bestseller\":").append(p.isBestseller()).append(",");
            // images array
            json.append("\"images\":[");
            if (images != null) {
                for (int i = 0; i < images.size(); i++) {
                    com.aisthea.fashion.model.ProductImage img = images.get(i);
                    if (i > 0)
                        json.append(",");
                    json.append("{");
                    json.append("\"imageUrl\":").append(jsonStr(img.getImageUrl())).append(",");
                    json.append("\"color\":").append(jsonStr(img.getColor())).append(",");
                    json.append("\"isPrimary\":").append(img.isPrimary());
                    json.append("}");
                }
            }
            json.append("],");
            // colorSizes array
            json.append("\"colorSizes\":[");
            if (colorSizes != null) {
                for (int i = 0; i < colorSizes.size(); i++) {
                    ProductColorSize cs = colorSizes.get(i);
                    if (i > 0)
                        json.append(",");
                    json.append("{");
                    json.append("\"productColorSizeId\":").append(cs.getProductColorSizeId()).append(",");
                    json.append("\"color\":").append(jsonStr(cs.getColor())).append(",");
                    json.append("\"size\":").append(jsonStr(cs.getSize())).append(",");
                    json.append("\"stock\":").append(cs.getStock());
                    json.append("}");
                }
            }
            json.append("]}");
            out.print(json.toString());
        } catch (Exception e) {
            logger.log(Level.WARNING, "quickview error", e);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }

    /** Escape a Java String to a JSON string literal (with quotes). */
    private static String jsonStr(String s) {
        if (s == null)
            return "null";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") + "\"";
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

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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Part;
import com.aisthea.fashion.util.ImageUploadHelper;

/**
 * Handles all product-related requests for both public browsing and admin CRUD.
 *
 * <p>The {@code @MultipartConfig} annotation is required for file upload processing
 * ({@link Part}-based API). Without it, {@code request.getPart()} throws
 * {@link IllegalStateException} and all device uploads would silently fail.
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB — spool to disk above this
    maxFileSize       = 10L * 1024 * 1024,  // 10 MB per file
    maxRequestSize    = 50L * 1024 * 1024   // 50 MB total per request
)
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
                case "insert": {
                    productForRollback = extractProductFromRequest(request);
                    if (productService.addProduct(productForRollback)) {
                        String newName = productForRollback.getName() != null
                                ? java.net.URLEncoder.encode(productForRollback.getName(), "UTF-8") : "";
                        response.sendRedirect(request.getContextPath()
                                + "/product?action=manage&flash=created&pname=" + newName);
                    } else {
                        throw new Exception("Lưu sản phẩm vào database thất bại. Kiểm tra log server để biết chi tiết.");
                    }
                    break;
                }

                case "update": {
                    String idParam = request.getParameter("id");
                    if (idParam == null || idParam.isBlank()) {
                        Part idPart = request.getPart("id");
                        if (idPart != null) {
                            try (java.util.Scanner scanner = new java.util.Scanner(idPart.getInputStream())) {
                                if (scanner.hasNext()) idParam = scanner.next();
                            }
                        }
                    }
                    if (idParam == null || idParam.isBlank()) {
                        throw new Exception("ID sản phẩm không hợp lệ. Vui lòng quay lại và thử lại.");
                    }

                    int id = Integer.parseInt(idParam.trim());
                    productForRollback = extractProductFromRequest(request);
                    productForRollback.setProductId(id);

                    if (productService.updateProduct(productForRollback)) {
                        String updName = productForRollback.getName() != null
                                ? java.net.URLEncoder.encode(productForRollback.getName(), "UTF-8") : "";
                        response.sendRedirect(request.getContextPath()
                                + "/product?action=manage&flash=updated&pname=" + updName);
                    } else {
                        throw new Exception("Cập nhật sản phẩm thất bại. Có thể sản phẩm không tồn tại hoặc dữ liệu không hợp lệ.");
                    }
                    break;
                }

                case "toggle_status":
                    response.setContentType("application/json;charset=UTF-8");
                    try {
                        int toggleId = Integer.parseInt(request.getParameter("id"));
                        boolean tz = productService.toggleProductStatus(toggleId);
                        response.getWriter().write("{\"success\":" + tz + "}");
                    } catch (Exception ex) {
                        response.getWriter().write("{\"success\":false,\"message\":\"" + ex.getMessage().replace("\"", "\\\"") + "\"}");
                    }
                    return;

                case "quick_stock":
                    response.setContentType("application/json;charset=UTF-8");
                    try {
                        int pcsId = Integer.parseInt(request.getParameter("pcsId"));
                        int newStock = Integer.parseInt(request.getParameter("stock"));
                        if (newStock < 0) throw new Exception("Stock không được âm.");
                        productService.updateStock(pcsId, newStock);
                        response.getWriter().write("{\"success\":true}");
                    } catch (Exception ex) {
                        response.getWriter().write("{\"success\":false,\"message\":\"" + ex.getMessage().replace("\"", "\\\"") + "\"}");
                    }
                    return;

                case "quick_price":
                    response.setContentType("application/json;charset=UTF-8");
                    try {
                        int pid = Integer.parseInt(request.getParameter("id"));
                        java.math.BigDecimal newPrice = new java.math.BigDecimal(request.getParameter("price"));
                        if (newPrice.compareTo(java.math.BigDecimal.ZERO) < 0) throw new Exception("Giá không được âm.");
                        boolean success = productService.updateProductPrice(pid, newPrice);
                        response.getWriter().write("{\"success\":" + success + "}");
                    } catch (Exception ex) {
                        response.getWriter().write("{\"success\":false,\"message\":\"" + ex.getMessage().replace("\"", "\\\"") + "\"}");
                    }
                    return;

                default:
                    response.sendRedirect(request.getContextPath() + "/product?action=manage");
                    break;
            }
        } catch (Exception e) {
            String errorMsg = "Lỗi: " + (e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName());
            if (e.getCause() != null && e.getCause().getMessage() != null) {
                errorMsg += " → " + e.getCause().getMessage();
            }
            logger.log(Level.SEVERE, "doPost ProductServlet (action=" + action + "): " + errorMsg, e);

            /* ── Restore form with error: for 'update' load existing product from DB as fallback ── */
            Product formProduct = productForRollback; // may be null if extractProductFromRequest threw
            if (formProduct == null && "update".equals(action)) {
                try {
                    String idStr = getMultipartParam(request, "id");
                    if (idStr != null && !idStr.isBlank()) {
                        formProduct = productService.getProductById(Integer.parseInt(idStr.trim()));
                    }
                } catch (Exception ignored) { }
            }

            request.setAttribute("error", errorMsg);
            request.setAttribute("product", formProduct);
            request.setAttribute("allCategories", categoryService.getAllCategories());

            if (formProduct != null && formProduct.getCategory() != null) {
                try {
                    String parentIndexName = formProduct.getCategory().getParentid();
                    if (parentIndexName != null && !parentIndexName.isBlank()) {
                        Category parentCat = categoryService.findCategoryByIndexNameAndGender(
                                parentIndexName, formProduct.getCategory().getGenderid());
                        if (parentCat != null) request.setAttribute("parentCategory", parentCat);
                    }
                } catch (Exception ex) {
                    logger.warning("Could not resolve parent category for error rollback: " + ex.getMessage());
                }
            }

            request.getRequestDispatcher(jspPage).forward(request, response);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ── 1. Read all filter parameters ──────────────────────────────────────
        String categoryIdParam    = request.getParameter("categoryId");
        String categoryIndexParam = request.getParameter("categoryIndex");
        String genderIdParam      = request.getParameter("genderid");
        String colorParam         = request.getParameter("color");
        String sizeParam          = request.getParameter("size");
        String minPriceParam      = request.getParameter("minPrice");
        String maxPriceParam      = request.getParameter("maxPrice");
        String sortParam          = request.getParameter("sort");
        String searchParam        = request.getParameter("search");

        // ── 2. Parse typed values ───────────────────────────────────────────────
        Integer categoryId    = parseInteger(categoryIdParam);
        Integer genderId      = parseInteger(genderIdParam);
        String  categoryIndex = (categoryIndexParam != null && !categoryIndexParam.isBlank()) ? categoryIndexParam.trim() : null;
        String  color         = (colorParam  != null && !colorParam.isBlank())  ? colorParam.trim()  : null;
        String  size          = (sizeParam   != null && !sizeParam.isBlank())   ? sizeParam.trim()   : null;
        String  keyword       = (searchParam != null && !searchParam.isBlank()) ? searchParam.trim() : null;
        String  sortBy        = (sortParam   != null && !sortParam.isBlank())   ? sortParam.trim()   : null;

        final BigDecimal PRICE_SLIDER_MAX = new BigDecimal("500000000");
        BigDecimal minPrice = parseBigDecimalOrNull(minPriceParam);
        BigDecimal maxPrice = parseBigDecimalOrNull(maxPriceParam);

        // Treat slider max as "no upper bound" (don't filter)
        if (maxPrice != null && maxPrice.compareTo(PRICE_SLIDER_MAX) >= 0) maxPrice = null;

        // ── 3. Build display metadata for breadcrumb / page title ───────────────
        try {
            if (keyword != null) {
                request.setAttribute("pageTitle", "KẾT QUẢ TÌM KIẾM: \"" + keyword + "\"");

            } else if (categoryId != null) {
                Category selected = categoryService.getCategoryById(categoryId);
                if (selected != null) {
                    request.setAttribute("displayCategory", selected);
                    request.setAttribute("pageTitle", selected.getName());
                    int catGenderId = selected.getGenderid();
                    request.setAttribute("genderId",   catGenderId);
                    request.setAttribute("genderLabel", catGenderId == 1 ? "Men" : "Women");
                    // Breadcrumb: fetch parent when this is a child category
                    if (selected.getParentid() != null && !selected.getParentid().isBlank()) {
                        Category parent = categoryService.findCategoryByIndexNameAndGender(
                                selected.getParentid(), catGenderId);
                        if (parent != null) request.setAttribute("parentCategory", parent);
                    }
                }

            } else if (categoryIndex != null) {
                Category found = categoryService.findCategoryByIndexNameAndGender(
                        categoryIndex, genderId != null ? genderId : 1);
                if (found != null) {
                    request.setAttribute("displayCategory", found);
                    request.setAttribute("pageTitle",  found.getName());
                    request.setAttribute("genderId",   found.getGenderid());
                    request.setAttribute("genderLabel", found.getGenderid() == 1 ? "Men" : "Women");
                }

            } else if (genderId != null) {
                request.setAttribute("genderId",   genderId);
                request.setAttribute("genderLabel", genderId == 1 ? "Men" : "Women");
                request.setAttribute("pageTitle",   genderId == 1 ? "Men's Collection" : "Women's Collection");

            } else {
                request.setAttribute("pageTitle", "BỘ SƯU TẬP");
            }
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error building breadcrumb metadata", e);
        }

        // ── 4. Single SQL-level filtered query ──────────────────────────────────
        List<Product> list;
        try {
            list = productService.getFilteredProducts(
                    categoryId, categoryIndex, genderId,
                    color, size,
                    minPrice, maxPrice,
                    keyword, sortBy);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading filtered products", e);
            list = new ArrayList<>();
        }

        // ── 5. Pagination ───────────────────────────────────────────────────────
        int recordsPerPage = 12;
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isBlank()) page = Integer.parseInt(pageParam.trim());
        } catch (NumberFormatException ignored) { }
        if (page < 1) page = 1;

        int totalRecords = list.size();
        int totalPages   = (int) Math.ceil((double) totalRecords / recordsPerPage);
        int start        = (page - 1) * recordsPerPage;
        int end          = Math.min(start + recordsPerPage, totalRecords);

        List<Product> listForPage;
        if (totalRecords == 0 || start >= totalRecords) {
            listForPage = new ArrayList<>();
        } else {
            listForPage = new ArrayList<>(list.subList(start, end));
        }

        // ── 6. Populate rating data only for the visible page ───────────────────
        for (Product p : listForPage) {
            double[] ratingData = feedbackService.getAvgRatingForProduct(p.getProductId());
            p.setAvgRating(ratingData[0]);
            p.setReviewCount((int) ratingData[1]);
        }

        // ── 7. Set request attributes & forward ────────────────────────────────
        request.setAttribute("productList",            listForPage);
        request.setAttribute("totalPages",             totalPages);
        request.setAttribute("currentPage",            page);
        request.setAttribute("totalRecords",           totalRecords);
        request.setAttribute("categories",             categoryService.getAllCategories());
        request.setAttribute("parentCategoriesMale",   categoryService.getParentCategoriesByGender(1));
        request.setAttribute("parentCategoriesFemale", categoryService.getParentCategoriesByGender(2));

        request.getRequestDispatcher("/WEB-INF/views/product/product-list-page.jsp")
               .forward(request, response);
    }

    // ── Helper parsers ────────────────────────────────────────────────────────
    private static Integer parseInteger(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return null; }
    }

    private static BigDecimal parseBigDecimalOrNull(String s) {
        if (s == null || s.isBlank()) return null;
        try {
            BigDecimal v = new BigDecimal(s.trim());
            return v.compareTo(BigDecimal.ZERO) > 0 ? v : null;
        } catch (NumberFormatException e) { return null; }
    }

    private void manageProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String searchName    = request.getParameter("searchName");
        String sortCol       = request.getParameter("sort");
        String sortDir       = request.getParameter("dir");
        String statusParam   = request.getParameter("statusFilter");
        String psParam       = request.getParameter("ps");
        
        // Advanced filters
        Integer genderId = null;
        try {
            String gid = request.getParameter("genderId");
            if (gid != null && !gid.isBlank()) genderId = Integer.parseInt(gid.trim());
        } catch (NumberFormatException ignored) {}
        
        String parentCategory = request.getParameter("parentCategory");
        if (parentCategory != null && parentCategory.isBlank()) parentCategory = null;
        
        Integer subCategoryId = null;
        try {
            String sid = request.getParameter("subCategoryId");
            if (sid != null && !sid.isBlank()) subCategoryId = Integer.parseInt(sid.trim());
        } catch (NumberFormatException ignored) {}

        // Parse page
        int page = 1;
        try {
            String p = request.getParameter("page");
            if (p != null) page = Math.max(1, Integer.parseInt(p.trim()));
        } catch (NumberFormatException ignored) {}

        // Parse pageSize (default 15, min 5, max 100)
        int pageSize = 15;
        try {
            if (psParam != null) pageSize = Math.min(100, Math.max(5, Integer.parseInt(psParam.trim())));
        } catch (NumberFormatException ignored) {}

        // Parse statusFilter (null = all, 0 = hidden, 1 = active)
        Integer statusFilter = null;
        if ("1".equals(statusParam)) statusFilter = 1;
        else if ("0".equals(statusParam)) statusFilter = 0;

        // DAO overloads that support statusFilter and Categories
        com.aisthea.fashion.dao.ProductDAO dao = new com.aisthea.fashion.dao.ProductDAO();
        List<Product> list  = dao.getAdminProducts(page, pageSize, sortCol, sortDir, searchName, statusFilter, genderId, parentCategory, subCategoryId);
        int totalRecords    = dao.countAdminProducts(searchName, statusFilter, genderId, parentCategory, subCategoryId);
        int totalPages      = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages < 1) totalPages = 1;
        
        // Fetch low stock system-wide
        List<Product> lowStockList = dao.getLowStockProducts(5);

        request.setAttribute("productList",   list);
        request.setAttribute("currentPage",   page);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("totalRecords",  totalRecords);
        request.setAttribute("pageSize",      pageSize);
        request.setAttribute("lowStockList",  lowStockList);
        request.setAttribute("allCategories", categoryService.getAllCategories());

        request.getRequestDispatcher("/WEB-INF/views/admin/product/manage_products.jsp")
               .forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("allCategories", categoryService.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/views/admin/product/edit_product.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Validate parameter ID ─────────────────────────────────────────
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/product?action=manage&error=invalid_id");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idParam.trim());
            if (productId <= 0) throw new NumberFormatException("non-positive");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/product?action=manage&error=invalid_id");
            return;
        }

        // ── 2. Load product via single JOIN query ────────────────────────────
        Product product;
        try {
            product = productService.getProductById(productId);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading product id=" + productId, e);
            response.sendRedirect(request.getContextPath() + "/product?action=manage&error=load_failed");
            return;
        }

        // ── 3. Guard: product must exist ─────────────────────────────────────
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/product?action=manage&error=not_found");
            return;
        }

        // ── 4. Resolve parent category for breadcrumb / form pre-fill ───────
        if (product.getCategory() != null) {
            String parentIndexName = product.getCategory().getParentid();
            if (parentIndexName != null && !parentIndexName.isBlank()) {
                try {
                    Category parentCategory = categoryService.findCategoryByIndexNameAndGender(
                            parentIndexName, product.getCategory().getGenderid());
                    request.setAttribute("parentCategory", parentCategory);
                } catch (Exception e) {
                    logger.log(Level.WARNING, "Could not resolve parent category", e);
                }
            }
        }

        // ── 5. Set attributes & forward ──────────────────────────────────────
        request.setAttribute("product", product);
        request.setAttribute("allCategories", categoryService.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/views/admin/product/edit_product.jsp").forward(request, response);
    }

    private void viewProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            return;
        }

        Product product = productService.getProductById(id);

        // Block hidden or non-existent products from user-facing pages
        if (product == null || product.getStatus() == 0) {
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            return;
        }

        request.setAttribute("product",   product);
        request.setAttribute("colorSizes", product.getColorSizes()); // already loaded by getProductById
        request.setAttribute("images",    product.getImages());       // already loaded by getProductById
        request.setAttribute("feedbacks", feedbackService.getFeedbacksByProductId(id));

        // Build breadcrumb data
        if (product.getCategory() != null) {
            Category category = product.getCategory();
            int genderId = category.getGenderid();
            request.setAttribute("genderLabel", genderId == 1 ? "Men" : "Women");
            request.setAttribute("genderId",    genderId);

            if (category.getParentid() != null && !category.getParentid().isBlank()) {
                Category parentCat = categoryService.findCategoryByIndexNameAndGender(
                        category.getParentid(), genderId);
                if (parentCat != null) request.setAttribute("parentCategory", parentCat);
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
            Product p = productService.getProductById(id); // includes colorSizes via single JOIN
            if (p == null) {
                out.print("{\"error\":\"Product not found\"}");
                return;
            }

            // If AJAX request from Admin Quick Stock Modal — return minimal JSON
            List<ProductColorSize> colorSizes = p.getColorSizes();
            List<com.aisthea.fashion.model.ProductImage> images = p.getImages();

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"productId\":").append(p.getProductId()).append(",");
            json.append("\"name\":").append(jsonStr(p.getName())).append(",");
            json.append("\"brand\":").append(jsonStr(p.getBrand())).append(",");
            json.append("\"price\":").append(p.getPrice() != null ? p.getPrice().toPlainString() : "0").append(",");
            json.append("\"discount\":").append(p.getDiscount() != null ? p.getDiscount().toPlainString() : "0").append(",");
            json.append("\"bestseller\":").append(p.isBestseller()).append(",");
            // images array
            json.append("\"images\":[");
            if (images != null) {
                for (int i = 0; i < images.size(); i++) {
                    com.aisthea.fashion.model.ProductImage img = images.get(i);
                    if (i > 0) json.append(",");
                    String resolvedUrl = img.getImageUrl();
                    if (resolvedUrl != null && !resolvedUrl.startsWith("http") && !resolvedUrl.startsWith("/") && !resolvedUrl.startsWith("data:")) {
                        resolvedUrl = request.getContextPath() + "/uploads/" + resolvedUrl;
                    }
                    json.append("{");
                    json.append("\"imageUrl\":").append(jsonStr(resolvedUrl)).append(",");
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
                    if (i > 0) json.append(",");
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
        if (s == null) return "null";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") + "\"";
    }


    /**
     * Safely reads a text parameter from a multipart request.
     * Uses getParameter first (works in most cases), then falls back
     * to reading from the Part's InputStream for robustness.
     */
    private String getMultipartParam(HttpServletRequest request, String name) {
        // Primary: standard getParameter (works even in multipart on Tomcat 10+)
        String val = request.getParameter(name);
        if (val != null && !val.isBlank()) return val.trim();
        // Fallback: read from Part stream
        try {
            Part part = request.getPart(name);
            if (part != null && part.getSize() > 0) {
                try (java.util.Scanner sc = new java.util.Scanner(
                        part.getInputStream(), java.nio.charset.StandardCharsets.UTF_8)) {
                    String raw = sc.useDelimiter("\\A").hasNext() ? sc.next().trim() : "";
                    if (!raw.isBlank()) return raw;
                }
            }
        } catch (Exception ignored) { }
        return null;
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

        // ── Basic fields ──────────────────────────────────────────────────────
        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setBrand(request.getParameter("brand"));
        product.setPrice(parseBigDecimal(request.getParameter("price")));
        product.setDiscount(parseBigDecimal(request.getParameter("discount")));

        // Bestseller: form sends hidden "bestseller=false" + optional checkbox "bestseller=true".
        // getParameterValues gives both; the last value wins for a checkbox trick,
        // so we check if any submitted value equals "true".
        String[] bestsellerValues = request.getParameterValues("bestseller");
        boolean isBestseller = false;
        if (bestsellerValues != null) {
            for (String v : bestsellerValues) {
                if ("true".equalsIgnoreCase(v.trim())) { isBestseller = true; break; }
            }
        }
        product.setBestseller(isBestseller);

        // ── Category resolution ───────────────────────────────────────────────
        // Under @MultipartConfig, getParameter() should still work for non-file fields,
        // but we add Part-based fallback for reliability.
        String categoryIdParam = getMultipartParam(request, "categoryid");
        String backupParam     = getMultipartParam(request, "categoryid_backup");
        String parentParam     = getMultipartParam(request, "parentCategory");
        String genderIdParam   = getMultipartParam(request, "genderid");

        // Resolution order: child select → JS backup hidden → parent fallback
        String resolvedCategoryId = categoryIdParam;
        if (resolvedCategoryId == null || resolvedCategoryId.isBlank()) resolvedCategoryId = backupParam;
        if (resolvedCategoryId == null || resolvedCategoryId.isBlank()) resolvedCategoryId = parentParam;

        logger.info("[Category] child=" + categoryIdParam + ", backup=" + backupParam
                + ", parent=" + parentParam + ", gender=" + genderIdParam
                + ", resolved=" + resolvedCategoryId);

        if (resolvedCategoryId == null || resolvedCategoryId.isBlank()) {
            throw new ServletException("Danh mục sản phẩm không được để trống."
                    + " Chi tiết: {child=" + categoryIdParam
                    + ", backup=" + backupParam
                    + ", parent=" + parentParam + "}."
                    + " Vui lòng chọn lại danh mục.");
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(resolvedCategoryId.trim());
        } catch (NumberFormatException e) {
            throw new ServletException("Mã danh mục không hợp lệ: \"" + resolvedCategoryId + "\"");
        }

        product.setCategory(categoryService.getCategoryById(categoryId));

        // ── Color / Size / Stock variants ─────────────────────────────────────
        List<ProductColorSize> colorSizeList = new ArrayList<>();
        String variantsCombined = getMultipartParam(request, "variants_combined");
        
        if (variantsCombined != null && !variantsCombined.isBlank()) {
            String[] rows = variantsCombined.split(";");
            for (String row : rows) {
                if (row.isBlank()) continue;
                String[] parts = row.split("\\|");
                if (parts.length >= 3) {
                    ProductColorSize pcs = new ProductColorSize();
                    pcs.setColor(parts[0].trim().toUpperCase());
                    pcs.setSize(parts[1].trim().toUpperCase());
                    try { pcs.setStock(Integer.parseInt(parts[2].trim())); }
                    catch (NumberFormatException e) { pcs.setStock(0); }
                    pcs.setProduct(product);
                    colorSizeList.add(pcs);
                }
            }
        }
        product.setColorSizes(colorSizeList);

        // ── Image processing ───────────────────────────────────────────────────
        List<ProductImage> imageList     = new ArrayList<>();
        String imagesCombined = getMultipartParam(request, "images_combined");
        String primaryImageIndex = getMultipartParam(request, "image_isprimary");

        if (imagesCombined != null && !imagesCombined.isBlank()) {
            String[] rows = imagesCombined.split(";");
            for (String row : rows) {
                if (row.isBlank()) continue;
                String[] parts = row.split("\\|", 3); // max 3 splits to allow empty color
                if (parts.length >= 3) {
                    String url   = parts[0].trim();
                    String color = parts[1].trim();
                    String idx   = parts[2].trim();

                    // Priority: device-upload overrides the URL field
                    try {
                        Part filePart = request.getPart("image_file_" + idx);
                        if (filePart != null && filePart.getSize() > 0) {
                            String uploaded = ImageUploadHelper.save(filePart, "product");
                            if (uploaded != null) {
                                url = uploaded;
                            }
                        }
                    } catch (Exception ignored) { }

                    if (!url.isBlank()) {
                        ProductImage img = new ProductImage();
                        img.setImageUrl(url);
                        img.setColor(color);
                        img.setPrimary(idx.equals(primaryImageIndex));
                        img.setProduct(product);
                        imageList.add(img);
                    }
                }
            }
        }

        // Guarantee at least one primary image — fall back to first
        if (!imageList.isEmpty()) {
            boolean hasPrimary = imageList.stream().anyMatch(ProductImage::isPrimary);
            if (!hasPrimary) {
                imageList.get(0).setPrimary(true);
                logger.info("No primary image selected; defaulting to first image.");
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
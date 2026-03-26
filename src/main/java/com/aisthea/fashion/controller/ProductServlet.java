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
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.util.Scanner;
import com.aisthea.fashion.util.Constants;
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
                    String idParam = request.getParameter("id");
                    if (idParam == null || idParam.isBlank()) {
                        // Attempt to read from part if it's there but getParameter failed (can happen in some multipart configs)
                        Part idPart = request.getPart("id");
                        if (idPart != null) {
                            try (Scanner scanner = new Scanner(idPart.getInputStream())) {
                                if (scanner.hasNext()) idParam = scanner.next();
                            }
                        }
                    }

                    if (idParam == null || idParam.isBlank()) {
                        throw new Exception("ID của sản phẩm không được cung cấp (null). Vui lòng thử lại.");
                    }

                    int id = Integer.parseInt(idParam.trim());
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
            String errorMsg = e.getMessage();
            if (e.getCause() != null) {
                errorMsg += " -> " + e.getCause().getMessage();
            }
            logger.log(Level.SEVERE, "Lỗi doPost ProductServlet (action=" + action + "): " + errorMsg, e);

            request.setAttribute("error", "Lỗi xử lý " + action + ": " + errorMsg);
            request.setAttribute("product", productForRollback);
            request.setAttribute("allCategories", categoryService.getAllCategories());

            if (productForRollback != null && productForRollback.getCategory() != null) {
                try {
                    String parentIndexName = productForRollback.getCategory().getParentid();
                    if (parentIndexName != null && !parentIndexName.isEmpty()) {
                        Category parentCategory = categoryService.findCategoryByIndexNameAndGender(
                                parentIndexName,
                                productForRollback.getCategory().getGenderid());
                        request.setAttribute("parentCategory", parentCategory);
                    }
                } catch (Exception ex) {
                    logger.warning("Không thể lấy thông tin danh mục cha để hiển thị lại: " + ex.getMessage());
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
                    String resolvedUrl = img.getImageUrl();
                    if (resolvedUrl != null && !resolvedUrl.startsWith("http") && !resolvedUrl.startsWith("/") && !resolvedUrl.startsWith("data:")) {
                        resolvedUrl = request.getContextPath() + "/uploads/" + resolvedUrl;
                    }
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
        // Fallback 1: Javascript-synced hidden input
        if (categoryIdParam == null || categoryIdParam.isBlank()) {
            categoryIdParam = request.getParameter("categoryid_backup");
        }
        // Fallback 2: if child category is empty, use parent category value
        if (categoryIdParam == null || categoryIdParam.isBlank()) {
            categoryIdParam = request.getParameter("parentCategory");
        }
        
        String genderIdParam = request.getParameter("genderid");
        String parentCategoryParam = request.getParameter("parentCategory");

        logger.info("DEBUG Categories: categoryid=" + categoryIdParam + ", backup=" + request.getParameter("categoryid_backup") + ", gender=" + genderIdParam + ", parent=" + parentCategoryParam);

        if (categoryIdParam == null || categoryIdParam.isBlank()) {
            throw new ServletException("Danh mục con không được rỗng. Chi tiết nhận được: {child=" + categoryIdParam + ", backup=" + request.getParameter("categoryid_backup") + ", parent=" + parentCategoryParam + "}. Vui lòng chọn lại danh mục và nhấn Publish.");
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdParam.trim());
        } catch (NumberFormatException e) {
            throw new ServletException("Lỗi: categoryid không phải là số. Giá trị: " + categoryIdParam + " (parent=" + parentCategoryParam + ")");
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
        String[] imgIndexes = request.getParameterValues("image_index");
        String primaryImageIndex = request.getParameter("image_isprimary");

        if (urls != null && imgColors != null && imgIndexes != null) {
            int imageRowCount = Math.min(urls.length, Math.min(imgColors.length, imgIndexes.length));

            for (int i = 0; i < imageRowCount; i++) {
                String url = urls[i];
                String idx = imgIndexes[i];
                
                // Tiên quyết: Xử lý file upload nếu người dùng dùng tab "Upload from Device"
                try {
                    Part filePart = request.getPart("image_file_" + idx);
                    if (filePart != null && filePart.getSize() > 0) {
                        String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        String ext = "";
                        int dotIdx = originalName.lastIndexOf('.');
                        if (dotIdx >= 0) ext = originalName.substring(dotIdx).toLowerCase();

                        String savedName = UUID.randomUUID().toString() + ext;

                        File productDir = new File(Constants.UPLOAD_DIR, "product");
                        if (!productDir.exists()) {
                            boolean created = productDir.mkdirs();
                            logger.info("Created upload directory: " + productDir.getAbsolutePath() + " result=" + created);
                        }

                        File savedFile = new File(productDir, savedName);
                        try (InputStream is = filePart.getInputStream()) {
                            Files.copy(is, savedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        }

                        // Set URL mới về đường dẫn file đã lưu
                        url = "product/" + savedName;
                    }
                } catch (Exception uploadEx) {
                    logger.warning("Upload image failed for index " + i + ": " + uploadEx.getMessage());
                }

                if (url != null && !url.isBlank()) {
                    ProductImage img = new ProductImage();
                    img.setImageUrl(url);
                    img.setColor(imgColors[i]);
                    // Mark as primary based on the index string equality (radio value is idx)
                    img.setPrimary(idx != null && idx.equals(primaryImageIndex));
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

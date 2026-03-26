package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.CartItem;
import com.aisthea.fashion.model.Product;
import com.aisthea.fashion.model.ProductColorSize;
import com.aisthea.fashion.service.IProductService;
import com.aisthea.fashion.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Logger;
import java.util.Optional;

public class CartServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CartServlet.class.getName());
    private IProductService productService;

    @Override
    public void init() {
        this.productService = new ProductService();
    }

    private Cart getCartFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            com.aisthea.fashion.model.User user = (com.aisthea.fashion.model.User) session.getAttribute("user");
            Integer userId = (user != null) ? user.getUserId() : null;
            String sessionId = session.getId();
            
            Cart dbCart = new com.aisthea.fashion.dao.CartDAO().getCart(userId, sessionId);
            if(dbCart != null) {
                cart = dbCart;
            } else {
                cart = new Cart();
            }
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private void syncDbOnItemChange(HttpServletRequest request, CartItem item) {
        if(item == null) return;
        HttpSession session = request.getSession(true);
        com.aisthea.fashion.model.User user = (com.aisthea.fashion.model.User) session.getAttribute("user");
        Integer userId = (user != null) ? user.getUserId() : null;
        String sessionId = session.getId();
        
        com.aisthea.fashion.dao.CartDAO cd = new com.aisthea.fashion.dao.CartDAO();
        Integer cartId = cd.getCartId(userId, sessionId);
        if (cartId == null) {
            cartId = cd.createCart(userId, sessionId);
        }
        if (cartId != null) {
            cd.addOrUpdateItem(cartId, item);
        }
    }

    private void syncDbOnRemove(HttpServletRequest request, int pcsId) {
        HttpSession session = request.getSession(true);
        com.aisthea.fashion.model.User user = (com.aisthea.fashion.model.User) session.getAttribute("user");
        Integer userId = (user != null) ? user.getUserId() : null;
        String sessionId = session.getId();
        
        com.aisthea.fashion.dao.CartDAO cd = new com.aisthea.fashion.dao.CartDAO();
        Integer cartId = cd.getCartId(userId, sessionId);
        if (cartId != null) {
            cd.removeItem(cartId, pcsId);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        String action = request.getParameter("action");
        String servletPath = request.getServletPath();

        // If no action, but accessing /checkout, set action to checkout
        if (action == null && "/checkout".equals(servletPath)) {
            action = "checkout";
        }

        if (action == null) {
            action = "view";
        }

        Cart cart = getCartFromSession(request);
        String jspPath = "/WEB-INF/views/cart/cart.jsp";

        try {
            if ("remove".equals(action)) {
                int pcsId = Integer.parseInt(request.getParameter("id"));
                cart.removeItem(pcsId);
                syncDbOnRemove(request, pcsId);
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        } catch (NumberFormatException e) {
            logger.warning("Invalid ID format for remove action: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Handle /checkout route
        if ("checkout".equals(action)) {
            Cart checkoutCart = (Cart) session.getAttribute("checkoutCart");
            if (checkoutCart == null || checkoutCart.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Guest user: redirect to login, then come back to checkout
            com.aisthea.fashion.model.User user = (com.aisthea.fashion.model.User) session.getAttribute("user");
            if (user == null) {
                String checkoutUrl = request.getContextPath() + "/checkout";
                session.setAttribute("returnUrl", checkoutUrl);
                response.sendRedirect(request.getContextPath() + "/login?returnUrl="
                        + java.net.URLEncoder.encode(checkoutUrl, "UTF-8"));
                return;
            }

            // Refresh user session data to ensure profile address is latest
            try {
                com.aisthea.fashion.model.User freshUser = new com.aisthea.fashion.dao.UserDAO().selectUser(user.getUserId());
                if (freshUser != null) {
                    freshUser.setPassword(null);
                    session.setAttribute("user", freshUser);
                    user = freshUser;
                }
            } catch (Exception e) {
                System.err.println("Failed to refresh user in CartServlet: " + e.getMessage());
            }

            // Load active vouchers for the "pick voucher" panel
            com.aisthea.fashion.dao.VoucherDAO vDao = new com.aisthea.fashion.dao.VoucherDAO();
            request.setAttribute("activeVouchers", vDao.findActiveVouchers());

            // Load user addresses
            com.aisthea.fashion.dao.UserAddressDAO addressDao = new com.aisthea.fashion.dao.UserAddressDAO();
            java.util.List<com.aisthea.fashion.model.UserAddress> addrs = addressDao.getByUserId(user.getUserId());
            System.out.println(">>> CHECKOUT: Loading addresses for UserID = " + user.getUserId() + " | Found: "
                    + addrs.size());
            request.setAttribute("userAddresses", addrs);

            // ── Calculate Tier Membership Discount ──────────────────────
            Cart checkoutCartForTier = (Cart) session.getAttribute("checkoutCart");
            if (checkoutCartForTier != null) {
                String tierName = com.aisthea.fashion.service.TierService.getTierName(user);
                int tierDiscountPercent = com.aisthea.fashion.service.TierService.getTierDiscountPercent(user);
                java.math.BigDecimal tierDiscountAmount = com.aisthea.fashion.service.TierService.calculateTierDiscount(
                        user, checkoutCartForTier.getTotalPrice());

                request.setAttribute("tierName", tierName);
                request.setAttribute("tierDiscountPercent", tierDiscountPercent);
                request.setAttribute("tierDiscountAmount", tierDiscountAmount);

                System.out.println(">>> CHECKOUT TIER: User=" + user.getUserId()
                        + " | Tier=" + tierName
                        + " | Discount=" + tierDiscountPercent + "%"
                        + " | Amount=" + tierDiscountAmount);
            }
            // ────────────────────────────────────────────────────────────

            request.getRequestDispatcher("/WEB-INF/views/cart/checkout.jsp")
                    .forward(request, response);
            return;
        }

        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        String redirectUrl = request.getContextPath() + "/cart";
        String productId = request.getParameter("productId");

        try {
            if ("add".equals(action)) {
                Cart cart = getCartFromSession(request);
                boolean addSuccess = handleAddAction(request, cart);
                if (addSuccess) {
                    int pcsId = Integer.parseInt(request.getParameter("productColorSizeId"));
                    syncDbOnItemChange(request, cart.getItem(pcsId));
                }

                boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
                        || "true".equals(request.getParameter("ajax"));

                if (isAjax) {
                    response.setContentType("application/json;charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    if (addSuccess) {
                        out.print("{\"success\":true,\"cartCount\":" + cart.getTotalQuantity() + "}");
                    } else {
                        out.print("{\"success\":false,\"message\":\"Số lượng vượt quá tồn kho hoặc sản phẩm không hợp lệ.\"}");
                    }
                    out.flush();
                    return;
                }
                
                if (addSuccess) {
                    redirectUrl = request.getContextPath() + "/product?action=view&id=" + productId + "&added=true";
                } else {
                    redirectUrl = request.getContextPath() + "/product?action=view&id=" + productId + "&error=stock";
                }

            } else if ("buy".equals(action)) {
                Cart buyNowCart = new Cart();
                boolean addSuccess = handleAddAction(request, buyNowCart);

                if (buyNowCart.isEmpty() || !addSuccess) {
                    redirectUrl = request.getContextPath() + "/product?action=view&id=" + productId + "&error=stock";
                } else {
                    session.removeAttribute("appliedVoucher");
                    session.removeAttribute("appliedDiscount");
                    session.setAttribute("checkoutCart", buyNowCart);
                    redirectUrl = request.getContextPath() + "/checkout";
                }

            } else if ("prepareCheckout".equals(action)) {
                Cart mainCart = getCartFromSession(request);
                Cart checkoutCart = new Cart();
                
                String[] selectedIds = request.getParameterValues("selectedItems");
                if (selectedIds != null) {
                    for (String idStr : selectedIds) {
                        try {
                            int pcsId = Integer.parseInt(idStr);
                            CartItem item = mainCart.getItem(pcsId);
                            if (item != null) {
                                checkoutCart.addItem(new CartItem(item));
                            }
                        } catch (Exception ignored) {}
                    }
                }
                
                if (checkoutCart.isEmpty()) {
                    session.setAttribute("error", "Vui lòng chọn ít nhất một sản phẩm để thanh toán.");
                    redirectUrl = request.getContextPath() + "/cart";
                } else {
                    session.removeAttribute("appliedVoucher");
                    session.removeAttribute("appliedDiscount");
                    session.setAttribute("checkoutCart", checkoutCart);
                    redirectUrl = request.getContextPath() + "/checkout";
                }

            } else if ("update".equals(action)) {
                Cart cart = getCartFromSession(request);
                handleUpdateAction(request, cart);
                
                int pcsId = Integer.parseInt(request.getParameter("id"));
                CartItem item = cart.getItem(pcsId);
                if (item != null && item.getQuantity() > 0) {
                    syncDbOnItemChange(request, item);
                } else {
                    syncDbOnRemove(request, pcsId);
                }

                boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
                        || "true".equals(request.getParameter("ajax"));
                if (isAjax) {
                    response.setContentType("application/json;charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    out.print("{");
                    out.print("\"success\":true");
                    out.print(",\"itemSubtotal\":" + (item != null ? item.getSubtotal() : 0));
                    out.print(",\"cartTotal\":" + cart.getTotalPrice());
                    out.print(",\"cartCount\":" + cart.getTotalQuantity());
                    out.print(",\"newQuantity\":" + (item != null ? item.getQuantity() : 0));
                    String errorRaw = session.getAttribute("error") != null ? session.getAttribute("error").toString() : "";
                    String errorEscaped = errorRaw.replace("\"", "\\\"");
                    out.print(",\"error\":\"" + errorEscaped + "\"");
                    out.print("}");
                    session.removeAttribute("error");
                    out.flush();
                    return;
                }
            } else if ("remove".equals(action)) {
                 Cart cart = getCartFromSession(request);
                 int pcsId = Integer.parseInt(request.getParameter("id"));
                 cart.removeItem(pcsId);
                 syncDbOnRemove(request, pcsId);
                 
                 boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
                        || "true".equals(request.getParameter("ajax"));
                 if (isAjax) {
                     response.setContentType("application/json;charset=UTF-8");
                     PrintWriter out = response.getWriter();
                     out.print("{\"success\":true,\"cartTotal\":" + cart.getTotalPrice() + ",\"cartCount\":" + cart.getTotalQuantity() + "}");
                     out.flush();
                     return;
                 }
            }
        } catch (Throwable e) {
            logger.severe("Error in Cart doPost (action=" + action + "): " + e.getMessage());
            boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
                    || "true".equals(request.getParameter("ajax"));
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().print("{\"success\":false,\"message\":\"Exception: " + e.getClass().getSimpleName() + " - " + (e.getMessage() != null ? e.getMessage().replace("\"", "'") : "null") + "\"}");
                return;
            }
            if (productId != null && !productId.isEmpty()) {
                redirectUrl = request.getContextPath() + "/product?action=view&id=" + productId + "&error=true";
            }
        }

        response.sendRedirect(redirectUrl);
    }

    private boolean handleAddAction(HttpServletRequest request, Cart cart) throws NumberFormatException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int pcsId = Integer.parseInt(request.getParameter("productColorSizeId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String imageUrl = request.getParameter("imageUrl");

        Product product = productService.getProductById(productId);
        if (product == null) {
            logger.warning("Attempted to add non-existent product ID: " + productId);
            return false;
        }

        List<ProductColorSize> variants = productService.getColorSizesByProductId(productId);
        Optional<ProductColorSize> selectedVariant = variants.stream()
                .filter(v -> v.getProductColorSizeId() == pcsId)
                .findFirst();

        if (selectedVariant.isEmpty()) {
            logger.warning("Attempted to add non-existent variant ID: " + pcsId);
            return false;
        }

        ProductColorSize variant = selectedVariant.get();

        CartItem existingItem = cart.getItem(pcsId);
        int quantityInCart = (existingItem != null) ? existingItem.getQuantity() : 0;

        if (quantity + quantityInCart > variant.getStock()) {
            logger.warning("Attempted to add more stock than available for variant ID: " + pcsId);
            return false;
        }

        CartItem item = new CartItem();
        item.setProductId(productId);
        item.setProductColorSizeId(pcsId);
        item.setProductName(product.getName());
        item.setPrice(product.getActualPrice());
        item.setColor(variant.getColor());
        item.setSize(variant.getSize());
        item.setQuantity(quantity);
        item.setProductImageUrl(imageUrl);

        cart.addItem(item);
        return true;
    }

    private void handleUpdateAction(HttpServletRequest request, Cart cart) throws NumberFormatException {
        int pcsId = Integer.parseInt(request.getParameter("id"));
        int newQuantity = Integer.parseInt(request.getParameter("quantity"));

        CartItem item = cart.getItem(pcsId);

        if (item != null) {
            List<ProductColorSize> variants = productService.getColorSizesByProductId(item.getProductId());

            int currentStockDb = 0;
            for (ProductColorSize v : variants) {
                if (v.getProductColorSizeId() == pcsId) {
                    currentStockDb = v.getStock();
                    break;
                }
            }

            if (newQuantity > currentStockDb) {
                newQuantity = currentStockDb;
                request.getSession().setAttribute("error",
                        "Số lượng sản phẩm '" + item.getProductName()
                                + "' vượt quá tồn kho! Đã điều chỉnh về mức tối đa: " + currentStockDb);
            }
            cart.updateItem(pcsId, newQuantity);
        }
    }
}



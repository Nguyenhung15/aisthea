package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.CartItem;
import com.aisthea.fashion.model.Product;
import com.aisthea.fashion.model.ProductColorSize;
import com.aisthea.fashion.service.IProductService;
import com.aisthea.fashion.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
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
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart originalCart = (Cart) session.getAttribute("originalCart");
        if (originalCart != null) {
            session.setAttribute("cart", originalCart);
            session.removeAttribute("originalCart");
            logger.info("Restored original cart for user.");
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }
        Cart cart = (Cart) session.getAttribute("cart");
        String jspPath = "/views/cart/cart.jsp";

        try {
            if ("remove".equals(action)) {
                int pcsId = Integer.parseInt(request.getParameter("id"));
                cart.removeItem(pcsId);
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        } catch (NumberFormatException e) {
            logger.warning("Invalid ID format for remove action: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
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

                if (session.getAttribute("originalCart") != null) {
                    session.removeAttribute("originalCart");
                    logger.info("Cleared temp originalCart on 'add' action.");
                }

                boolean addSuccess = handleAddAction(request, cart);

                if (addSuccess) {
                    redirectUrl = request.getContextPath() + "/product?action=view&id=" + productId + "&added=true";
                } else {
                    redirectUrl = request.getContextPath() + "/product?action=view&id=" + productId + "&error=stock";
                }

            } else if ("buy".equals(action)) {

                Cart originalCart = getCartFromSession(request);
                session.setAttribute("originalCart", new Cart(originalCart));

                Cart buyNowCart = new Cart();
                boolean addSuccess = handleAddAction(request, buyNowCart);

                if (buyNowCart.isEmpty() || !addSuccess) {
                    logger.warning("Buy Now failed, item not added (likely out of stock).");
                    redirectUrl = request.getContextPath() + "/product?action=view&id=" + productId + "&error=stock";
                    session.removeAttribute("originalCart");
                } else {
                    session.setAttribute("cart", buyNowCart);
                    redirectUrl = request.getContextPath() + "/views/cart/checkout.jsp";
                }

            } else if ("update".equals(action)) {
                if (session.getAttribute("originalCart") != null) {
                    session.removeAttribute("originalCart");
                }
                Cart cart = getCartFromSession(request);
                handleUpdateAction(request, cart);
            }
        } catch (Exception e) {
            logger.severe("Error in Cart doPost (action=" + action + "): " + e.getMessage());
            e.printStackTrace();
            if (productId != null && !productId.isEmpty()) {
                redirectUrl = request.getContextPath() + "/product?action=view&id=" + productId + "&error=true";
            }
            session.removeAttribute("originalCart");
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
        item.setPrice(product.getPrice());
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
                    "Số lượng sản phẩm '" + item.getProductName() + "' vượt quá tồn kho! Đã điều chỉnh về mức tối đa: " + currentStockDb);
            }
            cart.updateItem(pcsId, newQuantity);
        }
    }
}

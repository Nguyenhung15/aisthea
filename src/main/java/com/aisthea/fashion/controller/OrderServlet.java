package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.ReturnRequestDAO;
import com.aisthea.fashion.dao.OrderDAO;
import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.Order;
import com.aisthea.fashion.model.OrderItem;
import com.aisthea.fashion.model.ReturnRequest;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IOrderService;
import com.aisthea.fashion.service.OrderService;
import com.aisthea.fashion.config.EmailConfig;
import com.aisthea.fashion.config.PayOSConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkRequest;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkResponse;
import vn.payos.model.v2.paymentRequests.PaymentLinkItem;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.aisthea.fashion.util.Constants;

@WebServlet(name = "OrderServlet", urlPatterns = { "/order" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class OrderServlet extends HttpServlet {

    private IOrderService orderService;
    private static final Logger logger = Logger.getLogger(OrderServlet.class.getName());

    @Override
    public void init() {
        this.orderService = new OrderService();
    }

    private boolean isAdmin(User user) {
        return "ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (action == null) {
            action = "history";
        }

        try {
            switch (action) {
                case "view":
                    viewOrderDetails(request, response, user);
                    break;
                case "list":
                    handleAdminListOrders(request, response, user);
                    break;
                case "adminViewDetail":
                    handleAdminViewDetail(request, response, user);
                    break;
                case "listReturns":
                    handleAdminListReturns(request, response, user);
                    break;
                case "adminDelete":
                    handleAdminDelete(request, response, user);
                    break;
                case "adminUpdateStatus":
                    handleAdminUpdateStatus(request, response, user);
                    break;
                case "history":
                default:
                    showOrderHistory(request, response, user);
                    break;
            }
        } catch (Exception e) {
            logger.severe("Lỗi doGet OrderServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "placeorder":
                    placeOrder(request, response, user);
                    break;
                case "adminUpdateStatus":
                    handleAdminUpdateStatus(request, response, user);
                    break;
                case "cancel":
                    handleCancelOrder(request, response, user);
                    break;
                case "updateAddress":
                    handleUpdateAddress(request, response, user);
                    break;
                case "adminMarkRefunded":
                    handleAdminMarkRefunded(request, response, user);
                    break;
                case "submitReturn":
                    handleSubmitReturn(request, response, user);
                    break;
                case "processReturn":
                    handleProcessReturn(request, response, user);
                    break;
                case "cancelReturn":
                    handleCancelReturn(request, response, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/order?action=history");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi doPost OrderServlet (action=" + action + ")", e);
            e.printStackTrace();
            session.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/order?action=history");
        }
    }

    private void showOrderHistory(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Refresh user in session to ensure rank/points are up to date in sidebar
        refreshSessionUser(request);

        List<Order> orderList = orderService.getOrderHistory(user.getUserId());
        request.setAttribute("orderList", orderList);

        // Build a per-order map: orderId -> Set<productId reviewed for that order>
        // This lets each order independently show "Đánh giá" / "Sửa đánh giá".
        try {
            com.aisthea.fashion.dao.FeedbackDAO fbDao = new com.aisthea.fashion.dao.FeedbackDAO();
            java.util.Map<Integer, java.util.Set<Integer>> perOrderReviewed = new java.util.HashMap<>();
            for (Order o : orderList) {
                if ("Completed".equalsIgnoreCase(o.getStatus())) {
                    perOrderReviewed.put(o.getOrderid(),
                            fbDao.getReviewedProductIdsForOrder(user.getUserId(), o.getOrderid()));
                }
            }
            request.setAttribute("perOrderReviewedMap", perOrderReviewed);
        } catch (Exception e) {
            request.setAttribute("perOrderReviewedMap", new java.util.HashMap<>());
        }

        // Fetch Return Requests for history view
        try {
            com.aisthea.fashion.dao.ReturnRequestDAO rrDao = new com.aisthea.fashion.dao.ReturnRequestDAO();
            java.util.Map<Integer, ReturnRequest> returnRequestsMap = new java.util.HashMap<>();
            for (Order o : orderList) {
                ReturnRequest rr = rrDao.getByOrderId(o.getOrderid());
                if (rr != null) {
                    returnRequestsMap.put(o.getOrderid(), rr);
                }
            }
            request.setAttribute("returnRequestsMap", returnRequestsMap);
        } catch (Exception e) {
            request.setAttribute("returnRequestsMap", new java.util.HashMap<>());
        }

        request.getRequestDispatcher("/WEB-INF/views/order/history.jsp").forward(request, response);
    }

    private void viewOrderDetails(HttpServletRequest request, HttpServletResponse response, User user)
            throws Exception {
        try {
            String orderIdStr = request.getParameter("orderid");
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                orderIdStr = request.getParameter("id"); // Fallback to current 'id'
            }

            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/order?action=history&error=missingid");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);
            logger.info("Viewing order details for ID: " + orderId);

            Order order = null; // Declare order here
            // Check for payment status from PayOS return URL
            String paymentStatus = request.getParameter("payment");
            if ("success".equalsIgnoreCase(paymentStatus)) {
                Order orderBeforeUpdate = orderService.getOrderDetails(orderId, user.getUserId());
                if (orderBeforeUpdate != null && "Pending".equalsIgnoreCase(orderBeforeUpdate.getStatus())) {
                    logger.info("Payment success detected for order " + orderId + ". Updating status to Processing.");
                    orderService.updateOrderStatus(orderId, "Processing");
                    // Refresh order data and send confirmation email
                    order = orderService.getOrderDetails(orderId, user.getUserId()); // Assign to declared 'order'
                    if (order != null) {
                        sendOrderEmail(order, request);
                        
                        // Gửi thông báo cho Admin/Staff là có đơn hàng mới đã thanh toán QR
                        try {
                            com.aisthea.fashion.dao.NotificationDAO notifDao = new com.aisthea.fashion.dao.NotificationDAO();
                            try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                                 java.sql.PreparedStatement ps = conn.prepareStatement("SELECT userid FROM Users WHERE UPPER(role) IN ('ADMIN', 'STAFF')");
                                 java.sql.ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    com.aisthea.fashion.model.Notification n = new com.aisthea.fashion.model.Notification();
                                    n.setUserId(rs.getInt("userid"));
                                    n.setTitle("Thanh toán mới #" + orderId);
                                    n.setContent("Đơn hàng #" + orderId + " đã được thanh toán QR qua PayOS.");
                                    n.setType("ORDER");
                                    n.setTargetId(orderId);
                                    n.setRead(false);
                                    notifDao.addNotification(n);
                                }
                            }
                        } catch (Exception e) {}
                    }
                }
            } else if ("cancel".equalsIgnoreCase(paymentStatus)) {
                Order orderBeforeUpdate = orderService.getOrderDetails(orderId, user.getUserId());
                if (orderBeforeUpdate != null && "Pending".equalsIgnoreCase(orderBeforeUpdate.getStatus())) {
                    logger.info("Payment cancelled detected for order " + orderId + ". Cancelling order.");
                    orderService.cancelOrder(orderId, user.getUserId(), "Người dùng tự hủy thanh toán QR.");
                    request.setAttribute("error",
                            "Thanh toán QR đã bị hủy. Đơn hàng của bạn không thành công. Bạn có thể kiểm tra lại giỏ hàng.");
                }
            }

            // Always refresh user session when viewing details to ensure tier/points are
            // current
            refreshSessionUser(request);
            user = (User) request.getSession().getAttribute("user");

            // If 'order' was not updated in the payment status blocks, fetch it now
            if (order == null) {
                order = orderService.getOrderDetails(orderId, user.getUserId());
            }

            // If payment was success, remove processed items from main cart
            if ("success".equalsIgnoreCase(paymentStatus)) {
                HttpSession sess = request.getSession();
                Cart checkoutCart = (Cart) sess.getAttribute("checkoutCart");
                Cart mainCart = (Cart) sess.getAttribute("cart");
                if (checkoutCart != null && mainCart != null) {
                    com.aisthea.fashion.dao.CartDAO cd = new com.aisthea.fashion.dao.CartDAO();
                    Integer cartId = cd.getCartId(user.getUserId(), sess.getId());
                    for (com.aisthea.fashion.model.CartItem item : checkoutCart.getItems()) {
                        mainCart.removeItem(item.getProductColorSizeId());
                        if (cartId != null)
                            cd.removeItem(cartId, item.getProductColorSizeId());
                    }
                }
                sess.removeAttribute("checkoutCart");
            }

            if (order != null) {
                request.setAttribute("order", order);
                // Per-ORDER review check: user can review the same product again if bought in a
                // new order
                try {
                    com.aisthea.fashion.dao.FeedbackDAO fbDao = new com.aisthea.fashion.dao.FeedbackDAO();
                    java.util.Set<Integer> reviewedIds = fbDao.getReviewedProductIdsForOrder(user.getUserId(),
                            order.getOrderid());
                    request.setAttribute("reviewedProductIds", reviewedIds);
                } catch (Exception ignored) {
                    request.setAttribute("reviewedProductIds", new java.util.HashSet<>());
                }
                // Load existing return request for customer view
                try {
                    ReturnRequest existingReturn = new ReturnRequestDAO().getByOrderId(order.getOrderid());
                    request.setAttribute("returnRequest", existingReturn);
                } catch (Exception ignored) {
                    /* table may not exist yet */ }
                request.getRequestDispatcher("/WEB-INF/views/order/details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/order?action=history&error=notfound");
            }
        } catch (NumberFormatException e) {
            logger.warning("Invalid Order ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/order?action=history&error=invalidid");
        }
    }

    private void placeOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws Exception {

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("checkoutCart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }

        try {
            Order newOrder = orderService.placeOrder(user, cart, request);

            String saveNewAddress = request.getParameter("saveNewAddress");
            if ("true".equals(saveNewAddress)) {
                try {
                    com.aisthea.fashion.model.UserAddress newAddr = new com.aisthea.fashion.model.UserAddress();
                    newAddr.setUserId(user.getUserId());
                    newAddr.setFullName(request.getParameter("fullname"));
                    newAddr.setPhone(request.getParameter("phone"));
                    newAddr.setDetailedAddress(request.getParameter("address"));
                    newAddr.setDefault(false);
                    com.aisthea.fashion.dao.UserAddressDAO addrDao = new com.aisthea.fashion.dao.UserAddressDAO();
                    addrDao.insert(newAddr);
                } catch (Exception ignored) {
                    // Ignore explicitly if saving new address fails, order still placed
                    logger.warning("Failed to save new address during checkout: " + ignored.getMessage());
                }
            }

            if ("QR".equalsIgnoreCase(newOrder.getPaymentMethod())) {
                String baseUrl = PayOSConfig.getBaseUrl(request);
                String returnUrl = baseUrl + "/order?action=view&orderid=" + newOrder.getOrderid() + "&payment=success";
                String cancelUrl = baseUrl + "/order?action=view&orderid=" + newOrder.getOrderid() + "&payment=cancel";

                List<PaymentLinkItem> payosItems = new ArrayList<>();
                for (OrderItem oi : newOrder.getItems()) {
                    payosItems.add(PaymentLinkItem.builder()
                            .name(oi.getProductName())
                            .quantity(oi.getQuantity())
                            .price(oi.getPrice().longValue())
                            .build());
                }

                CreatePaymentLinkRequest paymentData = CreatePaymentLinkRequest.builder()
                        .orderCode(System.currentTimeMillis() / 1000)
                        .amount(newOrder.getTotalprice().longValue())
                        .description("Thanh toan don " + newOrder.getOrderid())
                        .items(payosItems)
                        .returnUrl(returnUrl)
                        .cancelUrl(cancelUrl)
                        .build();

                CreatePaymentLinkResponse checkoutResponse = PayOSConfig.getPayOS().paymentRequests()
                        .create(paymentData);
                String checkoutUrl = checkoutResponse.getCheckoutUrl();

                // Note: We DO NOT clear the cart here for QR payment.
                // It will be cleared in doGet when the user returns with payment=success.
                // This allows the user to try again if they cancel or the payment fails.

                response.sendRedirect(checkoutUrl);
                return;
            }

            sendOrderEmail(newOrder, request);

            // Gửi thông báo cho Admin/Staff khi có đơn mới (COD)
            try {
                com.aisthea.fashion.dao.NotificationDAO notifDao = new com.aisthea.fashion.dao.NotificationDAO();
                try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement("SELECT userid FROM Users WHERE UPPER(role) IN ('ADMIN', 'STAFF')");
                     java.sql.ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        com.aisthea.fashion.model.Notification n = new com.aisthea.fashion.model.Notification();
                        n.setUserId(rs.getInt("userid"));
                        n.setTitle("Đơn hàng mới #" + newOrder.getOrderid());
                        n.setContent("Khách hàng " + user.getFullname() + " đã đặt đơn hàng COD mới. Cần xác nhận!");
                        n.setType("ORDER");
                        n.setTargetId(newOrder.getOrderid());
                        n.setRead(false);
                        notifDao.addNotification(n);
                    }
                }
            } catch (Exception e) {
                logger.warning("Lỗi gửi thông báo admin (COD): " + e.getMessage());
            }

            // Remove purchased items from the main cart
            Cart mainCart = (Cart) session.getAttribute("cart");
            if (mainCart != null && cart != null) {
                com.aisthea.fashion.dao.CartDAO cd = new com.aisthea.fashion.dao.CartDAO();
                Integer cartId = cd.getCartId(user.getUserId(), session.getId());
                for (com.aisthea.fashion.model.CartItem item : cart.getItems()) {
                    mainCart.removeItem(item.getProductColorSizeId());
                    if (cartId != null)
                        cd.removeItem(cartId, item.getProductColorSizeId());
                }
            }
            session.removeAttribute("checkoutCart");

            // Refresh session user after placing order
            User freshUser = new com.aisthea.fashion.dao.UserDAO().selectUser(user.getUserId());
            if (freshUser != null) {
                freshUser.setPassword(null);
                session.setAttribute("user", freshUser);
            }

            response.sendRedirect(
                    request.getContextPath() + "/order?action=view&id=" + newOrder.getOrderid() + "&success=true");

        } catch (Exception e) {
            logger.log(Level.SEVERE,
                    "Lỗi khi đặt hàng (ID: "
                            + (session.getAttribute("user") != null ? ((User) session.getAttribute("user")).getUserId()
                                    : "unknown")
                            + "): " + e.getMessage(),
                    e);
            session.setAttribute("error", "Lỗi tạo yêu cầu thanh toán (PayOS): "
                    + (e.getMessage() != null ? e.getMessage() : "Unknown error"));
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws Exception {

        int orderId = -1;
        try {
            orderId = Integer.parseInt(request.getParameter("orderid"));
            String reason = request.getParameter("reason");
            if ("Other".equalsIgnoreCase(reason)) {
                String otherText = request.getParameter("otherReasonText");
                if (otherText != null && !otherText.trim().isEmpty()) {
                    reason = "Khác: " + otherText.trim();
                }
            } else if (reason == null || reason.trim().isEmpty()) {
                reason = "Không có lý do";
            }

            // Lấy bank info nếu có (đơn QR)
            String bankName   = request.getParameter("cancelBankName");
            String bankAcc    = request.getParameter("cancelBankAccount");
            String bankHolder = request.getParameter("cancelBankHolder");
            boolean hasBankInfo = bankName != null && !bankName.trim().isEmpty()
                    && bankAcc != null && !bankAcc.trim().isEmpty()
                    && bankHolder != null && !bankHolder.trim().isEmpty();

            if (hasBankInfo) {
                reason += " | Hoàn tiền: STK " + bankAcc.trim()
                        + " - " + bankName.trim()
                        + " - " + bankHolder.trim().toUpperCase();
            }

            // Lấy thông tin đơn trước khi hủy (để lấy totalprice)
            Order orderBeforeCancel = hasBankInfo
                    ? orderService.getOrderDetails(orderId, user.getUserId()) : null;

            orderService.cancelOrder(orderId, user.getUserId(), reason);

            // Nếu có bank info → tự động tạo ReturnRequest để admin xử lý hoàn tiền
            if (hasBankInfo) {
                try {
                    ReturnRequestDAO rrDao = new ReturnRequestDAO();
                    // Chỉ tạo nếu chưa có return request cho đơn này
                    if (rrDao.getByOrderId(orderId) == null) {
                        ReturnRequest rr = new ReturnRequest();
                        rr.setOrderId(orderId);
                        rr.setUserId(user.getUserId());
                        rr.setReasonType("Hoàn tiền sau hủy đơn");
                        rr.setReasonDetail(reason);
                        rr.setBankName(bankName.trim());
                        rr.setBankAccountNumber(bankAcc.trim());
                        rr.setBankAccountName(bankHolder.trim().toUpperCase());
                        if (orderBeforeCancel != null && orderBeforeCancel.getTotalprice() != null) {
                            rr.setRefundAmount(orderBeforeCancel.getTotalprice());
                        }
                        rrDao.insert(rr);

                        // Gửi thông báo cho Admin/Staff
                        try {
                            com.aisthea.fashion.dao.NotificationDAO notifDao = new com.aisthea.fashion.dao.NotificationDAO();
                            try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                                 java.sql.PreparedStatement ps = conn.prepareStatement(
                                         "SELECT userid FROM Users WHERE UPPER(role) IN ('ADMIN','STAFF')");
                                 java.sql.ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    com.aisthea.fashion.model.Notification n = new com.aisthea.fashion.model.Notification();
                                    n.setUserId(rs.getInt("userid"));
                                    n.setTitle("Yêu cầu hoàn tiền #" + orderId);
                                    n.setContent("Khách hàng " + user.getFullname()
                                            + " đã hủy đơn QR #" + orderId
                                            + " và yêu cầu hoàn tiền về STK " + bankAcc.trim()
                                            + " - " + bankName.trim() + ".");
                                    n.setType("RETURN");
                                    n.setTargetId(orderId);
                                    n.setRead(false);
                                    notifDao.addNotification(n);
                                }
                            }
                        } catch (Exception ne) {
                            logger.warning("Lỗi gửi thông báo hoàn tiền: " + ne.getMessage());
                        }
                    }
                } catch (Exception re) {
                    logger.warning("Không thể tạo return request tự động: " + re.getMessage());
                }
            }

            response.sendRedirect(request.getContextPath() + "/order?action=view&id=" + orderId + "&cancel=success");
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            String redirectUrl = (orderId != -1)
                    ? "/order?action=view&id=" + orderId + "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8")
                    : "/order?action=history&error=true";
            response.sendRedirect(request.getContextPath() + redirectUrl);
        }
    }

    private void handleUpdateAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws Exception {
        int orderId = -1;
        try {
            orderId = Integer.parseInt(request.getParameter("orderid"));

            // Fetch order to verify ownership and eligibility
            Order order = orderService.getOrderDetails(orderId, user.getUserId());
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/order?action=history&error=notfound");
                return;
            }
            String status = order.getStatus();
            if (!"Pending".equalsIgnoreCase(status) && !"Processing".equalsIgnoreCase(status)) {
                request.getSession().setAttribute("error",
                        "Chỉ có thể thay đổi địa chỉ khi đơn hàng đang ở trạng thái Pending hoặc Processing.");
                response.sendRedirect(request.getContextPath() + "/order?action=view&id=" + orderId);
                return;
            }

            String fullname = request.getParameter("newFullname");
            String phone = request.getParameter("newPhone");
            String province = request.getParameter("newProvince");
            String ward = request.getParameter("newWard");
            String detail = request.getParameter("newAddressDetail");

            // Build full address string: detail, ward, province
            String fullAddress = detail + ", " + ward + ", " + province;

            OrderDAO dao = new OrderDAO();
            boolean updated = dao.updateAddress(orderId, user.getUserId(), fullname, phone, fullAddress);

            if (updated) {
                response.sendRedirect(request.getContextPath()
                        + "/order?action=view&orderid=" + orderId + "&addrUpdated=true");
            } else {
                request.getSession().setAttribute("error", "Không thể cập nhật địa chỉ. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/order?action=view&id=" + orderId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage() != null ? e.getMessage() : "Lỗi không xác định";
            String redirectUrl = (orderId != -1)
                    ? "/order?action=view&id=" + orderId + "&error=" + java.net.URLEncoder.encode(msg, "UTF-8")
                    : "/order?action=history&error=true";
            response.sendRedirect(request.getContextPath() + redirectUrl);
        }
    }

    private void handleAdminListOrders(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");
        String customerName = request.getParameter("customerName");
        String date = request.getParameter("date");

        List<Order> filteredOrders = orderService.getFilteredOrders(orderId, status, customerName, date);
        request.setAttribute("orderList", filteredOrders);
        request.getRequestDispatcher("/WEB-INF/views/admin/order/manage_orders.jsp").forward(request, response);
    }

    private void handleAdminViewDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderService.getAdminOrderDetails(orderId);

            if (order != null) {
                request.setAttribute("order", order);
                // Load return request for admin view
                try {
                    ReturnRequest rr = new ReturnRequestDAO().getByOrderId(orderId);
                    request.setAttribute("returnRequest", rr);
                } catch (Exception ignored) {
                    /* table may not exist yet */ }
                request.getRequestDispatcher("/WEB-INF/views/admin/order/admin_order_detail.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(request.getContextPath() + "/order?action=list&error=notfound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/order?action=list&error=invalidid");
        }
    }

    private void handleAdminDelete(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            orderService.deleteOrder(orderId);
            response.sendRedirect(request.getContextPath() + "/order?action=list&delete=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/order?action=list&error=deletefail");
        }
    }

    private void handleAdminListReturns(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        try {
            ReturnRequestDAO rrDao = new ReturnRequestDAO();
            List<ReturnRequest> returnRequests = rrDao.getAllWithCustomerInfo();
            request.setAttribute("returnRequests", returnRequests);
        } catch (Exception e) {
            logger.warning("Error loading return requests: " + e.getMessage());
            request.setAttribute("returnRequests", new java.util.ArrayList<>());
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/order/manage_returns.jsp").forward(request, response);
    }

    private void handleAdminUpdateStatus(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        int orderId = -1;
        try {
            orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("newStatus");
            String cancelReason = request.getParameter("cancelReason");

            if (newStatus == null || newStatus.trim().isEmpty()) {
                throw new Exception("Trạng thái mới không được rỗng.");
            }

            if ("Cancelled".equalsIgnoreCase(newStatus)) {
                if (cancelReason == null || cancelReason.isBlank()) {
                    cancelReason = "Đã bị hủy bởi Quản trị viên.";
                }
                orderService.adminCancelOrder(orderId, cancelReason);
            } else {
                orderService.updateOrderStatus(orderId, newStatus);
            }

            response.sendRedirect(
                    request.getContextPath() + "/order?action=adminViewDetail&id=" + orderId + "&update=success");

        } catch (Exception e) {
            e.printStackTrace();
            String redirectUrl = (orderId != -1)
                    ? "/order?action=adminViewDetail&id=" + orderId + "&update=error"
                    : "/order?action=list&error=true";
            response.sendRedirect(request.getContextPath() + redirectUrl);
        }
    }

    private void handleAdminMarkRefunded(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        int orderId = -1;
        try {
            orderId = Integer.parseInt(request.getParameter("orderId"));
            orderService.markRefunded(orderId);
            response.sendRedirect(
                    request.getContextPath() + "/order?action=adminViewDetail&id=" + orderId + "&update=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath() + "/order?action=adminViewDetail&id=" + orderId + "&error=refundFailed");
        }
    }

    // ─── Return Request Handlers ──────────────────────────────────────────────

    private void handleSubmitReturn(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException, ServletException {
        int orderId = -1;
        try {
            orderId = Integer.parseInt(request.getParameter("orderid"));
            ReturnRequest rr = new ReturnRequest();
            rr.setOrderId(orderId);
            rr.setUserId(user.getUserId());
            rr.setReasonType(request.getParameter("reasonType"));
            rr.setReasonDetail(request.getParameter("reasonDetail"));
            rr.setBankName(request.getParameter("bankName"));
            rr.setBankAccountName(request.getParameter("bankAccountName"));
            rr.setBankAccountNumber(request.getParameter("bankAccountNumber"));

            // Save uploaded evidence files (images only)
            StringBuilder evidencePaths = new StringBuilder();
            java.util.Collection<jakarta.servlet.http.Part> parts = request.getParts();
            if (parts != null) {
                for (jakarta.servlet.http.Part part : parts) {
                    if ("evidenceFiles".equals(part.getName()) && part.getSize() > 0) {
                        // Use save() which only allows image extensions
                        String savedPath = com.aisthea.fashion.util.ImageUploadHelper.save(part, "returns");
                        if (savedPath != null) {
                            if (evidencePaths.length() > 0)
                                evidencePaths.append(",");
                            evidencePaths.append(savedPath);
                        }
                    }
                }
            }
            rr.setEvidenceUrls(evidencePaths.length() > 0 ? evidencePaths.toString() : null);

            orderService.submitReturnRequest(rr);
            
            // Gửi thông báo cho Admin/Staff khi có yêu cầu hoàn hàng mới
            try {
                com.aisthea.fashion.dao.NotificationDAO notifDao = new com.aisthea.fashion.dao.NotificationDAO();
                try (java.sql.Connection conn = com.aisthea.fashion.dao.DBConnection.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement("SELECT userid FROM Users WHERE UPPER(role) IN ('ADMIN', 'STAFF')");
                     java.sql.ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        com.aisthea.fashion.model.Notification n = new com.aisthea.fashion.model.Notification();
                        n.setUserId(rs.getInt("userid"));
                        n.setTitle("Yêu cầu hoàn trả #" + orderId);
                        n.setContent("Khách hàng " + user.getFullname() + " đã gửi yêu cầu bảo hành/hoàn trả cho đơn #" + orderId);
                        n.setType("RETURN");
                        n.setTargetId(orderId);
                        n.setRead(false);
                        notifDao.addNotification(n);
                    }
                }
            } catch (Exception e) {}

            response.sendRedirect(request.getContextPath()
                    + "/order?action=view&orderid=" + orderId + "&returnSubmitted=true");
        } catch (Exception e) {
            logger.warning("handleSubmitReturn error: " + e.getMessage());
            try {
                String encodedMsg = java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
                response.sendRedirect(request.getContextPath()
                        + "/order?action=view&orderid=" + orderId + "&returnError=" + encodedMsg);
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/order?action=history");
            }
        }
    }

    private void handleProcessReturn(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }
        int returnId = -1;
        int orderId = -1;
        try {
            returnId = Integer.parseInt(request.getParameter("returnId"));
            orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("newStatus");
            String adminNote = request.getParameter("adminNote");
            orderService.processReturnRequest(returnId, newStatus, adminNote);

            String from = request.getParameter("from");
            if ("list".equals(from)) {
                response.sendRedirect(request.getContextPath()
                        + "/order?action=listReturns&update=success");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/order?action=adminViewDetail&id=" + orderId + "&update=success");
            }
        } catch (Exception e) {
            logger.warning("handleProcessReturn error: " + e.getMessage());
            String from = request.getParameter("from");
            if ("list".equals(from)) {
                response.sendRedirect(request.getContextPath()
                        + "/order?action=listReturns&update=error");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/order?action=adminViewDetail&id=" + orderId + "&update=error");
            }
        }
    }

    private void handleCancelReturn(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int orderId = -1;
        try {
            int returnId = Integer.parseInt(request.getParameter("returnId"));
            orderId = Integer.parseInt(request.getParameter("orderId"));
            orderService.cancelReturnRequest(returnId, user.getUserId());
            response.sendRedirect(request.getContextPath()
                    + "/order?action=view&orderid=" + orderId + "&returnCancelled=true");
        } catch (Exception e) {
            logger.warning("handleCancelReturn error: " + e.getMessage());
            response.sendRedirect(request.getContextPath()
                    + (orderId != -1 ? "/order?action=view&orderid=" + orderId : "/order?action=history"));
        }
    }

    // ─── EMAIL HELPERS ────────────────────────────────────────────────────────

    /**
     * Sends a professional HTML order-confirmation email.
     * <p>
     * For product images uploaded from device (local files), the images are
     * embedded directly into the email using CID inline attachments.
     * This ensures images display correctly even when the server runs on localhost.
     * External HTTP images are linked normally.
     */
    private void sendOrderEmail(Order order, HttpServletRequest request) {
        if (order == null)
            return;
        try {
            @SuppressWarnings("deprecation")
            Locale localeVN = new Locale("vi", "VN");
            NumberFormat currencyFmt = NumberFormat.getCurrencyInstance(localeVN);

            String customerEmail = order.getEmail();
            if (customerEmail == null || customerEmail.trim().isEmpty()) {
                logger.warning("Cannot send email for order #" + order.getOrderid() + ": missing customer email.");
                return;
            }

            // Build base URL dynamically from the real request
            String baseUrl = com.aisthea.fashion.config.PayOSConfig.getBaseUrl(request);
            String contextPath = request.getContextPath(); // e.g. "/AistheaFashion"

            String subject = "AISTH\u00c9A - X\u00e1c nh\u1eadn \u0111\u01a1n h\u00e0ng #" + order.getOrderid();
            logger.info("Sending order email \u2192 " + customerEmail + " (order #" + order.getOrderid() + ")");

            // Collect local images to embed as CID inline attachments
            Map<String, File> inlineImages = new HashMap<>();
            int cidIndex = 0;

            StringBuilder html = new StringBuilder();
            html.append(
                    "<!DOCTYPE html><html lang='vi'><body style='margin:0;padding:0;font-family:Arial,sans-serif;background:#f4f4f4;'>");
            html.append(
                    "<div style='max-width:600px;margin:24px auto;background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.08);'>");
            html.append("<div style='background:#0f172a;padding:28px 32px;text-align:center;'>");
            html.append("<h1 style='margin:0;color:#fff;letter-spacing:6px;font-size:24px;'>AISTH\u00c9A</h1>");
            html.append("</div><div style='padding:32px;'>");
            html.append("<p>Ch\u00e0o <strong>").append(order.getFullname()).append("</strong>,</p>");
            html.append(
                    "<p style='color:#555;'>C\u1ea3m \u01a1n b\u1ea1n \u0111\u00e3 tin t\u01b0\u1edfng mua s\u1eafm t\u1ea1i <strong>AISTH\u00c9A</strong>. \u0110\u01a1n h\u00e0ng <strong>#")
                    .append(order.getOrderid())
                    .append("</strong> \u0111\u00e3 \u0111\u01b0\u1ee3c x\u00e1c nh\u1eadn.</p>");

            html.append(
                    "<h3 style='border-bottom:2px solid #f1f5f9;padding-bottom:8px;margin-top:28px;font-size:12px;text-transform:uppercase;letter-spacing:1px;color:#64748b;'>Chi ti\u1ebft \u0111\u01a1n h\u00e0ng</h3>");
            html.append("<table style='width:100%;border-collapse:collapse;'>");

            if (order.getItems() != null) {
                for (OrderItem item : order.getItems()) {
                    String rawUrl = item.getImageUrl();
                    String imgSrc;
                    File localFile = resolveLocalImageFile(rawUrl, contextPath);

                    if (localFile != null && localFile.exists()) {
                        // Local uploaded image → embed via CID
                        String cid = "img_" + cidIndex++;
                        inlineImages.put(cid, localFile);
                        imgSrc = "cid:" + cid;
                    } else {
                        // External HTTP or fallback → use resolved URL
                        imgSrc = resolveImageUrlForEmail(rawUrl, baseUrl);
                    }

                    BigDecimal lineTotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
                    html.append("<tr style='border-bottom:1px solid #f1f5f9;'>");
                    html.append("<td style='padding:12px 0;width:80px;vertical-align:top;'>")
                            .append("<img src='").append(imgSrc).append("' width='68' height='85'")
                            .append(" style='border-radius:6px;object-fit:cover;border:1px solid #e2e8f0;' /></td>");
                    html.append("<td style='padding:12px 8px;vertical-align:top;'>")
                            .append("<strong>").append(item.getProductName()).append("</strong><br>")
                            .append("<span style='font-size:12px;color:#94a3b8;'>")
                            .append(item.getColor()).append(" / ").append(item.getSize()).append("</span></td>");
                    html.append(
                            "<td style='padding:12px 4px;text-align:center;vertical-align:top;font-size:13px;color:#64748b;'>x")
                            .append(item.getQuantity()).append("</td>");
                    html.append("<td style='padding:12px 0 12px 8px;text-align:right;vertical-align:top;'>")
                            .append("<strong>").append(currencyFmt.format(lineTotal)).append("</strong></td>");
                    html.append("</tr>");
                }
            }
            html.append("</table>");
            html.append("<div style='text-align:right;padding:16px 0 0;border-top:2px solid #f1f5f9;'>")
                    .append("<span style='font-size:13px;color:#64748b;'>T\u1ed4NG THANH TO\u00c1N&nbsp;&nbsp;</span>")
                    .append("<strong style='font-size:20px;color:#9B774E;'>")
                    .append(currencyFmt.format(order.getTotalprice())).append("</strong></div>");

            html.append(
                    "<h3 style='border-bottom:2px solid #f1f5f9;padding-bottom:8px;margin-top:28px;font-size:12px;text-transform:uppercase;letter-spacing:1px;color:#64748b;'>Th\u00f4ng tin giao h\u00e0ng</h3>");
            html.append(
                    "<div style='background:#f8fafc;padding:16px;border-radius:8px;font-size:14px;line-height:1.8;'>")
                    .append("<b>Ng\u01b0\u1eddi nh\u1eadn:</b> ").append(order.getFullname()).append("<br>")
                    .append("<b>\u0110i\u1ec7n tho\u1ea1i:</b> ").append(order.getPhone()).append("<br>")
                    .append("<b>\u0110\u1ecba ch\u1ec9:</b> ").append(order.getAddress()).append("<br>")
                    .append("<b>Ph\u01b0\u01a1ng th\u1ee9c:</b> ").append(order.getPaymentMethod()).append("</div>");

            html.append(
                    "<p style='margin-top:28px;text-align:center;color:#94a3b8;font-size:13px;font-style:italic;'>Ch\u00fang t\u00f4i s\u1ebd li\u00ean h\u1ec7 s\u1edbm \u0111\u1ec3 giao h\u00e0ng.</p>");
            html.append(
                    "<p style='text-align:center;font-weight:700;'>Tr\u00e2n tr\u1ecdng,<br>\u0110\u1ed9i ng\u0169 AISTH\u00c9A</p>");
            html.append("</div>");
            html.append(
                    "<div style='background:#f8fafc;padding:16px;text-align:center;font-size:11px;color:#94a3b8;border-top:1px solid #e2e8f0;'>\u00a9 2025 AISTH\u00c9A. All rights reserved.</div>");
            html.append("</div></body></html>");

            // Use CID inline images if any local files were found
            EmailConfig.sendMailWithInlineImages(customerEmail, subject, html.toString(),
                    inlineImages, EmailConfig.TYPE_ORDER_CONFIRM, order.getUserid());
            logger.info("Order confirmation email #" + order.getOrderid() + " sent to " + customerEmail
                    + " (" + inlineImages.size() + " inline image(s))");

        } catch (Exception e) {
            logger.warning("Failed to send email for order #" + order.getOrderid() + ": " + e.getMessage());
        }
    }

    /**
     * Resolves a raw imageUrl (as stored in the database) to a fully-qualified
     * absolute URL that remote email clients can load.
     *
     * Resolution rules:
     * 1. Already absolute (http / https) → returned as-is.
     * 2. Starts with contextPath (e.g. "/AistheaFashion/uploads/...") → strip
     * contextPath, prepend baseUrl.
     * 3. Starts with '/' but without contextPath → prepend baseUrl.
     * 4. Otherwise (bare relative, e.g. "product/abc.jpg") → baseUrl + "/uploads/"
     * + path.
     */
    private String resolveImageUrlForEmail(String rawUrl, String baseUrl) {
        if (rawUrl == null || rawUrl.isBlank()) {
            return baseUrl + "/images/product-placeholder.png";
        }
        String url = rawUrl.trim();

        // 1. Already absolute
        if (url.startsWith("http://") || url.startsWith("https://")) {
            return url;
        }

        // 2 & 3. Starts with '/'
        if (url.startsWith("/")) {
            // Extract contextPath from baseUrl (e.g. "/AistheaFashion")
            // baseUrl looks like "http://host:port/AistheaFashion"
            try {
                java.net.URI uri = java.net.URI.create(baseUrl);
                String ctxPath = uri.getPath(); // e.g. "/AistheaFashion"
                if (ctxPath != null && !ctxPath.isEmpty() && url.startsWith(ctxPath + "/")) {
                    // Strip duplicate contextPath → "/uploads/product/uuid.jpg"
                    url = url.substring(ctxPath.length());
                }
            } catch (Exception ignored) {
                /* fallback: use url as-is */ }
            return baseUrl + url;
        }

        // 4. Bare relative path stored by ProductServlet, e.g. "product/uuid.jpg"
        return baseUrl + "/uploads/" + url;
    }

    /**
     * Attempts to resolve a raw imageUrl to a local File in UPLOAD_DIR.
     * Returns null if the URL points to an external HTTP resource or the file
     * doesn't exist locally — meaning it should be linked by URL instead of CID.
     *
     * Handles these stored formats:
     * - "product/uuid.jpg" → UPLOAD_DIR/product/uuid.jpg
     * - "/AistheaFashion/uploads/product/uuid.jpg" → UPLOAD_DIR/product/uuid.jpg
     * - "/uploads/product/uuid.jpg" → UPLOAD_DIR/product/uuid.jpg
     * - "https://example.com/img.jpg" → null (external)
     */
    private File resolveLocalImageFile(String rawUrl, String contextPath) {
        if (rawUrl == null || rawUrl.isBlank())
            return null;
        String url = rawUrl.trim();

        // External URL → not local
        if (url.startsWith("http://") || url.startsWith("https://")) {
            return null;
        }

        // Strip contextPath prefix if present (e.g. "/AistheaFashion/uploads/..." →
        // "/uploads/...")
        if (contextPath != null && !contextPath.isEmpty() && url.startsWith(contextPath + "/")) {
            url = url.substring(contextPath.length());
        }

        // Strip "/uploads/" prefix to get the relative path inside UPLOAD_DIR
        if (url.startsWith("/uploads/")) {
            url = url.substring("/uploads/".length());
        } else if (url.startsWith("/")) {
            // Some other absolute path that doesn't point to uploads
            return null;
        }

        // url is now "product/uuid.jpg" or "avatars/uuid.jpg" etc.
        File file = new File(Constants.UPLOAD_DIR, url);
        return file.exists() ? file : null;
    }

    // ─── SESSION HELPER ───────────────────────────────────────────────────────

    private void refreshSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return;
        User user = (User) session.getAttribute("user");
        if (user == null)
            return;
        try {
            User freshUser = new com.aisthea.fashion.dao.UserDAO().selectUser(user.getUserId());
            if (freshUser != null) {
                freshUser.setPassword(null);
                session.setAttribute("user", freshUser);
            }
        } catch (Exception e) {
            logger.warning("Failed to refresh session user: " + e.getMessage());
        }
    }
}

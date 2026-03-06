package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.Order;
import com.aisthea.fashion.model.OrderItem;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IOrderService;
import com.aisthea.fashion.service.OrderService;
import com.aisthea.fashion.utils.MailUtil;
import com.aisthea.fashion.utils.PayOSConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkRequest;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkResponse;
import vn.payos.model.v2.paymentRequests.PaymentLinkItem;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrderServlet", urlPatterns = { "/order" })
public class OrderServlet extends HttpServlet {

    private IOrderService orderService;
    private static final Logger logger = Logger.getLogger(OrderServlet.class.getName());

    @Override
    public void init() {
        this.orderService = new OrderService();
    }

    private boolean isAdmin(User user) {
        return "ADMIN".equals(user.getRole());
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
                case "adminDelete":
                    handleAdminDelete(request, response, user);
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
        List<Order> orderList = orderService.getOrderHistory(user.getUserId());
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("/WEB-INF/views/order/history.jsp").forward(request, response);
    }

    private void viewOrderDetails(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
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

            // Check for payment status from PayOS return URL
            String paymentStatus = request.getParameter("payment");
            if ("success".equalsIgnoreCase(paymentStatus)) {
                Order orderBeforeUpdate = orderService.getOrderDetails(orderId, user.getUserId());
                if (orderBeforeUpdate != null && !"Paid".equalsIgnoreCase(orderBeforeUpdate.getStatus())) {
                    logger.info("Payment success detected for order " + orderId + ". Updating status to Paid.");
                    orderService.updateOrderStatus(orderId, "Paid");
                    // Refresh order data and send confirmation email
                    Order updatedOrder = orderService.getOrderDetails(orderId, user.getUserId());
                    if (updatedOrder != null) {
                        sendOrderEmail(updatedOrder);
                    }
                }
            }

            Order order = orderService.getOrderDetails(orderId, user.getUserId());

            if (order != null) {
                request.setAttribute("order", order);
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
        Cart cart = (Cart) session.getAttribute("cart");

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

                session.setAttribute("cart", new Cart());
                session.removeAttribute("originalCart");

                response.sendRedirect(checkoutUrl);
                return;
            }

            sendOrderEmail(newOrder);

            session.setAttribute("cart", new Cart());
            session.removeAttribute("originalCart");

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
            orderService.cancelOrder(orderId, user.getUserId());
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

    private void handleAdminListOrders(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/order?action=history");
            return;
        }

        List<Order> allOrders = orderService.getAllOrders();
        request.setAttribute("orderList", allOrders);
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

            if (newStatus == null || newStatus.trim().isEmpty()) {
                throw new Exception("Trạng thái mới không được rỗng.");
            }

            orderService.updateOrderStatus(orderId, newStatus);
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

    private void sendOrderEmail(Order order) {
        if (order == null)
            return;

        try {
            Locale localeVN = new Locale("vi", "VN");
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(localeVN);
            String customerEmail = order.getEmail();
            if (customerEmail == null || customerEmail.trim().isEmpty()) {
                logger.warning(
                        "Không thể gửi mail cho đơn hàng #" + order.getOrderid() + " vì thiếu email khách hàng.");
                return;
            }
            String customerName = order.getFullname();
            String subject = "AISTHÉA - Xác nhận đơn hàng #" + order.getOrderid();

            logger.info("Đang chuẩn bị gửi mail tới: " + customerEmail + " cho đơn hàng #" + order.getOrderid());

            StringBuilder html = new StringBuilder();
            html.append("<html><body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>");
            html.append("<div style='max-width: 600px; margin: auto; border: 1px solid #eee; padding: 20px;'>");
            html.append("<h2 style='text-align: center; color: #000; letter-spacing: 2px;'>AISTHÉA</h2>");
            html.append("<p>Chào <b>" + customerName + "</b>,</p>");
            html.append("<p>Cảm ơn bạn đã tin tưởng và chọn sở hữu những thiết kế từ <b>AISTHÉA</b>.</p>");
            html.append("<p>Đơn hàng <strong>#" + order.getOrderid()
                    + "</strong> của bạn đã được xác nhận thành công.</p>");

            html.append(
                    "<h3 style='border-bottom: 2px solid #eee; padding-bottom: 5px; margin-top: 30px;'>CHI TIẾT ĐƠN HÀNG</h3>");
            html.append("<table style='width: 100%; border-collapse: collapse;'>");

            if (order.getItems() != null) {
                for (OrderItem item : order.getItems()) {
                    html.append("<tr style='border-bottom: 1px solid #eee;'>");
                    html.append("<td style='padding: 10px 0; width: 85px; vertical-align: top;'>");
                    html.append("<img src='" + item.getImageUrl() + "' width='70' style='border-radius: 4px;'>");
                    html.append("</td>");
                    html.append("<td style='padding: 10px 0; vertical-align: top;'>");
                    html.append("<strong>" + item.getProductName() + "</strong><br>");
                    html.append("<span style='color: #777; font-size: 0.85em;'>" + item.getColor() + " / "
                            + item.getSize() + "</span>");
                    html.append("</td>");
                    html.append("<td style='padding: 10px 0; text-align: right; width: 50px; vertical-align: top;'>x"
                            + item.getQuantity() + "</td>");
                    html.append(
                            "<td style='padding: 10px 0; text-align: right; white-space: nowrap; width: 120px; vertical-align: top;'><strong>"
                                    + currencyFormatter
                                            .format(item.getPrice().multiply(new BigDecimal(item.getQuantity())))
                                    + "</strong></td>");
                    html.append("</tr>");
                }
            }

            html.append("</table>");
            html.append("<p style='text-align: right; font-size: 1.2em; margin-top: 20px;'>");
            html.append("TỔNG THANH TOÁN: <strong style='color: #9B774E;'>"
                    + currencyFormatter.format(order.getTotalprice()) + "</strong>");
            html.append("</p>");

            html.append(
                    "<h3 style='border-bottom: 2px solid #eee; padding-bottom: 5px; margin-top: 30px;'>THÔNG TIN GIAO HÀNG</h3>");
            html.append(
                    "<p style='background-color: #fcfcfc; padding: 15px; border: 1px solid #f0f0f0; border-radius: 4px;'>");
            html.append("<b>Người nhận:</b> " + order.getFullname() + "<br>");
            html.append("<b>Số điện thoại:</b> " + order.getPhone() + "<br>");
            html.append("<b>Địa chỉ:</b> " + order.getAddress() + "<br>");
            html.append("<b>Phương thức:</b> " + order.getPaymentMethod());
            html.append("</p>");

            html.append(
                    "<p style='margin-top: 30px; text-align: center; color: #777; font-style: italic;'>Chúng tôi sẽ sớm liên hệ để giao hàng đến bạn.</p>");
            html.append("<p style='text-align: center; font-weight: bold;'>Trân trọng,<br>Đội ngũ AISTHÉA</p>");
            html.append("</div>");
            html.append("</body></html>");

            MailUtil.sendMail(customerEmail, subject, html.toString());
            logger.info("Email xác nhận đơn hàng #" + order.getOrderid() + " đã được gửi tới " + customerEmail);

        } catch (Exception e) {
            logger.warning("Gửi mail cho đơn hàng #" + order.getOrderid() + " thất bại: " + e.getMessage());
        }
    }
}

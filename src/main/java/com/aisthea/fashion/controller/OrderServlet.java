package com.aisthea.fashion.controller;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.Order;
import com.aisthea.fashion.model.OrderItem;
import com.aisthea.fashion.model.User;
import com.aisthea.fashion.service.IOrderService;
import com.aisthea.fashion.service.OrderService;
import com.aisthea.fashion.util.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
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
        request.getRequestDispatcher("/views/order/history.jsp").forward(request, response);
    }

    private void viewOrderDetails(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderService.getOrderDetails(orderId, user.getUserId());

            if (order != null) {
                request.setAttribute("order", order);
                request.getRequestDispatcher("/views/order/details.jsp").forward(request, response);
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

            try {
                Locale localeVN = new Locale("vi", "VN");
                NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(localeVN);
                String customerEmail = newOrder.getEmail();
                String customerName = newOrder.getFullname();
                String subject = "AISTHÉA - Xác nhận đơn hàng #" + newOrder.getOrderid();

                StringBuilder html = new StringBuilder();
                html.append("<html><body style='font-family: Arial, sans-serif; line-height: 1.6;'>");
                html.append("<h2>Chào " + customerName + ",</h2>");
                html.append("<p>Cảm ơn bạn đã mua sắm tại <b>AISTHÉA FASHION</b>!</p>");
                html.append("<p>Đơn hàng <strong>#" + newOrder.getOrderid()
                        + "</strong> của bạn đã được xác nhận và đang chờ xử lý.</p>");
                html.append("<h3 style='border-bottom: 2px solid #eee; padding-bottom: 5px;'>Chi tiết đơn hàng</h3>");
                html.append("<table style='width: 100%; border-collapse: collapse;'>");

                if (newOrder.getItems() != null) {
                    for (OrderItem item : newOrder.getItems()) {
                        html.append("<tr style='border-bottom: 1px solid #eee;'>");
                        html.append("<td style='padding: 10px 0; width: 85px; vertical-align: top;'>");
                        html.append("<img src='" + item.getImageUrl()
                                + "' width='70' style='border-radius: 8px; margin-right: 15px;'>");
                        html.append("</td>");
                        html.append("<td style='padding: 10px 0; vertical-align: top;'>");
                        html.append("<strong>" + item.getProductName() + "</strong><br>");
                        html.append("<span style='color: #555; font-size: 0.9em;'>" + item.getColor() + " / "
                                + item.getSize() + "</span>");
                        html.append("</td>");
                        html.append(
                                "<td style='padding: 10px 0; text-align: right; width: 50px; vertical-align: top;'>x "
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
                html.append("Tổng cộng: <strong style='color: #9B774E;'>"
                        + currencyFormatter.format(newOrder.getTotalprice()) + "</strong>");
                html.append("</p>");
                html.append("<h3 style='border-bottom: 2px solid #eee; padding-bottom: 5px;'>Thông tin giao hàng</h3>");
                html.append("<p style='background-color: #f9f9f9; padding: 15px; border-radius: 8px;'>");
                html.append("<strong>" + newOrder.getFullname() + "</strong><br>");
                html.append(newOrder.getPhone() + "<br>");
                html.append(newOrder.getAddress());
                html.append("</p>");
                html.append("<p>Chúng tôi sẽ thông báo cho bạn khi đơn hàng bắt đầu được giao. Cảm ơn!</p>");
                html.append("</body></html>");

                MailUtil.sendMail(customerEmail, subject, html.toString());

            } catch (Exception mailException) {
                logger.warning("Đặt hàng THÀNH CÔNG, nhưng GỬI EMAIL XÁC NHẬN THẤT BẠI cho " + newOrder.getEmail());
                mailException.printStackTrace();
            }

            session.setAttribute("cart", new Cart());
            session.removeAttribute("originalCart");

            response.sendRedirect(
                    request.getContextPath() + "/order?action=view&id=" + newOrder.getOrderid() + "&success=true");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi khi đặt hàng: " + e.getMessage());
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
        request.getRequestDispatcher("/views/admin/order/manage_orders.jsp").forward(request, response);
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
                request.getRequestDispatcher("/views/admin/order/admin_order_detail.jsp").forward(request, response);
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
}

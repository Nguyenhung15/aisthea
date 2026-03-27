package com.aisthea.fashion.service;

import com.aisthea.fashion.dao.IOrderDAO;
import com.aisthea.fashion.dao.IOrderItemDAO;
import com.aisthea.fashion.dao.OrderDAO;
import com.aisthea.fashion.dao.OrderItemDAO;
import com.aisthea.fashion.dao.ReturnRequestDAO;
import com.aisthea.fashion.dao.UserDAO;
import com.aisthea.fashion.dao.VoucherDAO;
import com.aisthea.fashion.dao.PaymentDAO;
import com.aisthea.fashion.model.*;
import com.aisthea.fashion.dao.DBConnection;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class OrderService implements IOrderService {

    private IOrderDAO orderDAO;
    private IOrderItemDAO orderItemDAO;
    private final VoucherDAO voucherDAO = new VoucherDAO();
    private final INotificationService notificationService = new NotificationService();
    private static final Logger logger = Logger.getLogger(OrderService.class.getName());

    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.orderItemDAO = new OrderItemDAO();
    }

    @Override
    public Order placeOrder(User user, Cart cart, HttpServletRequest request) throws Exception {

        // ── 1. Đọc voucher từ request / session ──────────────────────────
        BigDecimal discountAmount = BigDecimal.ZERO;
        Integer voucherId = null;

        String discountStr = request.getParameter("discountAmount");
        String voucherIdStr = request.getParameter("voucherId");

        if (discountStr != null && !discountStr.isBlank()) {
            try {
                discountAmount = new BigDecimal(discountStr);
            } catch (Exception ignored) {
            }
        }
        if (voucherIdStr != null && !voucherIdStr.isBlank()) {
            try {
                voucherId = Integer.parseInt(voucherIdStr);
            } catch (Exception ignored) {
            }
        }

        // Fallback: lấy từ session nếu form không truyền đủ
        if (voucherId == null && request.getSession(false) != null) {
            Voucher sessionVoucher = (Voucher) request.getSession(false).getAttribute("appliedVoucher");
            BigDecimal sessionDiscount = (BigDecimal) request.getSession(false).getAttribute("appliedDiscount");
            if (sessionVoucher != null && sessionDiscount != null) {
                voucherId = sessionVoucher.getVoucherId();
                discountAmount = sessionDiscount;
            }
        }

        // ── 2. Tính Tier Discount (server validate, không tin client) ────
        BigDecimal tierDiscountAmount = TierService.calculateTierDiscount(user, cart.getTotalPrice());
        String tierName = TierService.getTierName(user);

        // ── 2b. Tính Birthday Discount (server validate) ────
        BigDecimal birthdayDiscountAmount = TierService.calculateBirthdayDiscount(user, cart.getTotalPrice());

        // ── 2c. Tính Shipping Fee ────────────────────────────────────────
        int provinceId = 0;
        Integer districtId = null;
        String wardCode = null;

        String provinceIdStr = request.getParameter("provinceId");
        if (provinceIdStr != null && !provinceIdStr.trim().isEmpty()) {
            try {
                provinceId = Integer.parseInt(provinceIdStr);
            } catch (Exception ignored) {}
        }
        
        String districtIdStr = request.getParameter("districtId");
        if (districtIdStr != null && !districtIdStr.trim().isEmpty()) {
            try {
                districtId = Integer.parseInt(districtIdStr);
            } catch (Exception ignored) {}
        }
        
        String reqWardCode = request.getParameter("wardCode");
        if (reqWardCode != null && !reqWardCode.trim().isEmpty()) {
            wardCode = reqWardCode.trim();
        }

        double totalWeight = 0.0;
        for (CartItem item : cart.getItems()) {
            totalWeight += item.getWeight() * item.getQuantity();
        }

        String shippingMethod = request.getParameter("shippingMethod");
        if (shippingMethod == null || shippingMethod.isEmpty()) {
            shippingMethod = "STANDARD";
        }

        BigDecimal shippingFee = new ShippingService().calculateShippingFee(provinceId, totalWeight, shippingMethod);
        String shippingCode = shippingMethod + "-ATA" + System.currentTimeMillis();

        // ── 3. Tính tổng tiền sau giảm + phí ship ──────────────────────────────
        BigDecimal cartTotal = cart.getTotalPrice();
        BigDecimal finalTotal = cartTotal
                .subtract(tierDiscountAmount)
                .subtract(birthdayDiscountAmount)
                .subtract(discountAmount)
                .add(shippingFee);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0)
            finalTotal = BigDecimal.ZERO;

        // ── 4. Build Order object ────────────────────────────────────────
        Order newOrder = new Order();
        newOrder.setUserid(user.getUserId());
        newOrder.setTotalprice(finalTotal.setScale(0, java.math.RoundingMode.HALF_UP));
        newOrder.setDiscountAmount(discountAmount.setScale(0, java.math.RoundingMode.HALF_UP));
        newOrder.setTierDiscount(tierDiscountAmount.setScale(0, java.math.RoundingMode.HALF_UP));
        newOrder.setTierName(tierName);
        newOrder.setBirthdayDiscount(birthdayDiscountAmount.setScale(0, java.math.RoundingMode.HALF_UP));
        newOrder.setShippingFee(shippingFee);
        newOrder.setShippingCode(shippingCode);
        if (voucherId != null)
            newOrder.setVoucherId(voucherId);
        newOrder.setStatus("Pending");
        newOrder.setFullname(request.getParameter("fullname"));
        newOrder.setEmail(user.getEmail());
        newOrder.setPhone(request.getParameter("phone"));
        newOrder.setAddress(request.getParameter("address"));
        newOrder.setPaymentMethod(request.getParameter("paymentMethod"));
        newOrder.setDistrictId(districtId);
        newOrder.setWardCode(wardCode);

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int newOrderId = orderDAO.addOrder(newOrder, conn);
            if (newOrderId == -1) {
                throw new SQLException("Không thể tạo đơn hàng. DAO trả về -1.");
            }
            newOrder.setOrderid(newOrderId);

            // ── Record birthday discount usage (1 lần/năm) ──
            if (birthdayDiscountAmount.compareTo(BigDecimal.ZERO) > 0) {
                com.aisthea.fashion.dao.BirthdayDiscountDAO bdDao = new com.aisthea.fashion.dao.BirthdayDiscountDAO();
                int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
                bdDao.recordUsage(user.getUserId(), currentYear, newOrderId, birthdayDiscountAmount, conn);
            }

            // ── 4. Order items + stock ───────────────────────────────────
            List<OrderItem> items = new ArrayList<>();
            for (CartItem cartItem : cart.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderid(newOrderId);
                orderItem.setProductcolorsizeid(cartItem.getProductColorSizeId());
                orderItem.setColor(cartItem.getColor());
                orderItem.setSize(cartItem.getSize());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(
                        cartItem.getPrice() != null ? cartItem.getPrice().setScale(0, java.math.RoundingMode.HALF_UP)
                                : BigDecimal.ZERO);
                orderItem.setImageUrl(cartItem.getProductImageUrl());
                orderItem.setProductName(cartItem.getProductName());

                items.add(orderItem);
                orderItemDAO.addOrderItem(orderItem, conn);

                boolean stockUpdated = orderItemDAO.updateStock(orderItem, conn);
                if (!stockUpdated) {
                    throw new SQLException("Hết hàng cho sản phẩm: " + cartItem.getProductName());
                }
            }
            newOrder.setItems(items);

            // ── 5. Tăng used_count voucher (trong cùng transaction) ──────
            if (voucherId != null) {
                voucherDAO.incrementUsedCount(voucherId, conn);
                logger.info("Voucher ID=" + voucherId + " used_count incremented for order #" + newOrderId);
            }

            // ── 6. Lưu vào bảng payments ──────────────────────────────────
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment payment = new Payment();
            payment.setOrderId(newOrderId);
            payment.setMethod(newOrder.getPaymentMethod());
            payment.setAmount(newOrder.getTotalprice());
            payment.setStatus("Pending");
            paymentDAO.insertPayment(payment, conn);

            conn.commit();

            // Send notification for new order
            notificationService.sendNotification(user.getUserId(),
                    "Đặt hàng thành công",
                    "Đơn hàng #" + newOrderId + " của bạn đã được đặt thành công và đang chờ xác nhận.",
                    "ORDER");

            // Points are added when order is Paid or Completed to avoid duplication.

            // ── 7. Xoá voucher khỏi session ──────────────────────────────
            if (request.getSession(false) != null) {
                request.getSession(false).removeAttribute("appliedVoucher");
                request.getSession(false).removeAttribute("appliedDiscount");
            }

            return newOrder;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public List<Order> getOrderHistory(int userId) {
        try {
            List<Order> orders = orderDAO.getOrdersByUserId(userId);
            for (Order o : orders) {
                o.setItems(orderItemDAO.getOrderItemsByOrderId(o.getOrderid()));
            }
            return orders;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi lấy lịch sử đơn hàng", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public Order getOrderDetails(int orderId, int userId) {
        try {
            Order order = orderDAO.getOrderById(orderId, userId);
            if (order != null) {
                List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
                order.setItems(items);
            }
            return order;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi lấy chi tiết đơn hàng", e);
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Order> getAllOrders() {
        try {
            return orderDAO.getAllOrders();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi lấy tất cả đơn hàng", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public boolean updateOrderStatus(int orderId, String newStatus) {
        try {

            // (Point adding logic has been moved to confirmPayment)

            boolean updated = orderDAO.updateOrderStatus(orderId, newStatus);
            if (updated) {
                try {
                    Order order = orderDAO.getAdminOrderById(orderId);
                    if (order != null) {
                        notificationService.sendNotification(order.getUserid(),
                                "Cập nhật đơn hàng",
                                "Đơn hàng #" + orderId + " của bạn đã được cập nhật trạng thái sang: " + newStatus,
                                "ORDER");
                    }
                } catch (Exception e) {
                    logger.warning("Could not send status update notification: " + e.getMessage());
                }
            }
            return updated;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái đơn hàng", e);
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Order getAdminOrderDetails(int orderId) {
        try {
            Order order = orderDAO.getAdminOrderById(orderId);
            if (order != null) {
                List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
                order.setItems(items);

                if (order.getVoucherId() != null) {
                    VoucherDAO voucherDAO = new VoucherDAO();
                    Voucher v = voucherDAO.findById(order.getVoucherId());
                    order.setVoucher(v);
                }
            }
            return order;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean confirmPayment(int orderId, String transactionCode) {
        try {
            PaymentDAO paymentDAO = new PaymentDAO();
            java.util.List<Payment> payments = paymentDAO.getByOrderId(orderId);
            if (payments.isEmpty()) return false;
            Payment latest = payments.get(0);
            if ("Paid".equalsIgnoreCase(latest.getStatus()) || "Success".equalsIgnoreCase(latest.getStatus())) {
                return true; // Already paid
            }

            boolean updated = paymentDAO.confirmPaymentByOrderId(orderId, transactionCode);
            if (updated) {
                Order order = orderDAO.getAdminOrderById(orderId);
                // Update Order Status if Pending
                if (order != null && "Pending".equalsIgnoreCase(order.getStatus())) {
                     updateOrderStatus(orderId, "Processing"); // Note this sends notification inside updateOrderStatus
                }
                
                // Add points
                if (order != null) {
                    int pointsEarned = order.getTotalprice()
                            .divide(new java.math.BigDecimal("10000"), 0, java.math.RoundingMode.DOWN)
                            .intValue();
                    if (pointsEarned > 0) {
                        UserDAO userDAO = new UserDAO();
                        userDAO.updateMembershipPoints(order.getUserid(), pointsEarned,
                                "Points from Paid Order #" + orderId);
                        logger.info("Đã cộng " + pointsEarned + " điểm cho user ID: " + order.getUserid()
                                + " từ đơn hàng #" + orderId + " (Payment: Paid)");
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi confirmPayment", e);
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteOrder(int orderId) {
        try {
            return orderDAO.deleteOrder(orderId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi xóa đơn hàng", e);
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean cancelOrder(int orderId, int userId, String reason) throws Exception {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            Order order = orderDAO.getOrderById(orderId, userId);
            if (order == null) {
                throw new Exception("Không tìm thấy đơn hàng hoặc bạn không có quyền.");
            }

            String currentStatus = order.getStatus();
            String refundStatus = null;

            if ("Pending".equalsIgnoreCase(currentStatus)) {
                // COD / Chờ xác nhận -> Hủy bình thường, không cần hoàn tiền
                refundStatus = null;
            } else if ("Processing".equalsIgnoreCase(currentStatus) || "Shipped".equalsIgnoreCase(currentStatus)) {
                if ("QR".equalsIgnoreCase(order.getPaymentMethod()))
                    refundStatus = "Pending";
            } else {
                throw new Exception("Quá trình hủy không hợp lệ cho trạng thái: " + currentStatus);
            }

            List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
            if (items == null || items.isEmpty()) {
                throw new Exception("Không tìm thấy sản phẩm trong đơn hàng này.");
            }

            for (OrderItem item : items) {
                boolean stockRestored = orderItemDAO.increaseStock(item, conn);
                if (!stockRestored) {
                    throw new SQLException(
                            "Lỗi: Không thể hoàn trả kho cho sản phẩm ID: " + item.getProductcolorsizeid());
                }
            }

            com.aisthea.fashion.dao.BirthdayDiscountDAO bdDao = new com.aisthea.fashion.dao.BirthdayDiscountDAO();
            bdDao.removeUsageByOrderId(orderId, conn);

            boolean statusUpdated = orderDAO.updateOrderStatus(orderId, "Cancelled", conn);
            if (!statusUpdated) {
                throw new SQLException("Lỗi: Không thể cập nhật trạng thái đơn hàng.");
            }

            boolean cancelInfoUpdated = orderDAO.updateCancelInfo(orderId, reason, refundStatus, conn);
            if (!cancelInfoUpdated) {
                logger.warning("Không thể lưu lý do hủy và trạng thái hoàn tiền cho đơn #" + orderId);
            }

            conn.commit();

            notificationService.sendNotification(userId,
                    "Hủy đơn hàng thành công",
                    "Đơn hàng #" + orderId + " của bạn đã được hủy thành công.",
                    "ORDER");
            return true;

        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            logger.log(Level.SEVERE, "Lỗi khi hủy đơn hàng (ID: " + orderId + ")", e);
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public boolean adminCancelOrder(int orderId, String reason) throws Exception {
        Order order = orderDAO.getAdminOrderById(orderId);
        if (order == null)
            throw new Exception("Không tìm thấy đơn hàng.");

        if ("Cancelled".equalsIgnoreCase(order.getStatus())) {
            // Already cancelled, just update the reason
            Connection conn = null;
            try {
                conn = DBConnection.getConnection();
                orderDAO.updateCancelInfo(orderId, reason, order.getRefundStatus(), conn);
                return true;
            } finally {
                if (conn != null)
                    conn.close();
            }
        }

        return cancelOrder(orderId, order.getUserid(), reason);
    }

    @Override
    public boolean markRefunded(int orderId) throws Exception {
        Order order = orderDAO.getAdminOrderById(orderId);
        if (order == null)
            throw new Exception("Không tìm thấy đơn hàng.");
        if (!"Cancelled".equalsIgnoreCase(order.getStatus()) || !"Pending".equalsIgnoreCase(order.getRefundStatus())) {
            throw new Exception("Đơn hàng không ở trạng thái cần hoàn tiền.");
        }

        return orderDAO.updateRefundStatus(orderId, "Completed");
    }

    @Override
    public int getTotalOrderCount() {
        try {
            return orderDAO.getAllOrders().size();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi đếm đơn hàng", e);
            return 0;
        }
    }

    @Override
    public BigDecimal getTotalRevenue() {
        try {
            return orderDAO.getAllOrders().stream()
                    .filter(order -> "Completed".equalsIgnoreCase(order.getStatus()))
                    .map(Order::getTotalprice)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi tính doanh thu", e);
            return BigDecimal.ZERO;
        }
    }

    @Override
    public List<Order> getRecentOrders(int limit) {
        try {
            List<Order> allOrders = orderDAO.getAllOrders();
            return allOrders.stream().limit(limit).collect(Collectors.toList());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi lấy đơn hàng gần đây", e);
            return new ArrayList<>();
        }
    }

    @Override
    public List<Order> getFilteredOrders(String orderId, String status, String customerName, String date) {
        try {
            return orderDAO.getFilteredOrders(orderId, status, customerName, date);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi lọc đơn hàng", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // ─── Return Request ───────────────────────────────────────────────────────

    @Override
    public ReturnRequest submitReturnRequest(ReturnRequest rr) throws Exception {
        ReturnRequestDAO rrDao = new ReturnRequestDAO();

        Order order = orderDAO.getOrderById(rr.getOrderId(), rr.getUserId());
        if (order == null) {
            throw new Exception("Không tìm thấy đơn hàng hoặc bạn không có quyền thực hiện.");
        }
        if (!"Completed".equalsIgnoreCase(order.getStatus())) {
            throw new Exception("Chỉ có thể yêu cầu hoàn trả đối với đơn hàng đã hoàn thành.");
        }

        // 7-day return window
        if (order.getCompletedAt() != null) {
            Calendar deadline = Calendar.getInstance();
            deadline.setTime(order.getCompletedAt());
            deadline.add(Calendar.DAY_OF_YEAR, 7);
            if (new Date().after(deadline.getTime())) {
                throw new Exception("Đã quá 7 ngày kể từ khi đơn hoàn thành. Không thể yêu cầu hoàn trả.");
            }
        }

        // No duplicate active request
        ReturnRequest existing = rrDao.getByOrderId(rr.getOrderId());
        if (existing != null && !"Rejected".equalsIgnoreCase(existing.getStatus())) {
            throw new Exception("Đơn hàng này đã có yêu cầu hoàn trả đang được xử lý.");
        }

        rr.setRefundAmount(order.getTotalprice());

        int newId = rrDao.insert(rr);
        if (newId == -1) {
            throw new Exception("Không thể tạo yêu cầu hoàn trả. Vui lòng thử lại.");
        }
        rr.setReturnId(newId);

        notificationService.sendNotification(rr.getUserId(),
                "Yêu cầu hoàn trả đã gửi",
                "Yêu cầu hoàn trả cho đơn hàng #" + rr.getOrderId() + " đã được gửi. Chúng tôi sẽ xử lý trong vòng 24-48 giờ.",
                "RETURN");

        logger.info("Return request #" + newId + " submitted for order #" + rr.getOrderId());
        return rr;
    }

    @Override
    public boolean processReturnRequest(int returnId, String newStatus, String adminNote) throws Exception {
        ReturnRequestDAO rrDao = new ReturnRequestDAO();

        ReturnRequest rr = rrDao.getAll().stream()
                .filter(r -> r.getReturnId() == returnId)
                .findFirst()
                .orElseThrow(() -> new Exception("Không tìm thấy yêu cầu hoàn trả #" + returnId));

        if (!"Pending".equalsIgnoreCase(rr.getStatus())) {
            throw new Exception("Yêu cầu này đã được xử lý rồi (trạng thái: " + rr.getStatus() + ").");
        }

        boolean updated = rrDao.updateStatus(returnId, newStatus, adminNote);
        if (!updated) return false;

        if ("Approved".equalsIgnoreCase(newStatus)) {
            try (Connection conn = DBConnection.getConnection()) {
                com.aisthea.fashion.dao.BirthdayDiscountDAO bdDao = new com.aisthea.fashion.dao.BirthdayDiscountDAO();
                bdDao.removeUsageByOrderId(rr.getOrderId(), conn);
            } catch (Exception e) {
                logger.warning("Could not restore birthday discount for order #" + rr.getOrderId() + ": " + e.getMessage());
            }
            orderDAO.updateOrderStatus(rr.getOrderId(), "ReturnApproved");
            
            // Insert Refund record into payments
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment refund = new Payment();
            refund.setOrderId(rr.getOrderId());
            refund.setMethod("Refund");
            refund.setAmount(rr.getRefundAmount().negate());
            refund.setStatus("Refunded");
            refund.setPaidAt(new java.sql.Timestamp(System.currentTimeMillis()));
            paymentDAO.insertPayment(refund);
            
            notificationService.sendNotification(rr.getUserId(),
                    "Yêu cầu hoàn trả được chấp nhận",
                    "Yêu cầu hoàn trả đơn hàng #" + rr.getOrderId() + " đã được chấp nhận. Tiền sẽ hoàn về tài khoản trong 3-5 ngày làm việc.",
                    "RETURN");
        } else if ("Rejected".equalsIgnoreCase(newStatus)) {
            notificationService.sendNotification(rr.getUserId(),
                    "Yêu cầu hoàn trả bị từ chối",
                    "Yêu cầu hoàn trả đơn hàng #" + rr.getOrderId() + " bị từ chối. Lý do: " + (adminNote != null ? adminNote : "Không có ghi chú."),
                    "RETURN");
        }

        logger.info("Return request #" + returnId + " → " + newStatus);
        return true;
    }

    @Override
    public boolean cancelReturnRequest(int returnId, int userId) throws Exception {
        ReturnRequestDAO rrDao = new ReturnRequestDAO();
        ReturnRequest rr = rrDao.getAll().stream()
                .filter(r -> r.getReturnId() == returnId && r.getUserId() == userId)
                .findFirst()
                .orElse(null);
        
        boolean deleted = rrDao.delete(returnId, userId);
        if (deleted && rr != null) {
            notificationService.sendNotification(userId,
                "Đã hủy yêu cầu hoàn trả",
                "Yêu cầu hoàn trả đơn hàng #" + rr.getOrderId() + " đã được hủy thành công.",
                "RETURN");
        }
        return deleted;
    }
}

package com.aisthea.fashion.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Maps the {@code vouchers} table.
 *
 * discount_type: "PERCENT" → giảm theo %, "FIXED" → giảm số tiền cố định
 * min_order_value: đơn hàng tối thiểu mới được dùng
 * max_discount_amount: trần giảm tối đa (chỉ áp dụng khi discount_type =
 * PERCENT)
 * usage_limit: số lần dùng tối đa (-1 = không giới hạn)
 * used_count: số lần đã dùng
 * is_active: admin có thể bật/tắt thủ công
 */
public class Voucher {

    private int voucherId;
    private String code; // Mã voucher, UNIQUE
    private String description; // Mô tả
    private String discountType; // "PERCENT" | "FIXED"
    private BigDecimal discountValue; // Giá trị giảm (% hoặc VND)
    private BigDecimal minOrderValue; // Đơn tối thiểu
    private BigDecimal maxDiscountAmount; // Trần giảm (khi PERCENT)
    private int usageLimit; // -1 = vô hạn
    private int usedCount;
    private Timestamp startDate;
    private Timestamp endDate;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Voucher() {
    }

    // ── Getters / Setters ────────────────────────────────────────────────

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public BigDecimal getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(BigDecimal minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public BigDecimal getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public int getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // ── Business helpers ────────────────────────────────────────────────

    /** Tính số tiền được giảm thực tế cho một đơn hàng */
    public BigDecimal calculateDiscount(BigDecimal orderTotal) {
        if (orderTotal == null || discountValue == null)
            return BigDecimal.ZERO;
        if (minOrderValue != null && orderTotal.compareTo(minOrderValue) < 0)
            return BigDecimal.ZERO;

        BigDecimal discount;
        if ("PERCENT".equalsIgnoreCase(discountType)) {
            discount = orderTotal.multiply(discountValue).divide(BigDecimal.valueOf(100));
            if (maxDiscountAmount != null && discount.compareTo(maxDiscountAmount) > 0) {
                discount = maxDiscountAmount;
            }
        } else {
            // FIXED
            discount = discountValue;
            if (discount.compareTo(orderTotal) > 0)
                discount = orderTotal;
        }
        return discount;
    }

    /** Kiểm tra voucher có còn dùng được không */
    public boolean isUsable() {
        if (!isActive)
            return false;
        if (usageLimit > 0 && usedCount >= usageLimit)
            return false;
        long now = System.currentTimeMillis();
        if (startDate != null && startDate.getTime() > now)
            return false;
        if (endDate != null && endDate.getTime() < now)
            return false;
        return true;
    }
}

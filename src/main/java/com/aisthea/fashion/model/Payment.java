package com.aisthea.fashion.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Maps the {@code payments} table.
 * Used to record payment history per order, including QR/banking transactions.
 */
public class Payment {

    private int paymentId; // paymentid
    private int orderId; // orderid
    private String method; // method (e.g. "COD", "VNPay", "MoMo", "Banking_QR")
    private BigDecimal amount; // amount
    private String status; // status (e.g. "Pending", "Paid", "Failed")
    private String transactionCode; // transactioncode – mã giao dịch QR/online
    private Timestamp paidAt; // paidat

    public Payment() {
    }

    // ── getters / setters ──────────────────────────────────────────────────

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTransactionCode() {
        return transactionCode;
    }

    public void setTransactionCode(String transactionCode) {
        this.transactionCode = transactionCode;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }
}

-- =====================================================
-- Migration: Create return_requests table
-- Supports Shopee-style return/refund flow
-- =====================================================

CREATE TABLE return_requests (
    return_id       INT IDENTITY(1,1) PRIMARY KEY,
    order_id        INT NOT NULL,
    user_id         INT NOT NULL,

    -- Reason & evidence
    reason_type     NVARCHAR(100)  NOT NULL,
    reason_detail   NVARCHAR(1000) NULL,
    evidence_urls   NVARCHAR(MAX)  NULL,

    -- Refund bank info
    bank_name           NVARCHAR(100)  NULL,
    bank_account_name   NVARCHAR(200)  NULL,
    bank_account_number NVARCHAR(50)   NULL,

    -- Status: Pending | Approved | Rejected
    status          NVARCHAR(30)   NOT NULL DEFAULT 'Pending',
    admin_note      NVARCHAR(1000) NULL,
    refund_amount   DECIMAL(18,0)  NULL,

    created_at      DATETIME       NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME       NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_return_order FOREIGN KEY (order_id) REFERENCES orders(orderid),
    CONSTRAINT FK_return_user  FOREIGN KEY (user_id)  REFERENCES users(userid)
);

CREATE INDEX IX_return_requests_order  ON return_requests(order_id);
CREATE INDEX IX_return_requests_user   ON return_requests(user_id);
CREATE INDEX IX_return_requests_status ON return_requests(status);

-- =====================================================
-- Script: Tạo thông báo cho tất cả đơn hàng cũ
-- Chạy file này 1 lần trong SQL Server Management Studio
-- =====================================================

-- 1. Tạo thông báo ORDER cho mỗi đơn hàng chưa có thông báo
INSERT INTO Notifications (userid, title, content, type, is_read, createdat)
SELECT 
    o.userid,
    CASE 
        WHEN o.status = 'Pending' THEN N'Đơn hàng mới'
        WHEN o.status = 'Confirmed' THEN N'Đơn hàng đã xác nhận'
        WHEN o.status = 'Shipping' THEN N'Đơn hàng đang giao'
        WHEN o.status IN ('Completed', 'Paid') THEN N'Đơn hàng hoàn thành'
        WHEN o.status = 'Cancelled' THEN N'Đơn hàng đã hủy'
        ELSE N'Cập nhật đơn hàng'
    END,
    N'Đơn hàng #' + CAST(o.orderid AS NVARCHAR(20)) + N' - Trạng thái: ' +
    CASE 
        WHEN o.status = 'Pending' THEN N'Chờ xác nhận'
        WHEN o.status = 'Confirmed' THEN N'Đã xác nhận'
        WHEN o.status = 'Shipping' THEN N'Đang giao hàng'
        WHEN o.status = 'Completed' THEN N'Hoàn thành'
        WHEN o.status = 'Paid' THEN N'Đã thanh toán'
        WHEN o.status = 'Cancelled' THEN N'Đã hủy'
        ELSE ISNULL(o.status, N'Không rõ')
    END,
    'ORDER',
    0,
    o.createdat
FROM orders o
WHERE NOT EXISTS (
    SELECT 1 FROM Notifications n 
    WHERE n.userid = o.userid 
      AND n.type = 'ORDER' 
      AND n.content LIKE N'%#' + CAST(o.orderid AS NVARCHAR(20)) + N'%'
);

-- 2. Tạo thông báo khuyến mãi cho user chưa có
INSERT INTO Notifications (userid, title, content, type, is_read, createdat)
SELECT DISTINCT 
    u.userid,
    N'Chào mừng bạn đến với AISTHÉA',
    N'Khám phá bộ sưu tập Thu Đông mới nhất với ưu đãi lên đến 50%. Nhập mã SPRING50 ngay!',
    'PROMOTION',
    0,
    GETDATE()
FROM Users u
WHERE NOT EXISTS (
    SELECT 1 FROM Notifications n 
    WHERE n.userid = u.userid AND n.type = 'PROMOTION'
);

INSERT INTO Notifications (userid, title, content, type, is_read, createdat)
SELECT DISTINCT 
    u.userid,
    N'Ưu đãi thành viên mới',
    N'Bạn đã nhận được phiếu giảm giá 20% cho đơn hàng đầu tiên. Hạn dùng: 30 ngày.',
    'PROMOTION',
    0,
    GETDATE()
FROM Users u
WHERE NOT EXISTS (
    SELECT 1 FROM Notifications n 
    WHERE n.userid = u.userid AND n.type = 'PROMOTION' AND n.title = N'Ưu đãi thành viên mới'
);

-- Kiểm tra kết quả
SELECT 'Tổng thông báo' AS Info, COUNT(*) AS SoLuong FROM Notifications
UNION ALL
SELECT 'Thông báo ORDER', COUNT(*) FROM Notifications WHERE type = 'ORDER'
UNION ALL
SELECT 'Thông báo PROMOTION', COUNT(*) FROM Notifications WHERE type = 'PROMOTION';

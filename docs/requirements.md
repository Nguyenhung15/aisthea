# Dự án: Hệ thống Quản lý Cửa hàng Thời trang AISTHEA (Nhóm 4)

## 1. Giới thiệu đề tài
Trong bối cảnh thị trường thời trang ngày càng phát triển và cạnh tranh gay gắt, việc quản lý cửa hàng theo phương pháp thủ công hoặc rời rạc gây ra nhiều khó khăn như sai sót trong quản lý hàng tồn kho, thất thoát doanh thu, khó theo dõi đơn hàng và chăm sóc khách hàng chưa hiệu quả.

Vì vậy, xây dựng hệ thống quản lý cửa hàng thời trang là một nhu cầu cần thiết nhằm hỗ trợ cửa hàng quản lý tập trung, tự động hóa quy trình bán hàng, nâng cao hiệu quả kinh doanh và trải nghiệm khách hàng.

Hệ thống giúp chủ cửa hàng và nhân viên dễ dàng quản lý sản phẩm, khách hàng, đơn hàng, thanh toán và báo cáo, đồng thời giảm thiểu sai sót và tiết kiệm thời gian vận hành.

## 2. Phạm vi của đề tài
- Quản lý sản phẩm thời trang (quần áo, phụ kiện)
- Quản lý khách hàng
- Quản lý đơn hàng – thanh toán
- Quản lý nhân viên
- Theo dõi tồn kho

**Hệ thống chưa làm được:**
- Bán hàng trực tuyến (Lưu ý: Use case có phần mua hàng, có thể dự án đã mở rộng)
- Thử đồ online
- Chat box AI (Lưu ý: Database có bảng Chat/Message, có thể đang phát triển)

## 3. Các tính năng chính
1. Gửi email xác nhận đăng ký.
2. Quản lý sản phẩm (thêm, sửa, xóa, tìm kiếm).
3. Quản lý danh mục, size, màu sắc, giá bán.
4. Quản lý khách hàng và lịch sử mua hàng.
5. Tạo và xử lý đơn hàng.
6. Tính tổng tiền, thuế, giảm giá.
7. Quản lý nhân viên và phân quyền.
8. Quản lý tồn kho (nhập – xuất).
9. Thống kê doanh thu, sản phẩm bán chạy.
10. Xuất hóa đơn qua gmail.

## 4. Các tác nhân (Actors)
1. **Quản trị hệ thống (Admin)**: Quyền cao nhất, cấu hình, kiểm soát và giám sát.
2. **Nhân viên bán hàng (Staff)**: Phục vụ tại cửa hàng, hỗ trợ giao dịch.
3. **Khách hàng (Customer)**: Đã đăng nhập, mua sắm và tương tác.
4. **Khách vãng lai (Guest)**: Chưa đăng nhập, truy cập chức năng cơ bản.

## 5. Use Cases chính

### Admin
- Quản lý Dashboard & Thống kê doanh thu.
- Quản lý User (Ban/Unban, Delete).
- Quản lý Category & Product.
- Cấu hình Discount, Stock.
- Quản lý Order status.

### Staff
- Quản lý Order status.
- Tìm kiếm sản phẩm & Kiểm tra tồn kho.
- Xem thông tin/lịch sử mua hàng khách hàng.

### Customer
- Profile (Đổi mật khẩu, cập nhật thông tin).
- Xem sản phẩm & chi tiết.
- Giỏ hàng (Thêm, sửa số lượng, đổi variant, xóa).
- Thanh toán / Đặt hàng.
- Lịch sử đơn hàng & Theo dõi đơn hàng.

### Guest
- Xem sản phẩm & tìm kiếm.
- Đăng ký tài khoản.

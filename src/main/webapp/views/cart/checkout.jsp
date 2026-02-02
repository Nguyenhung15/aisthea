<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thanh toán - AISTHÉA</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
            }
        </style>
    </head>
    <body class="bg-gray-100">

        <jsp:include page="/views/shared/header.jsp" />

        <div class="container mx-auto max-w-6xl p-4 md:p-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-8">Thanh Toán</h1>

            <form action="${pageContext.request.contextPath}/order" method="POST">
                <input type="hidden" name="action" value="placeorder">
                <div class="flex flex-col lg:flex-row gap-8">

                    <div class="w-full lg:w-2/3 bg-white rounded-lg shadow-lg p-6">
                        <h2 class="text-xl font-semibold text-gray-700 mb-6">Thông tin giao hàng</h2>

                        <c:if test="${not empty sessionScope.error}">
                            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                                <span class="block sm:inline">${sessionScope.error}</span>
                            </div>
                            <c:remove var="error" scope="session" />
                        </c:if>

                        <!-- ✅ Họ và tên + SĐT cùng hàng -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="md:col-span-2 grid grid-cols-3 gap-4">
                                <div class="col-span-2">
                                    <label for="fullname" class="block text-sm font-medium text-gray-700">Họ và tên</label>
                                    <input type="text" id="fullname" name="fullname" value="${sessionScope.user.fullname}" required 
                                           class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm">
                                </div>
                                <div class="col-span-1">
                                    <label for="phone" class="block text-sm font-medium text-gray-700">Số điện thoại</label>
                                    <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" required
                                           class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm">
                                </div>
                            </div>

                            <div class="md:col-span-2">
                                <label for="address" class="block text-sm font-medium text-gray-700">Địa chỉ</label>
                                <input type="text" id="address" name="address" value="${sessionScope.user.address}" required
                                       class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm">
                            </div>
                        </div>

                        <div class="mt-6">
                            <h2 class="text-lg text-gray-800 mb-3">Phương thức thanh toán</h2>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">

                                <label class="flex flex-col items-center justify-center border border-gray-300 rounded-lg py-3 cursor-pointer hover:border-[#9B774E] transition">
                                    <input type="radio" name="paymentMethod" value="COD" checked class="accent-[#9B774E] mb-2">
                                    <i class="fa-solid fa-box-open text-[#9B774E] text-2xl mb-1"></i>
                                    <span class="text-gray-700 text-sm text-center">Thanh toán khi nhận hàng</span>
                                </label>

                                <label class="flex flex-col items-center justify-center border border-gray-300 rounded-lg py-3 cursor-pointer hover:border-[#9B774E] transition">
                                    <input type="radio" name="paymentMethod" value="QR" class="accent-[#9B774E] mb-2">
                                    <i class="fa-solid fa-qrcode text-[#9B774E] text-2xl mb-1"></i>
                                    <span class="text-gray-700 text-sm text-center">Mã QR</span>
                                </label>

                                <label class="flex flex-col items-center justify-center border border-gray-300 rounded-lg py-3 cursor-pointer hover:border-[#9B774E] transition">
                                    <input type="radio" name="paymentMethod" value="Card" class="accent-[#9B774E] mb-2">
                                    <i class="fa-solid fa-credit-card text-[#9B774E] text-2xl mb-1"></i>
                                    <span class="text-gray-700 text-sm text-center">Thẻ (Visa / Nội địa)</span>
                                </label>

                            </div>

                            <div id="paymentDetails" class="mt-6">
                                <div id="qrSection" class="hidden border border-gray-300 rounded-lg p-4 text-center">
                                    <p class="text-gray-700 mb-2 font-semibold">Quét mã QR để thanh toán:</p>
                                    <img src="${pageContext.request.contextPath}/assets/img/qr-payment.png" alt="QR Code" class="mx-auto w-48 h-48 object-contain">
                                    <p class="text-sm text-gray-500 mt-2">Nội dung chuyển khoản: 
                                        <span class="font-semibold">AISTHEA - ${sessionScope.user.fullname}</span>
                                    </p>
                                </div>

                                <div id="cardSection" class="hidden border border-gray-300 rounded-lg p-4">
                                    <p class="text-gray-700 font-semibold mb-3">Nhập thông tin thẻ</p>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div class="md:col-span-2">
                                            <label class="block text-sm font-medium text-gray-700">Số thẻ</label>
                                            <input type="text" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" maxlength="19"
                                                   class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700">Ngày hết hạn</label>
                                            <input type="text" name="expiryDate" placeholder="MM/YY" maxlength="5"
                                                   class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700">CVV</label>
                                            <input type="password" name="cvv" placeholder="XXX" maxlength="3"
                                                   class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm">
                                        </div>
                                        <div class="md:col-span-2">
                                            <label class="block text-sm font-medium text-gray-700">Tên chủ thẻ</label>
                                            <input type="text" name="cardName" placeholder="Nguyen Van A"
                                                   class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="w-full lg:w-1/3">
                        <div class="bg-white rounded-lg shadow-lg p-6 sticky top-28">
                            <h2 class="text-xl font-semibold text-gray-700 border-b border-gray-200 pb-4 mb-4">Đơn hàng của bạn</h2>

                            <div class="max-h-60 overflow-y-auto space-y-4 mb-4 pr-2">
                                <c:forEach var="item" items="${sessionScope.cart.items}">
                                    <div class="flex items-center gap-4">
                                        <img src="${item.productImageUrl}" alt="${item.productName}" class="w-16 h-16 object-cover rounded-md">
                                        <div class="flex-grow">
                                            <p class="font-semibold text-gray-800">${item.productName}</p>
                                            <p class="text-sm text-gray-500">${item.color} / ${item.size} x ${item.quantity}</p>
                                        </div>
                                        <span class="font-semibold text-gray-800">
                                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="border-t border-gray-200 pt-4">
                                <div class="flex justify-between mb-2">
                                    <span class="text-gray-600">Tổng tiền hàng:</span>
                                    <span class="font-semibold text-gray-800">
                                        <fmt:formatNumber value="${sessionScope.cart.totalPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                    </span>
                                </div>
                                <div class="flex justify-between mb-4">
                                    <span class="text-gray-600">Phí vận chuyển:</span>
                                    <span class="font-semibold text-gray-800">Miễn phí</span>
                                </div>
                                <div class="border-t border-gray-200 pt-4 flex justify-between items-center">
                                    <span class="text-lg font-bold text-gray-900">Tổng Cộng:</span>
                                    <span class="text-xl font-bold text-[#9B774E]">
                                        <fmt:formatNumber value="${sessionScope.cart.totalPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                    </span>
                                </div>

                                <button type="submit" class="block w-full text-center bg-[#9B774E] text-white font-semibold px-6 py-3 rounded-lg shadow-md hover:bg-[#8a6944] transition duration-300 mt-6">
                                    Đặt hàng
                                </button>
                            </div>
                        </div>
                    </div>

                </div>
            </form>
        </div>

        <jsp:include page="/views/shared/footer.jsp" />

        <script>
            const radios = document.querySelectorAll('input[name="paymentMethod"]');
            const qrSection = document.getElementById('qrSection');
            const cardSection = document.getElementById('cardSection');

            radios.forEach(radio => {
                radio.addEventListener('change', () => {
                    qrSection.classList.add('hidden');
                    cardSection.classList.add('hidden');

                    if (radio.value === 'QR') {
                        qrSection.classList.remove('hidden');
                    } else if (radio.value === 'Card') {
                        cardSection.classList.remove('hidden');
                    }
                });
            });

            // ✅ Kiểm tra thanh toán QR
            const form = document.querySelector('form');
            form.addEventListener('submit', function (e) {
                const selected = document.querySelector('input[name="paymentMethod"]:checked').value;

                if (selected === 'QR') {
                    e.preventDefault();
                    alert("Vui lòng chuyển khoản theo mã QR hiển thị.\nSau khi chuyển khoản xong, nhấn OK để xác nhận.");

                    setTimeout(() => {
                        const success = confirm("Xác nhận bạn đã chuyển khoản thành công?");
                        if (success) {
                            form.submit();
                        } else {
                            alert("Vui lòng hoàn tất chuyển khoản trước khi tiếp tục.");
                        }
                    }, 2000);
                }

                // ✅ Kiểm tra thông tin thẻ trước khi thanh toán
                if (selected === 'Card') {
                    e.preventDefault();

                    const cardNumber = document.querySelector('input[name="cardNumber"]').value.trim();
                    const expiryDate = document.querySelector('input[name="expiryDate"]').value.trim();
                    const cvv = document.querySelector('input[name="cvv"]').value.trim();
                    const cardName = document.querySelector('input[name="cardName"]').value.trim();

                    const cardNumberRegex = /^[0-9]{16}$/;
                    const expiryRegex = /^(0[1-9]|1[0-2])\/\d{2}$/;
                    const cvvRegex = /^[0-9]{3}$/;

                    if (!cardNumberRegex.test(cardNumber.replace(/\s/g, ''))) {
                        alert("Số thẻ không hợp lệ. Vui lòng nhập đủ 16 chữ số.");
                        return;
                    }

                    if (!expiryRegex.test(expiryDate)) {
                        alert("Ngày hết hạn không hợp lệ. Vui lòng nhập theo định dạng MM/YY.");
                        return;
                    }

                    // ✅ Kiểm tra ngày hết hạn không được ở hiện tại hoặc quá khứ
                    const [monthStr, yearStr] = expiryDate.split('/');
                    const expMonth = parseInt(monthStr, 10);
                    const expYear = 2000 + parseInt(yearStr, 10);

                    const now = new Date();
                    const currentMonth = now.getMonth() + 1;
                    const currentYear = now.getFullYear();

                    // Nếu năm nhỏ hơn hiện tại → lỗi
                    if (expYear < currentYear) {
                        alert("Thẻ đã hết hạn. Vui lòng kiểm tra lại.");
                        return;
                    }

                    // Nếu cùng năm nhưng tháng nhỏ hơn hoặc bằng tháng hiện tại → lỗi
                    if (expYear === currentYear && expMonth <= currentMonth) {
                        alert("Thẻ đã hết hạn hoặc không hợp lệ (không được là tháng hiện tại).");
                        return;
                    }

                    if (!cvvRegex.test(cvv)) {
                        alert("Mã CVV không hợp lệ. Vui lòng nhập 3 chữ số.");
                        return;
                    }

                    if (cardName.length < 3) {
                        alert("Vui lòng nhập tên chủ thẻ hợp lệ.");
                        return;
                    }

                    alert("Xác nhận thông tin thẻ hợp lệ. Đang xử lý thanh toán...");
                    setTimeout(() => {
                        form.submit();
                    }, 1500);
                }
            });
        </script>

    </body>
</html>


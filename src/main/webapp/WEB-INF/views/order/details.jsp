<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Chi tiết Đơn hàng #${order.orderid} - AISTHÉA</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <script src="https://cdn.tailwindcss.com"></script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    body {
                        font-family: 'Poppins', sans-serif;
                    }

                    .modal {
                        display: none;
                        position: fixed;
                        z-index: 50;
                        inset: 0;
                        background-color: rgba(0, 0, 0, 0.5);
                        justify-content: center;
                        align-items: center;
                    }

                    .modal.active {
                        display: flex;
                    }
                </style>
            </head>

            <body class="bg-gray-100 min-h-screen flex flex-col">

                <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                <div class="container mx-auto max-w-6xl p-4 md:p-8 flex-grow">

                    <%-- ✅ Thông báo đặt hàng thành công --%>
                        <c:if test="${param.success == 'true'}">
                            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-6 rounded-lg shadow-md mb-8"
                                role="alert">
                                <div class="flex">
                                    <div class="py-1"><i class="fa-solid fa-check-circle text-3xl mr-4"></i></div>
                                    <div>
                                        <p class="text-xl font-bold">Đặt hàng thành công!</p>
                                        <p class="text-base">Cảm ơn bạn đã mua sắm tại AISTHÉA. Chúng tôi sẽ xử lý đơn
                                            hàng của bạn trong thời gian sớm nhất.</p>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <h1 class="text-3xl font-bold text-gray-800 mb-8">Chi tiết Đơn hàng #${order.orderid}</h1>

                        <div class="flex flex-col lg:flex-row gap-8 items-start">


                            <%-- 🛒 Cột trái: sản phẩm --%>
                                <div class="w-full lg:w-2/3 bg-white rounded-lg shadow-lg p-6">
                                    <h2 class="text-xl font-semibold text-gray-700 border-b border-gray-200 pb-4 mb-4">
                                        Danh sách sản phẩm</h2>

                                    <div class="space-y-4">
                                        <c:forEach var="item" items="${order.items}">
                                            <div class="flex items-center gap-4 border-b border-gray-100 pb-4">

                                                <img src="${item.imageUrl}" alt="Ảnh sản phẩm"
                                                    class="w-16 h-16 object-cover rounded-md"
                                                    onerror="this.src='https://placehold.co/100x100/eee/ccc?text=No+Image'">

                                                <div class="flex-grow">
                                                    <p class="font-semibold text-gray-800">${item.productName}</p>
                                                    <p class="text-sm text-gray-500">${item.color} / ${item.size}</p>
                                                    <p class="text-sm text-gray-500">Số lượng: ${item.quantity}</p>
                                                </div>

                                                <div class="text-right">
                                                    <p class="font-semibold text-gray-800">
                                                        <fmt:formatNumber value="${item.price}" type="currency"
                                                            currencyCode="VND" maxFractionDigits="0" />
                                                    </p>
                                                    <p class="text-sm text-gray-500">Thành tiền:</p>
                                                    <p class="font-semibold text-gray-600">
                                                        <fmt:formatNumber value="${item.price * item.quantity}"
                                                            type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                    </p>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <%-- 💰 Cột phải: Tóm tắt đơn hàng --%>
                                    <div class="w-full lg:w-1/3">
                                        <div class="bg-white rounded-lg shadow-lg p-6 sticky top-28">
                                            <h2
                                                class="text-xl font-semibold text-gray-700 border-b border-gray-200 pb-4 mb-4">
                                                Tóm tắt đơn hàng</h2>

                                            <div class="space-y-3 mb-4">
                                                <div class="flex justify-between">
                                                    <span class="text-gray-600">Ngày đặt:</span>
                                                    <span class="font-semibold text-gray-800">
                                                        <fmt:formatDate value="${order.createdat}"
                                                            pattern="dd/MM/yyyy" />
                                                    </span>
                                                </div>
                                                <div class="flex justify-between">
                                                    <span class="text-gray-600">Trạng thái:</span>
                                                    <span class="font-semibold text-[#9B774E]">${order.status}</span>
                                                </div>
                                                <div class="flex justify-between">
                                                    <span class="text-gray-600">Phí vận chuyển:</span>
                                                    <span class="font-semibold text-gray-800">Miễn phí</span>
                                                </div>
                                            </div>

                                            <div
                                                class="border-t border-gray-200 pt-4 flex justify-between items-center mb-6">
                                                <span class="text-lg font-bold text-gray-900">Tổng Cộng:</span>
                                                <span class="text-2xl font-bold text-[#9B774E]">
                                                    <fmt:formatNumber value="${order.totalprice}" type="currency"
                                                        currencyCode="VND" maxFractionDigits="0" />
                                                </span>
                                            </div>

                                            <h3
                                                class="text-lg font-semibold text-gray-700 border-b border-gray-200 pb-3 mb-3">
                                                Thông tin khách hàng</h3>

                                            <div class="space-y-2 text-gray-700">
                                                <p><i class="fa-solid fa-user w-5 mr-1"></i> ${order.fullname}</p>
                                                <p><i class="fa-solid fa-phone w-5 mr-1"></i> ${order.phone}</p>
                                                <p><i class="fa-solid fa-envelope w-5 mr-1"></i> ${order.email}</p>
                                                <p><i class="fa-solid fa-location-dot w-5 mr-1"></i> ${order.address}
                                                </p>
                                            </div>

                                            <%-- ✅ Nút HỦY ĐƠN HÀNG (màu nâu, mở modal) --%>
                                                <c:if test="${order.status == 'Pending'}">
                                                    <button type="button" onclick="openCancelModal()"
                                                        class="w-full bg-[#9B774E] hover:bg-[#866545] text-white font-semibold py-3 px-6 rounded-lg transition duration-300 mt-6">
                                                        <i class="fa-solid fa-ban mr-2"></i> Hủy đơn hàng
                                                    </button>
                                                </c:if>

                                                <c:if test="${order.status == 'Completed'}">
                                                    <a href="${pageContext.request.contextPath}/feedback?orderId=${order.orderid}"
                                                        class="block w-full text-center bg-emerald-500 hover:bg-emerald-600 text-white font-semibold px-6 py-3 rounded-lg transition duration-300 mt-6">
                                                        <i class="fa-regular fa-star mr-2"></i> Đánh giá sản phẩm
                                                    </a>
                                                </c:if>

                                                <a href="${pageContext.request.contextPath}/order?action=history"
                                                    class="block w-full text-center bg-gray-200 text-gray-800 font-semibold px-6 py-3 rounded-lg hover:bg-gray-300 transition duration-300 mt-6">
                                                    <i class="fa-solid fa-arrow-left mr-2"></i> Quay lại Lịch sử
                                                </a>
                                        </div>
                                    </div>
                        </div>
                </div>

                <%-- 🟤 Modal chọn lý do hủy đơn hàng --%>
                    <div id="cancelModal" class="modal">
                        <div class="bg-white rounded-lg shadow-xl w-full max-w-md p-6">
                            <h3 class="text-xl font-semibold text-gray-800 mb-4">Lý do bạn muốn hủy đơn hàng</h3>
                            <form id="cancelForm" action="${pageContext.request.contextPath}/order" method="post">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="orderid" value="${order.orderid}">

                                <div class="space-y-2 mb-4">
                                    <label class="flex items-center space-x-2">
                                        <input type="radio" name="reason" value="Đặt nhầm sản phẩm" required
                                            onchange="toggleOtherReason()">
                                        <span>Đặt nhầm sản phẩm</span>
                                    </label>
                                    <label class="flex items-center space-x-2">
                                        <input type="radio" name="reason" value="Thay đổi địa chỉ giao hàng"
                                            onchange="toggleOtherReason()">
                                        <span>Thay đổi địa chỉ giao hàng</span>
                                    </label>
                                    <label class="flex items-center space-x-2">
                                        <input type="radio" name="reason" value="Thời gian giao hàng quá lâu"
                                            onchange="toggleOtherReason()">
                                        <span>Thời gian giao hàng quá lâu</span>
                                    </label>
                                    <label class="flex items-center space-x-2">
                                        <input type="radio" name="reason" value="Tìm thấy giá tốt hơn ở nơi khác"
                                            onchange="toggleOtherReason()">
                                        <span>Tìm thấy giá tốt hơn ở nơi khác</span>
                                    </label>
                                    <label class="flex items-center space-x-2">
                                        <input type="radio" name="reason" value="Khác" id="reasonOther"
                                            onchange="toggleOtherReason()">
                                        <span>Lý do khác</span>
                                    </label>
                                </div>

                                <%-- ✅ Ô nhập lý do khác (ẩn mặc định) --%>
                                    <div id="otherReasonBox" class="hidden mb-4">
                                        <textarea name="otherReasonText" rows="3"
                                            class="w-full border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-[#9B774E]"
                                            placeholder="Vui lòng nhập lý do của bạn..."></textarea>
                                    </div>

                                    <div class="flex justify-end gap-3 mt-6">
                                        <button type="button" onclick="closeCancelModal()"
                                            class="px-5 py-2 rounded-lg bg-gray-200 text-gray-800 hover:bg-gray-300 transition">
                                            Quay lại
                                        </button>
                                        <button type="submit"
                                            class="px-5 py-2 rounded-lg bg-[#9B774E] text-white hover:bg-[#866545] transition">
                                            Xác nhận hủy
                                        </button>
                                    </div>
                            </form>
                        </div>
                    </div>

                    <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                    <script>
                        const modal = document.getElementById("cancelModal");
                        const otherBox = document.getElementById("otherReasonBox");

                        function openCancelModal() {
                            modal.classList.add("active");
                        }

                        function closeCancelModal() {
                            modal.classList.remove("active");
                        }

                        function toggleOtherReason() {
                            const selected = document.querySelector('input[name="reason"]:checked');
                            if (selected && selected.value === "Khác") {
                                otherBox.classList.remove("hidden");
                            } else {
                                otherBox.classList.add("hidden");
                            }
                        }

                        // Khi bấm Back -> quay về lịch sử
                        if (window.history && window.history.pushState) {
                            window.history.pushState(null, null, window.location.href);
                            window.onpopstate = function () {
                                window.location.href = "${pageContext.request.contextPath}/order?action=history";
                            };
                        }
                    </script>

            </body>

            </html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
            }
            .btn-brown {
                background-color: #8B4513;
                color: white;
                transition: all 0.3s;
            }
            .btn-brown:hover {
                background-color: #A0522D;
            }
            .text-brown {
                color: #8B4513;
            }
            input[type=number]::-webkit-inner-spin-button,
            input[type=number]::-webkit-outer-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }
            input[type=number] {
                -moz-appearance: textfield;
            }
        </style>
    </head>
    <body class="bg-gray-100">

        <jsp:include page="/views/shared/header.jsp" />

        <div class="container mx-auto max-w-6xl p-4 md:p-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-8">Giỏ Hàng Của Bạn</h1>

            <c:if test="${not empty sessionScope.error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline"><i class="fa-solid fa-triangle-exclamation mr-2"></i>${sessionScope.error}</span>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <c:choose>
                <c:when test="${empty sessionScope.cart or sessionScope.cart.isEmpty()}">
                    <div class="bg-white p-12 rounded-lg shadow-lg text-center">
                        <div class="text-gray-300 mb-4"><i class="fa-solid fa-cart-shopping text-6xl"></i></div>
                        <h2 class="text-2xl font-semibold text-gray-700 mb-2">Giỏ hàng trống</h2>
                        <p class="text-gray-500 mb-6">Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                        <a href="${pageContext.request.contextPath}/views/homepage.jsp" 
                           class="inline-block btn-brown font-semibold px-6 py-3 rounded-lg shadow-md">
                            Tiếp tục mua sắm
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="flex flex-col lg:flex-row gap-8">
                        <div class="w-full lg:w-2/3 bg-white rounded-lg shadow-lg overflow-hidden">
                            <div class="p-6 border-b border-gray-200 flex justify-between items-center">
                                <h2 class="text-xl font-semibold text-gray-700">Sản phẩm (${sessionScope.cart.totalQuantity})</h2>
                            </div>

                            <div id="cart-items" class="divide-y divide-gray-200">
                                <c:forEach var="item" items="${sessionScope.cart.items}">
                                    <div class="flex flex-col sm:flex-row items-center p-6 gap-6 cart-item transition hover:bg-gray-50">
                                        <div class="w-24 h-24 flex-shrink-0 border border-gray-200 rounded-md overflow-hidden">
                                            <img src="${item.productImageUrl}" alt="${item.productName}" class="w-full h-full object-cover">
                                        </div>

                                        <div class="flex-grow text-center sm:text-left w-full sm:w-auto">
                                            <h3 class="text-lg font-semibold text-gray-800 mb-1">
                                                <a href="${pageContext.request.contextPath}/product?action=view&id=${item.productId}" class="hover:text-[#8B4513] transition">
                                                    ${item.productName}
                                                </a>
                                            </h3>
                                            <div class="text-sm text-gray-500 mb-2">
                                                <span class="bg-gray-100 px-2 py-1 rounded text-xs font-medium mr-2">Màu: ${item.color}</span>
                                                <span class="bg-gray-100 px-2 py-1 rounded text-xs font-medium">Size: ${item.size}</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/cart?action=remove&id=${item.productColorSizeId}" 
                                               class="text-red-500 hover:text-red-700 text-sm inline-flex items-center gap-1 transition"
                                               onclick="return confirm('Xóa sản phẩm này khỏi giỏ hàng?')">
                                                <i class="fa-regular fa-trash-can"></i> Xóa
                                            </a>
                                        </div>

                                        <form action="${pageContext.request.contextPath}/cart" method="POST" class="flex items-center">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="id" value="${item.productColorSizeId}">

                                            <div class="flex flex-col items-center">
                                                <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden">
                                                    <button type="button" onclick="decreaseQty(this)" 
                                                            class="w-8 h-8 flex items-center justify-center bg-gray-50 hover:bg-gray-200 text-gray-600 transition">
                                                        <i class="fa-solid fa-minus text-xs"></i>
                                                    </button>

                                                    <input type="number" name="quantity" value="${item.quantity}" min="1"
                                                           class="w-12 h-8 text-center border-x border-gray-300 text-gray-700 font-medium focus:outline-none m-0 quantity-input"
                                                           onchange="this.form.submit()">

                                                    <button type="button" onclick="increaseQty(this)" 
                                                            class="w-8 h-8 flex items-center justify-center bg-gray-50 hover:bg-gray-200 text-gray-600 transition">
                                                        <i class="fa-solid fa-plus text-xs"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </form>

                                        <div class="text-right min-w-[100px]">
                                            <span class="block text-lg font-bold text-gray-800">
                                                <fmt:formatNumber value="${item.subtotal}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                            </span>
                                            <span class="block text-xs text-gray-400 font-light">
                                                <fmt:formatNumber value="${item.price}" type="number"/> đ / cái
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="w-full lg:w-1/3">
                            <div class="bg-white rounded-lg shadow-lg p-6 sticky top-8">
                                <h2 class="text-xl font-semibold text-gray-700 border-b border-gray-200 pb-4 mb-4">Tóm Tắt Đơn Hàng</h2>
                                <div class="space-y-3 mb-6">
                                    <div class="flex justify-between text-gray-600">
                                        <span>Tạm tính:</span>
                                        <span><fmt:formatNumber value="${sessionScope.cart.totalPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/></span>
                                    </div>
                                    <div class="flex justify-between text-gray-600">
                                        <span>Phí vận chuyển:</span>
                                        <span class="text-green-600 font-medium">Miễn phí</span>
                                    </div>
                                </div>
                                <div class="border-t border-gray-200 pt-4 flex justify-between items-center mb-6">
                                    <span class="text-lg font-bold text-gray-800">Tổng cộng:</span>
                                    <span class="text-2xl font-bold text-[#8B4513]">
                                        <fmt:formatNumber value="${sessionScope.cart.totalPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                    </span>
                                </div>
                                <a href="${pageContext.request.contextPath}/views/cart/checkout.jsp" 
                                   class="block w-full text-center btn-brown font-bold text-lg px-6 py-4 rounded-lg shadow-lg transform hover:-translate-y-0.5 transition duration-200">
                                    Tiến Hành Thanh Toán
                                </a>
                                <a href="${pageContext.request.contextPath}/views/homepage.jsp" 
                                   class="block w-full text-center text-gray-500 hover:text-[#8B4513] text-sm mt-4 underline transition">
                                    <i class="fa-solid fa-arrow-left mr-1"></i> Tiếp tục mua sắm
                                </a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="/views/shared/footer.jsp" />

        <script>
            function decreaseQty(btn) {
                const input = btn.nextElementSibling;
                let value = parseInt(input.value);
                if (value > 1) {
                    input.value = value - 1;
                    input.form.submit();
                }
            }

            function increaseQty(btn) {
                const input = btn.previousElementSibling;
                let value = parseInt(input.value);
                if (!isNaN(value)) {
                    input.value = value + 1;
                    input.form.submit();
                }
            }
        </script>
    </body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Giỏ hàng - AISTHÉA</title>

                <!-- Fonts (same as product-list-page) -->
                <link href="https://fonts.googleapis.com" rel="preconnect">
                <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
                <link
                    href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600;700&amp;family=Playfair+Display:wght@400;600;700&amp;display=swap"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                    rel="stylesheet">

                <!-- Font Awesome (for header icons) -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

                <!-- Tailwind -->
                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <script id="tailwind-config">
                    tailwind.config = {
                        darkMode: "class",
                        theme: {
                            extend: {
                                colors: {
                                    "primary": "#024acf",
                                    "primary-light": "#0288D1",
                                },
                                fontFamily: {
                                    "display": ["Manrope", "sans-serif"],
                                    "serif": ["Playfair Display", "serif"]
                                },
                            },
                        },
                    }
                </script>

                <style>
                    body {
                        font-family: 'Manrope', sans-serif;
                        background: #f9fafb;
                    }

                    /* ===== HEADER DEPENDENCIES (product-list-header.jsp) ===== */
                    .glass-panel {
                        background: rgba(255, 255, 255, 0.92);
                        -webkit-backdrop-filter: blur(12px);
                        backdrop-filter: blur(12px);
                        border: 1px solid rgba(255, 255, 255, 0.5);
                        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
                    }

                    .right {
                        display: flex;
                        align-items: center;
                        gap: 18px;
                    }

                    .icon-btn {
                        font-size: 20px;
                        color: #64748b;
                        cursor: pointer;
                        padding: 8px;
                        border-radius: 8px;
                        text-decoration: none;
                        transition: color 0.2s, transform 0.2s;
                    }

                    .icon-btn:hover {
                        color: #024acf;
                        transform: translateY(-2px);
                    }

                    /* ===== CART PAGE STYLES ===== */
                    .btn-brown {
                        background-color: #8B4513;
                        color: white;
                        transition: all 0.3s;
                    }

                    .btn-brown:hover {
                        background-color: #A0522D;
                        transform: translateY(-1px);
                    }

                    /* Xóa mũi tên input number */
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

            <body class="bg-gray-50">

                <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                <main class="container mx-auto max-w-6xl p-4 md:p-8 min-h-[70vh]">
                    <nav class="flex items-center gap-2 mb-6 text-sm text-gray-500">
                        <a class="hover:text-[#8B4513]" href="${pageContext.request.contextPath}/">Trang chủ</a>
                        <i class="fa-solid fa-chevron-right text-[10px]"></i>
                        <span class="font-semibold text-gray-800">Giỏ hàng</span>
                    </nav>


                    <%-- Thông báo lỗi nếu có --%>
                        <c:if test="${not empty sessionScope.error}">
                            <div
                                class="bg-red-50 border-l-4 border-red-500 text-red-700 px-4 py-3 rounded shadow-sm mb-6 flex items-center gap-3">
                                <i class="fa-solid fa-circle-exclamation text-lg"></i>
                                <span>${sessionScope.error}</span>
                            </div>
                            <c:remove var="error" scope="session" />
                        </c:if>

                        <c:choose>
                            <%-- Trường hợp giỏ hàng trống --%>
                                <c:when test="${empty sessionScope.cart or sessionScope.cart.items.isEmpty()}">
                                    <div class="bg-white p-16 rounded-2xl shadow-sm border border-gray-100 text-center">
                                        <div
                                            class="inline-flex items-center justify-center w-24 h-24 bg-gray-50 rounded-full text-gray-300 mb-6">
                                            <i class="fa-solid fa-cart-shopping text-4xl"></i>
                                        </div>
                                        <h2 class="text-2xl font-bold text-gray-800 mb-2">Giỏ hàng đang trống</h2>
                                        <p class="text-gray-500 mb-8">Có vẻ như bạn chưa thêm sản phẩm nào vào giỏ hàng
                                            của mình.</p>
                                        <a href="${pageContext.request.contextPath}/"
                                            class="btn-brown font-bold px-8 py-3 rounded-xl shadow-lg shadow-brown-500/20 inline-block">
                                            Khám phá ngay
                                        </a>
                                    </div>
                                </c:when>

                                <%-- Có sản phẩm trong giỏ --%>
                                    <c:otherwise>
                                        <div class="flex flex-col lg:flex-row gap-10">
                                            <div class="w-full lg:w-2/3 space-y-4">
                                                <div
                                                    class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                                                    <div class="p-5 border-b border-gray-50 bg-gray-50/50">
                                                        <h2 class="font-bold text-gray-700 flex items-center gap-2">
                                                            Sản phẩm <span
                                                                class="bg-gray-200 text-gray-600 text-xs px-2 py-0.5 rounded-full">${sessionScope.cart.totalQuantity}</span>
                                                        </h2>
                                                    </div>

                                                    <div class="divide-y divide-gray-100">
                                                        <c:forEach var="item" items="${sessionScope.cart.items}">
                                                            <div
                                                                class="p-6 flex flex-col sm:flex-row gap-6 items-center">
                                                                <div
                                                                    class="w-28 h-36 bg-gray-100 rounded-xl overflow-hidden shrink-0 shadow-sm border border-gray-50">
                                                                    <img src="${item.productImageUrl}"
                                                                        alt="${item.productName}"
                                                                        class="w-full h-full object-cover">
                                                                </div>

                                                                <div
                                                                    class="flex-grow text-center sm:text-left space-y-2">
                                                                    <h3
                                                                        class="text-lg font-bold text-gray-800 leading-tight">
                                                                        <a href="${pageContext.request.contextPath}/product?action=view&id=${item.productId}"
                                                                            class="hover:text-[#8B4513] transition">
                                                                            ${item.productName}
                                                                        </a>
                                                                    </h3>
                                                                    <div
                                                                        class="flex flex-wrap justify-center sm:justify-start gap-2">
                                                                        <span
                                                                            class="text-[11px] font-bold uppercase tracking-wider bg-gray-100 text-gray-500 px-2 py-1 rounded">Màu:
                                                                            ${item.color}</span>
                                                                        <span
                                                                            class="text-[11px] font-bold uppercase tracking-wider bg-gray-100 text-gray-500 px-2 py-1 rounded">Size:
                                                                            ${item.size}</span>
                                                                    </div>
                                                                    <a href="${pageContext.request.contextPath}/cart?action=remove&id=${item.productColorSizeId}"
                                                                        class="text-gray-400 hover:text-red-500 text-sm inline-flex items-center gap-1.5 transition pt-2"
                                                                        <i class="fa-regular fa-trash-can"></i>
                                                                        <span>Xóa</span>
                                                                    </a>
                                                                </div>

                                                                <div
                                                                    class="flex flex-col items-center sm:items-end gap-4 min-w-[140px]">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/cart"
                                                                        method="POST">
                                                                        <input type="hidden" name="action"
                                                                            value="update">
                                                                        <input type="hidden" name="id"
                                                                            value="${item.productColorSizeId}">

                                                                        <div
                                                                            class="flex items-center bg-gray-100 rounded-lg p-1 border border-gray-200">
                                                                            <button type="button"
                                                                                onclick="decreaseQty(this)"
                                                                                class="w-8 h-8 flex items-center justify-center hover:bg-white rounded-md transition text-gray-600 shadow-sm shadow-transparent hover:shadow-gray-200">
                                                                                <i
                                                                                    class="fa-solid fa-minus text-[10px]"></i>
                                                                            </button>
                                                                            <input type="number" name="quantity"
                                                                                value="${item.quantity}" min="1" class="w-10 bg-transparent text-center font-bold text-gray-800
                                                               border-0 outline-none focus:outline-none focus:ring-0
                                                               quantity-input" onchange="this.form.submit()">
                                                                            <button type="button"
                                                                                onclick="increaseQty(this)"
                                                                                class="w-8 h-8 flex items-center justify-center hover:bg-white rounded-md transition text-gray-600 shadow-sm shadow-transparent hover:shadow-gray-200">
                                                                                <i
                                                                                    class="fa-solid fa-plus text-[10px]"></i>
                                                                            </button>
                                                                        </div>
                                                                    </form>
                                                                    <div class="text-right">
                                                                        <p class="text-xl font-black text-gray-900">
                                                                            <fmt:formatNumber value="${item.subtotal}"
                                                                                type="currency" currencyCode="VND"
                                                                                maxFractionDigits="0" />
                                                                        </p>
                                                                        <p class="text-xs text-gray-400">
                                                                            <fmt:formatNumber value="${item.price}"
                                                                                type="number" />đ / sản phẩm
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>

                                                <a href="${pageContext.request.contextPath}/"
                                                    class="inline-flex items-center gap-2 text-sm font-bold text-gray-500 hover:text-[#8B4513] transition">
                                                    <i class="fa-solid fa-arrow-left"></i> Tiếp tục mua sắm
                                                </a>
                                            </div>

                                            <div class="w-full lg:w-1/3">
                                                <div
                                                    class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8 sticky top-24">
                                                    <h2
                                                        class="text-xl font-black text-gray-800 mb-6 pb-4 border-b border-gray-50">
                                                        Tóm tắt đơn hàng</h2>

                                                    <div class="space-y-4 mb-8">
                                                        <div class="flex justify-between text-gray-500 font-medium">
                                                            <span>Tạm tính</span>
                                                            <span class="text-gray-800">
                                                                <fmt:formatNumber
                                                                    value="${sessionScope.cart.totalPrice}"
                                                                    type="currency" currencyCode="VND"
                                                                    maxFractionDigits="0" />
                                                            </span>
                                                        </div>
                                                        <div class="flex justify-between text-gray-500 font-medium">
                                                            <span>Phí vận chuyển</span>
                                                            <span class="text-green-600 font-bold">Miễn phí</span>
                                                        </div>
                                                        <div
                                                            class="pt-4 border-t border-gray-50 flex justify-between items-end">
                                                            <span class="font-bold text-gray-800 text-lg">Tổng
                                                                cộng</span>
                                                            <div class="text-right">
                                                                <p class="text-2xl font-black text-[#8B4513]">
                                                                    <fmt:formatNumber
                                                                        value="${sessionScope.cart.totalPrice}"
                                                                        type="currency" currencyCode="VND"
                                                                        maxFractionDigits="0" />
                                                                </p>
                                                                <p
                                                                    class="text-[10px] text-gray-400 uppercase tracking-widest font-bold">
                                                                    Đã bao gồm thuế VAT</p>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <a href="${pageContext.request.contextPath}/cart?action=checkout"
                                                        class="block w-full text-center hover:bg-[#137fec] bg-[#3182ce] text-white font-black text-lg px-6 py-4 rounded-xl shadow-xl transform hover:-translate-y-1 transition-all duration-300">
                                                        Tiến hành thanh toán <i
                                                            class="fa-solid fa-arrow-right ml-2"></i>
                                                    </a>

                                                    <div
                                                        class="mt-8 flex items-center justify-center gap-6 opacity-40 grayscale">
                                                        <i class="fa-brands fa-cc-visa text-2xl"></i>
                                                        <i class="fa-brands fa-cc-mastercard text-2xl"></i>
                                                        <i class="fa-solid fa-wallet text-2xl"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                        </c:choose>
                </main>

                <%-- Footer của fen đây --%>
                    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

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
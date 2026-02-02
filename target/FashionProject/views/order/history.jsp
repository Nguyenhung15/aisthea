<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử Đơn hàng - AISTHÉA</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">

    <jsp:include page="/views/shared/header.jsp" />

    <div class="container mx-auto max-w-6xl p-4 md:p-8 flex-grow">
        <h1 class="text-3xl font-bold text-gray-800 mb-8">Lịch sử Đơn hàng</h1>

        <c:choose>
            <%-- TRƯỜNG HỢP 1: KHÔNG CÓ ĐƠN HÀNG --%>
            <c:when test="${empty orderList}">
                <div class="bg-white rounded-lg shadow-lg p-12 text-center">
                    <i class="fa-solid fa-box-open text-6xl text-gray-300 mb-6"></i>
                    <h2 class="text-2xl font-semibold text-gray-700 mb-2">Bạn chưa có đơn hàng nào</h2>
                    <p class="text-gray-500 mb-6">Hãy bắt đầu mua sắm để lấp đầy giỏ hàng của bạn nhé!</p>
                    <a href="${pageContext.request.contextPath}/views/homepage.jsp" 
                       class="inline-block bg-[#9B774E] text-white font-semibold px-6 py-3 rounded-lg shadow-md hover:bg-[#8a6944] transition duration-300">
                        Tiếp tục mua sắm
                    </a>
                </div>
            </c:when>

            <%-- TRƯỜNG HỢP 2: CÓ ĐƠN HÀNG --%>
            <c:otherwise>
                <div class="space-y-6">
                    <c:forEach var="order" items="${orderList}">
                        <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                            <div class="p-6">
                                <div class="flex flex-col md:flex-row justify-between md:items-center border-b border-gray-200 pb-4 mb-4">
                                    <div>
                                        <p class="text-lg font-bold text-gray-900">Đơn hàng #${order.orderid}</p>
                                        <p class="text-sm text-gray-500">
                                            Ngày đặt: <fmt:formatDate value="${order.createdat}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </div>
                                    <div class="mt-4 md:mt-0 md:text-right">
                                        <a href="${pageContext.request.contextPath}/order?action=view&id=${order.orderid}" 
                                           class="inline-block bg-[#9B774E] text-white font-semibold px-5 py-2 rounded-lg shadow-md hover:bg-[#8a6944] transition duration-300 text-sm">
                                            Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="flex justify-between items-center">
                                    <div>
                                        <p class="text-gray-600">Trạng thái:</p>
                                        <p class="font-semibold text-lg">
                                            <c:choose>
                                                <c:when test="${order.status == 'Pending'}">
                                                    <span class="px-3 py-1 text-sm font-bold rounded-full bg-yellow-100 text-yellow-800">
                                                        <i class="fa-solid fa-clock-rotate-left mr-1"></i> Chờ xử lý
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.status == 'Shipped'}">
                                                    <span class="px-3 py-1 text-sm font-bold rounded-full bg-blue-100 text-blue-800">
                                                        <i class="fa-solid fa-truck mr-1"></i> Đang giao
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.status == 'Completed'}">
                                                    <span class="px-3 py-1 text-sm font-bold rounded-full bg-green-100 text-green-800">
                                                        <i class="fa-solid fa-check-circle mr-1"></i> Hoàn thành
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.status == 'Cancelled'}">
                                                    <span class="px-3 py-1 text-sm font-bold rounded-full bg-red-100 text-red-800">
                                                        <i class="fa-solid fa-times-circle mr-1"></i> Đã hủy
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-3 py-1 text-sm font-bold rounded-full bg-gray-100 text-gray-800">
                                                        ${order.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-gray-600">Tổng tiền:</p>
                                        <p class="text-xl font-bold text-[#9B774E]">
                                            <fmt:formatNumber value="${order.totalprice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                        </t:formatNumber>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <jsp:include page="/views/shared/footer.jsp" />

</body>
</html>
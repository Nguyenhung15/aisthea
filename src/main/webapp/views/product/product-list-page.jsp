<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <%-- Đặt tiêu đề động: Nếu đang ở danh mục thì hiển thị tên, nếu không thì hiển thị chung --%>
        <c:choose>
            <c:when test="${not empty displayCategory}">
                <title>AISTHÉA - ${displayCategory.name}</title>
            </c:when>
            <c:otherwise>
                <title>AISTHÉA - Danh sách Sản phẩm</title>
            </c:otherwise>
        </c:choose>

        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f9f7f4;
            }
            .profile-card {
                border: 1px solid #d9c2a3;
                background-color: #fffdfb;
                transition: all 0.3s ease;
            }
            .profile-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(139, 94, 60, 0.15);
            }
            .profile-image {
                background-size: cover;
                background-position: center;
                transition: all 0.3s ease;
            }
            .btn-brown {
                border: 1px solid #8B5E3C;
                color: #8B5E3C;
            }
            .btn-brown:hover {
                background-color: #8B5E3C;
                color: white;
            }

            /* === CSS CHO BREADCRUMB MÀ BẠN YÊU CẦU === */
            .breadcrumb {
                background:#fff;
                padding:15px 5%;
                margin-top:0;
                font-size:14px;
                color:#555;
                border-bottom: 1px solid #eee;
            }
            .breadcrumb a {
                color:#555;
                text-decoration:none;
            }
            .breadcrumb a:hover {
                text-decoration: underline;
            }
            .breadcrumb span {
                font-weight:600;
                color:#111;
            }
            /* ========================================= */

        </style>
    </head>
    <body class="bg-[#f9f7f4] font-sans">

        <jsp:include page="/views/shared/header.jsp" />

        <div class="breadcrumb">
            <div style="max-width:1200px; margin:0 auto;">
                <a href="${pageContext.request.contextPath}/views/homepage.jsp">Home</a> &gt;

                <%-- 
                    Chỉ hiển thị tên danh mục nếu nó tồn tại (tức là khi lọc).
                    'displayCategory' được gửi từ 'ProductServlet'.
                --%>
                <c:if test="${not empty displayCategory}">
                    <span>${displayCategory.name}</span>
                </c:if>
                <c:if test="${empty displayCategory}">
                    <span>Tất cả sản phẩm</span>
                </c:if>
            </div>
        </div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">

            <c:choose>
                <%-- TRƯỜNG HỢP 1: KHÔNG TÌM THẤY SẢN PHẨM --%>
                <c:when test="${empty productList}">
                    <div class="text-center py-20">
                        <h2 class="text-3xl font-semibold text-gray-700">Không tìm thấy sản phẩm</h2>
                        <p class="text-gray-500 mt-2">Vui lòng thử lại với danh mục khác.</p>
                        <a href="${pageContext.request.contextPath}/views/homepage.jsp" 
                           class="mt-6 inline-block bg-[#8B5E3C] hover:bg-[#734C30] text-white px-5 py-2 rounded-md transition">
                            Quay về Trang chủ
                        </a>
                    </div>
                </c:when>

                <%-- TRƯỜNG HỢP 2: CÓ SẢN PHẨM, HIỂN THỊ DANH SÁCH --%>
                <c:otherwise>
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">

                        <%-- Vòng lặp sản phẩm --%>
                        <c:forEach var="product" items="${productList}">

                            <%-- Logic tìm ảnh chính (primary image) --%>
                            <c:set var="primaryImgUrl" value="https://placehold.co/600x600/eee/ccc?text=No+Image" />
                            <c:if test="${not empty product.images}">
                                <c:set var="foundPrimary" value="false" />
                                <c:forEach var="img" items="${product.images}">
                                    <c:if test="${img.primary and not foundPrimary}">
                                        <c:set var="primaryImgUrl" value="${img.imageUrl}" />
                                        <c:set var="foundPrimary" value="true" />
                                    </c:if>
                                </c:forEach>
                                <c:if test="${not foundPrimary and not empty product.images[0]}">
                                    <c:set var="primaryImgUrl" value="${product.images[0].imageUrl}" />
                                </c:if>
                            </c:if>

                            <%-- Thẻ sản phẩm --%>
                            <div class="profile-card rounded-lg overflow-hidden flex flex-col">

                                <a href="${pageContext.request.contextPath}/product?action=view&id=${product.productId}">
                                    <div class="relative">
                                        <div class="w-full h-96 bg-white flex items-center justify-center overflow-hidden">
                                            <img src="${primaryImgUrl}" 
                                                 onerror="this.src='https://placehold.co/600x600/eee/ccc?text=No+Image'"
                                                 class="profile-image h-96 w-full object-cover object-center transition-all duration-300 hover:scale-105" 
                                                 alt="${product.name}">
                                        </div>
                                    </div>
                                </a>

                                <div class="p-5 border-t border-[#d9c2a3] text-center">
                                    <h3 class="text-base font-semibold text-[#3b2a1a] uppercase tracking-wide mb-2 line-clamp-1">
                                        ${product.name}
                                    </h3>
                                    <p class="text-[#5b4631] text-sm mb-4 font-medium">
                                        <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>₫
                                    </p>
                                    <a href="${pageContext.request.contextPath}/product?action=view&id=${product.productId}" 
                                       class="btn-brown inline-block px-4 py-1.5 rounded-md text-xs tracking-wider uppercase transition-all duration-300">
                                        Xem chi tiết
                                    </a>
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
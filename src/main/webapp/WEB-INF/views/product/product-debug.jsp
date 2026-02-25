<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Product Debug</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        padding: 20px;
                    }

                    .product-card {
                        border: 2px solid #333;
                        padding: 10px;
                        margin: 10px;
                        display: inline-block;
                        width: 200px;
                        vertical-align: top;
                        background: #f0f0f0;
                    }

                    .product-card img {
                        width: 100%;
                        height: 150px;
                        object-fit: cover;
                    }

                    h1 {
                        color: red;
                    }

                    .count {
                        font-size: 20px;
                        color: blue;
                        font-weight: bold;
                    }
                </style>
            </head>

            <body>
                <h1>PRODUCT DEBUG PAGE</h1>
                <p class="count">Total products in list: ${fn:length(productList)}</p>
                <p>Categories count: ${fn:length(categories)}</p>
                <hr>

                <c:if test="${empty productList}">
                    <p style="color: red; font-size: 24px;">ERROR: productList is NULL or EMPTY!</p>
                </c:if>

                <c:forEach items="${productList}" var="p" varStatus="status">
                    <div class="product-card">
                        <p><strong>#${status.index + 1}</strong> ID: ${p.productId}</p>
                        <p><strong>${p.name}</strong></p>
                        <p>Price: ${p.price}</p>
                        <p>Images: ${fn:length(p.images)}</p>
                        <c:if test="${not empty p.images and fn:length(p.images) > 0}">
                            <img src="${p.images[0].imageUrl}" alt="${p.name}"
                                onerror="this.onerror=null; this.src=''; this.alt='NO IMG'" />
                            <p style="font-size:10px; word-break:break-all;">${p.images[0].imageUrl}</p>
                        </c:if>
                        <c:if test="${empty p.images or fn:length(p.images) == 0}">
                            <p style="color:orange;">No images</p>
                        </c:if>
                    </div>
                </c:forEach>

                <hr>
                <p>END OF LIST</p>
            </body>

            </html>
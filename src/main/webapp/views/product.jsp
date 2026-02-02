<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aisthea.fashion.model.Product" %>
<%
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect("home");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= product.getName() %> - Aisthéa Fashion</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <!-- Hình ảnh sản phẩm -->
            <div class="col-md-6">
                <img src="<%= product.getImageUrl() %>" class="img-fluid rounded" alt="<%= product.getName() %>">
            </div>

            <!-- Thông tin chi tiết -->
            <div class="col-md-6">
                <h2><%= product.getName() %></h2>
                <p class="text-muted"><%= product.getBrand() != null ? product.getBrand() : "" %></p>

                <% if (product.getDiscount() > 0) { %>
                    <p>
                        <span class="text-danger fw-bold fs-4">
                            $<%= product.getPrice().doubleValue() * (1 - product.getDiscount()/100) %>
                        </span>
                        <span class="text-secondary text-decoration-line-through">
                            $<%= product.getPrice() %>
                        </span>
                        <span class="badge bg-danger">-<%= product.getDiscount() %>%</span>
                    </p>
                <% } else { %>
                    <p class="fs-4 fw-bold">$<%= product.getPrice() %></p>
                <% } %>

                <p><strong>Màu sắc:</strong> <%= product.getColor() %></p>
                <p><strong>Kích cỡ:</strong> <%= product.getSize() %></p>
                <p><strong>Tồn kho:</strong> <%= product.getStock() %></p>
                <p><%= product.getDescription() %></p>

                <form action="cart" method="post" class="mt-3">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="id" value="<%= product.getProductId() %>">
                    <div class="mb-3">
                        <label for="qty">Số lượng:</label>
                        <input type="number" id="qty" name="quantity" value="1" min="1" max="<%= product.getStock() %>" class="form-control w-25">
                    </div>
                    <button type="submit" class="btn btn-dark">
                        🛒 Thêm vào giỏ hàng
                    </button>
                </form>
            </div>
        </div>
    </div>
                    <script src="assets/js/main.js"></script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>AISTHÉA | ${product.name}</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }
            body {
                background-color: #f9f9f9;
            }
            .container {
                width: 90%;
                max-width: 1200px;
                margin: 40px auto;
                display: flex;
                flex-direction: row;
                gap: 50px;
                align-items: flex-start;
                background: #fff;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            }
            .images {
                flex: 1;
            }
            .details {
                flex: 1.2;
                display: flex;
                flex-direction: column;
                gap: 18px;
            }
            .main-image {
                width: 100%;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                aspect-ratio: 1 / 1;
                object-fit: cover;
            }
            .thumbnails {
                display: flex;
                gap: 15px;
                margin-top: 15px;
                flex-wrap: wrap;
            }
            .thumbnails img {
                width: 80px;
                height: 80px;
                border-radius: 10px;
                cursor: pointer;
                border: 2px solid #eee;
                transition: 0.3s;
                object-fit: cover;
            }
            .thumbnails img:hover, .thumbnails img.active {
                border-color: #8B4513;
                opacity: 1;
            }
            .thumbnails img:not(.active) {
                opacity: 0.7;
            }
            .details h1 {
                font-size: 28px;
                font-weight: 700;
                color: #111;
            }
            .price {
                font-size: 20px;
                color: #8B4513;
                font-weight: 700;
            }
            .old-price {
                color: #999;
                text-decoration: line-through;
                margin-left: 10px;
                font-weight: 500;
            }
            .description {
                line-height: 1.6;
                color: #555;
            }
            .option-group {
                margin-top: 10px;
            }
            .option-group label {
                font-weight: 600;
                display: block;
                margin-bottom: 8px;
                color: #374151;
            }
            .colors, .sizes {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }
            .color-btn {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                border: 2px solid #ddd;
                cursor: pointer;
                transition: 0.2s;
                position: relative;
            }
            .color-btn.active, .color-btn:hover {
                border-color: #8B4513;
                transform: scale(1.1);
            }
            .color-btn[data-color="White"], .color-btn[data-color="Trắng"] {
                box-shadow: inset 0 0 0 1px #ccc;
            }
            .size-btn {
                padding: 8px 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                background: #fff;
                cursor: pointer;
                transition: 0.2s;
                font-weight: 600;
            }
            .size-btn:hover, .size-btn.active {
                border-color: #8B4513;
                background: #8B4513;
                color: #F5DEB3;
            }
            .size-btn:disabled {
                background: #f5f5f5;
                color: #ccc;
                border-color: #eee;
                cursor: not-allowed;
            }
            .buttons {
                margin-top: 25px;
                display: flex;
                gap: 15px;
            }
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: 0.3s;
                font-size: 15px;
                flex-grow: 1;
            }
            .btn-cart {
                background: #8B4513;
                color: #F5DEB3;
                border: 2px solid #8B4513;
            }
            .btn-cart:hover {
                background: #A0522D;
                color: #fff;
            }
            .btn-buy {
                background: #8B4513;
                color: #F5DEB3;
            }
            .btn-buy:hover {
                background: #A0522D;
                color: #fff;
            }
            .btn:disabled {
                background: #e9ecef;
                border-color: #e9ecef;
                color: #adb5bd;
                cursor: not-allowed;
            }

            input[type=number]::-webkit-inner-spin-button,
            input[type=number]::-webkit-outer-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }
            input[type=number] {
                -moz-appearance: textfield;
            }

            .breadcrumb {
                background:#fff;
                padding:15px 5%;
                margin-top:0;
                font-size:14px;
                color:#555;
                border-bottom: 1px solid #eee;
            }
            .feedback-section {
                width: 90%;
                max-width: 1200px;
                margin: 40px auto;
                background: #fff;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            }
            .feedback-section h2 {
                font-size: 22px;
                margin-bottom: 20px;
                font-weight: 700;
            }
            .review {
                border-top: 1px solid #eee;
                padding: 15px 0;
            }
            .review:first-of-type {
                border-top: none;
            }
            .review h4 {
                margin-bottom: 5px;
                font-weight: 600;
            }
            .stars {
                color: #ffb400;
                margin-bottom: 5px;
            }

            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                    margin: 20px auto;
                    gap: 30px;
                    padding: 20px;
                }
                .details h1 {
                    font-size: 24px;
                }
                .price {
                    font-size: 18px;
                }
                .buttons {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>

        <jsp:include page="/views/shared/header.jsp" />

        <c:set var="primaryImgUrl" value="https://placehold.co/600x600/eee/ccc?text=No+Image" />
        <c:if test="${not empty images}">
            <c:set var="foundPrimary" value="false" />
            <c:forEach var="img" items="${images}">
                <c:if test="${img.primary and not foundPrimary}">
                    <c:set var="primaryImgUrl" value="${img.imageUrl}" />
                    <c:set var="foundPrimary" value="true" />
                </c:if>
            </c:forEach>
            <c:if test="${not foundPrimary and not empty images[0]}">
                <c:set var="primaryImgUrl" value="${images[0].imageUrl}" />
            </c:if>
        </c:if>

        <div class="breadcrumb">
            <div style="max-width:1200px; margin:0 auto;">
                <a href="${pageContext.request.contextPath}/views/homepage.jsp" style="color:#555; text-decoration:none;">Home</a> &gt;
                <a href="${pageContext.request.contextPath}/product?action=list&categoryIndex=${product.category.indexName}&genderid=${product.category.genderid}" 
                   style="color:#555; text-decoration:none;">
                    ${product.category.name}
                </a> &gt;
                <span style="font-weight:600; color:#111;">${product.name}</span>
            </div>
        </div>

        <form id="cartForm" action="${pageContext.request.contextPath}/cart" method="POST">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="${product.productId}">
            <input type="hidden" name="productName" value="${product.name}">
            <input type="hidden" name="price" value="${product.price}">
            <input type="hidden" id="productImageUrlHidden" name="imageUrl" value="${primaryImgUrl}">
            <input type="hidden" id="quantity" name="quantity" value="1">
            <input type="hidden" id="selectedProductColorSizeId" name="productColorSizeId" value="">

            <div class="container">
                <div class="images">
                    <img src="${primaryImgUrl}" alt="${product.name}" class="main-image" id="mainImage"
                         onerror="this.src='https://placehold.co/600x600/eee/ccc?text=No+Image'">
                    <div class="thumbnails">
                        <c:forEach var="img" items="${images}">
                            <img src="${img.imageUrl}" alt="Thumbnail ${img.color}" 
                                 onclick="changeImage(this)" onerror="this.style.display='none'">
                        </c:forEach>
                    </div>
                </div>

                <div class="details">
                    <h1>${product.name}</h1>
                    <p class="price">
                        <fmt:formatNumber value="${product.price}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                        <c:if test="${product.discount > 0}">
                            <span class="old-price">119.999đ</span>
                        </c:if>
                    </p>
                    <p class="description">${product.description}</p>

                    <div class="option-group">
                        <label>Color</label>
                        <div class="colors" id="color-options"></div>
                    </div>

                    <div class="option-group">
                        <label>Size</label>
                        <div class="sizes" id="size-options">
                            <span style="color: #888; font-style: italic;">Vui lòng chọn màu trước</span>
                        </div>
                    </div>

                    <div class="option-group">
                        <label>Số lượng</label>
                        <div class="flex items-center gap-4">
                            <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden w-fit">
                                <button type="button" id="minusBtn" 
                                        class="w-10 h-10 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-600 transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed" 
                                        disabled>
                                    <i class="fa-solid fa-minus text-xs"></i>
                                </button>

                                <input type="number" id="quantityInput" value="1" min="1" 
                                       class="w-14 h-10 text-center border-x border-gray-300 text-gray-800 font-semibold focus:outline-none appearance-none m-0 bg-white" 
                                       disabled>

                                <button type="button" id="plusBtn" 
                                        class="w-10 h-10 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-600 transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed" 
                                        disabled>
                                    <i class="fa-solid fa-plus text-xs"></i>
                                </button>
                            </div>

                            <span id="stock-info" class="text-sm text-gray-500 font-medium italic"></span>
                        </div>

                        <span id="stock-error" class="text-red-500 text-sm mt-2 block hidden font-medium">
                            <i class="fa-solid fa-circle-exclamation mr-1"></i> Số lượng vượt quá tồn kho!
                        </span>
                    </div>

                    <div class="buttons">
                        <button type="submit" class="btn btn-cart opacity-50 cursor-not-allowed" id="add-to-cart-btn" disabled>
                            <i class="fa-solid fa-cart-plus"></i> Add to Cart
                        </button>
                        <button type="submit" class="btn btn-buy opacity-50 cursor-not-allowed" id="buy-now-btn" disabled>Buy Now</button>
                    </div>
                </div>
            </div>
        </form>

        <div class="feedback-section">
            <h2>Customer Reviews</h2>
            <div class="review"><h4>Nguyễn Minh</h4><div class="stars">★★★★☆</div><p>Áo mặc vừa vặn, vải xịn lắm luôn.</p></div>
            <div class="review"><h4>Trần Hà My</h4><div class="stars">★★★★★</div><p>Siêu đẹp, màu giống hình, rất đáng tiền ❤️</p></div>
        </div>

        <jsp:include page="/views/shared/footer.jsp" />

        <script>
            const colorSizeData = [
            <c:forEach var="cs" items="${colorSizes}" varStatus="status">
            {
            "id": ${cs.productColorSizeId},
                    "color": "${cs.color}",
                    "size": "${cs.size}",
                    "stock": parseInt(${cs.stock})
            }
                <c:if test="${!status.last}">,</c:if>
            </c:forEach>
            ];
            const colorToImageUrlMap = {
            <c:forEach var="img" items="${images}" varStatus="status">
            "${img.color}": "${img.imageUrl}"
                <c:if test="${!status.last}">,</c:if>
            </c:forEach>
            };
            const mainImage = document.getElementById('mainImage');
            const colorOptionsContainer = document.getElementById('color-options');
            const sizeOptionsContainer = document.getElementById('size-options');
            const cartForm = document.getElementById('cartForm');
            const hiddenInputPCSId = document.getElementById('selectedProductColorSizeId');
            const hiddenInputImageUrl = document.getElementById('productImageUrlHidden');
            const quantityHidden = document.getElementById('quantity');
            const addToCartBtn = document.getElementById('add-to-cart-btn');
            const buyBtn = document.getElementById('buy-now-btn');
            const quantityInput = document.getElementById('quantityInput');
            const minusBtn = document.getElementById('minusBtn');
            const plusBtn = document.getElementById('plusBtn');
            const stockError = document.getElementById('stock-error');
            const stockInfo = document.getElementById('stock-info');
            let selectedColor = null;
            let selectedSize = null;
            function getColorHex(colorName) {
            const map = {
            "trắng": "#FFFFFF", "white": "#FFFFFF", "đen": "#000000", "black": "#000000",
                    "beige": "#F5F5DC", "be": "#F5F5DC", "xám": "#808080", "grey": "#808080",
                    "nâu": "#8B4513", "brown": "#8B4513", "xanh navy": "#000080", "navy": "#000080",
                    "hồng": "#FFC0CB", "pink": "#FFC0CB", "xanh": "#0000FF", "blue": "#0000FF",
                    "đỏ": "#FF0000", "red": "#FF0000", "kem": "#FFFDD0", "cream": "#FFFDD0",
                    "xanh lam": "#ADD8E6", "light blue": "#ADD8E6", "xanh lá": "#008000", "green": "#008000",
                    "xanh dương": "#0000FF", "xanh biển": "#3182CE", "bạc": "#C0C0C0", "silver": "#C0C0C0",
                    "vàng": "#FFD700", "gold": "#FFD700"
            };
            return map[colorName.toLowerCase().trim()] || colorName.toLowerCase().trim();
            }

            function renderColorOptions() {
            const uniqueColors = [...new Set(colorSizeData.map(item => item.color))];
            colorOptionsContainer.innerHTML = '';
            uniqueColors.forEach(c => {
            const hex = getColorHex(c);
            const btn = document.createElement('div');
            btn.className = 'color-btn';
            btn.style.backgroundColor = hex;
            btn.dataset.color = c;
            btn.title = c;
            if (hex === "#FFFFFF" || hex.toLowerCase() === "trắng") btn.style.boxShadow = 'inset 0 0 0 1px #ccc';
            colorOptionsContainer.appendChild(btn);
            });
            }

            function renderSizeOptions(color) {
            const sizes = colorSizeData.filter(i => i.color === color).map(i => ({size: i.size, stock: i.stock}));
            sizeOptionsContainer.innerHTML = '';
            if (sizes.length === 0) {
            sizeOptionsContainer.innerHTML = '<span style="color:#888; font-style:italic;">Không có size</span>';
            return;
            }
            sizes.forEach(s => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'size-btn';
            btn.dataset.size = s.size;
            btn.innerText = s.size;
            if (s.stock === 0) {
            btn.disabled = true;
            btn.classList.add('opacity-50', 'cursor-not-allowed');
            btn.title = 'Hết hàng';
            }
            sizeOptionsContainer.appendChild(btn);
            });
            }

            function updateMainAndHiddenImage(url) {
            const finalUrl = url || "https://placehold.co/600x600/eee/ccc?text=No+Image";
            mainImage.src = finalUrl;
            hiddenInputImageUrl.value = finalUrl;
            document.querySelectorAll('.thumbnails img').forEach(t => {
            t.classList.remove('active');
            if (t.src === finalUrl) t.classList.add('active');
            });
            }

            window.changeImage = function(img) { updateMainAndHiddenImage(img.src); }

            // --- LOGIC CẬP NHẬT FORM & STOCK ---
            function updateFormState() {
            stockError.classList.add('hidden');
            stockInfo.textContent = '';
            addToCartBtn.style.display = 'block';
            buyBtn.style.display = 'block';
            let quantity = parseInt(quantityInput.value);
            if (isNaN(quantity) || quantity < 1) quantity = 1;
            // 1. Chưa chọn đủ
            if (!selectedColor || !selectedSize) {
            hiddenInputPCSId.value = '';
            addToCartBtn.disabled = true;
            buyBtn.disabled = true;
            minusBtn.disabled = true;
            plusBtn.disabled = true;
            quantityInput.disabled = true;
            addToCartBtn.classList.add('opacity-50', 'cursor-not-allowed');
            buyBtn.classList.add('opacity-50', 'cursor-not-allowed');
            return;
            }

            // 2. Đã chọn đủ
            const item = colorSizeData.find(i => i.color === selectedColor && i.size === selectedSize);
            if (item) {
            quantityInput.disabled = false;
            quantityInput.max = item.stock;
            // SỬA LỖI: DÙNG DẤU + ĐỂ NỐI CHUỖI TRÁNH XUNG ĐỘT JSP
            if (item.stock > 0) {
            stockInfo.textContent = '(Còn ' + item.stock + ' sản phẩm)';
            stockInfo.className = "text-sm text-gray-500 font-medium italic ml-2";
            } else {
            stockInfo.textContent = "(Hết hàng)";
            stockInfo.className = "text-sm text-red-500 font-medium italic ml-2";
            }

            if (item.stock === 0) {
            hiddenInputPCSId.value = '';
            addToCartBtn.disabled = true;
            buyBtn.disabled = true;
            minusBtn.disabled = true;
            plusBtn.disabled = true;
            quantityInput.disabled = true;
            quantityInput.value = 0;
            addToCartBtn.innerHTML = 'Hết hàng';
            addToCartBtn.classList.add('opacity-50', 'cursor-not-allowed');
            buyBtn.classList.add('opacity-50', 'cursor-not-allowed');
            } else if (quantity > item.stock) {
            hiddenInputPCSId.value = '';
            addToCartBtn.disabled = true;
            buyBtn.disabled = true;
            minusBtn.disabled = false;
            plusBtn.disabled = true;
            stockError.classList.remove('hidden');
            addToCartBtn.classList.add('opacity-50', 'cursor-not-allowed');
            buyBtn.classList.add('opacity-50', 'cursor-not-allowed');
            } else {
            hiddenInputPCSId.value = item.id;
            quantityHidden.value = quantity;
            addToCartBtn.disabled = false;
            buyBtn.disabled = false;
            minusBtn.disabled = (quantity <= 1);
            plusBtn.disabled = (quantity >= item.stock);
            addToCartBtn.innerHTML = '<i class="fa-solid fa-cart-plus mr-2"></i> Add to Cart';
            addToCartBtn.classList.remove('opacity-50', 'cursor-not-allowed');
            buyBtn.classList.remove('opacity-50', 'cursor-not-allowed');
            }
            }
            }

            // --- SỰ KIỆN ---
            colorOptionsContainer.addEventListener('click', (e) => {
            const target = e.target.closest('.color-btn');
            if (target) {
            colorOptionsContainer.querySelectorAll('.color-btn').forEach(b => b.classList.remove('active'));
            target.classList.add('active');
            selectedColor = target.dataset.color;
            selectedSize = null;
            quantityInput.value = 1;
            quantityHidden.value = 1;
            updateMainAndHiddenImage(colorToImageUrlMap[selectedColor]);
            renderSizeOptions(selectedColor);
            updateFormState();
            }
            });
            sizeOptionsContainer.addEventListener('click', (e) => {
            const target = e.target.closest('.size-btn');
            if (target && !target.disabled) {
            sizeOptionsContainer.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
            target.classList.add('active');
            selectedSize = target.dataset.size;
            quantityInput.value = 1;
            quantityHidden.value = 1;
            updateFormState();
            }
            });
            minusBtn.addEventListener('click', () => {
            let v = parseInt(quantityInput.value);
            if (v > 1) { quantityInput.value = v - 1; updateFormState(); }
            });
            plusBtn.addEventListener('click', () => {
            let v = parseInt(quantityInput.value);
            const item = colorSizeData.find(i => i.color === selectedColor && i.size === selectedSize);
            if (item && v < item.stock) { quantityInput.value = v + 1; updateFormState(); }
            });
            quantityInput.addEventListener('input', updateFormState);
            quantityInput.addEventListener('blur', () => {
            let v = parseInt(quantityInput.value);
            if (isNaN(v) || v < 1) { quantityInput.value = 1; updateFormState(); }
            });
            buyBtn.addEventListener('click', (e) => {
            if (buyBtn.disabled) { e.preventDefault(); return; }
            cartForm.querySelector('input[name="action"]').value = 'buy';
            });
            addToCartBtn.addEventListener('click', (e) => {
            if (addToCartBtn.disabled) { e.preventDefault(); return; }
            cartForm.querySelector('input[name="action"]').value = 'add';
            });
            function handleURLParams() {
            const params = new URLSearchParams(window.location.search);
            if (params.get('error') === 'stock') {
            stockError.textContent = "Số lượng chọn vượt quá tồn kho (tính cả trong giỏ hàng).";
            stockError.classList.remove('hidden');
            } else if (params.get('added') === 'true') {
            const msg = document.createElement('div');
            msg.className = 'text-green-600 font-bold mt-3';
            msg.textContent = 'Đã thêm vào giỏ hàng!';
            document.querySelector('.buttons').after(msg);
            setTimeout(() => msg.remove(), 3000);
            }
            if (params.get('error') || params.get('added')) {
            window.history.replaceState(null, null, window.location.pathname + window.location.hash);
            }
            }

            handleURLParams();
            renderColorOptions();
            updateMainAndHiddenImage(mainImage.src);
            const ft = document.querySelector('.thumbnails img');
            if (ft) ft.classList.add('active');
        </script>
    </body>
</html>
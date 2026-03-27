<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8" />
                    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                    <title>Your Cart | AISTHÉA</title>

                    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap"
                        rel="stylesheet" />
                    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                        rel="stylesheet" />
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                    <script id="tailwind-config">
                        tailwind.config = {
                            darkMode: "class",
                            theme: {
                                extend: {
                                    colors: {
                                        "primary": "#024acf",
                                        "accent-blue": "#0288D1",
                                        "background-light": "#f8f6f6",
                                        "background-dark": "#221610",
                                        "sky-subtle": "#E1F5FE",
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
                        .glass-card {
                            background: rgba(255, 255, 255, 0.7);
                            backdrop-filter: blur(12px);
                            -webkit-backdrop-filter: blur(12px);
                            border: 1px solid rgba(2, 136, 209, 0.1);
                        }

                        .bg-ombre {
                            background: linear-gradient(135deg, #ffffff 0%, #E1F5FE 100%);
                        }

                        input[type=number]::-webkit-inner-spin-button,
                        input[type=number]::-webkit-outer-spin-button {
                            -webkit-appearance: none;
                            margin: 0;
                        }
                    </style>
                </head>

                <body class="font-display bg-ombre text-slate-900 min-h-screen">
                    <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                    <main class="max-w-7xl mx-auto px-6 py-12">
                        <nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-slate-400 mb-10">
                            <span class="text-slate-900 font-medium">Cart</span>
                            <span class="material-icons-outlined text-sm">chevron_right</span>
                            <span>Checkout</span>
                            <span class="material-icons-outlined text-sm">chevron_right</span>
                            <span>Confirmation</span>
                        </nav>

                        <%-- Error Alert --%>
                            <c:if test="${not empty sessionScope.error}">
                                <div
                                    class="bg-red-50 border-l-4 border-red-500 text-red-700 px-4 py-3 rounded shadow-sm mb-6 flex items-center gap-3 animate-fade-in max-w-2xl mx-auto">
                                    <span class="material-icons-outlined text-lg">error_outline</span>
                                    <span>${sessionScope.error}</span>
                                </div>
                                <c:remove var="error" scope="session" />
                            </c:if>

                            <c:choose>
                                <c:when test="${empty sessionScope.cart or sessionScope.cart.items.isEmpty()}">
                                    <div class="glass-card rounded-2xl p-20 text-center max-w-2xl mx-auto mt-10">
                                        <span
                                            class="material-symbols-outlined text-6xl text-slate-300 mb-6">shopping_bag</span>
                                        <h2 class="font-serif text-3xl font-semibold text-slate-800 mb-4">Your cart is
                                            empty
                                        </h2>
                                        <p class="text-slate-500 mb-10">Discover our latest collection and find
                                            something
                                            special.</p>
                                        <a href="${pageContext.request.contextPath}/"
                                            class="inline-block bg-accent-blue text-white px-10 py-4 rounded-lg text-xs uppercase tracking-[0.2em] font-bold hover:bg-primary transition-all">
                                            Continue Shopping
                                        </a>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
                                        <div class="lg:col-span-8 space-y-6">
                                            <h1 class="font-serif text-4xl font-semibold text-slate-800 mb-8">Shopping
                                                Bag
                                            </h1>

                                            <div class="glass-card rounded-xl overflow-hidden border border-sky-100">
                                                <form id="checkoutForm" action="${pageContext.request.contextPath}/cart"
                                                    method="POST">
                                                    <input type="hidden" name="action" value="prepareCheckout">

                                                    <!-- ===== Chọn tất cả ===== -->
                                                    <div
                                                        class="px-8 py-4 border-b border-sky-100 bg-sky-50/30 flex items-center">
                                                        <label class="flex items-center gap-3 cursor-pointer group">
                                                            <input type="checkbox" id="selectAllCheckbox"
                                                                class="w-5 h-5 text-accent-blue border-slate-300 rounded focus:ring-accent-blue cursor-pointer"
                                                                onchange="toggleSelectAll(this)">
                                                            <span
                                                                class="text-xs font-bold text-slate-800 uppercase tracking-widest group-hover:text-accent-blue transition-colors">
                                                                Chọn tất cả
                                                            </span>
                                                        </label>
                                                    </div>

                                                    <div class="divide-y divide-sky-100 flex flex-col">
                                                        <c:forEach var="item" items="${sessionScope.cart.items}">
                                                            <c:set var="opacityClass"
                                                                value="${item.available ? 'order-1' : 'order-last opacity-60 bg-slate-50 grayscale'}" />
                                                            <div class="p-8 flex flex-col md:flex-row gap-8 items-center transition-all duration-500 ${opacityClass}"
                                                                id="item-row-${item.productColorSizeId}">
                                                                <div class="flex items-center justify-center w-5">
                                                                    <c:choose>
                                                                        <c:when test="${item.available}">
                                                                            <input type="checkbox" name="selectedItems"
                                                                                value="${item.productColorSizeId}"
                                                                                class="item-checkbox w-5 h-5 text-accent-blue border-slate-300 rounded focus:ring-accent-blue cursor-pointer"
                                                                                data-subtotal="${item.subtotal}"
                                                                                onchange="updateSelectedTotal()">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span
                                                                                class="material-icons-outlined text-slate-300 pointer-events-none"
                                                                                title="Không khả dụng">do_not_disturb_alt</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div
                                                                    class="w-32 h-40 flex-shrink-0 rounded-xl bg-slate-100 overflow-hidden shadow-sm">
                                                                    <c:set var="cartImg"
                                                                        value="${item.productImageUrl}" />
                                                                    <c:if
                                                                        test="${not empty cartImg and not fn:startsWith(cartImg, 'http') and not fn:startsWith(cartImg, '/')}">
                                                                        <c:set var="cartImg"
                                                                            value="${pageContext.request.contextPath}/uploads/${cartImg}" />
                                                                    </c:if>
                                                                    <img class="w-full h-full object-cover"
                                                                        src="${cartImg}" alt="${item.productName}" />
                                                                </div>

                                                                <div
                                                                    class="flex-grow space-y-2 text-center md:text-left">
                                                                    <h3 class="text-lg font-medium text-slate-900">
                                                                        <a href="${pageContext.request.contextPath}/product?action=view&id=${item.productId}"
                                                                            class="hover:text-accent-blue transition-colors">
                                                                            ${item.productName}
                                                                        </a>
                                                                    </h3>
                                                                    <p
                                                                        class="text-xs text-slate-500 italic uppercase tracking-wider">
                                                                        Color: ${item.color} <span class="mx-2">|</span>
                                                                        Size:
                                                                        ${item.size}
                                                                    </p>
                                                                    <div class="pt-4">
                                                                        <button type="button"
                                                                            onclick="removeItem(${item.productColorSizeId})"
                                                                            class="text-[10px] uppercase tracking-widest text-slate-400 hover:text-red-500 flex items-center justify-center md:justify-start gap-1 transition-colors">
                                                                            <span
                                                                                class="material-icons-outlined text-sm">delete_outline</span>
                                                                            Remove Item
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                                <div class="flex flex-col items-center md:items-end gap-4 min-w-[150px]"
                                                                    id="item-container-${item.productColorSizeId}">
                                                                    <c:choose>
                                                                        <c:when test="${item.available}">
                                                                            <div
                                                                                class="flex items-center border border-slate-200 rounded-lg bg-white/50 p-1">
                                                                                <button type="button"
                                                                                    onclick="updateQty(${item.productColorSizeId}, -1)"
                                                                                    class="w-8 h-8 flex items-center justify-center text-slate-500 hover:text-accent-blue transition-colors">
                                                                                    <span
                                                                                        class="material-icons-outlined text-sm">remove</span>
                                                                                </button>
                                                                                <input type="number"
                                                                                    id="qty-${item.productColorSizeId}"
                                                                                    value="${item.quantity}" min="1"
                                                                                    max="${item.stock}"
                                                                                    onchange="updateQtyManual(${item.productColorSizeId}, this.value)"
                                                                                    class="w-10 border-0 bg-transparent text-center text-sm font-semibold focus:ring-0">
                                                                                <button type="button"
                                                                                    onclick="updateQty(${item.productColorSizeId}, 1)"
                                                                                    class="w-8 h-8 flex items-center justify-center text-slate-500 hover:text-accent-blue transition-colors">
                                                                                    <span
                                                                                        class="material-icons-outlined text-sm">add</span>
                                                                                </button>
                                                                            </div>
                                                                            <div class="text-right">
                                                                                <span
                                                                                    class="text-lg font-bold text-slate-900"
                                                                                    id="subtotal-${item.productColorSizeId}">
                                                                                    <fmt:formatNumber
                                                                                        value="${item.subtotal}"
                                                                                        type="currency"
                                                                                        currencyCode="VND"
                                                                                        maxFractionDigits="0" />
                                                                                </span>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div
                                                                                class="text-right mt-4 flex items-center gap-2">
                                                                                <span
                                                                                    class="material-icons-outlined text-red-500 text-sm">error_outline</span>
                                                                                <span
                                                                                    class="text-xs font-bold text-red-500 uppercase tracking-widest bg-red-50 px-3 py-1 rounded">HẾT
                                                                                    HÀNG</span>
                                                                            </div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </form>
                                            </div>

                                            <a href="${pageContext.request.contextPath}/"
                                                class="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-widest text-slate-400 hover:text-accent-blue transition-all">
                                                <span class="material-icons-outlined text-sm">west</span>
                                                Back to Collection
                                            </a>
                                        </div>

                                        <div class="lg:col-span-4">
                                            <div
                                                class="sticky top-32 glass-card rounded-xl p-8 border border-slate-200 shadow-sm">
                                                <h2
                                                    class="font-serif mb-8 text-slate-800 tracking-wide font-semibold text-2xl">
                                                    Summary</h2>

                                                <div class="space-y-4 mb-8">
                                                    <div class="flex justify-between text-sm">
                                                        <span class="text-slate-500 font-medium">Subtotal</span>
                                                        <span class="text-slate-900 font-semibold"
                                                            id="summary-subtotal">
                                                            <fmt:formatNumber value="${sessionScope.cart.totalPrice}"
                                                                type="currency" currencyCode="VND"
                                                                maxFractionDigits="0" />
                                                        </span>
                                                    </div>
                                                    <div class="flex justify-between text-sm">
                                                        <span class="text-slate-500 font-medium">Shipping</span>
                                                        <span class="text-emerald-600 font-semibold italic">Free</span>
                                                    </div>
                                                    <div
                                                        class="pt-6 border-t border-sky-100 flex justify-between items-baseline">
                                                        <span class="text-xl font-bold text-slate-900">Total</span>
                                                        <div class="text-right">
                                                            <p class="text-2xl font-bold text-accent-blue"
                                                                id="summary-total">
                                                                <fmt:formatNumber
                                                                    value="${sessionScope.cart.totalPrice}"
                                                                    type="currency" currencyCode="VND"
                                                                    maxFractionDigits="0" />
                                                            </p>
                                                            <p
                                                                class="text-[9px] text-slate-400 uppercase tracking-widest mt-1">
                                                                VAT Included</p>
                                                        </div>
                                                    </div>
                                                </div>

                                                <button type="button" onclick="submitCheckout()"
                                                    class="w-full bg-slate-900 text-white py-5 rounded-lg text-xs uppercase tracking-[0.3em] font-bold transition-all flex items-center justify-center gap-3 hover:bg-accent-blue">
                                                    Checkout Selected
                                                    <span class="material-icons-outlined text-sm">east</span>
                                                </button>

                                                <div
                                                    class="mt-8 flex justify-center gap-4 opacity-30 grayscale scale-90">
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

                    <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                    <!-- Tiny Toast -->
                    <div id="toast"
                        class="fixed bottom-10 left-1/2 -translate-x-1/2 z-50 transform transition-all duration-500 opacity-0 translate-y-10 pointer-events-none">
                        <div class="bg-slate-900 text-white px-6 py-3 rounded-full shadow-2xl flex items-center gap-3">
                            <span id="toast-icon"
                                class="material-icons-outlined text-emerald-400 text-sm">check_circle</span>
                            <span id="toast-msg" class="text-xs font-bold uppercase tracking-widest">Cart Updated</span>
                        </div>
                    </div>

                    <script>
                        const contextPath = '${pageContext.request.contextPath}';

                        document.addEventListener('DOMContentLoaded', () => {
                            updateSelectedTotal();
                        });

                        function submitCheckout() {
                            const form = document.getElementById('checkoutForm');
                            const checkboxes = form.querySelectorAll('.item-checkbox:checked');
                            if (checkboxes.length === 0) {
                                showToast('Vui lòng chọn ít nhất 1 sản phẩm để thanh toán.', 'warning');
                                return;
                            }
                            form.submit();
                        }

                        function toggleSelectAll(source) {
                            const checkboxes = document.querySelectorAll('.item-checkbox');
                            checkboxes.forEach(cb => {
                                cb.checked = source.checked;
                            });
                            updateSelectedTotal();
                        }

                        function updateSelectedTotal() {
                            const checkboxes = document.querySelectorAll('.item-checkbox');
                            const checkedBoxes = document.querySelectorAll('.item-checkbox:checked');
                            const selectAllCb = document.getElementById('selectAllCheckbox');

                            if (selectAllCb) {
                                selectAllCb.checked = (checkboxes.length > 0 && checkboxes.length === checkedBoxes.length);
                            }

                            let total = 0;
                            checkedBoxes.forEach(cb => {
                                total += parseFloat(cb.getAttribute('data-subtotal'));
                            });
                            document.getElementById('summary-subtotal').textContent = formatVND(total);
                            document.getElementById('summary-total').textContent = formatVND(total);
                        }

                        async function updateQty(pcsId, delta) {
                            const input = document.getElementById('qty-' + pcsId);
                            let currentQty = parseInt(input.value);
                            if (isNaN(currentQty)) currentQty = 1;
                            let newQty = currentQty + delta;
                            if (newQty < 1) return;
                            execUpdateQty(pcsId, newQty);
                        }

                        function updateQtyManual(pcsId, value) {
                            const input = document.getElementById('qty-' + pcsId);
                            let maxStock = parseInt(input.getAttribute('max')) || 999;
                            let newQty = parseInt(value);
                            if (isNaN(newQty) || newQty < 1) newQty = 1;

                            if (newQty > maxStock) {
                                newQty = maxStock;
                                showToast('Số lượng sản phẩm vượt quá tồn kho. Đã điều chỉnh về tối đa: ' + maxStock, 'warning');
                                input.value = newQty;
                            }

                            execUpdateQty(pcsId, newQty);
                        }

                        async function execUpdateQty(pcsId, newQty) {
                            const input = document.getElementById('qty-' + pcsId);

                            // UI visual feedback
                            input.style.opacity = '0.5';

                            try {
                                const params = new URLSearchParams();
                                params.append('action', 'update');
                                params.append('id', pcsId);
                                params.append('quantity', newQty);
                                params.append('ajax', 'true');

                                const res = await fetch(contextPath + '/cart', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                    body: params
                                });

                                const data = await res.json();
                                if (data.success) {
                                    input.value = data.newQuantity || newQty;
                                    const subtotalSpan = document.getElementById('subtotal-' + pcsId);
                                    subtotalSpan.textContent = formatVND(data.itemSubtotal);

                                    // Update checkbox data attribute
                                    const checkbox = document.querySelector('.item-checkbox[value="' + pcsId + '"]');
                                    if (checkbox) {
                                        checkbox.setAttribute('data-subtotal', data.itemSubtotal);
                                    }
                                    updateSelectedTotal();

                                    if (data.error && data.error.trim() !== "") {
                                        showToast(data.error, 'warning');
                                    } else {
                                        // Subtle feedback
                                    }
                                } else {
                                    showToast(data.message || 'Lỗi cập nhật số lượng', 'error');
                                }
                            } catch (e) {
                                console.error(e);
                                showToast('Lỗi kết nối server', 'error');
                            } finally {
                                input.style.opacity = '1';
                            }
                        }

                        async function removeItem(pcsId) {
                            confirmRemove(pcsId);
                        }

                        function confirmRemove(pcsId) {
                            const modal = document.getElementById('remove-confirm-modal');
                            modal.classList.remove('hidden');
                            document.body.style.overflow = 'hidden';

                            document.getElementById('modal-confirm-btn').onclick = async function () {
                                closeRemoveModal();

                                const itemRow = document.getElementById('item-row-' + pcsId);
                                if (itemRow) itemRow.style.opacity = '0.3';

                                try {
                                    const params = new URLSearchParams();
                                    params.append('action', 'remove');
                                    params.append('id', pcsId);
                                    params.append('ajax', 'true');

                                    const res = await fetch(contextPath + '/cart', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                        body: params
                                    });

                                    const data = await res.json();
                                    if (data.success) {
                                        if (data.cartCount === 0) {
                                            location.reload(); // Refresh to show empty cart state
                                        } else {
                                            if (itemRow) itemRow.remove();
                                            updateSelectedTotal();
                                            showToast('Đã xóa sản phẩm', 'success');
                                        }
                                    }
                                } catch (e) {
                                    showToast('Lỗi khi xóa sản phẩm', 'error');
                                    if (itemRow) itemRow.style.opacity = '1';
                                }
                            };

                            document.getElementById('modal-cancel-btn').onclick = closeRemoveModal;
                        }

                        function closeRemoveModal() {
                            document.getElementById('remove-confirm-modal').classList.add('hidden');
                            document.body.style.overflow = '';
                        }

                        function formatVND(number) {
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND',
                                maximumFractionDigits: 0
                            }).format(number).replace(/₫/, '₫');
                        }

                        function showToast(msg, type = 'success') {
                            const toast = document.getElementById('toast');
                            const toastMsg = document.getElementById('toast-msg');
                            const toastIcon = document.getElementById('toast-icon');

                            toastMsg.textContent = msg;

                            if (type === 'success') {
                                toastIcon.textContent = 'check_circle';
                                toastIcon.className = 'material-icons-outlined text-emerald-400 text-sm';
                            } else if (type === 'error') {
                                toastIcon.textContent = 'error';
                                toastIcon.className = 'material-symbols-outlined text-red-500 text-sm';
                            } else {
                                toastIcon.textContent = 'warning';
                                toastIcon.className = 'material-symbols-outlined text-amber-500 text-sm';
                            }

                            toast.classList.remove('opacity-0', 'translate-y-10', 'pointer-events-none');
                            toast.classList.add('opacity-100', 'translate-y-0');

                            setTimeout(() => {
                                toast.classList.add('opacity-0', 'translate-y-10', 'pointer-events-none');
                                toast.classList.remove('opacity-100', 'translate-y-0');
                            }, 3000);
                        }
                    </script>

                    <!-- ===== Remove Confirm Modal ===== -->
                    <div id="remove-confirm-modal"
                        class="fixed inset-0 z-[9999] flex items-center justify-center bg-black/50 backdrop-blur-sm hidden"
                        onclick="if(event.target===this)closeRemoveModal()">
                        <div
                            class="bg-white rounded-2xl shadow-2xl w-full max-w-sm mx-4 p-8 text-center animate-fade-in">
                            <div class="w-14 h-14 rounded-full bg-red-50 flex items-center justify-center mx-auto mb-4">
                                <span class="material-icons-outlined text-red-500 text-3xl">delete_forever</span>
                            </div>
                            <h3 class="font-serif text-xl text-slate-900 mb-2">Xoá sản phẩm?</h3>
                            <p class="text-sm text-slate-500 mb-6">Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng
                                không?</p>
                            <div class="flex gap-3">
                                <button id="modal-cancel-btn" type="button"
                                    class="flex-1 py-3 border border-slate-200 rounded-xl text-slate-600 text-sm font-semibold hover:bg-slate-50 transition-colors">
                                    Huỷ
                                </button>
                                <button id="modal-confirm-btn" type="button"
                                    class="flex-1 py-3 bg-red-500 hover:bg-red-600 text-white rounded-xl text-sm font-semibold transition-colors">
                                    Xoá
                                </button>
                            </div>
                        </div>
                    </div>
                </body>

                </html>
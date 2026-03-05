<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
                                    <h2 class="font-serif text-3xl font-semibold text-slate-800 mb-4">Your cart is empty
                                    </h2>
                                    <p class="text-slate-500 mb-10">Discover our latest collection and find something
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
                                        <h1 class="font-serif text-4xl font-semibold text-slate-800 mb-8">Shopping Bag
                                        </h1>

                                        <div class="glass-card rounded-xl overflow-hidden border border-sky-100">
                                            <div class="divide-y divide-sky-100">
                                                <c:forEach var="item" items="${sessionScope.cart.items}">
                                                    <div class="p-8 flex flex-col md:flex-row gap-8 items-center">
                                                        <div
                                                            class="w-32 h-40 flex-shrink-0 rounded-xl bg-slate-100 overflow-hidden shadow-sm">
                                                            <img class="w-full h-full object-cover"
                                                                src="${item.productImageUrl}"
                                                                alt="${item.productName}" />
                                                        </div>

                                                        <div class="flex-grow space-y-2 text-center md:text-left">
                                                            <h3 class="text-lg font-medium text-slate-900">
                                                                <a href="${pageContext.request.contextPath}/product?action=view&id=${item.productId}"
                                                                    class="hover:text-accent-blue transition-colors">
                                                                    ${item.productName}
                                                                </a>
                                                            </h3>
                                                            <p
                                                                class="text-xs text-slate-500 italic uppercase tracking-wider">
                                                                Color: ${item.color} <span class="mx-2">|</span> Size:
                                                                ${item.size}
                                                            </p>
                                                            <div class="pt-4">
                                                                <a href="${pageContext.request.contextPath}/cart?action=remove&id=${item.productColorSizeId}"
                                                                    class="text-[10px] uppercase tracking-widest text-slate-400 hover:text-red-500 flex items-center justify-center md:justify-start gap-1 transition-colors">
                                                                    <span
                                                                        class="material-icons-outlined text-sm">delete_outline</span>
                                                                    Remove Item
                                                                </a>
                                                            </div>
                                                        </div>

                                                        <div
                                                            class="flex flex-col items-center md:items-end gap-4 min-w-[150px]">
                                                            <form action="${pageContext.request.contextPath}/cart"
                                                                method="POST">
                                                                <input type="hidden" name="action" value="update">
                                                                <input type="hidden" name="id"
                                                                    value="${item.productColorSizeId}">

                                                                <div
                                                                    class="flex items-center border border-slate-200 rounded-lg bg-white/50 p-1">
                                                                    <button type="button" onclick="decreaseQty(this)"
                                                                        class="w-8 h-8 flex items-center justify-center text-slate-500 hover:text-accent-blue transition-colors">
                                                                        <span
                                                                            class="material-icons-outlined text-sm">remove</span>
                                                                    </button>
                                                                    <input type="number" name="quantity"
                                                                        value="${item.quantity}" min="1"
                                                                        class="w-10 border-0 bg-transparent text-center text-sm font-semibold focus:ring-0"
                                                                        onchange="this.form.submit()">
                                                                    <button type="button" onclick="increaseQty(this)"
                                                                        class="w-8 h-8 flex items-center justify-center text-slate-500 hover:text-accent-blue transition-colors">
                                                                        <span
                                                                            class="material-icons-outlined text-sm">add</span>
                                                                    </button>
                                                                </div>
                                                            </form>
                                                            <div class="text-right">
                                                                <span class="text-lg font-bold text-slate-900">
                                                                    <fmt:formatNumber value="${item.subtotal}"
                                                                        type="currency" currencyCode="VND"
                                                                        maxFractionDigits="0" />
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
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
                                                    <span class="text-slate-900 font-semibold">
                                                        <fmt:formatNumber value="${sessionScope.cart.totalPrice}"
                                                            type="currency" currencyCode="VND" maxFractionDigits="0" />
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
                                                        <p class="text-2xl font-bold text-accent-blue">
                                                            <fmt:formatNumber value="${sessionScope.cart.totalPrice}"
                                                                type="currency" currencyCode="VND"
                                                                maxFractionDigits="0" />
                                                        </p>
                                                        <p
                                                            class="text-[9px] text-slate-400 uppercase tracking-widest mt-1">
                                                            VAT Included</p>
                                                    </div>
                                                </div>
                                            </div>

                                            <a href="${pageContext.request.contextPath}/cart?action=checkout"
                                                class="w-full bg-slate-900 text-white py-5 rounded-lg text-xs uppercase tracking-[0.3em] font-bold transition-all flex items-center justify-center gap-3 hover:bg-accent-blue">
                                                Checkout Now
                                                <span class="material-icons-outlined text-sm">east</span>
                                            </a>

                                            <div class="mt-8 flex justify-center gap-4 opacity-30 grayscale scale-90">
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
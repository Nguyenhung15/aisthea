<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>

            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Checkout | AISTHÉA</title>
                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600&amp;family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&amp;display=swap"
                    rel="stylesheet" />
                <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                    rel="stylesheet" />
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script id="tailwind-config">        tailwind.config = {
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
                                borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
                            },
                        },
                    }</script>
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

                    .custom-scrollbar::-webkit-scrollbar {
                        width: 4px;
                    }

                    .custom-scrollbar::-webkit-scrollbar-track {
                        background: transparent;
                    }

                    .custom-scrollbar::-webkit-scrollbar-thumb {
                        background: #e2e8f0;
                        border-radius: 10px;
                    }

                    /* Unify Header/Footer with Checkout Style */
                    #pl-nav {
                        background: rgba(255, 255, 255, 0.8) !important;
                        backdrop-filter: blur(12px);
                        -webkit-backdrop-filter: blur(12px);
                        border-bottom: 1px solid rgba(186, 230, 253, 0.5);
                    }

                    footer.bg-white {
                        background: rgba(255, 255, 255, 0.4) !important;
                        backdrop-filter: blur(8px);
                        border-top: 1px solid rgba(186, 230, 253, 0.5);
                    }
                </style>
            </head>

            <body class="font-display bg-ombre text-slate-900 min-h-screen">
                <!-- Navigation Header -->
                <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                <main class="max-w-7xl mx-auto px-6 py-12">
                    <!-- Breadcrumbs -->
                    <nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-slate-400 mb-10">
                        <a class="hover:text-accent-blue" href="${pageContext.request.contextPath}/cart">Cart</a>
                        <span class="material-icons-outlined text-sm">chevron_right</span>
                        <span class="text-slate-900 font-medium">Checkout</span>
                        <span class="material-icons-outlined text-sm">chevron_right</span>
                        <span>Confirmation</span>
                    </nav>

                    <form action="${pageContext.request.contextPath}/order" method="POST" id="checkoutForm">
                        <input type="hidden" name="action" value="placeorder">

                        <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
                            <!-- Left Section: Shipping & Payment -->
                            <div class="lg:col-span-7 space-y-8">

                                <c:if test="${not empty sessionScope.error}">
                                    <div
                                        class="bg-red-50 border-l-4 border-red-500 text-red-700 px-4 py-3 rounded shadow-sm mb-6 flex items-center gap-3">
                                        <span class="material-icons-outlined text-lg">error_outline</span>
                                        <span>${sessionScope.error}</span>
                                    </div>
                                    <c:remove var="error" scope="session" />
                                </c:if>

                                <!-- Shipping Address Section -->
                                <section>
                                    <h2 class="font-serif mb-6 text-slate-800 tracking-wide font-semibold text-3xl">
                                        Shipping Details</h2>
                                    <div class="glass-card rounded-xl p-8 space-y-6">
                                        <!-- Address Book Selection -->
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            <label
                                                class="relative flex p-4 rounded-lg border-2 border-accent-blue bg-white/50 cursor-pointer">
                                                <div class="flex flex-col">
                                                    <span
                                                        class="text-[10px] tracking-[0.2em] font-semibold uppercase text-accent-blue mb-2">Default
                                                        Address</span>
                                                    <span class="font-medium">${sessionScope.user.fullname}</span>
                                                    <span
                                                        class="text-sm text-slate-500">${sessionScope.user.address}</span>
                                                    <span class="text-sm text-slate-500">Phone:
                                                        ${sessionScope.user.phone}</span>
                                                </div>
                                                <span
                                                    class="material-icons-outlined text-accent-blue ml-auto">check_circle</span>
                                            </label>
                                        </div>
                                        <div class="flex items-center gap-2 text-accent-blue cursor-pointer group">
                                            <a href="${pageContext.request.contextPath}/address"
                                                class="flex items-center gap-2">
                                                <span class="material-icons-outlined text-lg">add</span>
                                                <span
                                                    class="text-sm font-medium border-b border-transparent group-hover:border-accent-blue">Add
                                                    Address</span>
                                            </a>
                                        </div>

                                        <!-- Hidden identity fields for backend -->
                                        <input type="hidden" name="fullname" value="${sessionScope.user.fullname}">
                                        <input type="hidden" name="phone" value="${sessionScope.user.phone}">
                                        <input type="hidden" name="address" value="${sessionScope.user.address}">

                                        <!-- Form Fields -->
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                            <div class="flex items-center gap-2 mt-4">
                                                <input
                                                    class="w-4 h-4 text-accent-blue border-slate-300 rounded focus:ring-accent-blue"
                                                    id="ship_different" type="checkbox" />
                                                <label class="text-sm text-slate-600" for="ship_different">Purchasing as
                                                    a gift?</label>
                                            </div>
                                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4 hidden">
                                                <div class="space-y-1">
                                                    <label
                                                        class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold ml-1">Full
                                                        Name</label>
                                                    <input
                                                        class="w-full bg-white/50 border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue"
                                                        placeholder="Enter recipient name" type="text" />
                                                </div>
                                                <div class="space-y-1">
                                                    <label
                                                        class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold ml-1">Phone
                                                        Number</label>
                                                    <input
                                                        class="w-full bg-white/50 border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue"
                                                        placeholder="Enter recipient phone" type="tel" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <!-- Shipping Method Section -->
                                <section>
                                    <h2 class="font-serif mb-6 text-slate-800 tracking-wide font-semibold text-3xl">
                                        Shipping Method</h2>
                                    <div class="glass-card rounded-xl overflow-hidden border border-sky-100">
                                        <div class="divide-y divide-sky-100">
                                            <label
                                                class="flex items-center justify-between p-6 hover:bg-white/40 cursor-pointer">
                                                <div class="flex items-center gap-4">
                                                    <input checked="" class="text-accent-blue focus:ring-accent-blue"
                                                        name="shipping" type="radio" value="Express Courier" />
                                                    <div>
                                                        <p class="font-medium">Express Courier</p>
                                                        <p class="text-xs text-slate-500 italic">2-3 Business Days •
                                                            Carbon Neutral</p>
                                                    </div>
                                                </div>
                                                <span class="font-medium">Free</span>
                                            </label>
                                            <label
                                                class="flex items-center justify-between p-6 hover:bg-white/40 cursor-pointer">
                                                <div class="flex items-center gap-4">
                                                    <input class="text-accent-blue focus:ring-accent-blue"
                                                        name="shipping" type="radio" value="Standard Delivery" />
                                                    <div>
                                                        <p class="font-medium">Standard Delivery</p>
                                                        <p class="text-xs text-slate-500 italic">5-7 Business Days</p>
                                                    </div>
                                                </div>
                                                <span class="font-medium text-emerald-600">Complimentary</span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="mt-4 flex items-center gap-2 px-4">
                                        <span
                                            class="material-symbols-outlined text-slate-400 text-sm">calendar_today</span>
                                        <p class="text-sm text-slate-600">Estimated Delivery: <span
                                                class="font-medium text-slate-900">Thursday, March 5th, 2026</span></p>
                                    </div>
                                </section>
                                <!-- Payment Methods Section -->
                                <section>
                                    <h2 class="font-serif mb-6 text-slate-800 tracking-wide font-semibold text-3xl">
                                        Payment Selection</h2>
                                    <div class="glass-card rounded-xl p-8 space-y-8">
                                        <div class="space-y-4">
                                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                                <label
                                                    class="relative flex flex-col items-center justify-center p-6 rounded-xl border-2 border-accent-blue bg-white/80 cursor-pointer text-center group transition-all"
                                                    id="label-card">
                                                    <input checked="" class="sr-only" name="paymentMethod" value="Card"
                                                        type="radio" />
                                                    <span
                                                        class="material-symbols-outlined text-accent-blue mb-3 text-3xl">credit_card</span>
                                                    <span class="text-xs font-semibold uppercase tracking-wider">Credit
                                                        Card</span>
                                                </label>
                                                <label
                                                    class="relative flex flex-col items-center justify-center p-6 rounded-xl border border-slate-200 bg-white/40 hover:bg-white/60 cursor-pointer text-center group transition-all"
                                                    id="label-qr">
                                                    <input class="sr-only" name="paymentMethod" value="QR"
                                                        type="radio" />
                                                    <span
                                                        class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 mb-3 text-3xl">qr_code_2</span>
                                                    <span class="text-xs font-semibold uppercase tracking-wider">QR
                                                        Pay</span>
                                                </label>
                                                <label
                                                    class="relative flex flex-col items-center justify-center p-6 rounded-xl border border-slate-200 bg-white/40 hover:bg-white/60 cursor-pointer text-center group transition-all"
                                                    id="label-cod">
                                                    <input class="sr-only" name="paymentMethod" value="COD"
                                                        type="radio" />
                                                    <span
                                                        class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 mb-3 text-3xl">payments</span>
                                                    <span class="text-xs font-semibold uppercase tracking-wider">Cash on
                                                        Delivery</span>
                                                </label>
                                            </div>
                                            <div class="mt-8 pt-8 border-t border-slate-100">
                                                <div id="cardSection" class="max-w-md space-y-4">
                                                    <div class="space-y-1">
                                                        <label
                                                            class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">Card
                                                            Number</label>
                                                        <input name="cardNumber"
                                                            class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm tracking-widest"
                                                            placeholder="0000 0000 0000 0000" type="text" />
                                                    </div>
                                                    <div class="grid grid-cols-2 gap-4">
                                                        <div class="space-y-1">
                                                            <label
                                                                class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">Expiry
                                                                Date</label>
                                                            <input name="expiryDate"
                                                                class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm"
                                                                placeholder="MM / YY" type="text" />
                                                        </div>
                                                        <div class="space-y-1">
                                                            <label
                                                                class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">CVV</label>
                                                            <input name="cvv"
                                                                class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm"
                                                                placeholder="***" type="password" />
                                                        </div>
                                                    </div>
                                                    <div class="space-y-1">
                                                        <label
                                                            class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">Card
                                                            Name</label>
                                                        <input name="cardName"
                                                            class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm"
                                                            placeholder="NAME ON CARD" type="text" />
                                                    </div>
                                                </div>

                                                <!-- QR Section -->
                                                <div id="qrSection"
                                                    class="hidden border border-sky-100 rounded-xl p-6 text-center animate-fade-in">
                                                    <p class="text-sm text-slate-600 mb-4 font-medium">Scan QR to pay:
                                                    </p>
                                                    <img src="${pageContext.request.contextPath}/assets/img/qr-payment.png"
                                                        alt="QR Code"
                                                        class="mx-auto w-48 h-48 object-contain mb-4 ring-8 ring-white rounded-lg shadow-sm">
                                                    <p class="text-xs text-slate-500">Content: <span
                                                            class="font-bold text-slate-900">AISTHEA -
                                                            ${sessionScope.user.fullname}</span></p>
                                                </div>

                                                <!-- COD Section -->
                                                <div id="codSection" class="hidden text-center p-6">
                                                    <p class="text-sm text-slate-600">Pay directly with cash upon
                                                        delivery.</p>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </section>
                            </div>
                            <!-- Right Section: Order Summary (Sticky) -->
                            <div class="lg:col-span-5">
                                <div class="sticky top-32 glass-card rounded-xl p-8 border border-slate-200 shadow-sm">
                                    <h2 class="font-serif mb-8 text-slate-800 tracking-wide font-semibold text-3xl">Your
                                        Order</h2>
                                    <!-- Item List -->
                                    <div class="space-y-6 mb-8 max-h-[400px] overflow-y-auto pr-2 custom-scrollbar">
                                        <c:forEach var="item" items="${sessionScope.cart.items}">
                                            <div class="flex gap-4">
                                                <div
                                                    class="w-20 h-24 flex-shrink-0 rounded-lg bg-slate-100 overflow-hidden">
                                                    <img class="w-full h-full object-cover"
                                                        src="${item.productImageUrl}" alt="${item.productName}" />
                                                </div>
                                                <div class="flex-grow">
                                                    <div class="flex justify-between items-start">
                                                        <h3 class="text-sm font-medium text-slate-900">
                                                            ${item.productName}</h3>
                                                        <span class="text-sm font-medium">
                                                            <fmt:formatNumber value="${item.subtotal}" type="currency"
                                                                currencyCode="VND" maxFractionDigits="0" />
                                                        </span>
                                                    </div>
                                                    <p class="text-xs text-slate-500 mt-1 italic">${item.color} / Size
                                                        ${item.size}</p>
                                                    <div
                                                        class="flex items-center gap-1 mt-2 text-[10px] text-slate-400">
                                                        <span>Quantity: ${item.quantity}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <!-- Promo Code -->
                                    <!-- Totals -->
                                    <div class="py-3 border-y border-slate-100 my-3">
                                        <button type="button"
                                            onclick="document.getElementById('discount-drawer').classList.remove('hidden')"
                                            class="group flex items-center gap-2 text-xs font-semibold uppercase tracking-widest text-slate-800 hover:text-accent-blue transition-colors outline-none cursor-pointer">
                                            <span class="material-symbols-outlined text-lg">add_circle</span>
                                            <span
                                                class="border-b border-transparent group-hover:border-accent-blue transition-all">Add
                                                Promotion</span>
                                        </button>
                                    </div>
                                    <div class="space-y-3">
                                        <div class="flex justify-between text-sm">
                                            <span class="text-slate-500">Subtotal</span>
                                            <span class="text-slate-900">
                                                <fmt:formatNumber value="${sessionScope.cart.totalPrice}"
                                                    type="currency" currencyCode="VND" maxFractionDigits="0" />
                                            </span>
                                        </div>
                                        <div class="flex justify-between text-sm">
                                            <span class="text-slate-500">Shipping (Express)</span>
                                            <span class="text-slate-900">Free</span>
                                        </div>
                                        <div class="flex justify-between text-sm">
                                            <span class="text-slate-500">Estimated Tax</span>
                                            <span class="text-slate-900">Included</span>
                                        </div>
                                        <div class="flex justify-between pt-4 border-t border-sky-100">
                                            <span class="text-xl font-bold text-slate-900">Total</span>
                                            <span class="text-xl font-bold text-slate-900">
                                                <fmt:formatNumber value="${sessionScope.cart.totalPrice}"
                                                    type="currency" currencyCode="VND" maxFractionDigits="0" />
                                            </span>
                                        </div>
                                    </div>
                                    <!-- CTA -->
                                    <button type="submit"
                                        class="w-full mt-10 bg-accent-blue text-white py-5 rounded-lg text-xs uppercase tracking-[0.3em] font-bold transition-all flex items-center justify-center gap-3 hover:bg-[#0277bd] tracking-[0.2em]">
                                        Place Order
                                        <span class="material-icons-outlined text-sm">lock</span>
                                    </button>
                                    <p class="text-center text-[10px] text-slate-400 mt-4 leading-relaxed">
                                        By clicking Place Order, you agree to our <br /> <a class="underline"
                                            href="#">Terms of Service</a> and <a class="underline" href="#">Privacy
                                            Policy</a>.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </form>
                </main>

                <!-- Footer -->
                <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                <!-- Side Drawer for Discounts -->
                <div class="fixed inset-0 z-[100] hidden" id="discount-drawer">
                    <!-- Backdrop -->
                    <div class="absolute inset-0 bg-black/20 backdrop-blur-sm transition-opacity"
                        onclick="document.getElementById('discount-drawer').classList.add('hidden')"></div>
                    <!-- Drawer Panel -->
                    <div
                        class="absolute right-0 top-0 h-full w-full md:w-[380px] bg-white/90 backdrop-blur-xl border-l border-[#E3F2FD] shadow-[0_0_50px_rgba(0,0,0,0.1)] transform transition-transform duration-500 ease-out">
                        <div class="flex flex-col h-full">
                            <!-- Header -->
                            <div class="p-6 border-b border-slate-100 flex items-center justify-between">
                                <h2 class="text-2xl font-bold text-slate-900 tracking-tight">Discounts</h2>
                                <button type="button"
                                    onclick="document.getElementById('discount-drawer').classList.add('hidden')"
                                    class="material-symbols-outlined text-slate-400 hover:text-slate-900 transition-colors p-1">close</button>
                            </div>
                            <!-- Scrollable Content -->
                            <div class="flex-1 overflow-y-auto p-6 space-y-8 custom-scrollbar">
                                <!-- Promo Input -->
                                <div class="space-y-3 mb-10">
                                    <label
                                        class="text-[10px] uppercase tracking-[0.2em] text-slate-400 font-bold ml-1">Enter
                                        promo code</label>
                                    <div class="flex items-center gap-4">
                                        <input
                                            class="flex-1 border-0 border-b border-slate-200 focus:ring-0 focus:border-accent-blue text-sm py-3 px-1 bg-transparent uppercase"
                                            placeholder="PROMO CODE" type="text" />
                                        <button type="button"
                                            class="text-[10px] uppercase tracking-[0.2em] font-bold text-accent-blue hover:opacity-70 transition-opacity underline decoration-1 underline-offset-4">Apply</button>
                                    </div>
                                </div>
                                <div class="space-y-6">
                                    <p class="text-[10px] uppercase tracking-[0.3em] text-slate-500 font-bold ml-1">Your
                                        Collection</p>
                                    <!-- Recommended Voucher -->
                                    <div
                                        class="p-6 border border-accent-blue/20 bg-accent-blue/[0.02] rounded-lg space-y-3 relative group overflow-hidden">
                                        <div
                                            class="absolute top-0 right-0 bg-accent-blue text-white text-[8px] font-bold uppercase tracking-widest px-3 py-1 rounded-bl-lg">
                                            Recommended</div>
                                        <div class="flex justify-between items-end">
                                            <div>
                                                <h3 class="text-2xl text-slate-900 font-bold">$50 OFF</h3>
                                                <p class="text-[11px] text-slate-600 font-medium">Loyalty Anniversary
                                                    Reward</p>
                                            </div>
                                            <button type="button"
                                                class="text-[10px] uppercase tracking-[0.2em] font-bold text-accent-blue hover:bg-accent-blue hover:text-white border border-accent-blue px-4 py-2 rounded-md transition-all">Use</button>
                                        </div>
                                        <div class="pt-2 border-t border-slate-100 flex items-center gap-1.5">
                                            <span
                                                class="material-symbols-outlined text-[14px] text-slate-400">schedule</span>
                                            <p class="text-[9px] text-slate-400 italic">Valid until Mar 15, 2026</p>
                                        </div>
                                    </div>
                                    <!-- Regular Voucher -->
                                    <div
                                        class="p-6 border border-slate-100 rounded-lg space-y-3 hover:border-accent-blue/30 transition-all">
                                        <div class="flex justify-between items-end">
                                            <div>
                                                <h3 class="text-2xl text-slate-900 font-bold uppercase">10% OFF</h3>
                                                <p
                                                    class="text-[11px] text-slate-600 font-medium uppercase tracking-wider">
                                                    WELCOME20</p>
                                            </div>
                                            <button type="button"
                                                class="text-[10px] uppercase tracking-[0.2em] font-bold text-accent-blue hover:bg-accent-blue hover:text-white border border-accent-blue px-4 py-2 rounded-md transition-all">Use</button>
                                        </div>
                                    </div>
                                    <!-- Ineligible Voucher -->
                                    <div
                                        class="p-6 border border-slate-100 rounded-lg space-y-3 grayscale opacity-50 bg-slate-50/50">
                                        <div class="flex justify-between items-start">
                                            <div>
                                                <div class="flex items-center gap-2">
                                                    <h3 class="text-2xl text-slate-900 font-bold">$200 OFF</h3>
                                                    <span
                                                        class="material-symbols-outlined text-sm text-slate-400 cursor-help">info</span>
                                                </div>
                                                <p class="text-[11px] text-slate-500 font-medium">Minimum spend $5,000
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Footer -->
                            <div class="p-6 border-t border-slate-100">
                                <button type="button"
                                    onclick="document.getElementById('discount-drawer').classList.add('hidden')"
                                    class="w-full py-4 border border-slate-900 text-slate-900 text-[10px] uppercase tracking-[0.3em] font-bold rounded-lg hover:bg-slate-900 hover:text-white transition-all duration-300">
                                    Return to Checkout
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    const radios = document.querySelectorAll('input[name="paymentMethod"]');
                    const qrSection = document.getElementById('qrSection');
                    const cardSection = document.getElementById('cardSection');
                    const codSection = document.getElementById('codSection');

                    const labelCard = document.getElementById('label-card');
                    const labelQr = document.getElementById('label-qr');
                    const labelCod = document.getElementById('label-cod');

                    function updateSelection(value) {
                        if (qrSection) qrSection.classList.add('hidden');
                        if (cardSection) cardSection.classList.add('hidden');
                        if (codSection) codSection.classList.add('hidden');

                        // Reset classes
                        [labelCard, labelQr, labelCod].forEach(l => {
                            if (l) {
                                l.classList.remove('border-accent-blue', 'border-2');
                                l.classList.add('border-slate-200');
                                const icon = l.querySelector('span:first-of-type');
                                if (icon) {
                                    icon.classList.remove('text-accent-blue');
                                    icon.classList.add('text-slate-400');
                                }
                            }
                        });

                        if (value === 'QR' && qrSection) {
                            qrSection.classList.remove('hidden');
                            labelQr.classList.add('border-accent-blue', 'border-2');
                            labelQr.classList.remove('border-slate-200');
                            labelQr.querySelector('span:first-of-type').classList.add('text-accent-blue');
                        } else if (value === 'Card' && cardSection) {
                            cardSection.classList.remove('hidden');
                            labelCard.classList.add('border-accent-blue', 'border-2');
                            labelCard.classList.remove('border-slate-200');
                            labelCard.querySelector('span:first-of-type').classList.add('text-accent-blue');
                        } else if (value === 'COD' && codSection) {
                            codSection.classList.remove('hidden');
                            labelCod.classList.add('border-accent-blue', 'border-2');
                            labelCod.classList.remove('border-slate-200');
                            labelCod.querySelector('span:first-of-type').classList.add('text-accent-blue');
                        }
                    }

                    radios.forEach(radio => {
                        radio.addEventListener('change', (e) => {
                            updateSelection(e.target.value);
                        });
                    });

                    // Initialize with default check
                    updateSelection('Card');

                    // Validation logic
                    const form = document.getElementById('checkoutForm');
                    if (form) {
                        form.addEventListener('submit', function (e) {
                            const checkedRadio = document.querySelector('input[name="paymentMethod"]:checked');
                            if (!checkedRadio) return;
                            const selected = checkedRadio.value;

                            if (selected === 'QR') {
                                e.preventDefault();
                                alert("Please scan QR to transfer.\nAfter completed, press OK to continue.");
                                setTimeout(() => {
                                    if (confirm("Confirm your transfer successfully?")) {
                                        form.submit();
                                    }
                                }, 500);
                                return;
                            }

                            if (selected === 'Card') {
                                const cardNumberInput = document.querySelector('input[name="cardNumber"]');
                                const expiryDateInput = document.querySelector('input[name="expiryDate"]');
                                const cvvInput = document.querySelector('input[name="cvv"]');

                                if (cardNumberInput && expiryDateInput && cvvInput) {
                                    const cardNumber = cardNumberInput.value.trim();
                                    const expiryDate = expiryDateInput.value.trim();
                                    const cvv = cvvInput.value.trim();

                                    if (!/^\d{4}(\s\d{4}){3}$|^\d{16}$/.test(cardNumber.replace(/\s/g, ''))) {
                                        e.preventDefault();
                                        alert("Invalid card number (16 digits)");
                                        return;
                                    }
                                    if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiryDate)) {
                                        e.preventDefault();
                                        alert("Invalid expiry date (MM/YY)");
                                        return;
                                    }
                                    if (!/^\d{3}$/.test(cvv)) {
                                        e.preventDefault();
                                        alert("Invalid CVV (3 digits)");
                                        return;
                                    }
                                }
                            }
                        });
                    }

                </script>
            </body>

            </html>
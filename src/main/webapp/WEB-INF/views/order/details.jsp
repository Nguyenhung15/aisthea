<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Order Detail #${order.orderid} | AISTHÉA</title>

                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap"
                    rel="stylesheet" />
                <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet" />
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    @keyframes toastIn { from { opacity:0; transform:translateX(-50%) translateY(-12px); } to { opacity:1; transform:translateX(-50%) translateY(0); } }
                    @keyframes toastOut { from { opacity:1; transform:translateX(-50%) translateY(0); } to { opacity:0; transform:translateX(-50%) translateY(-12px); } }
                </style>

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

                    .status-badge {
                        padding: 4px 12px;
                        border-radius: 9999px;
                        font-size: 10px;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.1em;
                    }

                    .modal {
                        display: none;
                        position: fixed;
                        z-index: 100;
                        inset: 0;
                        background: rgba(15, 23, 42, 0.4);
                        backdrop-filter: blur(4px);
                        justify-content: center;
                        align-items: center;
                    }

                    .modal.active {
                        display: flex;
                    }

                    /* Return request status colours */
                    .return-status-Pending  { background:#fef3c7; color:#d97706; }
                    .return-status-Approved { background:#d1fae5; color:#065f46; }
                    .return-status-Rejected { background:#fee2e2; color:#b91c1c; }

                    .return-reason-option {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        padding: 10px 14px;
                        border: 1.5px solid #e2e8f0;
                        border-radius: 10px;
                        cursor: pointer;
                        transition: all 0.18s;
                    }
                    .return-reason-option:has(input:checked) {
                        border-color: #0288D1;
                        background: #e1f5fe;
                    }
                </style>
            </head>

            <body class="font-display bg-ombre text-slate-900 min-h-screen">
                <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                <main class="max-w-7xl mx-auto px-6 py-12">
                    <nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-slate-400 mb-10">
                        <a class="hover:text-accent-blue"
                            href="${pageContext.request.contextPath}/order?action=history">History</a>
                        <span class="material-icons-outlined text-sm">chevron_right</span>
                        <span class="text-slate-900 font-medium">Order Detail</span>
                    </nav>

                    <%-- Success Alert --%>
                        <%-- Success Alert --%>
                            <c:if
                                test="${(param.success == 'true' || param.payment == 'success') && order.status != 'Cancelled'}">
                                <div
                                    class="glass-card border-emerald-100 bg-emerald-100 rounded-xl p-6 mb-10 flex items-center gap-4 animate-fade-in shadow-lg shadow-emerald-100/50">
                                    <div class="bg-emerald-500 text-white rounded-full p-2">
                                        <span class="material-symbols-outlined text-lg">check</span>
                                    </div>
                                    <div class="flex-grow">
                                        <h3 class="font-bold text-emerald-900">Purchase Successful!</h3>
                                        <p class="text-sm text-emerald-700/80">Thank you for choosing AISTHÉA. Your
                                            order is
                                            being processed.</p>
                                    </div>
                                </div>
                            </c:if>

                            <%-- Error/Cancel Alert --%>
                                <c:if test="${not empty error}">
                                    <div
                                        class="glass-card border-red-100 bg-red-100 rounded-xl p-6 mb-10 flex items-center gap-4 animate-fade-in shadow-lg shadow-red-100/50">
                                        <div class="bg-red-500 text-white rounded-full p-2">
                                            <span class="material-symbols-outlined text-lg">priority_high</span>
                                        </div>
                                        <div class="flex-grow">
                                            <h3 class="font-bold text-red-900">Notice</h3>
                                            <p class="text-sm text-red-700/80">${error}</p>
                                        </div>
                                    </div>
                                </c:if>

                        <%-- Address-update success alert --%>
                        <c:if test="${param.addrUpdated == 'true'}">
                            <div class="glass-card border-emerald-100 bg-emerald-50 rounded-xl p-6 mb-6 flex items-center gap-4 shadow-lg shadow-emerald-100/50">
                                <div class="bg-emerald-500 text-white rounded-full p-2">
                                    <span class="material-symbols-outlined text-lg">check</span>
                                </div>
                                <div class="flex-grow">
                                    <h3 class="font-bold text-emerald-900">Địa chỉ giao hàng đã được cập nhật!</h3>
                                    <p class="text-sm text-emerald-700/80">Đơn hàng đã được chuyển về trạng thái <strong>Chờ xác nhận</strong> để xử lý lại.</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${param.returnSubmitted == 'true'}">
                            <div class="glass-card border-emerald-100 bg-emerald-50 rounded-xl p-6 mb-6 flex items-center gap-4 shadow-lg shadow-emerald-100/50">
                                <div class="bg-emerald-500 text-white rounded-full p-2">
                                    <span class="material-symbols-outlined text-lg">check</span>
                                </div>
                                <div class="flex-grow">
                                    <h3 class="font-bold text-emerald-900">Yêu cầu hoàn trả đã được gửi!</h3>
                                    <p class="text-sm text-emerald-700/80">Chúng tôi sẽ xem xét và phản hồi trong vòng 24–48 giờ.</p>
                                </div>
                            </div>
                        </c:if>

                        <%-- Return error alert --%>
                        <c:if test="${not empty param.returnError}">
                            <div class="glass-card border-red-100 bg-red-50 rounded-xl p-6 mb-6 flex items-center gap-4 shadow-lg shadow-red-100/50">
                                <div class="bg-red-500 text-white rounded-full p-2">
                                    <span class="material-symbols-outlined text-lg">priority_high</span>
                                </div>
                                <div class="flex-grow">
                                    <h3 class="font-bold text-red-900">Không thể gửi yêu cầu</h3>
                                    <p class="text-sm text-red-700/80">${param.returnError}</p>
                                </div>
                            </div>
                        </c:if>

                                <div class="flex flex-col lg:flex-row gap-12">
                                    <div class="lg:col-span-8 flex-grow space-y-8">
                                        <div class="flex items-baseline justify-between gap-4">
                                            <h1 class="font-serif text-4xl font-semibold text-slate-800 tracking-tight">
                                                Order
                                                #${order.orderid}</h1>
                                            <div class="status-badge 
                                        ${order.status == 'Pending' ? 'bg-amber-100 text-amber-700' : ''}
                                        ${order.status == 'Processing' ? 'bg-sky-100 text-sky-700' : ''}
                                        ${order.status == 'Processing' ? 'bg-indigo-100 text-indigo-700' : ''}
                                        ${order.status == 'Completed' ? 'bg-emerald-100 text-emerald-700' : ''}
                                        ${order.status == 'Cancelled' ? 'bg-red-100 text-red-700' : ''}">
                                                ${order.status}
                                            </div>
                                        </div>

                                        <div class="glass-card rounded-xl overflow-hidden">
                                            <div class="p-6 border-b border-sky-50 bg-white/30">
                                                <h2 class="text-xs uppercase tracking-[0.2em] font-bold text-slate-400">
                                                    Shipment
                                                    Items</h2>
                                            </div>
                                            <div class="divide-y divide-sky-50">
                                                <c:forEach var="item" items="${order.items}">
                                                    <a href="${pageContext.request.contextPath}/product?action=view&id=${item.productId}"
                                                        class="p-6 flex items-center gap-6 hover:bg-sky-50/40 transition-colors block">
                                                        <div
                                                            class="w-20 h-24 flex-shrink-0 rounded-lg bg-slate-100 overflow-hidden shadow-sm">
                                                            <c:set var="oImgUrl" value="${item.imageUrl}" />
                                                            <c:if test="${not empty oImgUrl and not fn:startsWith(oImgUrl, 'http') and not fn:startsWith(oImgUrl, '/')}">
                                                                <c:set var="oImgUrl" value="${pageContext.request.contextPath}/uploads/${oImgUrl}" />
                                                            </c:if>
                                                            <img class="w-full h-full object-cover"
                                                                src="${oImgUrl}" alt="${item.productName}"
                                                                onerror="this.src='https://placehold.co/100x120?text=No+Image'" />
                                                        </div>
                                                        <div class="flex-grow">
                                                            <h3
                                                                class="text-sm font-semibold text-slate-900 hover:text-accent-blue transition-colors">
                                                                ${item.productName}
                                                            </h3>
                                                            <p class="text-xs text-slate-500 italic mt-1">${item.color}
                                                                / Size ${item.size}</p>
                                                            <p
                                                                class="text-[10px] text-slate-400 mt-2 font-bold uppercase tracking-wider">
                                                                Qty: ${item.quantity}</p>
                                                        </div>
                                                        <div class="text-right">
                                                            <p class="text-sm font-bold text-slate-900">
                                                                <fmt:formatNumber value="${item.price * item.quantity}"
                                                                    type="currency" currencyCode="VND"
                                                                    maxFractionDigits="0" />
                                                            </p>
                                                            <p class="text-[10px] text-slate-400 mt-1">
                                                                <fmt:formatNumber value="${item.price}" type="number" />
                                                                /unit
                                                            </p>
                                                        </div>
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="w-full lg:w-[400px] space-y-6">
                                        <div class="glass-card rounded-xl p-8 border border-slate-200">
                                            <h2 class="font-serif text-2xl font-semibold text-slate-800 mb-6">Order
                                                Summary</h2>

                                            <div class="space-y-4 text-sm mb-8 relative">
                                                <div class="flex flex-col space-y-3 pb-4 border-b border-slate-100">
                                                    <div
                                                        class="flex justify-between items-center relative pl-4 border-l-[2px] border-emerald-500">
                                                        <span class="text-slate-500">Ngày đặt hàng</span>
                                                        <span class="font-medium text-slate-900 text-right text-xs">
                                                            <fmt:formatDate value="${order.createdat}"
                                                                pattern="HH:mm — dd/MM/yyyy" />
                                                        </span>
                                                        <div
                                                            class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-emerald-500 ring-4 ring-white">
                                                        </div>
                                                    </div>

                                                    <c:if test="${order.confirmedAt != null}">
                                                        <div
                                                            class="flex justify-between items-center relative pl-4 border-l-[2px] border-emerald-500">
                                                            <span class="text-slate-500">Chờ lấy hàng</span>
                                                            <span class="font-medium text-slate-900 text-right text-xs">
                                                                <fmt:formatDate value="${order.confirmedAt}"
                                                                    pattern="HH:mm — dd/MM/yyyy" />
                                                            </span>
                                                            <div
                                                                class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-emerald-500 ring-4 ring-white">
                                                            </div>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${order.shippedAt != null}">
                                                        <div
                                                            class="flex justify-between items-center relative pl-4 border-l-[2px] border-blue-500">
                                                            <span class="text-slate-500">Đang giao hàng</span>
                                                            <span class="font-medium text-slate-900 text-right text-xs">
                                                                <fmt:formatDate value="${order.shippedAt}"
                                                                    pattern="HH:mm — dd/MM/yyyy" />
                                                            </span>
                                                            <div
                                                                class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-blue-500 ring-4 ring-white">
                                                            </div>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${order.completedAt != null}">
                                                        <div
                                                            class="flex justify-between items-center relative pl-4 border-l-[2px] border-indigo-500">
                                                            <span class="text-slate-500 text-indigo-600 font-bold">Hoàn
                                                                thành</span>
                                                            <span class="font-medium text-slate-900 text-right text-xs">
                                                                <fmt:formatDate value="${order.completedAt}"
                                                                    pattern="HH:mm — dd/MM/yyyy" />
                                                            </span>
                                                            <div
                                                                class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-indigo-500 ring-4 ring-white">
                                                            </div>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${order.status eq 'Cancelled'}">
                                                        <div
                                                            class="flex justify-between items-center relative pl-4 border-l-[2px] border-red-500">
                                                            <span class="text-slate-500 text-red-500 font-bold">Đã
                                                                hủy</span>
                                                            <span class="font-medium text-slate-900 text-right text-xs">
                                                                <fmt:formatDate value="${order.updatedat}"
                                                                    pattern="HH:mm — dd/MM/yyyy" />
                                                            </span>
                                                            <div
                                                                class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-red-500 ring-4 ring-white">
                                                            </div>
                                                        </div>

                                                        <div
                                                            class="mt-2 bg-red-50 p-3 rounded-lg border border-red-100">
                                                            <p class="text-xs text-red-600 font-semibold mb-1">Lý do
                                                                hủy:</p>
                                                            <p class="text-xs text-red-800">${empty order.cancelReason ?
                                                                "Không có dữ liệu" : order.cancelReason}</p>
                                                            <c:if test="${not empty order.refundStatus}">
                                                                <div
                                                                    class="mt-2 pt-2 border-t border-red-200 flex justify-between">
                                                                    <span
                                                                        class="text-[10px] text-slate-500 font-bold uppercase tracking-wider">Hoàn
                                                                        tiền (QR)</span>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${order.refundStatus eq 'Pending'}">
                                                                            <span
                                                                                class="text-[10px] text-amber-600 font-bold uppercase tracking-wider">Đang
                                                                                chờ xử lý</span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${order.refundStatus eq 'Completed'}">
                                                                            <span
                                                                                class="text-[10px] text-emerald-600 font-bold uppercase tracking-wider">Đã
                                                                                hoàn thành</span>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </c:if>
                                                </div>

                                                <%-- Payment Method --%>
                                                    <div class="flex justify-between">
                                                        <span class="text-slate-500">Payment</span>
                                                        <c:choose>
                                                            <c:when test="${order.paymentMethod eq 'QR'}">
                                                                <span class="font-medium text-slate-900">QR / Online</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="font-medium text-slate-900">COD / Tiền mặt</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <%-- Paid / Unpaid badge --%>
                                                        <div class="flex justify-between">
                                                            <span class="text-slate-500">Paid Status</span>
                                                            <c:choose>
                                                                <c:when test="${order.status eq 'Completed' or (order.paymentMethod eq 'QR' and order.status ne 'Pending')}">
                                                                    <span class="font-medium text-slate-900">Đã thanh toán</span>
                                                                </c:when>
                                                                <c:when test="${order.status eq 'Cancelled'}">
                                                                    <span class="font-medium text-slate-900">Đã hủy</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="font-medium text-slate-900">Chưa thanh toán</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="flex justify-between">
                                                            <span class="text-slate-500">Shipping</span>
                                                            <span class="font-medium text-slate-900">Complimentary</span>
                                                        </div>
                                                        <c:if
                                                            test="${order.tierDiscount != null && order.tierDiscount > 0}">
                                                            <div class="flex justify-between">
                                                                <span class="text-amber-600 flex items-center gap-1">
                                                                    <span
                                                                        class="material-symbols-outlined text-sm">star</span>
                                                                    Ưu đãi ${order.tierName}
                                                                </span>
                                                                <span class="text-amber-600 font-semibold">-
                                                                    <fmt:formatNumber value="${order.tierDiscount}"
                                                                        type="currency" currencyCode="VND"
                                                                        maxFractionDigits="0" />
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                        <c:if
                                                            test="${order.birthdayDiscount != null && order.birthdayDiscount > 0}">
                                                            <div class="flex justify-between">
                                                                <span class="text-pink-600 flex items-center gap-1">
                                                                    <span
                                                                        class="material-symbols-outlined text-sm">cake</span>
                                                                    Ưu đãi Sinh nhật
                                                                </span>
                                                                <span class="text-pink-600 font-semibold">-
                                                                    <fmt:formatNumber value="${order.birthdayDiscount}"
                                                                        type="currency" currencyCode="VND"
                                                                        maxFractionDigits="0" />
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                        <c:if
                                                            test="${order.discountAmount != null && order.discountAmount > 0}">
                                                            <div class="flex justify-between">
                                                                <span class="text-slate-500">Giảm giá (Voucher)</span>
                                                                <span class="text-red-500 font-semibold">-
                                                                    <fmt:formatNumber value="${order.discountAmount}"
                                                                        type="currency" currencyCode="VND"
                                                                        maxFractionDigits="0" />
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                        <div
                                                            class="pt-4 border-t border-sky-100 flex justify-between items-baseline">
                                                            <span class="text-lg font-bold text-slate-900">Total</span>
                                                            <span class="text-2xl font-bold text-accent-blue">
                                                                <fmt:formatNumber value="${order.totalprice}"
                                                                    type="currency" currencyCode="VND"
                                                                    maxFractionDigits="0" />
                                                            </span>
                                                        </div>
                                            </div>

                                            <div class="pt-6 border-t border-slate-100 space-y-4">
                                                <h3
                                                    class="text-[10px] uppercase tracking-[0.2em] font-bold text-slate-400">
                                                    Shipping Information</h3>
                                                <div class="text-xs space-y-2 text-slate-600 leading-relaxed">
                                                    <p class="font-bold text-slate-900 text-sm">${order.fullname}</p>
                                                    <p><span
                                                            class="material-icons-outlined text-[14px] align-middle mr-1">phone</span>${order.phone}
                                                    </p>
                                                    <p><span
                                                            class="material-icons-outlined text-[14px] align-middle mr-1">email</span>${order.email}
                                                    </p>
                                                    <p><span
                                                            class="material-icons-outlined text-[14px] align-middle mr-1">location_on</span>${order.address}
                                                    </p>
                                                </div>
                                            </div>

                                            <div class="mt-10 space-y-3">
                                                <c:if
                                                    test="${order.status == 'Pending' or order.status == 'Processing'}">
                                                    <button onclick="openCancelModal()"
                                                        class="w-full bg-white border border-slate-200 text-slate-600 py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:bg-red-50 hover:text-red-600 hover:border-red-100 transition-all flex items-center justify-center gap-2">
                                                        <span class="material-symbols-outlined text-sm">cancel</span>
                                                        Hủy Đơn Hàng
                                                    </button>
                                                </c:if>

                                                <%-- Single review button — new multi-product feedback page handles all
                                                    products at once --%>
                                                    <c:if test="${order.status == 'Completed'}">
                                                        <c:set var="anyUnreviewed" value="false" />
                                                        <c:forEach var="item" items="${order.items}">
                                                            <c:if
                                                                test="${!reviewedProductIds.contains(item.productId)}">
                                                                <c:set var="anyUnreviewed" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:choose>
                                                            <c:when test="${anyUnreviewed}">
                                                                <a href="${pageContext.request.contextPath}/feedback?orderId=${order.orderid}"
                                                                    class="w-full bg-accent-blue text-white py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:bg-primary transition-all flex items-center justify-center gap-2">
                                                                    <span
                                                                        class="material-symbols-outlined text-sm">star</span>
                                                                    Đánh giá sản phẩm
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/feedback?orderId=${order.orderid}"
                                                                    class="w-full bg-amber-500 text-white py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:bg-amber-600 transition-all flex items-center justify-center gap-2">
                                                                    <span
                                                                        class="material-symbols-outlined text-sm">edit</span>
                                                                    Sửa đánh giá
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>

                                                        <%-- Return Request Section (shown only for Completed orders) --%>
                                                        <c:if test="${order.status == 'Completed'}">
                                                            <c:choose>
                                                                <c:when test="${not empty returnRequest}">
                                                                    <div class="w-full rounded-xl border p-4 text-xs space-y-2
                                                                        ${returnRequest.status == 'Pending'  ? 'bg-amber-50  border-amber-200'  : ''}
                                                                        ${returnRequest.status == 'Approved' ? 'bg-emerald-50 border-emerald-200' : ''}
                                                                        ${returnRequest.status == 'Rejected' ? 'bg-red-50   border-red-200'   : ''}">
                                                                        <div class="flex items-center justify-between">
                                                                            <span class="font-bold uppercase tracking-wider text-[10px] text-slate-400">Yêu Cầu Hoàn Trả</span>
                                                                            <span class="return-status-${returnRequest.status} font-bold uppercase text-[10px] tracking-wider px-2 py-1 rounded-full">${returnRequest.status}</span>
                                                                        </div>
                                                                        <p class="text-slate-600">Lý do: <span class="font-semibold">${returnRequest.reasonType}</span></p>
                                                                        <c:if test="${not empty returnRequest.reasonDetail}">
                                                                            <p class="text-slate-500">${returnRequest.reasonDetail}</p>
                                                                        </c:if>
                                                                        <c:if test="${not empty returnRequest.adminNote}">
                                                                            <p class="text-slate-500 italic">Phản hồi: ${returnRequest.adminNote}</p>
                                                                        </c:if>
                                                                        <%-- Evidence media display --%>
                                                                        <c:if test="${not empty returnRequest.evidenceUrls}">
                                                                            <div class="mt-2">
                                                                                <span class="font-bold uppercase tracking-wider text-[10px] text-slate-400 block mb-1.5">Bằng chứng đính kèm</span>
                                                                                <div class="flex flex-wrap gap-2">
                                                                                    <c:forEach var="evUrl" items="${returnRequest.evidenceUrls.split(',')}">
                                                                                        <c:set var="evTrimmed" value="${evUrl.trim()}" />
                                                                                        <c:choose>
                                                                                            <c:when test="${evTrimmed.endsWith('.mp4') || evTrimmed.endsWith('.mov') || evTrimmed.endsWith('.webm')}">
                                                                                                <video src="${pageContext.request.contextPath}/uploads/${evTrimmed}" controls
                                                                                                    class="w-24 h-24 object-cover rounded-lg border border-slate-200"
                                                                                                    style="max-width:96px;max-height:96px;"></video>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <img src="${pageContext.request.contextPath}/uploads/${evTrimmed}"
                                                                                                    class="w-16 h-16 object-cover rounded-lg border border-slate-200 hover:opacity-80 transition-opacity cursor-pointer"
                                                                                                    alt="Evidence"
                                                                                                    onclick="openLightbox('${pageContext.request.contextPath}/uploads/${evTrimmed}', 'image')">
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </c:forEach>
                                                                                </div>
                                                                            </div>
                                                                        </c:if>
                                                                        <div class="flex items-center justify-between gap-4 mt-2">
                                                                            <p class="text-slate-400">
                                                                                <fmt:formatDate value="${returnRequest.createdAt}" pattern="HH:mm dd/MM/yyyy" />
                                                                            </p>
                                                                            <c:if test="${returnRequest.status == 'Pending'}">
                                                                                <form action="${pageContext.request.contextPath}/order" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy yêu cầu hoàn đơn?')">
                                                                                    <input type="hidden" name="action" value="cancelReturn">
                                                                                    <input type="hidden" name="returnId" value="${returnRequest.returnId}">
                                                                                    <input type="hidden" name="orderId" value="${order.orderid}">
                                                                                    <button type="submit" class="text-red-500 hover:text-red-700 font-bold uppercase text-[10px] tracking-wider flex items-center gap-1 transition-colors">
                                                                                        <span class="material-icons-outlined text-xs">close</span>
                                                                                        Hủy Yêu Cầu
                                                                                    </button>
                                                                                </form>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button onclick="document.getElementById('returnModal').classList.add('active')"
                                                                        class="w-full bg-white border border-slate-200 text-red-500 py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:bg-red-50 hover:border-red-200 transition-all flex items-center justify-center gap-2">
                                                                        <span class="material-symbols-outlined text-sm">undo</span>
                                                                        Yêu Cầu Hoàn Trả
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>


                                                    <a href="${pageContext.request.contextPath}/order?action=history"
                                                        class="w-full bg-slate-900 text-white py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:opacity-90 transition-all flex items-center justify-center gap-2 text-center">
                                                        <span class="material-icons-outlined text-sm">arrow_back</span>
                                                        Back to History
                                                    </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                </main>

                <div id="cancelModal" class="modal">
                    <div class="glass-card bg-white/95 rounded-2xl w-full max-w-md p-8 shadow-2xl animate-scale-in">
                        <h3 class="font-serif text-2xl font-semibold text-slate-800 mb-2">Hủy Đơn Hàng</h3>
                        <p class="text-sm text-slate-500 mb-6">Xin vui lòng cho chúng tôi biết lý do bạn muốn hủy đơn
                            hàng này.</p>

                        <c:if test="${order.status == 'Processing' and order.paymentMethod == 'QR'}">
                            <div class="bg-amber-50 text-amber-800 text-xs p-3 rounded-lg border border-amber-200 mb-6">
                                <strong>Lưu ý:</strong> Đây là đơn hàng đã thanh toán qua mã QR. Sau khi hủy hành công,
                                yêu cầu hoàn tiền của bạn sẽ được chuyển đến bộ phận chăm sóc khách hàng. Thời gian hoàn
                                tiền thường từ 3-5 ngày làm việc.
                            </div>
                        </c:if>

                        <form id="cancelForm" action="${pageContext.request.contextPath}/order" method="post"
                            class="space-y-4">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="orderid" value="${order.orderid}">

                            <div class="space-y-2">
                                <c:forEach var="reason"
                                    items="${['Thay đổi địa chỉ giao hàng', 'Phí vận chuyển cao', 'Thời gian giao hàng quá lâu', 'Tìm thấy giá rẻ hơn ở nơi khác', 'Hủy để đặt lại đơn hàng khác', 'Other']}">
                                    <c:choose>
                                        <c:when test="${reason eq 'Thay đổi địa chỉ giao hàng'}">
                                            <%-- Special: opens address modal instead of cancelling --%>
                                            <button type="button" onclick="closeCancelModal(); openAddressModal();"
                                                class="w-full flex items-center gap-3 p-3.5 rounded-xl border border-sky-200 bg-sky-50/60 hover:bg-sky-100 hover:border-accent-blue/60 text-left cursor-pointer transition-all group">
                                                <span class="material-symbols-outlined text-accent-blue text-[20px]">edit_location_alt</span>
                                                <span class="text-sm font-medium text-accent-blue">Thay đổi địa chỉ giao hàng</span>
                                                <span class="ml-auto material-symbols-outlined text-xs text-accent-blue opacity-60 group-hover:opacity-100 transition-opacity">arrow_forward</span>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <label class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:border-accent-blue/30 hover:bg-sky-50/50 cursor-pointer transition-all">
                                                <input type="radio" name="reason" value="${reason}" required
                                                    onchange="handleReasonChange(this)"
                                                    class="text-accent-blue focus:ring-accent-blue">
                                                <span class="text-sm text-slate-600">
                                                    <c:choose>
                                                        <c:when test="${reason eq 'Other'}">Lý do khác...</c:when>
                                                        <c:otherwise>${reason}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </label>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>

                            <div id="otherReasonBox" class="hidden mt-4">
                                <textarea name="otherReasonText" rows="3"
                                    class="w-full bg-white/50 border border-slate-200 rounded-xl focus:ring-accent-blue focus:border-accent-blue text-sm p-4 outline-none"
                                    placeholder="Vui lòng cung cấp thêm chi tiết..."></textarea>
                            </div>

                            <div class="flex gap-3 mt-8">
                                <button type="button" onclick="closeCancelModal()"
                                    class="flex-1 py-3 text-[10px] uppercase font-bold tracking-widest text-slate-400 hover:text-slate-600 transition-colors bg-slate-100 rounded-lg">Quay
                                    lại</button>
                                <button type="submit" id="cancelSubmitBtn"
                                    class="flex-1 bg-red-500 text-white py-3 rounded-lg text-[10px] uppercase font-bold tracking-widest hover:bg-red-600 shadow-lg shadow-red-200 transition-all">Xác
                                    Nhận Hủy</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- ══════  ADDRESS CHANGE MODAL  ══════ --%>
                <div id="addressModal" class="modal">
                    <div class="glass-card bg-white/98 rounded-2xl w-full max-w-lg shadow-2xl animate-scale-in overflow-hidden">

                        <%-- Header --%>
                        <div class="bg-gradient-to-r from-[#024acf]/5 to-[#0288D1]/5 px-8 py-6 border-b border-sky-100 flex items-center justify-between">
                            <div>
                                <p class="text-[10px] uppercase tracking-[0.2em] font-bold text-accent-blue mb-1">Đơn hàng #${order.orderid}</p>
                                <h3 class="font-serif text-2xl font-semibold text-slate-800">Cập nhật địa chỉ</h3>
                            </div>
                            <button type="button" onclick="closeAddressModal()"
                                class="w-9 h-9 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-500 transition-colors">
                                <span class="material-symbols-outlined text-lg">close</span>
                            </button>
                        </div>

                        <%-- Body --%>
                        <div class="px-8 py-6 max-h-[70vh] overflow-y-auto">
                            <p class="text-sm text-slate-500 mb-6">Điền địa chỉ mới bên dưới. Đơn hàng sẽ được chuyển về trạng thái <strong class="text-slate-700">Chờ xác nhận</strong> sau khi lưu.</p>

                            <form id="addressUpdateForm" action="${pageContext.request.contextPath}/order" method="post" class="space-y-4">
                                <input type="hidden" name="action" value="updateAddress">
                                <input type="hidden" name="orderid" value="${order.orderid}">

                                <%-- Recipient --%>
                                <div class="grid grid-cols-2 gap-4">
                                    <div class="space-y-1.5">
                                        <label class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Tên người nhận <span class="text-red-400">*</span></label>
                                        <div class="relative">
                                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-300 text-[18px]">person</span>
                                            <input type="text" id="au_fullname" name="newFullname"
                                                class="w-full pl-9 pr-3 py-2.5 text-sm border border-slate-200 rounded-xl focus:ring-2 focus:ring-accent-blue/20 focus:border-accent-blue outline-none bg-white transition-all"
                                                placeholder="Nguyễn Văn A" value="${order.fullname}">
                                        </div>
                                    </div>
                                    <div class="space-y-1.5">
                                        <label class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Số điện thoại <span class="text-red-400">*</span></label>
                                        <div class="relative">
                                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-300 text-[18px]">phone</span>
                                            <input type="tel" id="au_phone" name="newPhone"
                                                class="w-full pl-9 pr-3 py-2.5 text-sm border border-slate-200 rounded-xl focus:ring-2 focus:ring-accent-blue/20 focus:border-accent-blue outline-none bg-white transition-all"
                                                placeholder="0912 345 678" value="${order.phone}">
                                        </div>
                                    </div>
                                </div>

                                 <%-- Province --%>
                                <div class="space-y-1.5">
                                    <label class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Tỉnh / Thành phố <span class="text-red-400">*</span></label>
                                    <div class="relative">
                                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-300 text-[18px] pointer-events-none">location_city</span>
                                        <select id="au_province" name="newProvince"
                                            class="w-full pl-9 pr-3 py-2.5 text-sm border border-slate-200 rounded-xl focus:ring-2 focus:ring-accent-blue/20 focus:border-accent-blue outline-none bg-white appearance-none transition-all"
                                            onchange="auLoadWardsByProvince(this.value)">
                                            <option value="">-- Chọn Tỉnh/Thành Phố --</option>
                                        </select>
                                    </div>
                                </div>

                                <%-- Ward --%>
                                <div class="space-y-1.5">
                                    <label class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Phường / Xã <span class="text-red-400">*</span></label>
                                    <div class="relative">
                                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-300 text-[18px] pointer-events-none">holiday_village</span>
                                        <select id="au_ward" name="newWard"
                                            class="w-full pl-9 pr-3 py-2.5 text-sm border border-slate-200 rounded-xl focus:ring-2 focus:ring-accent-blue/20 focus:border-accent-blue outline-none bg-white appearance-none transition-all"
                                            disabled>
                                            <option value="">-- Chọn Phường/Xã --</option>
                                        </select>
                                    </div>
                                </div>

                                <%-- Detail address --%>
                                <div class="space-y-1.5">
                                    <label class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Địa chỉ cụ thể <span class="text-red-400">*</span></label>
                                    <div class="relative">
                                        <span class="material-symbols-outlined absolute left-3 top-3 text-slate-300 text-[18px]">home</span>
                                        <input type="text" id="au_detail" name="newAddressDetail"
                                            class="w-full pl-9 pr-3 py-2.5 text-sm border border-slate-200 rounded-xl focus:ring-2 focus:ring-accent-blue/20 focus:border-accent-blue outline-none bg-white transition-all"
                                            placeholder="Số nhà, tên đường, tòa nhà...">
                                    </div>
                                </div>

                                <%-- Info note --%>
                                <div class="flex items-start gap-2 bg-amber-50 border border-amber-100 rounded-xl p-3 text-xs text-amber-700">
                                    <span class="material-symbols-outlined text-[16px] mt-0.5 flex-shrink-0">info</span>
                                    <span>Sau khi cập nhật, đơn hàng sẽ trở về trạng thái <strong>Chờ xác nhận</strong> để nhân viên kiểm tra và xác nhận lại.</span>
                                </div>

                                <%-- Buttons --%>
                                <div class="flex gap-3 pt-2">
                                    <button type="button" onclick="closeAddressModal(); openCancelModal();"
                                        class="flex-1 py-3 text-[10px] uppercase font-bold tracking-widest text-slate-400 hover:text-slate-600 transition-colors bg-slate-100 hover:bg-slate-200 rounded-xl">Quay lại</button>
                                    <button type="submit"
                                        class="flex-1 bg-gradient-to-r from-[#024acf] to-[#0288D1] text-white py-3 rounded-xl text-[10px] uppercase font-bold tracking-widest hover:opacity-90 shadow-lg shadow-blue-200 transition-all flex items-center justify-center gap-2">
                                        <span class="material-symbols-outlined text-sm">save</span>
                                        Lưu địa chỉ mới
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>


                <%-- ══════  RETURN REQUEST MODAL (Voucher Style) ══════ --%>
                <div id="returnModal" class="modal">
                    <div class="bg-slate-50 w-full max-w-md h-[90vh] md:h-[85vh] md:rounded-2xl flex flex-col relative overflow-hidden shadow-2xl animate-scale-in">
                        
                        <%-- Header --%>
                        <div class="bg-white px-6 py-5 flex items-center justify-between border-b border-slate-100 shrink-0">
                            <h3 class="text-xl font-semibold text-slate-800 tracking-tight">Yêu Cầu Hoàn Trả</h3>
                            <button type="button" onclick="document.getElementById('returnModal').classList.remove('active')"
                                class="text-slate-400 hover:text-slate-600 transition-colors flex items-center justify-center p-1">
                                <span class="material-symbols-outlined font-bold" style="font-size: 22px;">close</span>
                            </button>
                        </div>

                        <%-- Scrollable Body --%>
                        <%-- Scrollable Body --%>
                        <div class="flex-1 overflow-y-auto px-5 py-4 custom-scrollbar">
                            
                            <form id="returnForm" action="${pageContext.request.contextPath}/order" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="submitReturn">
                                <input type="hidden" name="orderid" value="${order.orderid}">

                                <div class="space-y-5">
                                    <%-- Info note --%>
                                    <div class="text-xs text-slate-500 leading-relaxed bg-white p-3.5 rounded-xl border border-slate-100 shadow-sm">
                                        Đơn hàng <strong>#${order.orderid}</strong>. Yêu cầu phải được gửi trong vòng <strong>7 ngày</strong> kể từ khi đơn hoàn thành.
                                    </div>

                                    <%-- Reason --%>
                                    <div>
                                        <p class="text-[11px] uppercase tracking-widest font-bold text-slate-400 mb-2.5">Lý do hoàn trả <span class="text-red-400">*</span></p>
                                        <div class="space-y-2" id="reasonTypeGroup">
                                            <c:forEach var="reason" items="${[
                                                'Hàng lỗi / hư hỏng',
                                                'Giao sai sản phẩm / sai màu / sai size',
                                                'Sản phẩm không đúng mô tả',
                                                'Thiếu phụ kiện / quà tặng kèm',
                                                'Tôi đổi ý / không còn cần nữa'
                                            ]}">
                                                <label class="flex items-center gap-3 p-3.5 bg-white rounded-xl border border-slate-100 hover:border-slate-300 cursor-pointer transition-all shadow-sm">
                                                    <input type="radio" name="reasonType" value="${reason}" class="w-4 h-4 text-slate-800 border-slate-300 focus:ring-slate-800" onchange="clearFieldError('reasonType')">
                                                    <span class="text-sm font-medium text-slate-700">${reason}</span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                        <p id="err-reasonType" class="text-red-500 text-xs mt-1.5 hidden"></p>
                                    </div>

                                    <%-- Detail --%>
                                    <div>
                                        <p class="text-[11px] uppercase tracking-widest font-bold text-slate-400 mb-2.5">Mô tả chi tiết <span class="text-red-400">*</span></p>
                                        <div class="relative bg-white rounded-xl border border-slate-100 shadow-sm p-3 hover:border-slate-300 transition-colors" id="reasonDetailWrap">
                                            <textarea name="reasonDetail" id="reasonDetailInput" rows="2"
                                                class="w-full bg-transparent border-0 focus:ring-0 text-sm p-0 outline-none resize-none"
                                                placeholder="Mô tả tình trạng hàng hóa..." oninput="clearFieldError('reasonDetail')"></textarea>
                                        </div>
                                        <p id="err-reasonDetail" class="text-red-500 text-xs mt-1.5 hidden"></p>
                                    </div>

                                    <%-- Evidence Media Upload (Shopee Style) --%>
                                    <div>
                                        <div class="mb-2">
                                            <p class="text-[11px] uppercase tracking-widest font-bold text-slate-400">Đăng tải hình ảnh hoặc video <span class="text-red-400">*</span></p>
                                        </div>
                                        <p class="text-xs text-slate-500 mb-3">1. Thấy rõ sản phẩm nhận được không phải sản phẩm người mua đã đặt</p>
                                        
                                        <div class="flex flex-wrap gap-3">
                                            <%-- Image Upload Box --%>
                                            <div id="imageUploadContainer" class="flex flex-wrap gap-3">
                                                <label class="w-24 h-24 border-2 border-dashed border-slate-200 rounded-lg flex flex-col items-center justify-center cursor-pointer hover:border-slate-400 hover:bg-slate-50 transition-all group shrink-0">
                                                    <span class="material-symbols-outlined text-2xl text-slate-400 group-hover:text-slate-600">photo_camera</span>
                                                    <span class="text-[10px] text-slate-500 mt-1 text-center leading-tight">Thêm Hình ảnh<br><span id="imgCount">(0/6)</span></span>
                                                    <input type="file" name="evidenceImages" id="evidenceImages" accept="image/*" multiple class="hidden" onchange="handleImageSelection(this)">
                                                </label>
                                            </div>

                                            <%-- Video Upload Box --%>
                                            <div id="videoUploadContainer" class="flex flex-wrap gap-3">
                                                <label id="videoUploadLabel" class="w-24 h-24 border-2 border-dashed border-slate-200 rounded-lg flex flex-col items-center justify-center cursor-pointer hover:border-slate-400 hover:bg-slate-50 transition-all group shrink-0">
                                                    <span class="material-symbols-outlined text-2xl text-slate-400 group-hover:text-slate-600">videocam</span>
                                                    <span class="text-[10px] text-slate-500 mt-1 text-center leading-tight">Thêm Video<br><span id="vidCount">(0/1)</span></span>
                                                    <input type="file" name="evidenceVideos" id="evidenceVideos" accept="video/*" class="hidden" onchange="handleVideoSelection(this)">
                                                </label>
                                            </div>
                                        </div>
                                        <div class="flex gap-10 mt-2">
                                            <span class="text-[10px] text-slate-400">Tối đa: 5MB</span>
                                            <span class="text-[10px] text-slate-400">Tối đa: 100MB</span>
                                        </div>
                                        <p id="err-evidence" class="text-red-500 text-xs mt-1.5 hidden"></p>
                                    </div>

                                    <%-- Bank Info --%>
                                    <div>
                                        <p class="text-[11px] uppercase tracking-widest font-bold text-slate-400 mb-2.5">Thông tin nhận tiền hoàn <span class="text-red-400">*</span></p>

                                        <div class="bg-white p-4 rounded-xl border border-slate-100 shadow-sm space-y-3">
                                            <div class="flex items-center justify-between pb-2.5 border-b border-slate-100">
                                                <span class="text-[10px] text-slate-500 font-semibold">Số tiền hoàn (dự kiến)</span>
                                                <span class="text-base font-bold text-blue-600">
                                                    <fmt:formatNumber value="${order.totalprice}" type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                </span>
                                            </div>
                                            <div class="relative" id="customBankSelect">
                                                <label class="text-[10px] text-slate-400 font-semibold block mb-0.5 uppercase tracking-wider">Ngân hàng</label>
                                                <input type="hidden" name="bankName" id="bankNameHidden" required>
                                                
                                                <button type="button" id="bankSelectBtn" class="w-full bg-transparent border-0 border-b border-slate-100 focus:border-slate-800 px-0 outline-none transition-colors font-medium flex items-center justify-between shadow-none relative pb-1.5 pt-1.5">
                                                    <div class="flex items-center gap-3 overflow-hidden" id="bankSelectContent">
                                                        <span class="text-slate-400 text-sm font-normal">Chọn ngân hàng</span>
                                                    </div>
                                                    <span class="material-symbols-outlined text-sm text-slate-400 flex-shrink-0 transition-transform duration-200" id="bankSelectIcon">expand_more</span>
                                                </button>
                                                
                                                <div id="bankDropdownMenu" class="absolute left-0 bottom-full mb-1 w-full bg-white border border-slate-100 rounded-xl shadow-2xl z-[999] opacity-0 invisible transition-all duration-200 translate-y-2 origin-bottom">
                                                    <div class="p-2 border-b border-slate-50 relative">
                                                        <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-[18px]">search</span>
                                                        <input type="text" id="bankSearchInput" autocomplete="off" placeholder="Tìm ngân hàng..." class="w-full bg-slate-50 border-0 rounded-lg text-xs py-2.5 pl-9 pr-3 focus:ring-1 focus:ring-slate-200 text-slate-700 outline-none">
                                                    </div>
                                                    <ul class="max-h-[220px] overflow-y-auto custom-scrollbar p-1.5 space-y-0.5" id="bankList">
                                                        <li class="p-4 text-center text-xs text-slate-400 flex items-center justify-center gap-2">
                                                            <span class="material-symbols-outlined animate-spin text-[16px]">sync</span> Đang tải...
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="relative mt-3">
                                                <label class="text-[10px] text-slate-400 font-semibold block mb-0.5 uppercase tracking-wider">Tên chủ thẻ</label>
                                                <input type="text" name="bankAccountName" placeholder="NGUYEN VAN A"
                                                    class="w-full bg-transparent border-0 border-b border-slate-100 focus:border-slate-800 focus:ring-0 text-sm py-1.5 px-0 outline-none transition-colors font-medium uppercase" 
                                                    required 
                                                    pattern="[a-zA-ZáàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ\s]+"
                                                    title="Tên chủ thẻ chỉ chứa chữ cái và khoảng trắng"
                                                    oninput="this.value = this.value.toUpperCase().replace(/[0-9!@#$%^&*()_+=\[\]{};':\\|.<>\/?,-]/g, '')">
                                            </div>
                                            <div class="relative mt-3">
                                                <label class="text-[10px] text-slate-400 font-semibold block mb-0.5 uppercase tracking-wider">Số tài khoản</label>
                                                <input type="text" name="bankAccountNumber" placeholder="0123456789"
                                                    class="w-full bg-transparent border-0 focus:ring-0 text-sm py-1.5 px-0 outline-none transition-colors font-medium tracking-wide" 
                                                    required 
                                                    pattern="[0-9]{8,15}" 
                                                    title="Số tài khoản ngân hàng phải từ 8 đến 15 chữ số"
                                                    oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="h-1"></div>
                            </form>
                        </div>

                        <%-- Sticky Footer --%>
                        <div class="bg-slate-50 p-6 shrink-0 border-t border-slate-200">
                            <button type="submit" form="returnForm"
                                class="w-full bg-transparent border border-slate-800 text-slate-800 py-4 rounded font-semibold text-[11px] uppercase tracking-[0.2em] hover:bg-slate-800 hover:text-white transition-all text-center">
                                GỬI YÊU CẦU HOÀN TRẢ
                            </button>
                        </div>
                    </div>
                </div>

                <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                <script>
                    const modal = document.getElementById("cancelModal");
                    const otherBox = document.getElementById("otherReasonBox");

                    function openCancelModal()  { modal.classList.add("active"); }
                    function closeCancelModal() { modal.classList.remove("active"); }

                    function openAddressModal() {
                        var am = document.getElementById("addressModal");
                        am.classList.add("active");
                        // Load provinces on first open
                        var pSel = document.getElementById("au_province");
                        if (pSel && pSel.options.length <= 1) auLoadProvinces();
                    }
                    function closeAddressModal() {
                        document.getElementById("addressModal").classList.remove("active");
                    }

                    let selectedImages = [];
                    let selectedVideo = null;

                    // ── Toast notification (replaces alert()) ────────────────────
                    function showReturnToast(msg, type) {
                        var existing = document.getElementById('returnToast');
                        if (existing) existing.remove();

                        var colors = type === 'error'
                            ? 'background:#fef2f2;color:#dc2626;border:1px solid #fecaca;'
                            : 'background:#f0fdf4;color:#16a34a;border:1px solid #bbf7d0;';
                        var icon = type === 'error' ? 'error' : 'check_circle';

                        var toast = document.createElement('div');
                        toast.id = 'returnToast';
                        toast.style.cssText = 'position:fixed;top:24px;left:50%;transform:translateX(-50%);z-index:99999;padding:12px 20px;border-radius:12px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px;box-shadow:0 4px 24px rgba(0,0,0,0.12);animation:toastIn 0.3s ease;max-width:90vw;' + colors;
                        toast.innerHTML = '<span class="material-symbols-outlined" style="font-size:18px;">' + icon + '</span>' + msg;
                        document.body.appendChild(toast);

                        setTimeout(function() {
                            toast.style.animation = 'toastOut 0.3s ease forwards';
                            setTimeout(function() { toast.remove(); }, 300);
                        }, 3500);
                    }

                    // ── Inline field error helpers ────────────────────────────────
                    function showFieldError(fieldId, msg) {
                        var el = document.getElementById('err-' + fieldId);
                        if (el) { el.textContent = msg; el.classList.remove('hidden'); }
                    }
                    function clearFieldError(fieldId) {
                        var el = document.getElementById('err-' + fieldId);
                        if (el) { el.textContent = ''; el.classList.add('hidden'); }
                    }
                    function clearAllErrors() {
                        document.querySelectorAll('[id^="err-"]').forEach(function(el) {
                            el.textContent = ''; el.classList.add('hidden');
                        });
                    }

                    function handleImageSelection(input) {
                        const files = Array.from(input.files);
                        clearFieldError('evidence');
                        if (selectedImages.length + files.length > 6) {
                            showReturnToast('Bạn chỉ có thể chọn tối đa 6 hình ảnh.', 'error');
                            input.value = ""; return;
                        }
                        
                        files.forEach(file => {
                            if (file.size > 5 * 1024 * 1024) {
                                showReturnToast('File ' + file.name + ' vượt quá giới hạn 5MB.', 'error');
                                return;
                            }
                            selectedImages.push(file);
                            renderImagePreviews();
                        });
                        input.value = "";
                    }

                    function renderImagePreviews() {
                        const container = document.getElementById('imageUploadContainer');
                        const imgCount = document.getElementById('imgCount');
                        
                        container.querySelectorAll('.preview-item').forEach(el => el.remove());
                        
                        const label = container.querySelector('label');
                        selectedImages.forEach((file, index) => {
                            const reader = new FileReader();
                            const div = document.createElement('div');
                            div.className = 'preview-item w-24 h-24 border border-slate-200 rounded-lg relative overflow-hidden shrink-0';
                            div.innerHTML = `
                                <img src="" class="w-full h-full object-cover">
                                <button type="button" onclick="removeImage(${index})" class="absolute top-0 right-0 bg-black/50 text-white w-5 h-5 flex items-center justify-center text-[10px] rounded-bl-lg hover:bg-black/70">&times;</button>
                            `;
                            reader.onload = (e) => div.querySelector('img').src = e.target.result;
                            reader.readAsDataURL(file);
                            container.insertBefore(div, label);
                        });

                        imgCount.textContent = `(${selectedImages.length}/6)`;
                        label.style.display = selectedImages.length >= 6 ? 'none' : 'flex';
                    }

                    function removeImage(index) {
                        selectedImages.splice(index, 1);
                        renderImagePreviews();
                    }

                    function handleVideoSelection(input) {
                        const file = input.files[0];
                        if (!file) return;
                        clearFieldError('evidence');
                        if (file.size > 100 * 1024 * 1024) {
                            showReturnToast('Video vượt quá giới hạn 100MB.', 'error');
                            input.value = ""; return;
                        }
                        selectedVideo = file;
                        renderVideoPreview();
                        input.value = "";
                    }

                    function renderVideoPreview() {
                        const container = document.getElementById('videoUploadContainer');
                        const vidCount = document.getElementById('vidCount');
                        const label = document.getElementById('videoUploadLabel');

                        container.querySelectorAll('.video-preview-item').forEach(el => el.remove());

                        if (selectedVideo) {
                            const div = document.createElement('div');
                            div.className = 'video-preview-item w-24 h-24 border border-slate-200 rounded-lg relative overflow-hidden bg-black shrink-0 flex items-center justify-center';
                            div.innerHTML = `
                                <span class="material-symbols-outlined text-white/50 text-2xl">play_circle</span>
                                <button type="button" onclick="removeVideo()" class="absolute top-0 right-0 bg-black/70 text-white w-5 h-5 flex items-center justify-center text-[10px] rounded-bl-lg hover:bg-black/90">&times;</button>
                                <div class="absolute bottom-1 left-1 right-1 bg-black/40 text-[8px] text-white px-1 truncate rounded">${selectedVideo.name}</div>
                            `;
                            container.insertBefore(div, label);
                            label.style.display = 'none';
                            vidCount.textContent = '(1/1)';
                        } else {
                            label.style.display = 'flex';
                            vidCount.textContent = '(0/1)';
                        }
                    }

                    function removeVideo() {
                        selectedVideo = null;
                        renderVideoPreview();
                    }

                    // Intercept form submit — full validation + fetch
                    document.getElementById('returnForm').onsubmit = function(e) {
                        e.preventDefault();
                        clearAllErrors();
                        var hasError = false;

                        // 1. Reason
                        if (!document.querySelector('input[name="reasonType"]:checked')) {
                            showFieldError('reasonType', 'Vui lòng chọn lý do hoàn trả.');
                            hasError = true;
                        }

                        // 2. Detail
                        var detail = document.getElementById('reasonDetailInput');
                        if (!detail || !detail.value.trim()) {
                            showFieldError('reasonDetail', 'Vui lòng mô tả chi tiết tình trạng hàng hóa.');
                            hasError = true;
                        }

                        // 3. Evidence
                        if (selectedImages.length === 0 && !selectedVideo) {
                            showFieldError('evidence', 'Vui lòng đăng tải ít nhất 1 hình ảnh hoặc video bằng chứng.');
                            hasError = true;
                        }

                        // 4. Bank
                        var bankName = document.getElementById('bankNameHidden');
                        var bankAccName = document.querySelector('input[name="bankAccountName"]');
                        var bankAccNum = document.querySelector('input[name="bankAccountNumber"]');
                        if (!bankName || !bankName.value) {
                            showReturnToast('Vui lòng chọn ngân hàng.', 'error');
                            hasError = true;
                        }
                        if (bankAccName && !bankAccName.value.trim()) {
                            showReturnToast('Vui lòng nhập tên chủ thẻ.', 'error');
                            hasError = true;
                        }
                        if (bankAccNum && !bankAccNum.value.trim()) {
                            showReturnToast('Vui lòng nhập số tài khoản.', 'error');
                            hasError = true;
                        }

                        if (hasError) {
                            showReturnToast('Vui lòng điền đầy đủ thông tin bắt buộc.', 'error');
                            return false;
                        }

                        const formData = new FormData(this);
                        formData.delete('evidenceImages');
                        formData.delete('evidenceVideos');
                        
                        selectedImages.forEach(file => {
                            formData.append('evidenceImages', file);
                        });
                        if (selectedVideo) {
                            formData.append('evidenceVideos', selectedVideo);
                        }

                        // Show loading state
                        var submitBtn = document.querySelector('button[form="returnForm"]');
                        if (submitBtn) {
                            submitBtn.disabled = true;
                            submitBtn.textContent = 'ĐANG GỬI...';
                        }

                        fetch(this.action, { method: 'POST', body: formData })
                        .then(r => {
                            if (r.redirected) {
                                window.location.href = r.url;
                            } else if (r.ok) {
                                window.location.href = '${pageContext.request.contextPath}/order?action=view&orderid=${order.orderid}&returnSubmitted=true';
                            } else {
                                showReturnToast('Đã xảy ra lỗi khi gửi yêu cầu.', 'error');
                                if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = 'GỬI YÊU CẦU HOÀN TRẢ'; }
                            }
                        })
                        .catch(err => {
                            console.error(err);
                            showReturnToast('Đã xảy ra lỗi kết nối. Vui lòng thử lại.', 'error');
                            if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = 'GỬI YÊU CẦU HOÀN TRẢ'; }
                        });
                    };

                    function updateFileLabel(input) {
                        // Obsolete with new UI
                    }

                    function handleReasonChange(radio) {
                        if (radio.value === 'Other') {
                            otherBox.classList.remove('hidden');
                        } else {
                            otherBox.classList.add('hidden');
                        }
                    }

                    function toggleOtherReason() {
                        const selected = document.querySelector('input[name="reason"]:checked');
                        if (selected) handleReasonChange(selected);
                    }

                    // ── Address Modal: Province / District / Ward API ────────────
                    function auLoadProvinces() {
                        const sel = document.getElementById('au_province');
                        sel.innerHTML = '<option value="">Đang tải...</option>';
                        fetch('https://provinces.open-api.vn/api/p/')
                            .then(r => r.json())
                            .then(data => {
                                sel.innerHTML = '<option value="">-- Chọn Tỉnh/Thành --</option>';
                                data.forEach(p => {
                                    sel.innerHTML += '<option value="' + p.code + '">' + p.name + '</option>';
                                });
                            })
                            .catch(() => { sel.innerHTML = '<option value="">Lỗi tải dữ liệu</option>'; });
                    }

                    // Load all wards in the selected province (skip district step)
                    function auLoadWardsByProvince(provinceCode) {
                        var wardSel = document.getElementById('au_ward');
                        wardSel.innerHTML = '<option value="">Đang tải...</option>';
                        wardSel.disabled = true;
                        if (!provinceCode) {
                            wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                            return;
                        }
                        fetch('https://provinces.open-api.vn/api/p/' + provinceCode + '?depth=3')
                            .then(function(r) { return r.json(); })
                            .then(function(data) {
                                wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                                var wards = [];
                                (data.districts || []).forEach(function(d) {
                                    (d.wards || []).forEach(function(w) {
                                        wards.push(w.name);
                                    });
                                });
                                wards.sort();
                                wards.forEach(function(name) {
                                    wardSel.innerHTML += '<option value="' + name + '">' + name + '</option>';
                                });
                                wardSel.disabled = false;
                            })
                            .catch(function() {
                                wardSel.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
                            });
                    }

                    // ── Address form validation ─────────────────────────────────
                    document.addEventListener('DOMContentLoaded', function() {
                        var addrForm = document.getElementById('addressUpdateForm');
                        if (addrForm) {
                            addrForm.addEventListener('submit', function(e) {
                                var fullname = document.getElementById('au_fullname').value.trim();
                                var phone    = document.getElementById('au_phone').value.trim();
                                var province = document.getElementById('au_province').value;
                                var ward     = document.getElementById('au_ward').value;
                                var detail   = document.getElementById('au_detail').value.trim();
                                // Accepts all Vietnamese 10-digit numbers: 03x 05x 07x 08x 09x
                                var phoneRx  = /^0[35789][0-9]{8}$/;
                                if (!fullname || !phone || !province || !ward || !detail) {
                                    e.preventDefault();
                                    alert('Vui lòng điền đầy đủ thông tin địa chỉ giao hàng mới.');
                                    return;
                                }
                                if (!phoneRx.test(phone)) {
                                    e.preventDefault();
                                    alert('Số điện thoại không hợp lệ (phải là số Việt Nam 10 chữ số).');
                                    document.getElementById('au_phone').focus();
                                }
                            });
                        }
                    });

                    // Custom Bank Select Logic
                    document.addEventListener('DOMContentLoaded', function() {
                        const bankSelectBtn = document.getElementById('bankSelectBtn');
                        const bankDropdownMenu = document.getElementById('bankDropdownMenu');
                        const bankSearchInput = document.getElementById('bankSearchInput');
                        const bankList = document.getElementById('bankList');
                        const bankNameHidden = document.getElementById('bankNameHidden');
                        const bankSelectContent = document.getElementById('bankSelectContent');
                        const bankSelectIcon = document.getElementById('bankSelectIcon');
                        
                        let allBanks = [];

                        // Fetch banks
                        fetch('https://api.vietqr.io/v2/banks')
                            .then(res => res.json())
                            .then(data => {
                                if(data.code === "00") {
                                    allBanks = data.data;
                                    renderBanks(allBanks);
                                } else {
                                    bankList.innerHTML = '<li class="p-4 text-center text-xs text-red-400">Không thể tải danh sách</li>';
                                }
                            })
                            .catch(err => {
                                bankList.innerHTML = '<li class="p-4 text-center text-xs text-red-400">Lỗi kết nối</li>';
                            });

                        function renderBanks(banks) {
                            if(banks.length === 0) {
                                bankList.innerHTML = '<li class="p-4 text-center text-xs text-slate-400">Không tìm thấy ngân hàng</li>';
                                return;
                            }
                            bankList.innerHTML = banks.map(bank => 
                                '<li class="bank-item flex items-center justify-between p-2 rounded-lg hover:bg-slate-50 cursor-pointer transition-colors"' +
                                '    data-name="' + bank.shortName + '" data-fullname="' + bank.name + '" data-logo="' + bank.logo + '">' +
                                '    <div class="flex items-center gap-3">' +
                                '        <div class="w-10 h-10 rounded bg-white border border-slate-100 flex items-center justify-center overflow-hidden flex-shrink-0 p-1">' +
                                '            <img src="' + bank.logo + '" alt="' + bank.shortName + '" class="w-full h-full object-contain" referrerpolicy="no-referrer">' +
                                '        </div>' +
                                '        <div class="flex flex-col">' +
                                '            <span class="text-sm font-semibold text-slate-700">' + bank.shortName + '</span>' +
                                '            <span class="text-[10px] text-slate-400 max-w-[200px] truncate">' + bank.name + '</span>' +
                                '        </div>' +
                                '    </div>' +
                                '</li>'
                            ).join('');
                            
                            // Add click events to items
                            const items = bankList.querySelectorAll('.bank-item');
                            items.forEach(item => {
                                item.addEventListener('click', (e) => {
                                    const shortName = item.dataset.name;
                                    const logoUrl = item.dataset.logo;
                                    
                                    // Update hidden input
                                    bankNameHidden.value = shortName;
                                    
                                    // Update display
                                    bankSelectContent.innerHTML = 
                                        '<div class="w-6 h-6 rounded bg-white border border-slate-100 flex items-center justify-center overflow-hidden flex-shrink-0 p-0.5">' +
                                        '    <img src="' + logoUrl + '" class="w-full h-full object-contain" referrerpolicy="no-referrer">' +
                                        '</div>' +
                                        '<span class="text-slate-800 text-sm font-semibold">' + shortName + '</span>';
                                    
                                    closeBankDropdown();
                                    
                                    // Clear error state if any
                                    bankSelectBtn.classList.remove('border-red-500', 'border-b');
                                });
                            });
                        }

                        function toggleBankDropdown(e) {
                            e.preventDefault();
                            const isOpen = bankDropdownMenu.classList.contains('opacity-100');
                            if(isOpen) {
                                closeBankDropdown();
                            } else {
                                openBankDropdown();
                            }
                        }

                        function openBankDropdown() {
                            bankDropdownMenu.classList.remove('opacity-0', 'invisible', 'translate-y-2');
                            bankDropdownMenu.classList.add('opacity-100', 'visible', 'translate-y-0');
                            bankSelectIcon.classList.add('rotate-180');
                            bankSearchInput.focus();
                        }

                        function closeBankDropdown() {
                            bankDropdownMenu.classList.add('opacity-0', 'invisible', 'translate-y-2');
                            bankDropdownMenu.classList.remove('opacity-100', 'visible', 'translate-y-0');
                            bankSelectIcon.classList.remove('rotate-180');
                        }

                        bankSelectBtn.addEventListener('click', toggleBankDropdown);

                        // Search functionality
                        bankSearchInput.addEventListener('input', (e) => {
                            const val = e.target.value.toLowerCase();
                            const filtered = allBanks.filter(b => 
                                b.shortName.toLowerCase().includes(val) || 
                                b.name.toLowerCase().includes(val) ||
                                (b.code && b.code.toLowerCase().includes(val))
                            );
                            renderBanks(filtered);
                        });

                        // Click outside to close
                        document.addEventListener('click', (e) => {
                            if(document.getElementById('customBankSelect') && !document.getElementById('customBankSelect').contains(e.target)) {
                                closeBankDropdown();
                            }
                        });
                        
                        // Validate on submit
                        const returnForm = document.getElementById('returnForm');
                        if (returnForm) {
                            returnForm.addEventListener('submit', function(e) {
                                if(!bankNameHidden.value) {
                                    e.preventDefault();
                                    bankSelectBtn.classList.add('border-red-500', 'border-b', 'border-2');
                                    bankSelectContent.innerHTML = '<span class="text-red-500 text-sm font-normal">Vui lòng chọn ngân hàng</span>';
                                }
                            });
                        }
                    });

                    // Handle browser back button
                    if (window.history && window.history.pushState) {
                        window.history.pushState(null, null, window.location.href);
                        window.onpopstate = function () {
                            window.location.href = "${pageContext.request.contextPath}/order?action=history";
                        };
                    }
                </script>

                <%-- ══════ LIGHTBOX OVERLAY ══════ --%>
                <div id="evidenceLightbox" onclick="closeLightbox()" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.85);z-index:9999;justify-content:center;align-items:center;cursor:zoom-out;">
                    <button onclick="closeLightbox()" style="position:absolute;top:20px;right:24px;background:rgba(255,255,255,0.15);border:none;color:#fff;width:40px;height:40px;border-radius:50%;font-size:20px;cursor:pointer;display:flex;align-items:center;justify-content:center;backdrop-filter:blur(4px);transition:background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.3)'" onmouseout="this.style.background='rgba(255,255,255,0.15)'">&times;</button>
                    <img id="lightboxImg" src="" alt="Evidence" style="display:none;max-width:90vw;max-height:85vh;border-radius:12px;box-shadow:0 20px 60px rgba(0,0,0,0.5);object-fit:contain;" onclick="event.stopPropagation()">
                    <video id="lightboxVid" src="" controls style="display:none;max-width:90vw;max-height:85vh;border-radius:12px;box-shadow:0 20px 60px rgba(0,0,0,0.5);" onclick="event.stopPropagation()"></video>
                </div>
                <script>
                    function openLightbox(src, type) {
                        var lb = document.getElementById('evidenceLightbox');
                        var img = document.getElementById('lightboxImg');
                        var vid = document.getElementById('lightboxVid');
                        img.style.display = 'none'; vid.style.display = 'none';
                        if (type === 'video') { vid.src = src; vid.style.display = 'block'; }
                        else { img.src = src; img.style.display = 'block'; }
                        lb.style.display = 'flex';
                        document.body.style.overflow = 'hidden';
                    }
                    function closeLightbox() {
                        var lb = document.getElementById('evidenceLightbox');
                        var vid = document.getElementById('lightboxVid');
                        lb.style.display = 'none';
                        vid.pause(); vid.src = '';
                        document.body.style.overflow = '';
                    }
                    document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeLightbox(); });
                </script>
            </body>

            </html>
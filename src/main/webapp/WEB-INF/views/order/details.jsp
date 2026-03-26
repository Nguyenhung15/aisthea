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

                        <%-- Return submitted success alert --%>
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
                                                        <span class="font-semibold">
                                                            <c:choose>
                                                                <c:when test="${order.paymentMethod eq 'QR'}">
                                                                    <span class="text-blue-600"> QR / Online</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-slate-700"> COD / Tiền mặt</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <%-- Paid / Unpaid badge --%>
                                                        <div class="flex justify-between">
                                                            <span class="text-slate-500">Paid Status</span>
                                                            <c:choose>
                                                                <c:when
                                                                    test="${order.status eq 'Completed' or (order.paymentMethod eq 'QR' and order.status ne 'Pending')}">
                                                                    <span class="text-emerald-600 font-bold">Đã thanh
                                                                        toán</span>
                                                                </c:when>
                                                                <c:when test="${order.status eq 'Cancelled'}">
                                                                    <span class="text-red-500 font-bold">Đã hủy</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-amber-600 font-bold">Chưa thanh
                                                                        toán</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="flex justify-between">
                                                            <span class="text-slate-500">Shipping</span>
                                                            <span
                                                                class="text-emerald-600 font-bold italic">Complimentary</span>
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
                                                                        <c:if test="${not empty returnRequest.adminNote}">
                                                                            <p class="text-slate-500 italic">Phản hồi: ${returnRequest.adminNote}</p>
                                                                        </c:if>
                                                                        <p class="text-slate-400">
                                                                            <fmt:formatDate value="${returnRequest.createdAt}" pattern="HH:mm dd/MM/yyyy" />
                                                                        </p>
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

                            <div class="space-y-3">
                                <c:forEach var="reason"
                                    items="${['Thay đổi địa chỉ giao hàng', 'Phí vận chuyển cao', 'Thời gian giao hàng quá lâu', 'Tìm thấy giá rẻ hơn ở nơi khác', 'Hủy để đặt lại đơn hàng khác', 'Other']}">
                                    <label
                                        class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:border-accent-blue/30 hover:bg-sky-50/50 cursor-pointer transition-all">
                                        <input type="radio" name="reason" value="${reason}" required
                                            onchange="toggleOtherReason()"
                                            class="text-accent-blue focus:ring-accent-blue">
                                        <span class="text-sm text-slate-600">
                                            <c:choose>
                                                <c:when test="${reason eq 'Other'}">Lý do khác...</c:when>
                                                <c:otherwise>${reason}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </label>
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
                                <button type="submit"
                                    class="flex-1 bg-red-500 text-white py-3 rounded-lg text-[10px] uppercase font-bold tracking-widest hover:bg-red-600 shadow-lg shadow-red-200 transition-all">Xác
                                    Nhận Hủy</button>
                            </div>
                        </form>
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
                                        <div class="space-y-2">
                                            <c:forEach var="reason" items="${[
                                                'Hàng lỗi / hư hỏng',
                                                'Giao sai sản phẩm / sai màu / sai size',
                                                'Sản phẩm không đúng mô tả',
                                                'Thiếu phụ kiện / quà tặng kèm',
                                                'Tôi đổi ý / không còn cần nữa'
                                            ]}">
                                                <label class="flex items-center gap-3 p-3.5 bg-white rounded-xl border border-slate-100 hover:border-slate-300 cursor-pointer transition-all shadow-sm">
                                                    <input type="radio" name="reasonType" value="${reason}" required class="w-4 h-4 text-slate-800 border-slate-300 focus:ring-slate-800">
                                                    <span class="text-sm font-medium text-slate-700">${reason}</span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <%-- Detail --%>
                                    <div>
                                        <p class="text-[11px] uppercase tracking-widest font-bold text-slate-400 mb-2.5">Mô tả chi tiết <span class="text-red-400">*</span></p>
                                        <div class="relative bg-white rounded-xl border border-slate-100 shadow-sm p-3 hover:border-slate-300 transition-colors">
                                            <textarea name="reasonDetail" rows="2"
                                                class="w-full bg-transparent border-0 focus:ring-0 text-sm p-0 outline-none resize-none"
                                                placeholder="Mô tả tình trạng hàng hóa..." required></textarea>
                                        </div>
                                    </div>

                                    <%-- Evidence: File Upload --%>
                                    <div>
                                        <p class="text-[11px] uppercase tracking-widest font-bold text-slate-400 mb-2.5">Hình ảnh / Video bằng chứng <span class="text-red-400">*</span></p>
                                        <label class="relative bg-white rounded-xl border-2 border-dashed border-slate-200 p-5 hover:border-slate-400 transition-colors cursor-pointer flex flex-col items-center justify-center gap-1.5 group">
                                            <span class="material-symbols-outlined text-3xl text-slate-300 group-hover:text-slate-500 transition-colors">cloud_upload</span>
                                            <span class="text-sm font-medium text-slate-500 group-hover:text-slate-700 transition-colors text-center px-2" id="evidenceFileName">Chọn ảnh / video từ máy</span>
                                            <span class="text-[10px] text-slate-400">JPG, PNG, MP4 (tối đa 10MB)</span>
                                            <input type="file" name="evidenceFiles" accept="image/*,video/*" multiple required
                                                class="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                                                onchange="updateFileLabel(this)">
                                        </label>
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

                    function openCancelModal() { modal.classList.add("active"); }
                    function closeCancelModal() { modal.classList.remove("active"); }

                    function updateFileLabel(input) {
                        const label = document.getElementById('evidenceFileName');
                        if (input.files.length > 0) {
                            const names = Array.from(input.files).map(f => f.name);
                            label.textContent = names.length + ' file đã chọn: ' + names.join(', ');
                            label.classList.add('text-slate-800');
                        } else {
                            label.textContent = 'Chọn ảnh hoặc video từ máy';
                            label.classList.remove('text-slate-800');
                        }
                    }

                    function toggleOtherReason() {
                        const selected = document.querySelector('input[name="reason"]:checked');
                        if (selected && selected.value === "Other") {
                            otherBox.classList.remove("hidden");
                        } else {
                            otherBox.classList.add("hidden");
                        }
                    }

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
            </body>

            </html>
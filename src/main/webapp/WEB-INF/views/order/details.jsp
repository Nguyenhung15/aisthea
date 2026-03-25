<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
                                                            <img class="w-full h-full object-cover"
                                                                src="${item.imageUrl}" alt="${item.productName}"
                                                                onerror="this.src='https://placehold.co/100x120?text=No+Image'" />
                                                        </div>
                                                        <div class="flex-grow">
                                                            <h3 class="text-sm font-semibold text-slate-900 hover:text-accent-blue transition-colors">
                                                                ${item.productName}
                                                            </h3>
                                                            <p class="text-xs text-slate-500 italic mt-1">${item.color} / Size ${item.size}</p>
                                                            <p class="text-[10px] text-slate-400 mt-2 font-bold uppercase tracking-wider">Qty: ${item.quantity}</p>
                                                        </div>
                                                        <div class="text-right">
                                                            <p class="text-sm font-bold text-slate-900">
                                                                <fmt:formatNumber value="${item.price * item.quantity}"
                                                                    type="currency" currencyCode="VND"
                                                                    maxFractionDigits="0" />
                                                            </p>
                                                            <p class="text-[10px] text-slate-400 mt-1">
                                                                <fmt:formatNumber value="${item.price}" type="number" />/unit
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
                                                    <div class="flex justify-between items-center relative pl-4 border-l-[2px] border-emerald-500">
                                                        <span class="text-slate-500">Ngày đặt hàng</span>
                                                        <span class="font-medium text-slate-900 text-right text-xs">
                                                            <fmt:formatDate value="${order.createdat}" pattern="HH:mm — dd/MM/yyyy" />
                                                        </span>
                                                        <div class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-emerald-500 ring-4 ring-white"></div>
                                                    </div>
                                                    
                                                    <c:if test="${order.confirmedAt != null}">
                                                        <div class="flex justify-between items-center relative pl-4 border-l-[2px] border-emerald-500">
                                                            <span class="text-slate-500">Chờ lấy hàng</span>
                                                            <span class="font-medium text-slate-900 text-right text-xs">
                                                                <fmt:formatDate value="${order.confirmedAt}" pattern="HH:mm — dd/MM/yyyy" />
                                                            </span>
                                                            <div class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-emerald-500 ring-4 ring-white"></div>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <c:if test="${order.shippedAt != null}">
                                                        <div class="flex justify-between items-center relative pl-4 border-l-[2px] border-blue-500">
                                                            <span class="text-slate-500">Đang giao hàng</span>
                                                            <span class="font-medium text-slate-900 text-right text-xs">
                                                                <fmt:formatDate value="${order.shippedAt}" pattern="HH:mm — dd/MM/yyyy" />
                                                            </span>
                                                            <div class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-blue-500 ring-4 ring-white"></div>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <c:if test="${order.completedAt != null}">
                                                        <div class="flex justify-between items-center relative pl-4 border-l-[2px] border-indigo-500">
                                                            <span class="text-slate-500 text-indigo-600 font-bold">Hoàn thành</span>
                                                            <span class="font-medium text-slate-900 text-right text-xs">
                                                                <fmt:formatDate value="${order.completedAt}" pattern="HH:mm — dd/MM/yyyy" />
                                                            </span>
                                                            <div class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-indigo-500 ring-4 ring-white"></div>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${order.status eq 'Cancelled'}">
                                                        <div class="flex justify-between items-center relative pl-4 border-l-[2px] border-red-500">
                                                            <span class="text-slate-500 text-red-500 font-bold">Đã hủy</span>
                                                            <span class="font-medium text-slate-900 text-right text-xs">
                                                                <fmt:formatDate value="${order.updatedat}" pattern="HH:mm — dd/MM/yyyy" />
                                                            </span>
                                                            <div class="absolute -left-[5px] top-1.5 w-2 h-2 rounded-full bg-red-500 ring-4 ring-white"></div>
                                                        </div>
                                                        
                                                        <div class="mt-2 bg-red-50 p-3 rounded-lg border border-red-100">
                                                            <p class="text-xs text-red-600 font-semibold mb-1">Lý do hủy:</p>
                                                            <p class="text-xs text-red-800">${empty order.cancelReason ? "Không có dữ liệu" : order.cancelReason}</p>
                                                            <c:if test="${not empty order.refundStatus}">
                                                                <div class="mt-2 pt-2 border-t border-red-200 flex justify-between">
                                                                    <span class="text-[10px] text-slate-500 font-bold uppercase tracking-wider">Hoàn tiền (QR)</span>
                                                                    <c:choose>
                                                                        <c:when test="${order.refundStatus eq 'Pending'}">
                                                                            <span class="text-[10px] text-amber-600 font-bold uppercase tracking-wider">Đang chờ xử lý</span>
                                                                        </c:when>
                                                                        <c:when test="${order.refundStatus eq 'Completed'}">
                                                                            <span class="text-[10px] text-emerald-600 font-bold uppercase tracking-wider">Đã hoàn thành</span>
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
                                                        <c:when test="${order.status eq 'Completed' or (order.paymentMethod eq 'QR' and order.status ne 'Pending')}">  
                                                            <span class="text-emerald-600 font-bold">Đã thanh toán</span>
                                                        </c:when>
                                                        <c:when test="${order.status eq 'Cancelled'}">
                                                            <span class="text-red-500 font-bold">Đã hủy</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-amber-600 font-bold">Chưa thanh toán</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="flex justify-between">
                                                    <span class="text-slate-500">Shipping</span>
                                                    <span class="text-emerald-600 font-bold italic">Complimentary</span>
                                                </div>
                                                <c:if test="${order.tierDiscount != null && order.tierDiscount > 0}">
                                                <div class="flex justify-between">
                                                    <span class="text-amber-600 flex items-center gap-1">
                                                        <span class="material-symbols-outlined text-sm">star</span>
                                                        Ưu đãi ${order.tierName}
                                                    </span>
                                                    <span class="text-amber-600 font-semibold">-<fmt:formatNumber value="${order.tierDiscount}" type="currency" currencyCode="VND" maxFractionDigits="0" /></span>
                                                </div>
                                                </c:if>
                                                <c:if test="${order.discountAmount != null && order.discountAmount > 0}">
                                                <div class="flex justify-between">
                                                    <span class="text-slate-500">Giảm giá (Voucher)</span>
                                                    <span class="text-red-500 font-semibold">-<fmt:formatNumber value="${order.discountAmount}" type="currency" currencyCode="VND" maxFractionDigits="0" /></span>
                                                </div>
                                                </c:if>
                                                <div
                                                    class="pt-4 border-t border-sky-100 flex justify-between items-baseline">
                                                    <span class="text-lg font-bold text-slate-900">Total</span>
                                                    <span class="text-2xl font-bold text-accent-blue">
                                                        <fmt:formatNumber value="${order.totalprice}" type="currency"
                                                            currencyCode="VND" maxFractionDigits="0" />
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
                                                <c:if test="${order.status == 'Pending' or order.status == 'Processing'}">
                                                    <button onclick="openCancelModal()"
                                                        class="w-full bg-white border border-slate-200 text-slate-600 py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:bg-red-50 hover:text-red-600 hover:border-red-100 transition-all flex items-center justify-center gap-2">
                                                        <span class="material-symbols-outlined text-sm">cancel</span>
                                                        Hủy Đơn Hàng
                                                    </button>
                                                </c:if>

                                                <%-- Single review button — new multi-product feedback page handles all products at once --%>
                                                <c:if test="${order.status == 'Completed'}">
                                                    <c:set var="anyUnreviewed" value="false"/>
                                                    <c:forEach var="item" items="${order.items}">
                                                        <c:if test="${!reviewedProductIds.contains(item.productId)}">
                                                            <c:set var="anyUnreviewed" value="true"/>
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:choose>
                                                        <c:when test="${anyUnreviewed}">
                                                            <a href="${pageContext.request.contextPath}/feedback?orderId=${order.orderid}"
                                                                class="w-full bg-accent-blue text-white py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:bg-primary transition-all flex items-center justify-center gap-2">
                                                                <span class="material-symbols-outlined text-sm">star</span>
                                                                Đánh giá sản phẩm
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/feedback?orderId=${order.orderid}"
                                                                class="w-full bg-amber-500 text-white py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:bg-amber-600 transition-all flex items-center justify-center gap-2">
                                                                <span class="material-symbols-outlined text-sm">edit</span>
                                                                Sửa đánh giá
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>


                                                <a href="${pageContext.request.contextPath}/order?action=history"
                                                    class="w-full bg-slate-900 text-white py-4 rounded-lg text-[10px] uppercase tracking-[0.2em] font-bold hover:opacity-90 transition-all flex items-center justify-center gap-2 text-center">
                                                    <span class="material-icons-outlined text-sm">arrow_back</span> Back to History
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                </main>

                <div id="cancelModal" class="modal">
                    <div class="glass-card bg-white/95 rounded-2xl w-full max-w-md p-8 shadow-2xl animate-scale-in">
                        <h3 class="font-serif text-2xl font-semibold text-slate-800 mb-2">Hủy Đơn Hàng</h3>
                        <p class="text-sm text-slate-500 mb-6">Xin vui lòng cho chúng tôi biết lý do bạn muốn hủy đơn hàng này.</p>
                        
                        <c:if test="${order.status == 'Processing' and order.paymentMethod == 'QR'}">
                            <div class="bg-amber-50 text-amber-800 text-xs p-3 rounded-lg border border-amber-200 mb-6">
                                <strong>Lưu ý:</strong> Đây là đơn hàng đã thanh toán qua mã QR. Sau khi hủy hành công, yêu cầu hoàn tiền của bạn sẽ được chuyển đến bộ phận chăm sóc khách hàng. Thời gian hoàn tiền thường từ 3-5 ngày làm việc.
                            </div>
                        </c:if>

                        <form id="cancelForm" action="${pageContext.request.contextPath}/order" method="post" class="space-y-4">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="orderid" value="${order.orderid}">

                            <div class="space-y-3">
                                <c:forEach var="reason" items="${['Thay đổi địa chỉ giao hàng', 'Phí vận chuyển cao', 'Thời gian giao hàng quá lâu', 'Tìm thấy giá rẻ hơn ở nơi khác', 'Hủy để đặt lại đơn hàng khác', 'Other']}">
                                    <label class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:border-accent-blue/30 hover:bg-sky-50/50 cursor-pointer transition-all">
                                        <input type="radio" name="reason" value="${reason}" required onchange="toggleOtherReason()" class="text-accent-blue focus:ring-accent-blue">
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
                                <textarea name="otherReasonText" rows="3" class="w-full bg-white/50 border border-slate-200 rounded-xl focus:ring-accent-blue focus:border-accent-blue text-sm p-4 outline-none" placeholder="Vui lòng cung cấp thêm chi tiết..."></textarea>
                            </div>

                            <div class="flex gap-3 mt-8">
                                <button type="button" onclick="closeCancelModal()"
                                    class="flex-1 py-3 text-[10px] uppercase font-bold tracking-widest text-slate-400 hover:text-slate-600 transition-colors bg-slate-100 rounded-lg">Quay lại</button>
                                <button type="submit"
                                    class="flex-1 bg-red-500 text-white py-3 rounded-lg text-[10px] uppercase font-bold tracking-widest hover:bg-red-600 shadow-lg shadow-red-200 transition-all">Xác Nhận Hủy</button>
                            </div>
                        </form>
                    </div>
                </div>

                <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                <script>
                    const modal = document.getElementById("cancelModal");
                    const otherBox = document.getElementById("otherReasonBox");

                    function openCancelModal() { modal.classList.add("active"); }
                    function closeCancelModal() { modal.classList.remove("active"); }

                    function toggleOtherReason() {
                        const selected = document.querySelector('input[name="reason"]:checked');
                        if (selected && selected.value === "Other") {
                            otherBox.classList.remove("hidden");
                        } else {
                            otherBox.classList.add("hidden");
                        }
                    }

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
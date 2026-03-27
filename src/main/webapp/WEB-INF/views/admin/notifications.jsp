<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="include/head_admin.jsp" />
    <title>Thông báo hệ thống | AISTHÉA Admin</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --color-primary: #0f1b2d;
            --color-secondary: #cba35c;
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(255, 255, 255, 0.4);
        }

        .notif-wrapper {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        .notif-card-container {
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 40px;
            min-height: 500px;
        }

        .notif-header-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .lux-title h1 {
            font-family: var(--font-serif);
            font-size: 2.25rem;
            color: var(--color-primary);
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .lux-title p { color: #64748b; font-size: 0.95rem; }

        .filter-ribbon {
            display: flex;
            gap: 12px;
            margin-bottom: 30px;
            overflow-x: auto;
            padding-bottom: 10px;
        }

        .filter-pills {
            padding: 10px 24px;
            border-radius: 50px;
            background: rgba(15, 27, 45, 0.05);
            color: #64748b;
            font-weight: 600;
            font-size: 0.85rem;
            border: 1px solid transparent;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            white-space: nowrap;
        }

        .filter-pills:hover { background: rgba(15, 27, 45, 0.1); transform: translateY(-1px); }
        .filter-pills.active { background: var(--color-primary); color: #fff; box-shadow: 0 4px 15px rgba(15, 27, 45, 0.2); }

        .notif-item {
            display: flex;
            align-items: center;
            padding: 24px;
            border-radius: 16px;
            background: #fff;
            margin-bottom: 16px;
            border: 1px solid #e2e8f0;
            transition: all 0.3s;
            cursor: pointer;
            animation: fadeIn 0.4s ease-out forwards;
        }

        .notif-item:hover {
            border-color: var(--color-secondary);
            transform: scale(1.01);
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
        }

        .notif-item.unread {
            background: linear-gradient(to right, rgba(203, 163, 92, 0.05), #fff);
            border-left: 4px solid var(--color-secondary);
        }

        .item-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-right: 24px;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .icon-order { background: #0f172a; color: #fff; }
        .icon-support { background: #cba35c; color: #fff; }
        .icon-return { background: #ef4444; color: #fff; }
        .icon-sys { background: #f8fafc; color: #64748b; border: 1px solid #e2e8f0; }

        .item-content { flex: 1; min-width: 0; }
        .item-title { font-weight: 700; font-size: 1.05rem; color: #0f172a; margin-bottom: 5px; }
        .item-text { color: #64748b; font-size: 0.9rem; line-height: 1.5; margin: 0; }

        .item-side { text-align: right; margin-left: 20px; min-width: 100px; }
        .item-time { font-size: 0.75rem; color: #94a3b8; font-weight: 500; font-variant-numeric: tabular-nums; }
        .item-badge {
            display: inline-block;
            margin-top: 10px;
            padding: 2px 10px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-unread { background: var(--color-secondary); color: #fff; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .swal2-popup { border-radius: 24px !important; font-family: 'Inter', sans-serif !important; }
        .swal2-styled.swal2-confirm { background-color: var(--color-primary) !important; border-radius: 12px !important; padding: 12px 30px !important; }
        .swal2-styled.swal2-cancel { border-radius: 12px !important; }

        .empty-state {
            text-align: center;
            padding: 100px 20px;
            color: #94a3b8;
        }
        .empty-icon { font-size: 4rem; color: #cbd5e1; margin-bottom: 20px; }

        .mark-all-form { margin: 0; }
        .btn-ghost {
            background: transparent;
            border: 1px solid #e2e8f0;
            color: #64748b;
            padding: 8px 16px;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-ghost:hover { background: #f8fafc; color: var(--color-primary); border-color: var(--color-primary); }
    </style>
</head>

<body class="luxury-admin">
    <jsp:include page="include/sidebar_admin.jsp" />
    <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

    <main class="lux-main">
        <div class="notif-wrapper">
            
            <div class="notif-header-info">
                <div class="lux-title">
                    <h1>System Notifications</h1>
                    <p>Administrative control center for orders, support, and returns.</p>
                </div>
                <div class="lux-actions">
                    <form action="${pageContext.request.contextPath}/admin-notifs" method="post" class="mark-all-form">
                        <input type="hidden" name="action" value="markAllRead">
                        <button type="submit" class="btn-ghost">
                            <i class="fa-solid fa-check-double"></i> Mark All as Read
                        </button>
                    </form>
                </div>
            </div>

            <div class="notif-card-container">
                <div class="filter-ribbon">
                    <button class="filter-pills ${activeType eq 'ALL' ? 'active' : ''}" onclick="window.location.href='?type=ALL'">All Updates</button>
                    <button class="filter-pills ${activeType eq 'ORDER' ? 'active' : ''}" onclick="window.location.href='?type=ORDER'">Orders & Logistics</button>
                    <button class="filter-pills ${activeType eq 'SUPPORT' or activeType eq 'CHAT' ? 'active' : ''}" onclick="window.location.href='?type=SUPPORT'">Customer Support</button>
                    <button class="filter-pills ${activeType eq 'RETURN' ? 'active' : ''}" onclick="window.location.href='?type=RETURN'">Return Requests</button>
                </div>

                <div class="notif-stream">
                    <%-- === STRICT JSP-LEVEL FILTER: Only show CHAT, SUPPORT, RETURN, ORDER === --%>
                    <c:set var="hasAdminNotifs" value="false" />
                    <c:forEach var="n" items="${notifications}">
                        <c:if test="${n.type eq 'ORDER' or n.type eq 'ORDER_CONFIRM' or n.type eq 'CHAT' or n.type eq 'SUPPORT' or n.type eq 'RETURN'}">
                            <c:set var="hasAdminNotifs" value="true" />
                            <div class="notif-item ${!n.read ? 'unread' : ''}" onclick="handleAdminFlow('${n.notificationId}', '${n.type}', '${n.targetId}', this)"
                                 data-title="<c:out value='${n.title}' escapeXml='true'/>"
                                 data-content="<c:out value='${n.content}' escapeXml='true'/>">
                                <div class="item-icon icon-${(n.type eq 'ORDER' or n.type eq 'ORDER_CONFIRM') ? 'order' : (n.type eq 'SUPPORT' or n.type eq 'CHAT') ? 'support' : (n.type eq 'RETURN') ? 'return' : 'sys'}">
                                    <c:choose>
                                        <c:when test="${n.type eq 'ORDER' or n.type eq 'ORDER_CONFIRM'}"><i class="fa-solid fa-receipt"></i></c:when>
                                        <c:when test="${n.type eq 'SUPPORT' or n.type eq 'CHAT'}"><i class="fa-solid fa-headset"></i></c:when>
                                        <c:when test="${n.type eq 'RETURN'}"><i class="fa-solid fa-parachute-box"></i></c:when>
                                        <c:otherwise><i class="fa-solid fa-satellite-dish"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="item-content">
                                    <h3 class="item-title"><c:out value="${n.title}" /></h3>
                                    <p class="item-text"><c:out value="${n.content}" /></p>
                                </div>
                                <div class="item-side">
                                    <div class="item-time"><fmt:formatDate value="${n.createdAt}" pattern="MMM dd, HH:mm" /></div>
                                    <c:if test="${!n.read}"><span class="item-badge badge-unread">New</span></c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${!hasAdminNotifs or empty notifications}">
                        <div class="empty-state">
                            <i class="fa-solid fa-sparkles empty-icon"></i>
                            <h3>Inbox is empty</h3>
                            <p>Good job! No notifications requiring immediate action in this category.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>

    <script>
        async function handleAdminFlow(notifId, type, targetId, element) {
            const ctx = '${pageContext.request.contextPath}';
            const content = element.getAttribute('data-content') || '';
            const title = element.getAttribute('data-title') || '';

            // Step 1: Mark as read silently
            try {
                await fetch(ctx + '/notifications/api?action=markRead&id=' + notifId, { method: 'POST' });
                // Remove the "unread" style immediately
                element.classList.remove('unread');
                var badge = element.querySelector('.badge-unread');
                if (badge) badge.remove();
            } catch (e) {}

            // Step 2: Extract the real order ID from notification content 
            // Content format is: "Đơn hàng #48 - Trạng thái: Đã hủy"
            function extractOrderId(text) {
                var match = text.match(/#(\d+)/);
                return match ? match[1] : null;
            }

            // Step 3: Check if notification content indicates a non-actionable status
            function isOrderCancelled(text) {
                var lower = text.toLowerCase();
                return lower.includes('đã hủy') || lower.includes('cancelled');
            }
            function isOrderCompleted(text) {
                var lower = text.toLowerCase();
                return lower.includes('hoàn thành') || lower.includes('completed') || lower.includes('đã thanh toán') || lower.includes('paid');
            }
            function isOrderPending(text) {
                var lower = text.toLowerCase();
                return lower.includes('chờ xác nhận') || lower.includes('pending');
            }
            function isOrderShipping(text) {
                var lower = text.toLowerCase();
                return lower.includes('đang giao') || lower.includes('shipping');
            }

            // Step 4: Specialized Logic based on notification type
            if (type === 'ORDER' || type === 'ORDER_CONFIRM') {
                var orderId = extractOrderId(content) || targetId;
                
                if (!orderId || orderId === '0') {
                    // No valid order ID found, just go to order list
                    Swal.fire({
                        title: 'Thông báo đơn hàng',
                        html: '<p>' + content + '</p>',
                        icon: 'info',
                        confirmButtonText: 'Quản lý đơn hàng'
                    }).then(function() {
                        window.location.href = ctx + '/order?action=list';
                    });
                    return;
                }

                if (isOrderCancelled(content)) {
                    // Order is already cancelled - just show info, no confirmation
                    Swal.fire({
                        title: 'Đơn hàng đã hủy',
                        html: '<p>Đơn hàng <strong>#' + orderId + '</strong> đã được hủy.</p>',
                        icon: 'info',
                        confirmButtonText: 'Xem chi tiết',
                        showCancelButton: true,
                        cancelButtonText: 'Đóng',
                        reverseButtons: true
                    }).then(function(result) {
                        if (result.isConfirmed) {
                            window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                        }
                    });
                } else if (isOrderCompleted(content)) {
                    // Order is completed - just show info
                    Swal.fire({
                        title: 'Đơn hàng hoàn thành',
                        html: '<p>Đơn hàng <strong>#' + orderId + '</strong> đã hoàn thành.</p>',
                        icon: 'success',
                        confirmButtonText: 'Xem chi tiết',
                        showCancelButton: true,
                        cancelButtonText: 'Đóng',
                        reverseButtons: true
                    }).then(function(result) {
                        if (result.isConfirmed) {
                            window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                        }
                    });
                } else if (isOrderPending(content)) {
                    // Order is PENDING -> Show confirmation to approve
                    Swal.fire({
                        title: 'Xác nhận đơn hàng',
                        html: '<p>Duyệt đơn hàng <strong>#' + orderId + '</strong> và cập nhật trạng thái sang <strong>"Processing"</strong>?</p>',
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonText: 'Đồng ý',
                        cancelButtonText: 'Xem chi tiết',
                        reverseButtons: true
                    }).then(function(result) {
                        if (result.isConfirmed) {
                            window.location.href = ctx + '/order?action=adminUpdateStatus&orderId=' + orderId + '&newStatus=Processing';
                        } else if (result.dismiss === Swal.DismissReason.cancel) {
                            window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                        }
                    });
                } else {
                    // Other order status (e.g., shipping, confirmed) - just view details
                    Swal.fire({
                        title: 'Chi tiết đơn hàng',
                        html: '<p>' + content + '</p>',
                        icon: 'info',
                        confirmButtonText: 'Xem chi tiết',
                        showCancelButton: true,
                        cancelButtonText: 'Đóng',
                        reverseButtons: true
                    }).then(function(result) {
                        if (result.isConfirmed) {
                            window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                        }
                    });
                }
            } else if (type === 'RETURN') {
                var orderId = extractOrderId(content) || targetId;
                Swal.fire({
                    title: 'Yêu cầu hoàn hàng',
                    html: '<p>Khách hàng yêu cầu hoàn trả đơn hàng <strong>#' + orderId + '</strong>. Bạn muốn xem chi tiết để xử lý?</p>',
                    icon: 'warning',
                    confirmButtonText: 'Xem chi tiết',
                    showCancelButton: true,
                    cancelButtonText: 'Đóng',
                    reverseButtons: true
                }).then(function(result) {
                    if (result.isConfirmed) {
                        window.location.href = ctx + '/order?action=adminViewDetail&id=' + orderId;
                    }
                });
            } else if (type === 'SUPPORT' || type === 'CHAT') {
                window.location.href = ctx + '/chat?action=manage&convoId=' + targetId;
            } else {
                window.location.reload();
            }
        }
    </script>
</body>
</html>

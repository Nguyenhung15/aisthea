<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Hub — AISTHÉA Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
    <style>
        .eh-header { margin-bottom: 2rem; }
        .eh-header h1 { font-family:'Playfair Display',serif; font-size:1.8rem; font-weight:700; color:#0f1b2d; margin:0 0 .25rem; display:flex; align-items:center; gap:.6rem; }
        .eh-header p  { color:#8896a6; font-size:.9rem; margin:0; }

        /* Stats */
        .eh-stats { display:grid; grid-template-columns:repeat(auto-fill,minmax(180px,1fr)); gap:1.25rem; margin-bottom:2rem; }
        .eh-stat  { background:#fff; border-radius:14px; padding:1.25rem 1.5rem; box-shadow:0 2px 12px rgba(0,0,0,.06); display:flex; flex-direction:column; gap:.4rem; }
        .eh-stat__label { font-size:.75rem; font-weight:600; text-transform:uppercase; letter-spacing:.08em; color:#8896a6; }
        .eh-stat__value { font-size:2rem; font-weight:700; color:#0f1b2d; line-height:1; }
        .eh-stat--sent   .eh-stat__value { color:#16a34a; }
        .eh-stat--failed .eh-stat__value { color:#dc2626; }

        /* Toolbar */
        .eh-toolbar { display:flex; align-items:center; justify-content:space-between; gap:1rem; flex-wrap:wrap; margin-bottom:1.5rem; }
        .eh-toolbar-filters { display:flex; align-items:center; gap:.75rem; flex-wrap:wrap; }

        .eh-select, .eh-btn {
            height:38px; padding:0 1.25rem;
            border:1.5px solid #e5e7eb; border-radius:8px;
            font-size:.85rem; font-family:'Inter',sans-serif;
            background:#fff; color:#0f1b2d; cursor:pointer;
            transition:all .2s; white-space:nowrap;
            display:inline-flex; align-items:center; justify-content:center; gap:.5rem;
        }
        .eh-select:focus { outline:none; border-color:#0f1b2d; box-shadow:0 0 0 3px rgba(15,27,45,.08); }
        .eh-btn--primary  { background:#0f1b2d; color:#fff; border-color:#0f1b2d; font-weight:600; }
        .eh-btn--primary:hover { background:#1e3a5f; transform:translateY(-1px); box-shadow:0 4px 12px rgba(15,27,45,.15); }
        
        .eh-btn--reset { 
            color:#4b5563; border-color:#e5e7eb; background:#f9fafb; font-weight:500;
            text-decoration:none;
        }
        .eh-btn--reset:hover { background:#f3f4f6; border-color:#d1d5db; color:#111827; }

        .eh-btn--ghost { color:#6b7280; background:transparent; border:1.5px solid transparent; }
        .eh-btn--ghost:hover { background:#f3f4f6; color:#111827; }

        /* Alerts */
        .eh-alert { padding:12px 16px; border-radius:10px; margin-bottom:1.5rem; display:flex; align-items:center; gap:10px; font-size:.9rem; font-weight:500; }
        .eh-alert--success { background:#dcfce7; color:#15803d; border:1px solid #bef26466; }
        .eh-alert--error   { background:#fee2e2; color:#dc2626; border:1px solid #fecaca66; }

        /* Table */
        .eh-table-wrap { background:#fff; border-radius:16px; box-shadow:0 2px 16px rgba(0,0,0,.06); border:1px solid #f1f5f9; overflow:hidden; }
        .eh-table { width:100%; border-collapse:collapse; font-size:.875rem; }
        .eh-table thead th {
            background:#f8f9fc; color:#6b7280; font-weight:600; font-size:.72rem;
            text-transform:uppercase; letter-spacing:.07em;
            padding:1rem 1.25rem; text-align:left;
            border-bottom:1px solid #f1f5f9; white-space:nowrap;
        }
        .eh-table tbody td { padding:.875rem 1.25rem; border-bottom:1px solid #f8f9fc; vertical-align:middle; }
        .eh-table tbody tr:last-child td { border-bottom:none; }
        .eh-table tbody tr:hover { background:#fafbff; }

        .eh-email-link { color:#0f1b2d; font-weight:500; cursor:pointer; text-decoration:none; transition:color .2s; }
        .eh-email-link:hover { text-decoration:underline; color:#2563eb; }

        .eh-subject { color:#374151; max-width:260px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; display:block; }
        .eh-date { color:#9ca3af; font-size:.8rem; white-space:nowrap; }

        /* Badges */
        .eh-badge { display:inline-flex; align-items:center; gap:.35rem; padding:.25rem .75rem; border-radius:999px; font-size:.75rem; font-weight:600; }
        .eh-badge--sent   { background:#dcfce7; color:#15803d; }
        .eh-badge--failed { background:#fee2e2; color:#dc2626; }
        .eh-type-tag { display:inline-block; padding:.2rem .65rem; border-radius:6px; font-size:.72rem; font-weight:600; background:#f1f5f9; color:#475569; }

        /* Pagination */
        .eh-pager { display:flex; align-items:center; justify-content:flex-end; gap:.5rem; margin-top:1.5rem; }
        .eh-pager a, .eh-pager span {
            display:inline-flex; align-items:center; justify-content:center;
            width:36px; height:36px; border-radius:8px;
            border:1.5px solid #e5e7eb; font-size:.85rem; font-weight:500;
            color:#374151; text-decoration:none; transition:all .2s;
        }
        .eh-pager a:hover { border-color:#0f1b2d; color:#0f1b2d; background:#f9fafb; }
        .eh-pager .active { background:#0f1b2d; color:#fff; border-color:#0f1b2d; pointer-events:none; }

        /* Modals */
        .eh-overlay {
            display:none; position:fixed; inset:0;
            background:rgba(0,0,0,.5); backdrop-filter:blur(4px);
            z-index:9999; align-items:center; justify-content:center;
        }
        .eh-overlay.open { display:flex; }
        .eh-modal {
            background:#fff; border-radius:20px; padding:2rem;
            max-width:680px; width:92%; max-height:90vh; overflow-y:auto;
            box-shadow:0 25px 50px -12px rgba(0,0,0,0.25);
            animation:eh-anim .3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        @keyframes eh-anim { from { opacity:0; transform:scale(0.95) translateY(10px); } to { opacity:1; transform:scale(1) translateY(0); } }
        .eh-modal__hdr { display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem; border-bottom:1px solid #f1f5f9; padding-bottom:1rem; }
        .eh-modal__title { font-family:'Playfair Display',serif; font-size:1.3rem; font-weight:700; color:#0f1b2d; margin:0; }
        .eh-modal__close { background:#f3f4f6; border:none; width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; cursor:pointer; color:#6b7280; transition:all .2s; }
        .eh-modal__close:hover { background:#fee2e2; color:#dc2626; transform:rotate(90deg); }
        .eh-preview-body { border:1px solid #e5e7eb; border-radius:12px; padding:1.25rem; max-height:450px; overflow-y:auto; background:#fdfdfd; line-height:1.6; }

        /* Compose form */
        .eh-form-group { margin-bottom:1.25rem; }
        .eh-label { display:block; font-size:.85rem; font-weight:600; margin-bottom:.5rem; color:#374151; }
        .eh-required { color:#dc2626; margin-left:2px; }
        .eh-input {
            width:100%; box-sizing:border-box; padding:12px 16px;
            border:1.5px solid #e5e7eb; border-radius:10px;
            font-size:.9rem; font-family:'Inter',sans-serif;
            color:#111827; transition:all .2s;
        }
        .eh-input:focus { outline:none; border-color:#0f1b2d; box-shadow:0 0 0 4px rgba(15,27,45,.06); background:#fff; }
        textarea.eh-input { height:180px; resize:vertical; }
        .eh-form-actions { display:flex; justify-content:flex-end; gap:12px; margin-top:2rem; padding-top:1.5rem; border-top:1px solid #f1f5f9; }
        
        .eh-hint { font-size:.78rem; color:#9ca3af; margin-top:.4rem; display:block; }
    </style>
</head>
<body class="luxury-admin">

<%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
<%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

<main class="lux-main">
    <div class="lux-content">

        <!-- Page Header -->
        <div class="eh-header">
            <h1>
                <i class="fa-solid fa-envelope-open-text"></i>
                Email Hub
            </h1>
            <p>Quản lý lịch sử email, theo dõi chiến dịch và gửi mail chăm sóc khách hàng chuyên nghiệp.</p>
        </div>

        <!-- Stats -->
        <div class="eh-stats">
            <div class="eh-stat">
                <span class="eh-stat__label">Total Emails</span>
                <span class="eh-stat__value">${totalRecords}</span>
            </div>
            <div class="eh-stat eh-stat--sent">
                <span class="eh-stat__label">Successfully Sent</span>
                <span class="eh-stat__value">${totalSent}</span>
            </div>
            <div class="eh-stat eh-stat--failed">
                <span class="eh-stat__label">Delivery Failed</span>
                <span class="eh-stat__value">${totalFailed}</span>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${param.success eq 'sent'}">
            <div class="eh-alert eh-alert--success">
                <i class="fa-solid fa-circle-check"></i> Email đã được gửi thành công đến tất cả người nhận!
            </div>
        </c:if>
        <c:if test="${param.success eq 'partial'}">
            <div class="eh-alert eh-alert--success" style="background:#fef9c3; color:#854d0e; border-color:#fef08a;">
                <i class="fa-solid fa-circle-info"></i> Gửi thành công ${param.s} mail, thất bại ${param.f} mail. Vui lòng kiểm tra log.
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="eh-alert eh-alert--error">
                <i class="fa-solid fa-circle-exclamation"></i>
                <c:choose>
                    <c:when test="${param.error eq 'missing_fields'}">Vui lòng nhập đầy đủ email, tiêu đề và nội dung.</c:when>
                    <c:when test="${param.error eq 'invalid_email'}">Một số địa chỉ email không hợp lệ.</c:when>
                    <c:when test="${param.error eq 'send_failed'}">Không thể gửi mail. Vui lòng kiểm tra cấu hình SMTP Server.</c:when>
                    <c:otherwise>Hệ thống gặp sự cố, vui lòng thử lại sau.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Toolbar -->
        <div class="eh-toolbar">
            <form method="get" action="${pageContext.request.contextPath}/admin/emails" class="eh-toolbar-filters">
                <select name="type" class="eh-select">
                    <option value="">— Types —</option>
                    <option value="REGISTER"      <c:if test="${filterType eq 'REGISTER'}">selected</c:if>>📝 Registration</option>
                    <option value="PASSWORD_RESET" <c:if test="${filterType eq 'PASSWORD_RESET'}">selected</c:if>>🔑 Security</option>
                    <option value="ORDER_CONFIRM"  <c:if test="${filterType eq 'ORDER_CONFIRM'}">selected</c:if>>📦 Orders</option>
                    <option value="GENERAL"        <c:if test="${filterType eq 'GENERAL'}">selected</c:if>>✉️ General</option>
                    <option value="PROMOTION"      <c:if test="${filterType eq 'PROMOTION'}">selected</c:if>>💎 Promotion</option>
                </select>
                <select name="status" class="eh-select">
                    <option value="">— Status —</option>
                    <option value="SENT"   <c:if test="${filterStatus eq 'SENT'}">selected</c:if>>Sent</option>
                    <option value="FAILED" <c:if test="${filterStatus eq 'FAILED'}">selected</c:if>>Failed</option>
                </select>
                <button type="submit" class="eh-btn eh-btn--primary">
                    <i class="fa-solid fa-magnifying-glass"></i> Filter
                </button>
                <a href="${pageContext.request.contextPath}/admin/emails" class="eh-btn eh-btn--reset">
                    <i class="fa-solid fa-rotate-left"></i> Reset
                </a>
            </form>

            <button class="eh-btn eh-btn--primary" onclick="openCompose('')" style="background:#0f1b2d;">
                <i class="fa-solid fa-plus"></i> Compose New
            </button>
        </div>

        <!-- Email Table -->
        <div class="eh-table-wrap">
            <c:choose>
                <c:when test="${not empty logs}">
                    <table class="eh-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Recipient</th>
                                <th>Subject</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>Sent At</th>
                                <th style="text-align:right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="log" items="${logs}">
                            <tr>
                                <td style="color:#cbd5e1;font-weight:600;">#${log.emailid}</td>
                                <td>
                                    <a class="eh-email-link" data-email="<c:out value='${log.recipientemail}'/>"
                                       onclick="openCompose(this.getAttribute('data-email'))">
                                        <i class="fa-regular fa-envelope" style="margin-right:.4rem;color:#94a3b8;"></i>
                                        <c:out value="${log.recipientemail}"/>
                                    </a>
                                </td>
                                <td><span class="eh-subject" title="${log.subject}"><c:out value="${log.subject}"/></span></td>
                                <td>
                                    <span class="eh-type-tag">
                                        <c:choose>
                                            <c:when test="${log.emailtype eq 'REGISTER'}">📝 Register</c:when>
                                            <c:when test="${log.emailtype eq 'PASSWORD_RESET'}">🔑 Security</c:when>
                                            <c:when test="${log.emailtype eq 'ORDER_CONFIRM'}">📦 Order</c:when>
                                            <c:when test="${log.emailtype eq 'PROMOTION'}">💎 Promo</c:when>
                                            <c:otherwise>✉️ Gen</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${log.status eq 'SENT'}">
                                            <span class="eh-badge eh-badge--sent"><i class="fa-solid fa-check"></i> Sent</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="eh-badge eh-badge--failed"><i class="fa-solid fa-xmark"></i> Failed</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="eh-date"><fmt:formatDate value="${log.sentat}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td style="text-align:right">
                                    <div id="ec-${log.emailid}" style="display:none"><c:out value="${log.content}" escapeXml="false"/></div>
                                    <button class="eh-btn eh-btn--ghost" title="View details" data-id="${log.emailid}" data-subject="<c:out value='${log.subject}'/>"
                                            onclick="openPreview(this.getAttribute('data-id'), this.getAttribute('data-subject'))">
                                        <i class="fa-solid fa-eye" style="font-size:1.1rem;"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="padding: 60px 20px; text-align: center; background: #fff; border-radius: 12px; margin-top: 10px;">
                        <i class="fa-solid fa-magnifying-glass" style="display: block; font-size: 1.8rem; color: #cbd5e1; margin-bottom: 12px;"></i>
                        <span style="color: #64748b; font-size: 1rem; font-weight: 500;">No Email Records Found</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="eh-pager">
                <c:if test="${currentPage > 1}"><a href="?page=${currentPage - 1}&type=${filterType}&status=${filterStatus}"><i class="fa-solid fa-angle-left"></i></a></c:if>
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <c:choose><c:when test="${p == currentPage}"><span class="active">${p}</span></c:when>
                    <c:otherwise><a href="?page=${p}&type=${filterType}&status=${filterStatus}">${p}</a></c:otherwise></c:choose>
                </c:forEach>
                <c:if test="${currentPage < totalPages}"><a href="?page=${currentPage + 1}&type=${filterType}&status=${filterStatus}"><i class="fa-solid fa-angle-right"></i></a></c:if>
            </div>
        </c:if>
    </div>
</main>

<!-- Modals -->
<div class="eh-overlay" id="previewOverlay" onclick="if(event.target===this)closePreview()">
    <div class="eh-modal">
        <div class="eh-modal__hdr">
            <h2 class="eh-modal__title" id="previewTitle">Email Content</h2>
            <button class="eh-modal__close" onclick="closePreview()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="eh-preview-body" id="previewBody"></div>
    </div>
</div>

<div class="eh-overlay" id="composeOverlay" onclick="if(event.target===this)closeCompose()">
    <div class="eh-modal" style="max-width:720px;">
        <div class="eh-modal__hdr">
            <h2 class="eh-modal__title">
                <i class="fa-solid fa-paper-plane" style="font-size:1.1rem;"></i> New Email
            </h2>
            <button class="eh-modal__close" onclick="closeCompose()"><i class="fa-solid fa-xmark"></i></button>
        </div>

        <!-- Inline error banner (hidden by default) -->
        <div id="formError" style="display:none; background:#fee2e2; color:#b91c1c; padding:10px 14px;
             border-radius:10px; font-size:.85rem; font-weight:600; margin-bottom:1rem;
             border:1px solid #fecaca; align-items:center; gap:8px;">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span id="formErrorMsg"></span>
        </div>

        <form id="composeForm"
              action="${pageContext.request.contextPath}/admin/emails"
              method="post"
              onsubmit="return validateCompose()">

            <%-- Hidden: filled by JS chip logic before submit --%>
            <input type="hidden" id="fRecipientHidden" name="recipient">

            <%-- RECIPIENTS --%>
            <div class="eh-form-group">
                <label class="eh-label">
                    <i class="fa-solid fa-users" style="margin-right:5px;color:#94a3b8;"></i>
                    Recipients <span class="eh-required">*</span>
                </label>

                <%-- Chip box (shows selected emails as tags) --%>
                <div id="chipBox" style="min-height:46px; padding:8px 12px; border:1.5px solid #e5e7eb;
                     border-radius:10px; display:flex; flex-wrap:wrap; gap:8px; align-items:center;
                     background:#f9fafb; margin-bottom:10px; cursor:text;"
                     onclick="document.getElementById('manualInput').focus()">
                    <input type="text" id="manualInput"
                           placeholder="Type email and press Enter..."
                           style="border:none; outline:none; background:transparent; font-size:.88rem;
                                  font-family:'Inter',sans-serif; flex:1; min-width:180px;"
                           onkeydown="handleManualInput(event)">
                </div>
                <span class="eh-hint">Press Enter to add an email, or tick customers below.</span>

                <%-- Customer picker — always visible --%>
                <div style="margin-top:10px; border:1.5px solid #e5e7eb; border-radius:12px; overflow:hidden;">
                    <div style="background:#f8f9fc; padding:10px 16px; border-bottom:1px solid #e5e7eb;
                                display:flex; justify-content:space-between; align-items:center;">
                        <span style="font-size:.83rem; font-weight:700; color:#1e293b;">
                            <i class="fa-solid fa-users" style="margin-right:6px; color:#64748b;"></i>
                            Select from Customer List
                        </span>
                        <span id="selCounter" style="font-size:.7rem; background:#0f1b2d; color:#fff;
                              padding:2px 10px; border-radius:12px; font-weight:700;">0 Selected</span>
                    </div>
                    <div style="padding:10px;">
                        <div style="position:relative; margin-bottom:10px;">
                            <i class="fa-solid fa-magnifying-glass" style="position:absolute; left:12px;
                               top:50%; transform:translateY(-50%); color:#94a3b8; font-size:.8rem;"></i>
                            <input type="text" id="pickerSearch"
                                   placeholder="Search by name or email..."
                                   oninput="filterPicker(this.value)"
                                   style="width:100%; box-sizing:border-box; padding:8px 12px 8px 35px;
                                          border:1.5px solid #f0f0f0; border-radius:8px; font-size:.82rem;
                                          font-family:'Inter',sans-serif; outline:none;">
                        </div>
                        <div id="customerCheckboxes"
                             style="max-height:200px; overflow-y:auto;
                                    display:grid; grid-template-columns:1fr 1fr; gap:8px;">
                            <c:choose>
                                <c:when test="${not empty customers}">
                                    <c:forEach var="customer" items="${customers}">
                                        <label class="cust-row"
                                               data-name="${customer.fullname}"
                                               data-email="<c:out value='${customer.email}'/>"
                                               style="display:flex; align-items:center; gap:10px;
                                                      padding:10px 12px; border:1.5px solid #f3f4f6;
                                                      border-radius:10px; cursor:pointer; background:#fff;
                                                      transition:all .15s;"
                                               onmouseover="this.style.borderColor='#c7d2fe';this.style.background='#f5f3ff'"
                                               onmouseout="this.style.borderColor='#f3f4f6';this.style.background='#fff'">
                                            <input type="checkbox" class="cust-chk"
                                                   value="<c:out value='${customer.email}'/>"
                                                   data-name="<c:out value='${customer.fullname}'/>"
                                                   onchange="syncFromCheckboxes()"
                                                   style="width:15px;height:15px;accent-color:#0f1b2d;cursor:pointer;flex-shrink:0;">
                                            <div style="min-width:0; overflow:hidden;">
                                                <div style="font-weight:600; font-size:.84rem; color:#1e293b;
                                                            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                                                    <c:choose>
                                                        <c:when test="${not empty customer.fullname}">
                                                            <c:out value="${customer.fullname}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${customer.username}"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div style="font-size:.73rem; color:#94a3b8;
                                                            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                                                    <c:out value="${customer.email}"/>
                                                </div>
                                            </div>
                                        </label>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="grid-column:span 2; text-align:center; padding:28px; color:#94a3b8; font-size:.83rem;">
                                        <i class="fa-solid fa-user-slash" style="display:block;font-size:1.4rem;margin-bottom:8px;"></i>
                                        No customers found in database.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>


            <%-- TYPE + SUBJECT --%>
            <div style="display:grid; grid-template-columns:200px 1fr; gap:12px;" class="eh-form-group">
                <div>
                    <label class="eh-label">Type</label>
                    <select name="emailType" class="eh-input" style="cursor:pointer;">
                        <option value="GENERAL">✉️ General</option>
                        <option value="PROMOTION">💎 Promotion</option>
                        <option value="ORDER_CONFIRM">📦 Order Confirm</option>
                    </select>
                </div>
                <div>
                    <label class="eh-label">Subject <span class="eh-required">*</span></label>
                    <input type="text" name="subject" class="eh-input" placeholder="Subject line..." required>
                </div>
            </div>

            <%-- MESSAGE --%>
            <div class="eh-form-group">
                <label class="eh-label">Message <span class="eh-required">*</span></label>
                <textarea name="content" class="eh-input" placeholder="Write your message here..." required></textarea>
            </div>

            <%-- ACTIONS --%>
            <div class="eh-form-actions">
                <span id="recipientCount"
                      style="font-size:.8rem; color:#94a3b8; align-self:center; margin-right:auto;">
                    0 recipient(s) selected
                </span>
                <button type="button" class="eh-btn eh-btn--ghost" onclick="closeCompose()">Discard</button>
                <button type="submit" class="eh-btn eh-btn--primary">
                    <i class="fa-solid fa-paper-plane"></i> Send Now
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    /* ── Preview ───────────────────────────────────────── */
    function openPreview(id, subject) {
        var el = document.getElementById('ec-' + id);
        document.getElementById('previewTitle').textContent = subject;
        document.getElementById('previewBody').innerHTML = el ? el.innerHTML : '<em>No content</em>';
        document.getElementById('previewOverlay').classList.add('open');
    }
    function closePreview() { document.getElementById('previewOverlay').classList.remove('open'); }

    /* ── Compose open / close ──────────────────────────── */
    function openCompose(prefillEmail) {
        if (prefillEmail) addChip(prefillEmail);
        document.getElementById('composeOverlay').classList.add('open');
        setTimeout(() => document.getElementById('manualInput').focus(), 150);
    }
    function closeCompose() {
        document.getElementById('composeOverlay').classList.remove('open');
        resetCompose();
    }
    function resetCompose() {
        document.getElementById('composeForm').reset();
        document.getElementById('formError').style.display = 'none';
        document.getElementById('fRecipientHidden').value = '';
        document.getElementById('chipBox').querySelectorAll('.eh-chip').forEach(c => c.remove());
        document.getElementById('manualInput').value = '';
        document.querySelectorAll('.cust-chk').forEach(c => c.checked = false);
        selectedEmails.clear();  // CRITICAL: reset the internal Set
        updateCount();
    }

    /* ── Chip management ───────────────────────────────── */
    var selectedEmails = new Set();

    function addChip(email, displayName) {
        email = email.trim().toLowerCase();
        if (!email || selectedEmails.has(email)) return;
        selectedEmails.add(email);
        var label = displayName ? displayName.trim() : email;
        var chip = document.createElement('span');
        chip.className = 'eh-chip';
        chip.dataset.email = email;
        chip.style.cssText = 'display:inline-flex;align-items:center;gap:6px;background:#eef2ff;' +
            'color:#3730a3;padding:4px 12px;border-radius:999px;font-size:.78rem;font-weight:600;' +
            'border:1px solid #e0e7ff;max-width:200px;';
        chip.innerHTML = '<span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="' + email + '">' +
            label + '</span>' +
            '<button type="button" onclick="removeChip(this)" ' +
            'style="background:none;border:none;cursor:pointer;color:#6366f1;font-size:.85rem;line-height:1;' +
            'flex-shrink:0;padding:0;" title="Remove">&times;</button>';
        document.getElementById('chipBox').insertBefore(chip, document.getElementById('manualInput'));
        syncHiddenField();
        updateCount();
    }

    function removeChip(btn) {
        var chip = btn.parentElement;
        selectedEmails.delete(chip.dataset.email);
        // uncheck corresponding checkbox if any
        var chk = document.querySelector('.cust-chk[value="' + chip.dataset.email + '"]');
        if (chk) chk.checked = false;
        chip.remove();
        syncHiddenField();
        updateCount();
    }

    function handleManualInput(e) {
        if (e.key === 'Enter' || e.key === ',') {
            e.preventDefault();
            var val = document.getElementById('manualInput').value.replace(',', '').trim();
            if (val) { addChip(val); document.getElementById('manualInput').value = ''; }
        }
    }

    function syncFromCheckboxes() {
        document.querySelectorAll('.cust-chk').forEach(function(chk) {
            var email = chk.value.trim().toLowerCase();
            var name  = chk.getAttribute('data-name') || '';
            if (chk.checked) {
                addChip(email, name);
            } else {
                if (selectedEmails.has(email)) {
                    selectedEmails.delete(email);
                    var chip = document.querySelector('.eh-chip[data-email="' + email + '"]');
                    if (chip) chip.remove();
                    syncHiddenField();
                    updateCount();
                }
            }
        });
    }

    function syncHiddenField() {
        document.getElementById('fRecipientHidden').value = Array.from(selectedEmails).join(',');
    }

    function updateCount() {
        var n = selectedEmails.size;
        document.getElementById('recipientCount').textContent = n + ' recipient' + (n !== 1 ? 's' : '') + ' selected';
        var badge = document.getElementById('selCounter');
        if (badge) badge.textContent = n + ' Selected';
    }

    function showError(msg) {
        var err = document.getElementById('formError');
        document.getElementById('formErrorMsg').textContent = msg;
        err.style.display = 'block';
    }

    function validateCompose() {
        document.getElementById('formError').style.display = 'none';
        var manual = document.getElementById('manualInput').value.trim();
        if (manual) addChip(manual);
        if (selectedEmails.size === 0) {
            showError('Please select at least one recipient from the list or type an email.');
            return false;
        }
        syncHiddenField();
        return true;
    }

    /* ── Picker filter ─────────────────────────────────── */

    function filterPicker(q) {
        q = q.toLowerCase();
        document.querySelectorAll('#customerCheckboxes .cust-row').forEach(function(row) {
            var name  = (row.getAttribute('data-name')  || '').toLowerCase();
            var email = (row.getAttribute('data-email') || '').toLowerCase();
            row.style.display = (name.includes(q) || email.includes(q)) ? 'flex' : 'none';
        });
    }
</script>
</body>
</html>


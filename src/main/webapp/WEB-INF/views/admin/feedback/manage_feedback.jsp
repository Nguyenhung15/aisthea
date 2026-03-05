<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Feedback — AISTHÉA Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <style>
                    /* ── Feedback-specific styles ── */
                    .fb-table {
                        width: 100%;
                        border-collapse: collapse;
                    }

                    .fb-table thead tr {
                        background: var(--color-bg);
                    }

                    .fb-table th {
                        padding: 14px 20px;
                        text-align: left;
                        font-size: 0.72rem;
                        font-weight: 600;
                        color: var(--color-text-muted);
                        text-transform: uppercase;
                        letter-spacing: 1px;
                    }

                    .fb-table td {
                        padding: 16px 20px;
                        border-bottom: 1px solid var(--color-border-light);
                        font-size: 0.88rem;
                        vertical-align: top;
                    }

                    .fb-table tbody tr {
                        transition: background 0.15s ease;
                    }

                    .fb-table tbody tr:hover {
                        background: var(--color-bg);
                    }

                    /* Stars */
                    .fb-stars {
                        display: flex;
                        gap: 2px;
                        margin-bottom: 8px;
                    }

                    .fb-stars i {
                        font-size: 0.65rem;
                    }

                    .fb-star--active {
                        color: #d4a853;
                    }

                    .fb-star--inactive {
                        color: var(--color-border);
                    }

                    /* Status badges */
                    .fb-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        padding: 4px 12px;
                        border-radius: var(--radius-full);
                        font-size: 0.7rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .fb-badge--visible {
                        background: var(--color-success-bg);
                        color: var(--color-success-text);
                    }

                    .fb-badge--hidden {
                        background: #fef2f2;
                        color: #dc2626;
                    }

                    /* Helpful count */
                    .fb-helpful {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        font-size: 0.72rem;
                        font-weight: 500;
                        color: var(--color-text-muted);
                        margin-top: 8px;
                    }

                    .fb-helpful i {
                        font-size: 0.65rem;
                        color: #d4a853;
                    }

                    /* Admin reply card */
                    .fb-reply-card {
                        margin-top: 12px;
                        padding: 12px 16px;
                        background: rgba(26, 35, 50, 0.02);
                        border-left: 2px solid var(--color-primary);
                        border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
                    }

                    .fb-reply-card__label {
                        font-size: 0.65rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 1.5px;
                        color: var(--color-primary);
                        margin-bottom: 4px;
                    }

                    .fb-reply-card__text {
                        font-family: var(--font-serif);
                        font-size: 0.82rem;
                        font-style: italic;
                        color: var(--color-text-secondary);
                        line-height: 1.5;
                    }

                    /* Image thumbnail */
                    .fb-image-thumb {
                        width: 56px;
                        height: 56px;
                        object-fit: cover;
                        border-radius: var(--radius-sm);
                        border: 1px solid var(--color-border-light);
                        transition: all 0.2s ease;
                        display: block;
                        margin-top: 8px;
                    }

                    .fb-image-thumb:hover {
                        transform: scale(1.05);
                        box-shadow: var(--shadow-md);
                    }

                    /* Action buttons */
                    .fb-action-btn {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 6px 14px;
                        border: none;
                        border-radius: var(--radius-full);
                        font-family: var(--font-sans);
                        font-size: 0.72rem;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        text-decoration: none;
                        letter-spacing: 0.3px;
                    }

                    .fb-action-btn--reply {
                        background: var(--color-bg);
                        color: var(--color-primary);
                    }

                    .fb-action-btn--reply:hover {
                        background: var(--color-primary);
                        color: var(--color-white);
                    }

                    .fb-action-btn--toggle {
                        background: none;
                        color: var(--color-text-muted);
                        padding: 6px 10px;
                    }

                    .fb-action-btn--toggle:hover {
                        color: var(--color-text-primary);
                    }

                    /* Reply Modal */
                    .fb-modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(0, 0, 0, 0.5);
                        display: none;
                        align-items: center;
                        justify-content: center;
                        z-index: 1000;
                        backdrop-filter: blur(4px);
                    }

                    .fb-modal-overlay.show {
                        display: flex;
                    }

                    .fb-modal {
                        background: var(--color-white);
                        border-radius: var(--radius-xl);
                        padding: var(--space-2xl);
                        width: 90%;
                        max-width: 500px;
                        box-shadow: var(--shadow-lg);
                    }

                    .fb-modal__title {
                        font-family: var(--font-serif);
                        font-size: 1.4rem;
                        font-weight: 700;
                        color: var(--color-primary);
                        margin-bottom: var(--space-sm);
                    }

                    .fb-modal__subtitle {
                        font-size: 0.82rem;
                        color: var(--color-text-muted);
                        margin-bottom: var(--space-xl);
                    }

                    .fb-modal__textarea {
                        width: 100%;
                        border: 1.5px solid var(--color-border);
                        border-radius: var(--radius-md);
                        padding: 14px 16px;
                        font-family: var(--font-serif);
                        font-size: 0.95rem;
                        font-style: italic;
                        color: var(--color-text-primary);
                        resize: vertical;
                        outline: none;
                        transition: border-color 0.2s ease;
                        min-height: 100px;
                    }

                    .fb-modal__textarea::placeholder {
                        color: var(--color-text-muted);
                        font-style: italic;
                    }

                    .fb-modal__textarea:focus {
                        border-color: var(--color-primary);
                        box-shadow: 0 0 0 3px rgba(26, 35, 50, 0.06);
                    }

                    .fb-modal__actions {
                        display: flex;
                        gap: 12px;
                        margin-top: var(--space-xl);
                    }

                    .fb-modal__btn-submit {
                        flex: 1;
                        padding: 14px 24px;
                        background: var(--color-primary);
                        color: var(--color-white);
                        border: none;
                        border-radius: var(--radius-full);
                        font-family: var(--font-sans);
                        font-size: 0.8rem;
                        font-weight: 600;
                        letter-spacing: 1px;
                        text-transform: uppercase;
                        cursor: pointer;
                        transition: all 0.25s ease;
                    }

                    .fb-modal__btn-submit:hover {
                        background: var(--color-primary-light);
                        transform: translateY(-1px);
                        box-shadow: 0 6px 20px rgba(26, 35, 50, 0.2);
                    }

                    .fb-modal__btn-cancel {
                        padding: 14px 24px;
                        background: var(--color-bg);
                        color: var(--color-text-secondary);
                        border: 1px solid var(--color-border);
                        border-radius: var(--radius-full);
                        font-family: var(--font-sans);
                        font-size: 0.8rem;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s ease;
                    }

                    .fb-modal__btn-cancel:hover {
                        background: var(--color-border);
                    }

                    /* KPI mini cards for feedback page */
                    .fb-kpi-row {
                        display: flex;
                        gap: var(--space-lg);
                        margin-bottom: var(--space-xl);
                    }

                    .fb-kpi-card {
                        background: var(--color-white);
                        border-radius: var(--radius-xl);
                        padding: var(--space-lg) var(--space-xl);
                        box-shadow: var(--shadow-card);
                        display: flex;
                        align-items: center;
                        gap: var(--space-md);
                        min-width: 180px;
                    }

                    .fb-kpi-card__icon {
                        width: 40px;
                        height: 40px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        background: var(--color-bg);
                        border-radius: var(--radius-md);
                        color: var(--color-text-secondary);
                        font-size: 0.95rem;
                    }

                    .fb-kpi-card__value {
                        font-family: var(--font-serif);
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: var(--color-primary);
                        line-height: 1;
                    }

                    .fb-kpi-card__label {
                        font-size: 0.7rem;
                        font-weight: 600;
                        color: var(--color-text-muted);
                        text-transform: uppercase;
                        letter-spacing: 0.8px;
                        margin-top: 2px;
                    }

                    /* Customer info in table */
                    .fb-customer-name {
                        font-weight: 600;
                        font-size: 0.88rem;
                        color: var(--color-text-primary);
                    }

                    .fb-customer-date {
                        font-size: 0.72rem;
                        color: var(--color-text-muted);
                        margin-top: 2px;
                    }

                    .fb-comment {
                        font-family: var(--font-serif);
                        font-style: italic;
                        color: var(--color-text-secondary);
                        line-height: 1.6;
                        font-size: 0.85rem;
                    }

                    .fb-product-id {
                        font-size: 0.82rem;
                        font-weight: 600;
                        color: var(--color-text-primary);
                    }

                    .fb-product-sku {
                        font-size: 0.72rem;
                        color: var(--color-text-muted);
                        margin-top: 2px;
                    }
                </style>
            </head>

            <body class="luxury-admin">
                <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
                    <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

                        <main class="lux-main">
                            <div class="lux-content">

                                <!-- Page Header -->
                                <section class="lux-page-header">
                                    <div class="lux-page-header__text">
                                        <h1 class="lux-page-header__title">Feedback<br>Management</h1>
                                        <p class="lux-page-header__subtitle">
                                            Review, moderate, and respond to customer feedback.
                                            Maintain quality standards across all product reviews.
                                        </p>
                                    </div>
                                </section>

                                <!-- KPI Cards -->
                                <div class="fb-kpi-row">
                                    <div class="fb-kpi-card">
                                        <div class="fb-kpi-card__icon">
                                            <i class="fa-solid fa-comments"></i>
                                        </div>
                                        <div>
                                            <div class="fb-kpi-card__value">${feedbacks.size()}</div>
                                            <div class="fb-kpi-card__label">Total Reviews</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Feedback Table -->
                                <div
                                    style="background:var(--color-white);border-radius:var(--radius-xl);box-shadow:var(--shadow-card);overflow:hidden;">
                                    <table class="fb-table">
                                        <thead>
                                            <tr>
                                                <th style="width:60px;">ID</th>
                                                <th style="width:160px;">Customer</th>
                                                <th style="width:140px;">Product</th>
                                                <th>Review</th>
                                                <th style="width:100px;">Status</th>
                                                <th style="width:140px;text-align:right;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="f" items="${feedbacks}">
                                                <tr>
                                                    <td style="color:var(--color-text-muted);">#${f.feedbackid}</td>
                                                    <td>
                                                        <div class="fb-customer-name">${f.username}</div>
                                                        <div class="fb-customer-date">
                                                            <fmt:formatDate value="${f.createdat}"
                                                                pattern="MMM dd, yyyy" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="fb-product-id">ID: ${f.productid}</div>
                                                        <div class="fb-product-sku">SKU: ART-FB-${f.productid}</div>
                                                    </td>
                                                    <td>
                                                        <!-- Stars -->
                                                        <div class="fb-stars">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i
                                                                    class="fa-solid fa-star ${i <= f.rating ? 'fb-star--active' : 'fb-star--inactive'}"></i>
                                                            </c:forEach>
                                                        </div>

                                                        <!-- Comment -->
                                                        <div class="fb-comment">"${f.comment}"</div>

                                                        <!-- Image -->
                                                        <c:if test="${not empty f.imageUrl}">
                                                            <a href="${f.imageUrl}" target="_blank">
                                                                <img src="${f.imageUrl}" alt="Customer photo"
                                                                    class="fb-image-thumb"
                                                                    onerror="this.style.display='none'">
                                                            </a>
                                                        </c:if>

                                                        <!-- Helpful -->
                                                        <div class="fb-helpful">
                                                            <i class="fa-solid fa-heart"></i>
                                                            ${f.helpfulCount} helpful
                                                        </div>

                                                        <!-- Admin Reply -->
                                                        <c:if test="${not empty f.adminReply}">
                                                            <div class="fb-reply-card">
                                                                <div class="fb-reply-card__label">
                                                                    <i class="fa-solid fa-reply"
                                                                        style="margin-right:4px;"></i>
                                                                    AISTHÉA
                                                                </div>
                                                                <div class="fb-reply-card__text">"${f.adminReply}"</div>
                                                            </div>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="fb-badge ${not empty f.status and f.status.toLowerCase() == 'visible' ? 'fb-badge--visible' : 'fb-badge--hidden'}">
                                                            <i class="fa-solid ${not empty f.status and f.status.toLowerCase() == 'visible' ? 'fa-eye' : 'fa-eye-slash'}"
                                                                style="font-size:0.6rem;"></i>
                                                            ${f.status}
                                                        </span>
                                                    </td>
                                                    <td style="text-align:right;">
                                                        <div
                                                            style="display:flex;flex-direction:column;gap:8px;align-items:flex-end;">
                                                            <button onclick="openReplyModal(this)"
                                                                data-id="${f.feedbackid}" data-name="${f.username}"
                                                                class="fb-action-btn fb-action-btn--reply">
                                                                <i class="fa-solid fa-reply"
                                                                    style="font-size:0.7rem;"></i>
                                                                ${empty f.adminReply ? 'Reply' : 'Edit'}
                                                            </button>
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/feedback"
                                                                method="POST" style="margin:0;">
                                                                <input type="hidden" name="action" value="updateStatus">
                                                                <input type="hidden" name="id" value="${f.feedbackid}">
                                                                <input type="hidden" name="status"
                                                                    value="${not empty f.status and f.status.toLowerCase() == 'visible' ? 'Hidden' : 'Visible'}">
                                                                <button type="submit"
                                                                    class="fb-action-btn fb-action-btn--toggle">
                                                                    <i class="fa-solid ${not empty f.status and f.status.toLowerCase() == 'visible' ? 'fa-eye-slash' : 'fa-eye'}"
                                                                        style="font-size:0.7rem;"></i>
                                                                    ${not empty f.status and f.status.toLowerCase() ==
                                                                    'visible' ? 'Hide' :
                                                                    'Show'}
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty feedbacks}">
                                                <tr>
                                                    <td colspan="6"
                                                        style="padding:40px 20px;text-align:center;color:var(--color-text-muted);font-size:0.9rem;">
                                                        <i class="fa-solid fa-comments"
                                                            style="font-size:2rem;margin-bottom:12px;display:block;opacity:0.3;"></i>
                                                        No feedback found.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                            </div>
                        </main>

                        <!-- Reply Modal -->
                        <div id="replyModal" class="fb-modal-overlay">
                            <div class="fb-modal">
                                <div
                                    style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:var(--space-lg);">
                                    <div>
                                        <div class="fb-modal__title">Reply to <span id="modalCustomerName"></span></div>
                                        <div class="fb-modal__subtitle">Respond as AISTHÉA</div>
                                    </div>
                                    <button onclick="closeReplyModal()"
                                        style="background:none;border:none;cursor:pointer;color:var(--color-text-muted);font-size:1.2rem;padding:4px;">
                                        <i class="fa-solid fa-xmark"></i>
                                    </button>
                                </div>
                                <form action="${pageContext.request.contextPath}/admin/feedback" method="POST">
                                    <input type="hidden" name="action" value="reply">
                                    <input type="hidden" id="modalFeedbackId" name="id">
                                    <div style="margin-bottom:var(--space-lg);">
                                        <label
                                            style="display:block;font-size:0.72rem;font-weight:600;color:var(--color-text-muted);text-transform:uppercase;letter-spacing:1px;margin-bottom:var(--space-sm);">Your
                                            Response</label>
                                        <textarea name="reply" class="fb-modal__textarea" rows="4"
                                            placeholder="We sincerely appreciate your reflection..."></textarea>
                                    </div>
                                    <div class="fb-modal__actions">
                                        <button type="button" onclick="closeReplyModal()"
                                            class="fb-modal__btn-cancel">Cancel</button>
                                        <button type="submit" class="fb-modal__btn-submit">
                                            <i class="fa-solid fa-paper-plane" style="margin-right:6px;"></i>
                                            Send Response
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <script>
                            function openReplyModal(btn) {
                                var id = btn.getAttribute('data-id');
                                var name = btn.getAttribute('data-name');
                                document.getElementById('modalFeedbackId').value = id;
                                document.getElementById('modalCustomerName').innerText = name;
                                document.getElementById('replyModal').classList.add('show');
                            }

                            function closeReplyModal() {
                                document.getElementById('replyModal').classList.remove('show');
                            }

                            // Close modal on overlay click
                            document.getElementById('replyModal').addEventListener('click', function (e) {
                                if (e.target === this) closeReplyModal();
                            });
                        </script>
            </body>

            </html>
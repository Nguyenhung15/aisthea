<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>AI Chats — AISTHÉA Admin</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
            <style>
                .chat-admin-grid { display: grid; grid-template-columns: 380px 1fr; gap: 24px; height: calc(100vh - 160px); min-height: 500px; }
                @media (max-width: 900px) {
                    .chat-admin-grid { grid-template-columns: 1fr; }
                    .chat-detail-panel { display: none; }
                    .chat-detail-panel.active { display: flex; }
                }
                .convo-list-card { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); display: flex; flex-direction: column; overflow: hidden; }
                .convo-list-header { padding: 20px 24px; border-bottom: 1px solid var(--color-border); display: flex; align-items: center; justify-content: space-between; }
                .convo-list-header h3 { font-family: var(--font-serif); font-size: 1.1rem; font-weight: 700; color: var(--color-text-primary); margin: 0; }
                .convo-count-badge { background: var(--color-primary); color: #fff; font-size: 0.7rem; font-weight: 700; padding: 3px 10px; border-radius: var(--radius-full); }
                .convo-search { padding: 12px 16px; border-bottom: 1px solid var(--color-border); display: flex; gap: 8px; flex-wrap: wrap; }
                .convo-search input { flex: 1; min-width: 120px; border: 1.5px solid var(--color-border); border-radius: var(--radius-full); padding: 8px 16px; font-size: 0.8rem; outline: none; background: var(--color-bg); color: var(--color-text-primary); transition: border-color 0.2s; box-sizing: border-box; }
                .convo-search input:focus { border-color: var(--color-primary); }
                .convo-filter-btn { border: 1.5px solid var(--color-border); border-radius: var(--radius-full); padding: 6px 14px; font-size: 0.72rem; font-weight: 600; background: var(--color-bg); color: var(--color-text-secondary); cursor: pointer; transition: all 0.15s; white-space: nowrap; }
                .convo-filter-btn.active, .convo-filter-btn:hover { background: var(--color-primary); color: #fff; border-color: var(--color-primary); }
                .convo-list-body { flex: 1; overflow-y: auto; padding: 8px; }
                .convo-list-body::-webkit-scrollbar { width: 4px; }
                .convo-list-body::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }
                .convo-item { display: flex; align-items: center; gap: 14px; padding: 14px 16px; border-radius: var(--radius-lg); cursor: pointer; transition: background 0.15s; border: 1px solid transparent; }
                .convo-item:hover { background: var(--color-bg); }
                .convo-item.active { background: rgba(2,74,207,0.06); border-color: rgba(2,74,207,0.15); }
                .convo-avatar { width: 44px; height: 44px; border-radius: 50%; background: var(--color-primary); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.9rem; flex-shrink: 0; overflow: hidden; }
                .convo-avatar img { width: 100%; height: 100%; object-fit: cover; }
                .convo-info { flex: 1; min-width: 0; }
                .convo-name { font-weight: 600; font-size: 0.85rem; color: var(--color-text-primary); margin: 0 0 3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: flex; align-items: center; gap: 6px; }
                .convo-status-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
                .convo-status-dot.open { background: #4ade80; }
                .convo-status-dot.closed { background: #94a3b8; }
                .convo-preview { font-size: 0.75rem; color: var(--color-text-tertiary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin: 0; }
                .convo-meta { text-align: right; flex-shrink: 0; }
                .convo-time { font-size: 0.65rem; color: var(--color-text-tertiary); margin: 0 0 4px; }
                .convo-msg-count { font-size: 0.6rem; font-weight: 700; background: var(--color-bg); color: var(--color-text-secondary); padding: 2px 8px; border-radius: var(--radius-full); }
                .convo-type-badge { font-size: 0.55rem; font-weight: 700; padding: 1px 6px; border-radius: var(--radius-full); text-transform: uppercase; letter-spacing: 0.5px; }
                .convo-type-badge.ai { background: #dbeafe; color: #2563eb; }
                .convo-type-badge.staff { background: #fef3c7; color: #d97706; }

                .chat-detail-panel { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); display: flex; flex-direction: column; overflow: hidden; }
                .chat-detail-header { padding: 18px 24px; border-bottom: 1px solid var(--color-border); display: flex; align-items: center; gap: 14px; }
                .chat-detail-header h3 { font-family: var(--font-serif); font-size: 1rem; font-weight: 700; color: var(--color-text-primary); margin: 0; }
                .chat-detail-header p { font-size: 0.72rem; color: var(--color-text-tertiary); margin: 2px 0 0; }
                .chat-detail-messages { flex: 1; overflow-y: auto; padding: 20px 24px; display: flex; flex-direction: column; gap: 12px; background: #f8fafc; }
                .chat-detail-messages::-webkit-scrollbar { width: 4px; }
                .chat-detail-messages::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }
                .admin-msg { max-width: 75%; padding: 10px 16px; border-radius: 16px; font-size: 0.82rem; line-height: 1.5; }
                .admin-msg--customer { align-self: flex-end; background: linear-gradient(135deg, #0f172a, #1e293b); color: #fff; border-bottom-right-radius: 4px; }
                .admin-msg--ai { align-self: flex-start; background: #fff; color: #334155; border: 1px solid #e2e8f0; border-bottom-left-radius: 4px; }
                .admin-msg--staff { align-self: flex-start; background: linear-gradient(135deg, #f59e0b, #d97706); color: #fff; border-bottom-left-radius: 4px; }
                .admin-msg__label { font-size: 0.6rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 3px; opacity: 0.7; }
                .admin-msg__time { font-size: 0.6rem; color: #94a3b8; margin-top: 4px; }
                .admin-msg--customer .admin-msg__time, .admin-msg--staff .admin-msg__time { color: rgba(255,255,255,0.5); text-align: right; }
                .chat-empty-state { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: var(--color-text-tertiary); gap: 12px; }
                .chat-empty-state i { font-size: 3rem; opacity: 0.3; }
                .chat-empty-state p { font-size: 0.85rem; }
                .chat-loading { display: flex; justify-content: center; align-items: center; padding: 40px; }
                .chat-loading .spinner { width: 28px; height: 28px; border: 3px solid #e2e8f0; border-top-color: var(--color-primary); border-radius: 50%; animation: chatSpin 0.8s linear infinite; }
                @keyframes chatSpin { to { transform: rotate(360deg); } }

                /* Admin Reply Input */
                .admin-reply-bar {
                    display: none; align-items: center; gap: 8px; padding: 14px 20px;
                    border-top: 1px solid var(--color-border); background: #fff;
                }
                .admin-reply-bar.visible { display: flex; }
                .admin-reply-bar input {
                    flex: 1; border: 1.5px solid var(--color-border); border-radius: var(--radius-full);
                    padding: 10px 16px; font-size: 0.82rem; outline: none; background: var(--color-bg);
                    color: var(--color-text-primary); transition: border-color 0.2s;
                }
                .admin-reply-bar input:focus { border-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245,158,11,0.1); }
                .admin-reply-bar button {
                    padding: 10px 20px; border-radius: var(--radius-full); border: none;
                    background: linear-gradient(135deg, #f59e0b, #d97706); color: #fff;
                    font-size: 0.8rem; font-weight: 600; cursor: pointer; transition: all 0.2s;
                    white-space: nowrap;
                }
                .admin-reply-bar button:hover { transform: scale(1.03); box-shadow: 0 4px 12px rgba(245,158,11,0.3); }
                .admin-reply-bar button:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
                
                /* New Message / Handoff Pulse */
                @keyframes pulseStaff {
                    0% { box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.4); }
                    70% { box-shadow: 0 0 0 10px rgba(245, 158, 11, 0); }
                    100% { box-shadow: 0 0 0 0 rgba(245, 158, 11, 0); }
                }
                .convo-item.pulse-staff {
                    animation: pulseStaff 2s infinite;
                    border-color: #f59e0b;
                }
            </style>
            <!-- Audio for notifications -->
            <audio id="notifSound" src="https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3" preload="auto"></audio>
        </head>

        <body class="luxury-admin">
            <%@ include file="/WEB-INF/views/admin/include/sidebar_admin.jsp" %>
            <%@ include file="/WEB-INF/views/admin/include/header_admin.jsp" %>

            <main class="lux-main">
                <div class="lux-content">
                    <!-- Page Header -->
                    <header class="lux-page-header">
                        <div class="lux-page-header__text">
                            <h1 class="lux-page-header__title">AI Chat History</h1>
                            <p class="lux-page-header__subtitle">AISTHÉA — Customer Conversations</p>
                        </div>
                    </header>

                    <div class="chat-admin-grid">
                        <!-- LEFT: Conversation List -->
                        <div class="convo-list-card">
                            <div class="convo-list-header">
                                <h3>Conversations</h3>
                                <span class="convo-count-badge" id="convoCount">—</span>
                            </div>
                            <div class="convo-search">
                                <input type="text" id="convoSearchInput" placeholder="Search customer...">
                                <button class="convo-filter-btn active" data-filter="ALL">All</button>
                                <button class="convo-filter-btn" data-filter="OPEN">Open</button>
                                <button class="convo-filter-btn" data-filter="CLOSED">Closed</button>
                                <button class="convo-filter-btn" data-filter="STAFF" style="border-color:#f59e0b;color:#d97706">Staff</button>
                            </div>
                            <div class="convo-list-body" id="convoListBody">
                                <div class="chat-loading"><div class="spinner"></div></div>
                            </div>
                        </div>

                        <!-- RIGHT: Chat Detail -->
                        <div class="chat-detail-panel" id="chatDetailPanel">
                            <div class="chat-empty-state" id="chatEmptyState">
                                <i class="fa-solid fa-comments"></i>
                                <p>Select a conversation to view</p>
                            </div>
                            <div class="chat-detail-header" id="chatDetailHeader" style="display:none;">
                                <div class="convo-avatar" id="detailAvatar" style="width:38px;height:38px;font-size:0.8rem;"></div>
                                <div style="flex:1">
                                    <h3 id="detailName">—</h3>
                                    <p id="detailMeta">—</p>
                                </div>
                                <span class="convo-type-badge" id="detailTypeBadge"></span>
                            </div>
                            <div class="chat-detail-messages" id="chatDetailMessages" style="display:none;"></div>

                            <!-- Admin Reply Input -->
                            <div class="admin-reply-bar" id="adminReplyBar">
                                <input type="text" id="adminReplyInput" placeholder="Nhập tin nhắn cho khách hàng..." autocomplete="off">
                                <button id="adminReplySend"><i class="fa-solid fa-paper-plane"></i> Gửi</button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <script>
            (function() {
                var ctxPath = '${pageContext.request.contextPath}';
                var convoListBody = document.getElementById('convoListBody');
                var convoCount = document.getElementById('convoCount');
                var chatEmptyState = document.getElementById('chatEmptyState');
                var chatDetailHeader = document.getElementById('chatDetailHeader');
                var chatDetailMessages = document.getElementById('chatDetailMessages');
                var detailAvatar = document.getElementById('detailAvatar');
                var detailName = document.getElementById('detailName');
                var detailMeta = document.getElementById('detailMeta');
                var detailTypeBadge = document.getElementById('detailTypeBadge');
                var searchInput = document.getElementById('convoSearchInput');
                var adminReplyBar = document.getElementById('adminReplyBar');
                var adminReplyInput = document.getElementById('adminReplyInput');
                var adminReplySend = document.getElementById('adminReplySend');

                var allConvos = [];
                var currentFilter = 'ALL';
                var activeConvoId = null;
                var activeConvoStatus = null;
                var lastAdminMsgId = 0;
                var pollTimer = null;
                var knownStaffConvos = new Set();
                var convoMsgCounts = {}; // Track message counts for each convoId
                var notifSound = document.getElementById('notifSound');
                var seenMessageIds = new Set(); // For deduplication

                // Filter buttons
                document.querySelectorAll('.convo-filter-btn').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        document.querySelectorAll('.convo-filter-btn').forEach(function(b) { b.classList.remove('active'); });
                        btn.classList.add('active');
                        currentFilter = btn.dataset.filter;
                        applyFilters();
                    });
                });
                searchInput.addEventListener('input', applyFilters);

                function applyFilters() {
                    var query = searchInput.value.toLowerCase().trim();
                    var filtered = allConvos.filter(function(c) {
                        var nameMatch = ((c.fullname||'') + ' ' + (c.username||'')).toLowerCase().indexOf(query) !== -1;
                        var statusMatch = currentFilter === 'ALL'
                            || (currentFilter === 'STAFF' && String(c.chatType||'').trim().toUpperCase() === 'STAFF')
                            || (currentFilter !== 'STAFF' && String(c.status||'').trim().toUpperCase() === currentFilter);
                        return nameMatch && statusMatch;
                    });
                    renderConvoList(filtered);
                }

                function loadConversations(autoSelectId) {
                    fetch(ctxPath + '/chat?action=conversations')
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        allConvos = data.conversations || [];
                        convoCount.textContent = allConvos.length;
                        
                        // Check for NEW staff handoffs OR NEW messages in existing staff chats
                        var hasReasonToNotif = false;
                        allConvos.forEach(function(c) {
                            var isStaffType = String(c.chatType||'').trim().toUpperCase() === 'STAFF';
                            var isOpen = String(c.status||'').trim().toUpperCase() === 'OPEN';
                            
                            // Reason 1: New handoff request
                            if (isStaffType && isOpen && !knownStaffConvos.has(c.convoId)) {
                                hasReasonToNotif = true;
                                knownStaffConvos.add(c.convoId);
                            }
                            
                            // Reason 2: New message in a staff chat (sent by customer)
                            var oldCount = convoMsgCounts[c.convoId] || 0;
                            if (isStaffType && isOpen && c.msgCount > oldCount) {
                                // Double check if last message was from customer to avoid notifying on staff replies
                                // For simplicity, we just notify if msgCount increases while chattype is staff
                                if (activeConvoId != c.convoId) { // Only if not currently looking at it
                                    hasReasonToNotif = true;
                                }
                            }
                            convoMsgCounts[c.convoId] = c.msgCount;
                        });

                        if (hasReasonToNotif) {
                            console.log("[ManageChats] New activity detected! Playing sound...");
                            if (notifSound) {
                                notifSound.currentTime = 0;
                                notifSound.play().catch(function(err) {
                                    console.warn("Audio play failed:", err);
                                });
                            }
                            // Blink title
                            var oldTitle = document.title;
                            var blinkCount = 0;
                            var blinker = setInterval(function() {
                                document.title = (blinkCount % 2 === 0) ? "🔔 CÓ TIN NHẮN..." : oldTitle;
                                if (++blinkCount > 10) {
                                    clearInterval(blinker);
                                    document.title = oldTitle;
                                }
                            }, 1000);
                        }
                        
                        applyFilters();

                        // Auto-select if requested
                        if (autoSelectId) {
                            var item = convoListBody.querySelector('.convo-item[data-convoid="' + autoSelectId + '"]');
                            if (item) {
                                item.click();
                                item.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            }
                        }
                    })
                    .catch(function() {
                        convoListBody.innerHTML = '<div class="chat-empty-state"><i class="fa-solid fa-triangle-exclamation"></i><p>Failed to load</p></div>';
                    });
                }

                // Initial load with potential deep link
                var urlParams = new URLSearchParams(window.location.search);
                var linkedId = urlParams.get('convoId');
                loadConversations(linkedId);

                // Refresh conversation list every 5 seconds
                setInterval(loadConversations, 5000);

                function renderConvoList(convos) {
                    if (convos.length === 0) {
                        convoListBody.innerHTML = '<div class="chat-empty-state" style="padding:40px"><i class="fa-solid fa-inbox"></i><p>No conversations found</p></div>';
                        return;
                    }
                    var html = '';
                    convos.forEach(function(c) {
                        var initials = (c.fullname || c.username || '?').charAt(0).toUpperCase();
                        var displayName = c.fullname || c.username || 'User #' + c.customerId;
                        var preview = c.lastMessage ? c.lastMessage.substring(0, 45) + (c.lastMessage.length > 45 ? '...' : '') : 'No messages';
                        var timeStr = c.lastActive ? formatTime(c.lastActive) : '';
                        var avatarHtml = (c.avatar && c.avatar !== 'images/ava_default.png')
                            ? '<img src="' + ctxPath + '/uploads/' + c.avatar + '" alt="">' : initials;
                        var statusClass = String(c.status||'').trim().toUpperCase() === 'OPEN' ? 'open' : 'closed';
                        var typeClass = String(c.chatType||'').trim().toUpperCase() === 'STAFF' ? 'staff' : 'ai';
                        var activeClass = (c.convoId == activeConvoId) ? ' active' : '';
                        var pulseClass = (String(c.chatType||'').trim().toUpperCase() === 'STAFF' && String(c.status||'').trim().toUpperCase() === 'OPEN') ? ' pulse-staff' : '';

                        html += '<div class="convo-item' + activeClass + pulseClass + '" data-convoid="' + c.convoId + '" data-name="' + escapeHtml(displayName) + '" data-type="' + String(c.chatType||'AI').trim().toUpperCase() + '" data-status="' + String(c.status||'OPEN').trim().toUpperCase() + '">'
                            + '<div class="convo-avatar">' + avatarHtml + '</div>'
                            + '<div class="convo-info">'
                            + '<p class="convo-name"><span class="convo-status-dot ' + statusClass + '"></span>' + escapeHtml(displayName) + '</p>'
                            + '<p class="convo-preview">' + escapeHtml(preview) + '</p>'
                            + '</div>'
                            + '<div class="convo-meta">'
                            + '<p class="convo-time">' + timeStr + '</p>'
                            + '<span class="convo-msg-count">' + c.msgCount + ' msgs</span>'
                            + '<br><span class="convo-type-badge ' + typeClass + '" style="margin-top:4px;display:inline-block">' + String(c.chatType||'AI').trim().toUpperCase() + '</span>'
                            + '</div></div>';
                    });
                    convoListBody.innerHTML = html;
                    convoListBody.querySelectorAll('.convo-item').forEach(function(item) {
                        item.addEventListener('click', function() {
                            convoListBody.querySelectorAll('.convo-item').forEach(function(el) { el.classList.remove('active'); });
                            item.classList.add('active');
                            loadChat(item.dataset.convoid, item.dataset.name, item.dataset.type, item.dataset.status);
                        });
                    });
                }

                function loadChat(convoId, name, chatType, status) {
                    activeConvoId = convoId;
                    activeConvoStatus = status;
                    lastAdminMsgId = 0;
                    seenMessageIds.clear(); // Clear for new chat
                    chatEmptyState.style.display = 'none';
                    chatDetailHeader.style.display = 'flex';
                    chatDetailMessages.style.display = 'flex';
                    chatDetailMessages.innerHTML = '<div class="chat-loading"><div class="spinner"></div></div>';

                    detailName.textContent = name;
                    detailAvatar.textContent = name.charAt(0).toUpperCase();
                    detailTypeBadge.textContent = chatType || 'AI';
                    detailTypeBadge.className = 'convo-type-badge ' + ((chatType||'').toLowerCase() === 'staff' ? 'staff' : 'ai');

                    // Show reply bar only for OPEN conversations
                    if ((status||'').toUpperCase() === 'OPEN') {
                        adminReplyBar.classList.add('visible');
                    } else {
                        adminReplyBar.classList.remove('visible');
                    }

                    fetch(ctxPath + '/chat?action=admin&convoId=' + convoId)
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        var msgs = data.messages || [];
                        detailMeta.textContent = msgs.length + ' messages · ' + (data.chatType||chatType||'AI') + ' · ' + (status||'OPEN');
                        renderMessages(msgs);
                        // Start polling for this conversation
                        startAdminPoll();
                    })
                    .catch(function() {
                        chatDetailMessages.innerHTML = '<div class="chat-empty-state"><i class="fa-solid fa-triangle-exclamation"></i><p>Failed to load</p></div>';
                    });
                }

                function renderMessages(msgs) {
                    var html = '';
                    msgs.forEach(function(m) {
                        var senderType = (m.sender||'').toUpperCase();
                        var cls = 'admin-msg--ai', label = '🤖 AI';
                        if (senderType === 'CUSTOMER') { cls = 'admin-msg--customer'; label = '👤 Customer'; }
                        else if (senderType === 'STAFF') { cls = 'admin-msg--staff'; label = '🧑‍💼 Staff'; }

                        var text = m.text || '';
                        if (senderType !== 'CUSTOMER') {
                            text = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>').replace(/\n/g, '<br>');
                        }
                        var timeStr = m.time ? formatTime(m.time) : '';
                        html += '<div class="admin-msg ' + cls + '">'
                            + '<div class="admin-msg__label">' + label + '</div>'
                            + text
                            + '<div class="admin-msg__time">' + timeStr + '</div></div>';
                        if (m.id && m.id > lastAdminMsgId) lastAdminMsgId = m.id;
                        if (m.id) seenMessageIds.add(String(m.id));
                    });
                    chatDetailMessages.innerHTML = html || '<div class="chat-empty-state"><p>No messages</p></div>';
                    chatDetailMessages.scrollTop = chatDetailMessages.scrollHeight;
                }

                // Admin send reply
                adminReplySend.addEventListener('click', sendAdminReply);
                adminReplyInput.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter') { e.preventDefault(); sendAdminReply(); }
                });

                function sendAdminReply() {
                    var text = adminReplyInput.value.trim();
                    if (!text || !activeConvoId) return;
                    adminReplySend.disabled = true;
                    adminReplyInput.value = '';

                    fetch(ctxPath + '/chat?action=staffReply', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                        body: JSON.stringify({ convoId: String(activeConvoId), message: text })
                    })
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        if (data.success) {
                            // Add message immediately to UI
                            var div = document.createElement('div');
                            div.className = 'admin-msg admin-msg--staff';
                            div.innerHTML = '<div class="admin-msg__label">🧑‍💼 Staff</div>' + escapeHtml(text)
                                + '<div class="admin-msg__time">Just now</div>';
                             chatDetailMessages.appendChild(div);
                             chatDetailMessages.scrollTop = chatDetailMessages.scrollHeight;
                             if (data.msgId > lastAdminMsgId) lastAdminMsgId = data.msgId;
                             if (data.msgId) seenMessageIds.add(String(data.msgId));
                         }
                    })
                    .finally(function() { adminReplySend.disabled = false; adminReplyInput.focus(); });
                }

                // ═══ Admin Polling ═══
                function startAdminPoll() {
                    stopAdminPoll();
                    pollTimer = setInterval(pollAdminMessages, 3000);
                }
                function stopAdminPoll() {
                    if (pollTimer) { clearInterval(pollTimer); pollTimer = null; }
                }

                function pollAdminMessages() {
                    if (!activeConvoId) return;
                    fetch(ctxPath + '/chat?action=poll&convoId=' + activeConvoId + '&after=' + lastAdminMsgId)
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        if (data.messages && data.messages.length > 0) {
                             data.messages.forEach(function(m) {
                                 // Deduplication
                                 if (seenMessageIds.has(String(m.id))) return;
                                 seenMessageIds.add(String(m.id));

                                 // Only add messages NOT from staff (avoid duplicates of own msgs)
                                 if (m.sender !== 'STAFF') {
                                    var senderType = (m.sender||'').toUpperCase();
                                    var cls = 'admin-msg--ai', label = '🤖 AI';
                                    if (senderType === 'CUSTOMER') { cls = 'admin-msg--customer'; label = '👤 Customer'; }
                                    var text = m.text || '';
                                    if (senderType !== 'CUSTOMER') {
                                        text = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>').replace(/\n/g, '<br>');
                                    }
                                    var div = document.createElement('div');
                                    div.className = 'admin-msg ' + cls;
                                    div.innerHTML = '<div class="admin-msg__label">' + label + '</div>' + text
                                        + '<div class="admin-msg__time">Just now</div>';
                                    chatDetailMessages.appendChild(div);
                                    chatDetailMessages.scrollTop = chatDetailMessages.scrollHeight;
                                }
                                if (m.id && m.id > lastAdminMsgId) lastAdminMsgId = m.id;
                            });
                        }
                        // Update chat type badge if changed
                        if (data.chatType) {
                            detailTypeBadge.textContent = data.chatType;
                            detailTypeBadge.className = 'convo-type-badge ' + (data.chatType.toLowerCase() === 'staff' ? 'staff' : 'ai');
                        }
                    })
                    .catch(function() { /* silent */ });
                }

                function formatTime(dateStr) {
                    try {
                        var d = new Date(dateStr);
                        if (isNaN(d.getTime())) return dateStr;
                        var now = new Date(); var diffMs = now - d;
                        var diffMins = Math.floor(diffMs / 60000);
                        if (diffMins < 1) return 'Just now';
                        if (diffMins < 60) return diffMins + 'm ago';
                        var diffHours = Math.floor(diffMins / 60);
                        if (diffHours < 24) return diffHours + 'h ago';
                        var diffDays = Math.floor(diffHours / 24);
                        if (diffDays < 7) return diffDays + 'd ago';
                        return d.toLocaleDateString('vi-VN');
                    } catch(e) { return dateStr; }
                }
                function escapeHtml(str) {
                    var div = document.createElement('div');
                    div.appendChild(document.createTextNode(str || ''));
                    return div.innerHTML;
                }
            })();
            </script>
        </body>
        </html>

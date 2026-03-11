<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- ========== AISTHÉA AI Chatbox Widget ==========
     Staff Handoff + HTTP Polling
     Only visible when user is logged in.
     ================================================ --%>

<c:if test="${not empty sessionScope.user}">

<style>
    .aisthea-chat-bubble {
        position: fixed; bottom: 28px; right: 28px; z-index: 9999;
        width: 64px; height: 64px; border-radius: 50%;
        background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
        color: #fff; display: flex; align-items: center; justify-content: center;
        cursor: pointer;
        box-shadow: 0 8px 32px rgba(15,23,42,0.35), 0 2px 8px rgba(0,0,0,0.15);
        transition: all 0.3s cubic-bezier(0.34,1.56,0.64,1);
        overflow: hidden; padding: 0;
    }
    .aisthea-chat-bubble:hover { transform: scale(1.1); box-shadow: 0 12px 40px rgba(15,23,42,0.5); }
    .aisthea-chat-bubble::after {
        content: ''; position: absolute; width: 100%; height: 100%; border-radius: 50%;
        background: rgba(15,23,42,0.3); animation: aisthea-pulse 2.5s ease-in-out infinite;
    }
    @keyframes aisthea-pulse {
        0%,100% { transform: scale(1); opacity: 0.5; }
        50% { transform: scale(1.4); opacity: 0; }
    }

    .aisthea-chat-window {
        position: fixed; bottom: 100px; right: 28px; z-index: 9998;
        width: 380px; max-height: 580px; background: #fff; border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.15), 0 0 0 1px rgba(0,0,0,0.05);
        display: flex; flex-direction: column; overflow: hidden;
        opacity: 0; visibility: hidden; transform: translateY(20px) scale(0.95);
        transition: all 0.3s cubic-bezier(0.34,1.56,0.64,1);
    }
    .aisthea-chat-window.open { opacity: 1; visibility: visible; transform: translateY(0) scale(1); }

    .aisthea-chat-header {
        background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
        color: #fff; padding: 18px 20px; display: flex; align-items: center; gap: 12px; flex-shrink: 0;
    }
    .aisthea-chat-header__avatar {
        width: 42px; height: 42px; border-radius: 50%; background: rgba(255,255,255,0.95);
        display: flex; align-items: center; justify-content: center;
        overflow: hidden; padding: 4px; flex-shrink: 0;
    }
    .aisthea-chat-header__info h4 {
        margin: 0; font-size: 0.95rem; font-weight: 700;
        font-family: 'Playfair Display', serif; letter-spacing: 0.5px;
    }
    .aisthea-chat-header__info p { margin: 2px 0 0; font-size: 0.72rem; opacity: 0.85; }
    .aisthea-chat-header__close {
        margin-left: auto; background: rgba(255,255,255,0.15); border: none; color: #fff;
        font-size: 1rem; width: 32px; height: 32px; border-radius: 50%; cursor: pointer;
        display: flex; align-items: center; justify-content: center; transition: background 0.2s;
    }
    .aisthea-chat-header__close:hover { background: rgba(255,255,255,0.3); }

    /* Mode indicator */
    .aisthea-chat-mode {
        padding: 8px 16px; font-size: 0.7rem; font-weight: 600; text-align: center;
        letter-spacing: 0.3px; flex-shrink: 0; transition: all 0.3s;
    }
    .aisthea-chat-mode.ai { background: #dbeafe; color: #2563eb; }
    .aisthea-chat-mode.staff { background: #fef3c7; color: #d97706; }

    .aisthea-chat-messages {
        flex: 1; overflow-y: auto; padding: 16px; display: flex; flex-direction: column;
        gap: 12px; min-height: 250px; max-height: 320px; background: #f8fafc;
    }
    .aisthea-chat-messages::-webkit-scrollbar { width: 4px; }
    .aisthea-chat-messages::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }

    .aisthea-msg {
        max-width: 82%; padding: 10px 14px; border-radius: 16px;
        font-size: 0.85rem; line-height: 1.5; animation: aisthea-fadeIn 0.3s ease;
    }
    @keyframes aisthea-fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
    .aisthea-msg--user {
        align-self: flex-end; background: linear-gradient(135deg, #0f172a, #1e293b);
        color: #fff; border-bottom-right-radius: 4px;
    }
    .aisthea-msg--ai {
        align-self: flex-start; background: #fff; color: #334155;
        border: 1px solid #e2e8f0; border-bottom-left-radius: 4px;
    }
    .aisthea-msg--staff {
        align-self: flex-start; background: linear-gradient(135deg, #f59e0b, #d97706);
        color: #fff; border-bottom-left-radius: 4px;
    }
    .aisthea-msg__label {
        font-size: 0.6rem; font-weight: 700; text-transform: uppercase;
        letter-spacing: 0.5px; margin-bottom: 2px; opacity: 0.7;
    }

    .aisthea-typing {
        align-self: flex-start; display: flex; gap: 4px; padding: 12px 16px;
        background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; border-bottom-left-radius: 4px;
    }
    .aisthea-typing span {
        width: 7px; height: 7px; border-radius: 50%; background: #94a3b8;
        animation: aisthea-bounce 1.4s ease-in-out infinite;
    }
    .aisthea-typing span:nth-child(2) { animation-delay: 0.2s; }
    .aisthea-typing span:nth-child(3) { animation-delay: 0.4s; }
    @keyframes aisthea-bounce { 0%,60%,100% { transform: translateY(0); } 30% { transform: translateY(-6px); } }

    /* Handoff + Actions Bar */
    .aisthea-chat-actions {
        display: flex; gap: 6px; padding: 6px 16px; border-top: 1px solid #e2e8f0;
        background: #fff; flex-shrink: 0;
    }
    .aisthea-action-btn {
        flex: 1; padding: 7px 10px; border-radius: 9999px; border: 1.5px solid #e2e8f0;
        font-size: 0.7rem; font-weight: 600; cursor: pointer; background: #f8fafc;
        color: #475569; transition: all 0.15s; text-align: center;
    }
    .aisthea-action-btn:hover { background: #0f172a; color: #fff; border-color: #0f172a; }
    .aisthea-action-btn--handoff { border-color: #f59e0b; color: #d97706; }
    .aisthea-action-btn--handoff:hover { background: #f59e0b; color: #fff; }

    .aisthea-chat-input {
        display: flex; align-items: center; gap: 8px; padding: 12px 16px;
        border-top: 1px solid #e2e8f0; background: #fff; flex-shrink: 0;
    }
    .aisthea-chat-input input {
        flex: 1; border: 1.5px solid #e2e8f0; border-radius: 9999px; padding: 10px 16px;
        font-size: 0.85rem; font-family: 'Manrope', sans-serif; color: #1e293b;
        outline: none; background: #f8fafc; transition: border-color 0.2s, box-shadow 0.2s;
    }
    .aisthea-chat-input input:focus { border-color: #024acf; box-shadow: 0 0 0 3px rgba(2,74,207,0.1); }
    .aisthea-chat-input input::placeholder { color: #94a3b8; }
    .aisthea-chat-input button {
        width: 40px; height: 40px; border-radius: 50%; border: none;
        background: linear-gradient(135deg, #0f172a, #1e293b); color: #fff;
        font-size: 0.9rem; cursor: pointer; display: flex; align-items: center;
        justify-content: center; transition: all 0.2s; flex-shrink: 0;
    }
    .aisthea-chat-input button:hover { transform: scale(1.08); box-shadow: 0 4px 16px rgba(15,23,42,0.3); }
    .aisthea-chat-input button:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }

    .aisthea-chat-footer {
        text-align: center; padding: 6px; font-size: 0.65rem; color: #94a3b8; background: #fff;
    }

    @media (max-width: 440px) {
        .aisthea-chat-window { width: calc(100vw - 24px); right: 12px; bottom: 80px; max-height: calc(100vh - 120px); }
        .aisthea-chat-bubble { bottom: 16px; right: 16px; width: 54px; height: 54px; }
    }

    /* Custom Modal Styles */
    .aisthea-modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(15, 23, 42, 0.4); backdrop-filter: blur(4px);
        display: flex; align-items: center; justify-content: center;
        z-index: 10000; opacity: 0; visibility: hidden; transition: all 0.3s ease;
    }
    .aisthea-modal-overlay.show { opacity: 1; visibility: visible; }
    .aisthea-modal-box {
        background: #fff; width: 90%; max-width: 380px; border-radius: 20px;
        padding: 32px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        transform: scale(0.9); transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        text-align: center;
    }
    .aisthea-modal-overlay.show .aisthea-modal-box { transform: scale(1); }
    .aisthea-modal-icon {
        width: 60px; height: 60px; background: #f8fafc; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        margin: 0 auto 20px; color: #0f172a; font-size: 1.5rem;
    }
    .aisthea-modal-title {
        font-family: 'Playfair Display', serif; font-size: 1.25rem;
        font-weight: 700; color: #0f172a; margin-bottom: 12px;
    }
    .aisthea-modal-text {
        font-size: 0.9rem; color: #64748b; line-height: 1.6; margin-bottom: 28px;
    }
    .aisthea-modal-actions { display: flex; gap: 12px; }
    .aisthea-modal-btn {
        flex: 1; padding: 12px; border-radius: 12px; font-size: 0.85rem;
        font-weight: 600; cursor: pointer; transition: all 0.2s; border: none;
    }
    .aisthea-modal-btn--cancel { background: #f1f5f9; color: #475569; }
    .aisthea-modal-btn--cancel:hover { background: #e2e8f0; }
    .aisthea-modal-btn--confirm {
        background: linear-gradient(135deg, #0f172a, #1e293b); color: #fff;
    }
    .aisthea-modal-btn--confirm:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(15, 23, 42, 0.3); }
</style>

<!-- Chat Bubble -->
<div class="aisthea-chat-bubble" id="aistheaChatBubble" title="Chat with AISTHÉA">
    <img src="${pageContext.request.contextPath}/assets/images/ata-logo.png" alt="AISTHÉA"
         style="width:44px;height:44px;object-fit:contain;position:relative;z-index:1;filter:drop-shadow(0 1px 2px rgba(0,0,0,0.1));">
</div>

<!-- Chat Window -->
<div class="aisthea-chat-window" id="aistheaChatWindow">
    <div class="aisthea-chat-header">
        <div class="aisthea-chat-header__avatar">
            <img src="${pageContext.request.contextPath}/assets/images/ata-logo.png" alt="AISTHÉA"
                 style="width:100%;height:100%;object-fit:contain;">
        </div>
        <div class="aisthea-chat-header__info">
            <h4>AISTHÉA Assistant</h4>
            <p id="aistheaHeaderStatus">
                <span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#4ade80;margin-right:4px;"></span>Online — AI Mode
            </p>
        </div>
        <button class="aisthea-chat-header__close" id="aistheaChatClose" title="Close">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>

    <!-- Mode indicator -->
    <div class="aisthea-chat-mode ai" id="aistheaChatMode">🤖 Đang chat với AI Assistant</div>

    <div class="aisthea-chat-messages" id="aistheaChatMessages"></div>

    <!-- Action buttons -->
    <div class="aisthea-chat-actions" id="aistheaChatActions">
        <button class="aisthea-action-btn aisthea-action-btn--handoff" id="aistheaHandoffBtn">
            🧑‍💼 Gặp nhân viên
        </button>
        <button class="aisthea-action-btn" id="aistheaCloseConvoBtn">
            ✕ Kết thúc chat
        </button>
    </div>

    <div class="aisthea-chat-input">
        <input type="text" id="aistheaChatInput" placeholder="Nhập tin nhắn..." autocomplete="off" />
        <button id="aistheaChatSend" title="Send"><i class="fa-solid fa-paper-plane"></i></button>
    </div>

    <div class="aisthea-chat-footer">Powered by Google Gemini AI</div>
</div>

<!-- Custom Modal -->
<div class="aisthea-modal-overlay" id="aistheaModalOverlay">
    <div class="aisthea-modal-box">
        <div class="aisthea-modal-icon">
            <i class="fa-solid fa-circle-question"></i>
        </div>
        <div class="aisthea-modal-title" id="aistheaModalTitle">Xác nhận</div>
        <div class="aisthea-modal-text" id="aistheaModalText">Bạn có chắc chắn muốn thực hiện hành động này?</div>
        <div class="aisthea-modal-actions">
            <button class="aisthea-modal-btn aisthea-modal-btn--cancel" id="aistheaModalCancel">Hủy bỏ</button>
            <button class="aisthea-modal-btn aisthea-modal-btn--confirm" id="aistheaModalConfirm">Đồng ý</button>
        </div>
    </div>
</div>

<script>
(function() {
    var bubble    = document.getElementById('aistheaChatBubble');
    var chatWin   = document.getElementById('aistheaChatWindow');
    var closeBtn  = document.getElementById('aistheaChatClose');
    var msgArea   = document.getElementById('aistheaChatMessages');
    var input     = document.getElementById('aistheaChatInput');
    var sendBtn   = document.getElementById('aistheaChatSend');
    var modeBar   = document.getElementById('aistheaChatMode');
    var headerSt  = document.getElementById('aistheaHeaderStatus');
    var handoffBtn = document.getElementById('aistheaHandoffBtn');
    var closeConvoBtn = document.getElementById('aistheaCloseConvoBtn');

    var isOpen = false, isSending = false, historyLoaded = false;
    var chatHistory = [];
    var currentConvoId = 0;
    var currentChatType = 'AI';
    var lastMessageId = 0;
    var seenMessageIds = new Set(); // For deduplication
    var pollTimer = null;
    var ctxPath = '${pageContext.request.contextPath}';

    // Toggle chat
    function toggleChat() {
        isOpen = !isOpen;
        if (isOpen) {
            chatWin.classList.add('open');
            bubble.style.transform = 'scale(0)';
            bubble.style.opacity = '0';
            setTimeout(function() { input.focus(); }, 350);
            if (!historyLoaded) { loadHistory(); historyLoaded = true; }
            startPolling();
        } else {
            chatWin.classList.remove('open');
            bubble.style.transform = 'scale(1)';
            bubble.style.opacity = '1';
            stopPolling();
        }
    }
    bubble.addEventListener('click', toggleChat);
    closeBtn.addEventListener('click', toggleChat);

    // Update mode display
    function updateModeUI(chatType) {
        currentChatType = chatType;
        if (chatType === 'STAFF') {
            modeBar.className = 'aisthea-chat-mode staff';
            modeBar.innerHTML = '🧑‍💼 Đang chat với nhân viên hỗ trợ';
            headerSt.innerHTML = '<span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#f59e0b;margin-right:4px;"></span>Staff Mode';
            handoffBtn.style.display = 'none';
        } else {
            modeBar.className = 'aisthea-chat-mode ai';
            modeBar.innerHTML = '🤖 Đang chat với AI Assistant';
            headerSt.innerHTML = '<span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#4ade80;margin-right:4px;"></span>Online — AI Mode';
            handoffBtn.style.display = '';
        }
    }

    // Load history
    function loadHistory() {
        fetch(ctxPath + '/chat?action=history')
        .then(function(res) { return res.json(); })
        .then(function(data) {
            currentConvoId = data.convoId || 0;
            updateModeUI(data.chatType || 'AI');
            if (data.messages && data.messages.length > 0) {
                data.messages.forEach(function(m) {
                    addMessage(m.text, m.sender || (m.role === 'user' ? 'CUSTOMER' : 'AI'), false);
                    if (m.id && m.id > lastMessageId) lastMessageId = m.id;
                    if (m.id) seenMessageIds.add(String(m.id));
                });
            } else {
                addMessage('Xin chào <strong>${sessionScope.user.fullname}</strong>! 👋 Tôi là <strong>AISTHÉA Assistant</strong>. Tôi có thể giúp bạn tìm kiếm sản phẩm, tư vấn size, hoặc giải đáp thắc mắc. Hãy hỏi tôi bất cứ điều gì! ✨', 'AI', false);
            }
        })
        .catch(function() {
            addMessage('Xin chào! 👋 Tôi là <strong>AISTHÉA Assistant</strong>. Hãy hỏi tôi bất cứ điều gì! ✨', 'AI', false);
        });
    }

    // Add message
    function addMessage(text, sender, animate) {
        if (text === null || text === undefined) text = '';
        var div = document.createElement('div');
        var cls = 'aisthea-msg--ai';
        if (sender === 'CUSTOMER') cls = 'aisthea-msg--user';
        else if (sender === 'STAFF') cls = 'aisthea-msg--staff';
        div.className = 'aisthea-msg ' + cls;

        var labelHtml = '';
        if (sender === 'STAFF') labelHtml = '<div class="aisthea-msg__label">🧑‍💼 Nhân viên</div>';

        if (sender !== 'CUSTOMER') {
            try {
                text = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
                text = text.replace(/\n/g, '<br>');
            } catch (e) {
                console.error('[ChatWidget] Regex error:', e, text);
            }
        }
        div.innerHTML = labelHtml + text;
        if (animate === false) div.style.animation = 'none';
        msgArea.appendChild(div);
        msgArea.scrollTop = msgArea.scrollHeight;
    }

    function showTyping() {
        var div = document.createElement('div');
        div.className = 'aisthea-typing'; div.id = 'aistheaTyping';
        div.innerHTML = '<span></span><span></span><span></span>';
        msgArea.appendChild(div); msgArea.scrollTop = msgArea.scrollHeight;
    }
    function removeTyping() { var el = document.getElementById('aistheaTyping'); if (el) el.remove(); }

    // Send message
    function sendMessage() {
        var text = input.value.trim();
        if (!text || isSending) return;
        isSending = true; sendBtn.disabled = true; input.value = '';
        console.log('[Chat] User sending:', text);
        addMessage(text, 'CUSTOMER', true);

        if (currentChatType === 'AI') showTyping();
        console.log('[Chat] sending to:', ctxPath + '/chat');
        fetch(ctxPath + '/chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: text, history: chatHistory })
        })
        .then(function(res) {
            console.log('[Chat] Response status:', res.status, res.statusText);
            if (!res.ok) {
                return res.json().then(function(errData) {
                    throw new Error(errData.error || 'Lỗi từ máy chủ (' + res.status + ')');
                });
            }
            return res.json();
        })
        .then(function(data) {
            console.log('[Chat] Received JSON data:', data);
            removeTyping();
            if (data.chatType) updateModeUI(data.chatType);
            if (data.convoId) currentConvoId = data.convoId;
            if (data.msgId && data.msgId > lastMessageId) lastMessageId = data.msgId;

            if (data.reply && data.reply.length > 0) {
                addMessage(data.reply, 'AI', true);
                chatHistory.push({ role: 'user', text: text });
                chatHistory.push({ role: 'model', text: data.reply });
                if (chatHistory.length > 20) chatHistory = chatHistory.slice(-20);
                if (data.replyId && data.replyId > lastMessageId) lastMessageId = data.replyId;
                if (data.replyId) seenMessageIds.add(String(data.replyId));
            }
            if (data.msgId) seenMessageIds.add(String(data.msgId));
        })
        .catch(function(err) {
            removeTyping();
            var friendlyMsg = '⚠️ Có lỗi xảy ra. Vui lòng thử lại sau!';
            if (err.message.indexOf('429') !== -1) {
                friendlyMsg = '⚠️ Hệ thống AI đang bận (hết hạn mức). Bạn vui lòng đợi vài giây rồi nhắn lại nhé, hoặc bấm "Gặp nhân viên" để được hỗ trợ ngay! 🙏';
            } else if (err.message.indexOf('404') !== -1) {
                friendlyMsg = '⚠️ Không tìm thấy máy chủ AI. Vui lòng báo cho quản trị viên!';
            }
            addMessage(friendlyMsg, 'AI', true);
            console.error('[Chat] FATAL ERROR:', err);
        })
        .finally(function() { isSending = false; sendBtn.disabled = false; input.focus(); });
    }

    sendBtn.addEventListener('click', sendMessage);
    input.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(); }
    });

    // ═════ Custom Confirm Modal Logic ═════
    var modalOverlay = document.getElementById('aistheaModalOverlay');
    var modalTitle   = document.getElementById('aistheaModalTitle');
    var modalText    = document.getElementById('aistheaModalText');
    var modalCancel  = document.getElementById('aistheaModalCancel');
    var modalConfirm = document.getElementById('aistheaModalConfirm');
    var modalCallback = null;

    function showAistheaConfirm(title, message, callback) {
        modalTitle.textContent = title;
        modalText.textContent = message;
        modalCallback = callback;
        modalOverlay.classList.add('show');
    }

    modalCancel.addEventListener('click', function() {
        modalOverlay.classList.remove('show');
        modalCallback = null;
    });

    modalConfirm.addEventListener('click', function() {
        modalOverlay.classList.remove('show');
        if (modalCallback) modalCallback();
        modalCallback = null;
    });

    // Handoff to staff
    handoffBtn.addEventListener('click', function() {
        showAistheaConfirm('Chuyển sang nhân viên', 'Bạn muốn chuyển sang nói chuyện với nhân viên thật?', function() {
            fetch(ctxPath + '/chat?action=handoff', { method: 'POST',
                headers: { 'Content-Type': 'application/json' }, body: '{}' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                console.log('[Handoff] Received response:', data);
                if (data.systemMsg) {
                    addMessage(data.systemMsg, 'AI', true);
                    if (data.msgId) {
                        seenMessageIds.add(String(data.msgId));
                        if (data.msgId > lastMessageId) lastMessageId = data.msgId;
                    }
                }
                if (data.success) {
                    updateModeUI('STAFF');
                } else if (data.error === 'STAFF_OFFLINE') {
                    updateModeUI('AI');
                }
                pollNewMessages();
            });
        });
    });

    // Close conversation
    closeConvoBtn.addEventListener('click', function() {
        showAistheaConfirm('Kết thúc hội thoại', 'Bạn muốn kết thúc cuộc trò chuyện này?', function() {
            fetch(ctxPath + '/chat?action=close', { method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ convoId: String(currentConvoId) }) })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    historyLoaded = false;
                    currentConvoId = 0;
                    lastMessageId = 0;
                    chatHistory = [];
                    msgArea.innerHTML = '';
                    updateModeUI('AI');
                    addMessage('Cuộc trò chuyện đã kết thúc. Mở chat lại để bắt đầu cuộc hội thoại mới! 🙏', 'AI', true);
                }
            });
        });
    });

    // ═══ HTTP Polling ═══
    function startPolling() {
        stopPolling();
        pollTimer = setInterval(pollNewMessages, 3000);
    }
    function stopPolling() {
        if (pollTimer) { clearInterval(pollTimer); pollTimer = null; }
    }

    function pollNewMessages() {
        if (!currentConvoId || currentConvoId <= 0) return;
        fetch(ctxPath + '/chat?action=poll&convoId=' + currentConvoId + '&after=' + lastMessageId)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.chatType) updateModeUI(data.chatType);
            if (data.messages && data.messages.length > 0) {
                data.messages.forEach(function(m) {
                    // Deduplication
                    if (seenMessageIds.has(String(m.id))) return;
                    seenMessageIds.add(String(m.id));

                    // Only show messages NOT sent by customer (avoid duplicates)
                    if (m.sender !== 'CUSTOMER') {
                        addMessage(m.text, m.sender, true);
                    }
                    if (m.id && m.id > lastMessageId) lastMessageId = m.id;
                });
            }
        })
        .catch(function() { /* silent fail */ });
    }
})();
</script>

</c:if>

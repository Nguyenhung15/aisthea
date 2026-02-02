<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <% if (session.getAttribute("user")==null) { response.sendRedirect(request.getContextPath() + "/login" );
            return; } %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Hồ sơ cá nhân | AISTHÉA</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <style>
                    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap');

                    body {
                        margin: 0;
                        padding: 0;
                        font-family: 'Poppins', sans-serif;
                        background: url('${pageContext.request.contextPath}/images/bg-watercolor.png') no-repeat center center fixed;
                        background-size: cover;
                        height: 100vh;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }

                    /* Logo */
                    .logo {
                        position: absolute;
                        top: 20px;
                        left: 30px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        animation: fadeIn 1.2s ease;
                    }

                    .logo img {
                        height: 60px;
                        width: auto;
                        cursor: pointer;
                        transition: transform 0.3s ease;
                    }

                    .logo img:hover {
                        transform: scale(1.05);
                    }

                    .logo span {
                        font-weight: 600;
                        color: #003366;
                        font-size: 20px;
                        letter-spacing: 1px;
                    }

                    /* Container */
                    .profile-container {
                        background: rgba(255, 255, 255, 0.5);
                        backdrop-filter: blur(14px);
                        border-radius: 20px;
                        box-shadow: 0 8px 25px rgba(0, 0, 0, .15);
                        width: 550px;
                        padding: 45px 50px;
                        color: #003366;
                        opacity: 0;
                        animation: fadeInUp 1s ease forwards;
                    }

                    .profile-header {
                        text-align: center;
                        margin-bottom: 25px;
                    }

                    .profile-header h2 {
                        margin: 0;
                        font-size: 24px;
                        font-weight: 600;
                        color: #003366;
                    }

                    .profile-header p {
                        margin-top: 8px;
                        font-size: 14px;
                        color: #555;
                    }

                    /* Avatar section */
                    .profile-img {
                        text-align: center;
                        margin-bottom: 25px;
                        position: relative;
                    }

                    .avatar-circle {
                        width: 120px;
                        height: 120px;
                        border-radius: 50%;
                        border: 3px solid #003366;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        background: white;
                        margin: 0 auto;
                        cursor: pointer;
                        transition: 0.3s;
                    }

                    .avatar-circle:hover {
                        box-shadow: 0 0 12px rgba(0, 51, 102, 0.3);
                    }

                    .avatar-circle img {
                        width: 100%;
                        height: 100%;
                        border-radius: 50%;
                        object-fit: cover;
                    }

                    .avatar-circle i {
                        font-size: 50px;
                        color: #003366;
                    }

                    /* Form */
                    form {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 20px 25px;
                    }

                    .form-group {
                        display: flex;
                        flex-direction: column;
                    }

                    label {
                        font-weight: 500;
                        font-size: 14px;
                        color: #00264d;
                        margin-bottom: 6px;
                    }

                    input,
                    select {
                        width: 100%;
                        padding: 11px 12px;
                        border: none;
                        border-radius: 8px;
                        background: rgba(255, 255, 255, 0.9);
                        outline: none;
                        font-size: 14px;
                        box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.1);
                        transition: all 0.25s ease;
                    }

                    input:focus,
                    select:focus {
                        background: rgba(255, 255, 255, 0.98);
                        box-shadow: 0 0 6px rgba(0, 76, 153, 0.3);
                    }

                    .form-actions {
                        grid-column: span 2;
                        text-align: center;
                        margin-top: 15px;
                    }

                    button {
                        background: linear-gradient(135deg, #004c99, #0073e6);
                        color: white;
                        padding: 12px 30px;
                        border: none;
                        border-radius: 8px;
                        cursor: pointer;
                        font-weight: 600;
                        transition: all 0.3s ease;
                        font-size: 15px;
                    }

                    button:hover {
                        transform: translateY(-2px);
                        background: linear-gradient(135deg, #0066cc, #0099ff);
                        box-shadow: 0 4px 15px rgba(0, 102, 204, 0.4);
                    }

                    @keyframes fadeInUp {
                        from {
                            transform: translateY(40px);
                            opacity: 0;
                        }

                        to {
                            transform: translateY(0);
                            opacity: 1;
                        }
                    }

                    /* Modal CSS */
                    .modal {
                        display: none;
                        position: fixed;
                        z-index: 1000;
                        left: 0;
                        top: 0;
                        width: 100%;
                        height: 100%;
                        overflow: auto;
                        background-color: rgba(0, 0, 0, 0.5);
                        animation: fadeIn 0.3s;
                    }

                    .modal-content {
                        background-color: #fefefe;
                        margin: 10% auto;
                        padding: 30px;
                        border: 1px solid #888;
                        width: 400px;
                        border-radius: 15px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
                        position: relative;
                        animation: slideDown 0.4s;
                    }

                    @keyframes slideDown {
                        from {
                            transform: translateY(-50px);
                            opacity: 0;
                        }

                        to {
                            transform: translateY(0);
                            opacity: 1;
                        }
                    }

                    .close {
                        color: #aaa;
                        float: right;
                        font-size: 28px;
                        font-weight: bold;
                        cursor: pointer;
                    }

                    .close:hover,
                    .close:focus {
                        color: black;
                        text-decoration: none;
                        cursor: pointer;
                    }

                    .modal h3 {
                        color: #003366;
                        margin-top: 0;
                        text-align: center;
                        margin-bottom: 20px;
                    }

                    .btn-secondary {
                        background: linear-gradient(135deg, #6c757d, #495057);
                        margin-left: 10px;
                    }

                    .btn-secondary:hover {
                        background: linear-gradient(135deg, #5a6268, #343a40);
                    }
                </style>
            </head>

            <body>

                <!-- Logo -->
                <div class="logo">
                    <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                        <img src="${pageContext.request.contextPath}/images/ata-logo.png" alt="AISTHÉA Logo">
                    </a>
                    <span>AISTHÉA</span>
                </div>

                <!-- Profile Form -->
                <div class="profile-container">
                    <div class="profile-header">
                        <h2>Hồ sơ cá nhân</h2>
                        <p>Quản lý thông tin tài khoản của bạn</p>
                    </div>

                    <form id="profileForm" action="${pageContext.request.contextPath}/updateProfile" method="post"
                        enctype="multipart/form-data">

                        <!-- Avatar -->
                        <div class="profile-img" style="grid-column: span 2;">
                            <label for="avatarInput">
                                <div class="avatar-circle" id="avatarWrapper">
                                    <c:choose>
                                        <c:when
                                            test="${not empty sessionScope.user.avatar and !sessionScope.user.avatar.equals('images/ava_default.png')}">
                                            <img id="avatarPreview"
                                                src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}"
                                                alt="Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-user"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </label>
                            <input type="file" id="avatarInput" name="avatar" accept="image/*" style="display:none;">
                        </div>

                        <!-- Thông tin -->
                        <div class="form-group">
                            <label>Họ và tên</label>
                            <input type="text" name="fullname" value="${sessionScope.user.fullname}" required>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" value="${sessionScope.user.email}" required readonly
                                style="background: rgba(200, 200, 200, 0.3); cursor: not-allowed;">
                        </div>
                        <div class="form-group">
                            <label>Giới tính</label>
                            <select name="gender">
                                <option value="Male" ${sessionScope.user.gender=='Male' ? 'selected' : '' }>Nam</option>
                                <option value="Female" ${sessionScope.user.gender=='Female' ? 'selected' : '' }>Nữ
                                </option>
                                <option value="Other" ${sessionScope.user.gender=='Other' ? 'selected' : '' }>Khác
                                </option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="text" name="phone" value="${sessionScope.user.phone}">
                        </div>
                        <div class="form-group" style="grid-column: span 2;">
                            <label>Địa chỉ</label>
                            <input type="text" name="address" value="${sessionScope.user.address}">
                        </div>

                        <div class="form-actions" style="grid-column: span 2;text-align:center;">
                            <button type="submit">Cập nhật thông tin</button>
                            <button type="button" class="btn-secondary" onclick="openModal()">Đổi mật khẩu</button>
                        </div>
                    </form>
                </div>

                <!-- Change Password Modal -->
                <div id="passwordModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal()">&times;</span>
                        <h3>Đổi mật khẩu</h3>
                        <form action="${pageContext.request.contextPath}/change-password" method="post"
                            style="display: flex; flex-direction: column; gap: 15px;">
                            <div class="form-group">
                                <label>Mật khẩu cũ</label>
                                <input type="password" name="oldPassword" required placeholder="Nhập mật khẩu hiện tại">
                            </div>
                            <div class="form-group">
                                <label>Mật khẩu mới</label>
                                <input type="password" name="newPassword" required placeholder="Nhập mật khẩu mới">
                            </div>
                            <div class="form-group">
                                <label>Xác nhận mật khẩu mới</label>
                                <input type="password" name="confirmPassword" required
                                    placeholder="Nhập lại mật khẩu mới">
                            </div>
                            <div style="text-align: center; margin-top: 10px;">
                                <button type="submit" style="width: 100%;">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    // ... existing avatar code ...
                    const avatarInput = document.getElementById("avatarInput");
                    const avatarWrapper = document.getElementById("avatarWrapper");

                    avatarInput.addEventListener("change", e => {
                        const file = e.target.files[0];
                        if (file) {
                            let preview = document.getElementById("avatarPreview");
                            if (!preview) {
                                preview = document.createElement("img");
                                preview.id = "avatarPreview";
                                preview.style.width = "100%";
                                preview.style.height = "100%";
                                preview.style.borderRadius = "50%";
                                preview.style.objectFit = "cover";
                                avatarWrapper.innerHTML = "";
                                avatarWrapper.appendChild(preview);
                            }
                            preview.src = URL.createObjectURL(file);
                        }
                    });

                    // Modal Script
                    function openModal() {
                        document.getElementById("passwordModal").style.display = "block";
                    }

                    function closeModal() {
                        document.getElementById("passwordModal").style.display = "none";
                    }

                    window.onclick = function (event) {
                        if (event.target == document.getElementById("passwordModal")) {
                            closeModal();
                        }
                    }

                </script>

                <c:if test="${not empty sessionScope.changePassSuccess}">
                    <script>
                        alert("${sessionScope.changePassSuccess}");
                    </script>
                    <c:remove var="changePassSuccess" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.changePassError}">
                    <script>
                        alert("${sessionScope.changePassError}");
                    </script>
                    <c:remove var="changePassError" scope="session" />
                </c:if>

                <% if (request.getParameter("success") !=null) { %>
                    <script>
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/views/homepage.jsp';
                        }, 1200);
                    </script>
                    <% } %>
            </body>

            </html>
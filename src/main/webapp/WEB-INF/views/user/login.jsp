<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html>


    <head>
        <title>Login - AISTHÉA</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


        <style>
            * {
                box-sizing: border-box;
            }


            body {
                background: url("${pageContext.request.contextPath}/images/bg-watercolor.png?v=1") no-repeat center center fixed;
                background-size: cover;
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
                font-family: 'Inter', sans-serif;
                height: 100vh;
                margin: 0;
            }


            h2 {
                text-align: center;
                margin: 0;
                color: #0f2c52;
                font-weight: 700;
                font-size: 28px;
            }


            p {
                font-size: 15px;
                font-weight: 500;
                line-height: 22px;
                letter-spacing: 0.5px;
                margin: 20px 0 30px;
                color: #1A4971;
            }


            span {
                font-size: 13px;
                color: #667788;
            }


            a {
                color: #0066cc;
                font-size: 14px;
                text-decoration: none;
                margin: 15px 0;
                font-weight: 600;
            }


            button {
                border-radius: 12px;
                border: none;
                background: linear-gradient(135deg, #4A8BC2 0%, #286090 100%);
                color: #FFFFFF;
                font-size: 15px;
                font-weight: bold;
                padding: 12px 45px;
                margin-top: 15px;
                letter-spacing: 1px;
                text-transform: uppercase;
                transition: transform 80ms ease-in, box-shadow 80ms ease-in;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(40, 96, 144, 0.4);
                width: 100%;
            }


            button:active {
                transform: scale(0.98);
            }


            button:hover {
                box-shadow: 0 6px 20px rgba(40, 96, 144, 0.6);
                transform: translateY(-2px);
                background: linear-gradient(135deg, #5CA0D8 0%, #3174AD 100%);
            }


            button:focus {
                outline: none;
            }


            button.ghost {
                background-color: transparent;
                border: 2px solid #ffffff;
                color: #ffffff;
                box-shadow: none;
                width: auto;
                font-weight: 800;
                letter-spacing: 2px;
                transition: all 0.3s ease;
            }


            button.ghost:hover {
                background-color: #ffffff;
                color: #1A4971;
                box-shadow: 0 4px 15px rgba(255, 255, 255, 0.4);
            }


            form {
                background-color: transparent;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                padding: 0 40px;
                height: 100%;
                width: 100%;
                text-align: center;
            }


            input,
            select {
                background-color: rgba(255, 255, 255, 0.9);
                border: 1px solid #e0e6ed;
                padding: 12px 15px;
                margin: 6px 0;
                width: 100%;
                border-radius: 10px;
                font-size: 14px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }


            input:focus,
            select:focus {
                outline: none;
                border-color: #2b7bff;
                box-shadow: 0 0 0 3px rgba(43, 123, 255, 0.15);
                background-color: #ffffff;
            }


            .container {
                background: rgba(255, 255, 255, 0.9);
                /* Readability returned while keeping slight transparency */
                backdrop-filter: blur(45px);
                -webkit-backdrop-filter: blur(45px);
                border: 1px solid rgba(255, 255, 255, 0.7);
                border-radius: 30px;
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.12);
                position: relative;
                overflow: hidden;
                width: 900px;
                max-width: 100%;
                min-height: 680px;
            }


            .form-container {
                position: absolute;
                top: 0;
                height: 100%;
                transition: all 0.6s ease-in-out;
                width: 50%;
                background: transparent;
            }


            .sign-in-container {
                left: 0;
                z-index: 2;
                background: transparent;
            }


            .container.right-panel-active .sign-in-container {
                transform: translateX(100%);
                opacity: 0;
                pointer-events: none;
            }


            .sign-up-container {
                left: 0;
                opacity: 0;
                z-index: 1;
                align-items: flex-start;
                pointer-events: none;
                background: transparent;
            }


            .container.right-panel-active .sign-up-container {
                transform: translateX(100%);
                opacity: 1;
                z-index: 5;
                animation: show 0.6s;
                pointer-events: auto;
            }


            @keyframes show {


                0%,
                49.99% {
                    opacity: 0;
                    z-index: 1;
                }


                50%,
                100% {
                    opacity: 1;
                    z-index: 5;
                }
            }


            .overlay-container {
                position: absolute;
                top: 0;
                left: 50%;
                width: 50%;
                height: 100%;
                overflow: hidden;
                transition: transform 0.6s ease-in-out;
                z-index: 100;
            }


            .container.right-panel-active .overlay-container {
                transform: translateX(-100%);
            }


            .overlay {
                color: #ffffff;
                position: relative;
                left: -100%;
                height: 100%;
                width: 200%;
                transform: translateX(0);
                transition: transform 0.6s ease-in-out;
                overflow: hidden;
            }


            .overlay::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(26, 42, 58, 0.5) 0%, rgba(15, 23, 34, 0.4) 100%),
                    url("${pageContext.request.contextPath}/images/bg-watercolor.png?v=1") center center;
                background-size: cover;
                filter: blur(0.5px) brightness(1.05);
                z-index: -1;
            }


            .container.right-panel-active .overlay {
                transform: translateX(50%);
            }


            .overlay-panel {
                position: absolute;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                padding: 30px;
                text-align: center;
                top: 55%;
                width: 50%;
                height: auto;
                background: transparent;
                backdrop-filter: none;
                -webkit-backdrop-filter: none;
                border: none;
                border-radius: 0;
                box-shadow: none;
                transition: transform 0.6s ease-in-out, opacity 0.6s ease-in-out;
            }


            .overlay-panel h1,
            .overlay-panel h2 {
                color: #ffffff !important;
                font-weight: 800 !important;
                letter-spacing: 2px;
                -webkit-text-stroke: 0;
                text-shadow: 0px 4px 12px rgba(0, 0, 0, 0.5);
                margin-bottom: 12px;
            }


            .overlay-panel p {
                color: #ffffff !important;
                font-weight: 500 !important;
                font-size: 16px;
                line-height: 26px;
                -webkit-text-stroke: 0;
                text-shadow: 0px 4px 10px rgba(0, 0, 0, 0.5);
                margin-bottom: 25px;
            }


            .overlay-left {
                left: 0;
                transform: translateY(-50%) translateX(-20%);
                opacity: 0;
                pointer-events: none;
            }


            .container.right-panel-active .overlay-left {
                transform: translateY(-50%) translateX(0);
                opacity: 1;
                pointer-events: auto;
            }


            .overlay-right {
                right: 0;
                transform: translateY(-50%) translateX(0);
                opacity: 1;
                pointer-events: auto;
            }


            .container.right-panel-active .overlay-right {
                transform: translateY(-50%) translateX(20%);
                opacity: 0;
                pointer-events: none;
            }


            .social-container {
                margin: 20px 0;
                display: flex;
                justify-content: center;
                width: 100%;
            }


            /* Adjustments for register fields */
            .row {
                display: flex;
                gap: 12px;
                width: 100%;
            }


            .col {
                flex: 1;
                min-width: 0;
                display: flex;
                flex-direction: column;
            }


            .validation-msg {
                color: #d93025;
                font-size: 11px;
                text-align: left;
                width: 100%;
                margin-top: -6px;
                margin-bottom: 2px;
                min-height: 14px;
                font-weight: 500;
            }


            .error {
                color: #d93025;
                margin-top: 15px;
                font-size: 14px;
                font-weight: 600;
            }


            .logo-container {
                position: absolute;
                top: 7%;
                margin-left: -65px;
                width: 50%;
                display: flex;
                flex-direction: column;
                align-items: center;
                z-index: 1001;
                transition: transform 0.6s ease-in-out, opacity 0.6s ease-in-out;
            }


            .logo-left {
                left: 0;
                transform: translateX(-20%);
                opacity: 0;
                pointer-events: none;
            }


            .container.right-panel-active .logo-left {
                transform: translateX(0);
                opacity: 1;
                pointer-events: auto;
            }


            .logo-right {
                right: 0;
                transform: translateX(0);
                opacity: 1;
                pointer-events: auto;
            }


            .container.right-panel-active .logo-right {
                transform: translateX(20%);
                opacity: 0;
                pointer-events: none;
            }


            .logo {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 15px;
                text-decoration: none;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            }


            .logo:hover {
                transform: translateY(-5px) scale(1.05);
            }


            .logo img {
                margin-bottom: 25px;
                height: 75px;
                filter: drop-shadow(0 4px 12px rgba(255, 255, 255, 0.4));
                transform: translateY(-2px);
            }


            .logo span {
                font-weight: 800;
                letter-spacing: 6px;
                margin-right: -6px;
                color: #ffffff;
                font-size: 32px;
                text-transform: uppercase;
                text-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
            }


            /* Sign up scrollbar */
            .sign-up-container form {
                justify-content: center;
                overflow-y: auto;
                padding-top: 20px;
                padding-bottom: 20px;
            }


            .sign-up-container form::-webkit-scrollbar {
                width: 6px;
            }


            .sign-up-container form::-webkit-scrollbar-thumb {
                background-color: rgba(0, 0, 0, 0.15);
                border-radius: 10px;
            }
        </style>
    </head>


    <body>






        <div class="container" id="container">
            <!-- REGISTRATION FORM -->
            <div class="form-container sign-up-container">
                <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post">
                    <h2>Tạo Tài Khoản</h2>
                    <div class="social-container" style="min-height: 10px; margin: 10px 0;"></div>


                    <input type="text" name="fullname" placeholder="Họ và tên" required />


                    <input type="email" name="email" id="reg-email" placeholder="Email" required />
                    <div id="emailMsg" class="validation-msg"></div>


                    <div class="row">
                        <div class="col">
                            <input type="password" name="password" id="reg-password" placeholder="Mật khẩu"
                                   required />
                            <div id="passwordMsg" class="validation-msg"></div>
                        </div>
                        <div class="col">
                            <input type="password" name="confirmPassword" id="reg-confirmPassword"
                                   placeholder="Nhập lại mật khẩu" required />
                            <div id="confirmMsg" class="validation-msg"></div>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col">
                            <select name="gender" id="reg-gender" required>
                                <option value="">-- Giới tính --</option>
                                <option value="Male">Nam</option>
                                <option value="Female">Nữ</option>
                                <option value="Other">Khác</option>
                            </select>
                            <div id="genderMsg" class="validation-msg"></div>
                        </div>
                        <div class="col">
                            <input type="text" name="phone" id="reg-phone" placeholder="Số điện thoại" />
                            <div id="phoneMsg" class="validation-msg"></div>
                        </div>
                    </div>


                    <input type="text" name="address" placeholder="Địa chỉ" />


                    <button type="submit">Đăng ký</button>


                    <c:if test="${not empty registerError}">
                        <div class="error">${registerError}</div>
                    </c:if>
                </form>
            </div>


            <!-- LOGIN FORM -->
            <div class="form-container sign-in-container">
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <h2>Đăng Nhập</h2>


                    <div class="social-container">
                        <script src="https://accounts.google.com/gsi/client" async defer></script>
                        <div id="g_id_onload"
                             data-client_id="149895780747-i2o54c2tbv6vhg5kb71k8kfnd3n12jrj.apps.googleusercontent.com"
                             data-context="signin" data-ux_mode="popup"
                             data-login_uri="http://localhost:8080${pageContext.request.contextPath}/google-login"
                             data-auto_prompt="false">
                        </div>
                        <div class="g_id_signin" data-type="standard" data-size="large" data-theme="outline"
                             data-text="sign_in_with" data-shape="rectangular" data-logo_alignment="center"
                             data-width="300">
                        </div>
                    </div>


                    <span style="margin-bottom: 20px;">hoặc sử dụng tài khoản email</span>


                    <input type="email" name="email" placeholder="Email" required />
                    <input type="password" name="password" placeholder="Mật khẩu" required />
                    <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>


                    <button type="submit">Đăng nhập</button>


                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>
                    <c:if test="${not empty param.success or not empty success}">
                        <div style="color: #009933; margin-top: 15px; font-weight: 600;">${success} ${param.success}
                        </div>
                    </c:if>
                </form>
            </div>


            <!-- OVERLAY PANELS -->
            <div class="overlay-container">
                <div class="overlay">
                    <div class="logo-container logo-left">
                        <a href="${pageContext.request.contextPath}/views/homepage.jsp" class="logo">
                            <img src="${pageContext.request.contextPath}/images/ata-logo.png"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/ata-logo.png'">
                            <span>AISTHÉA</span>
                        </a>
                    </div>
                    <div class="overlay-panel overlay-left">
                        <h2>Mừng bạn trở lại!</h2>
                        <p>Để giữ kết nối, vui lòng đăng nhập bằng thông tin cá nhân của bạn</p>
                        <button class="ghost" id="signIn">Đăng Nhập</button>
                    </div>
                    <div class="logo-container logo-right">
                        <a href="${pageContext.request.contextPath}/views/homepage.jsp" class="logo">
                            <img src="${pageContext.request.contextPath}/images/ata-logo.png"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/ata-logo.png'">
                            <span>AISTHÉA</span>
                        </a>
                    </div>
                    <div class="overlay-panel overlay-right">
                        <h2>Chào bạn mới!</h2>
                        <p>Nhập thông tin cá nhân của bạn và bắt đầu hành trình với chúng tôi</p>
                        <button class="ghost" id="signUp">Đăng Ký</button>
                    </div>
                </div>
            </div>
        </div>


        <script>
            // Toggle panel transition logic
            const signInButton = document.getElementById("signIn");
            const signUpButton = document.getElementById("signUp");
            const container = document.getElementById("container");


            signUpButton.addEventListener("click", () => {
                container.classList.add("right-panel-active");
            });


            signInButton.addEventListener("click", () => {
                container.classList.remove("right-panel-active");
            });


            // Registration form validation logic
            const form = document.getElementById('registerForm');
            const email = document.getElementById('reg-email');
            const phone = document.getElementById('reg-phone');
            const gender = document.getElementById('reg-gender');
            const emailMsg = document.getElementById('emailMsg');
            const phoneMsg = document.getElementById('phoneMsg');
            const genderMsg = document.getElementById('genderMsg');
            const password = document.getElementById('reg-password');
            const confirmPassword = document.getElementById('reg-confirmPassword');
            const passwordMsg = document.getElementById('passwordMsg');
            const confirmMsg = document.getElementById('confirmMsg');


            // Check email
            email.addEventListener('input', () => {
                const value = email.value.trim();
                if (value.length === 0) {
                    emailMsg.textContent = '';
                    return;
                }
                fetch('${pageContext.request.contextPath}/check-email?email=' + encodeURIComponent(value))
                        .then(res => res.text())
                        .then(data => {
                            if (data === 'EXISTS') {
                                emailMsg.textContent = 'Email này đã được đăng ký.';
                            } else {
                                emailMsg.textContent = '';
                            }
                        });
            });


            // Check phone
            phone.addEventListener('input', () => {
                const value = phone.value.trim();
                const phoneRegex = /^[0-9]{10}$/;
                if (!phoneRegex.test(value)) {
                    if (value.length > 0)
                        phoneMsg.textContent = 'SĐT phải có 10 chữ số.';
                    else
                        phoneMsg.textContent = '';
                    return;
                }
                fetch('${pageContext.request.contextPath}/check-phone?phone=' + encodeURIComponent(value))
                        .then(res => res.text())
                        .then(data => {
                            if (data === 'EXISTS') {
                                phoneMsg.textContent = 'SĐT này đã được sử dụng.';
                            } else {
                                phoneMsg.textContent = '';
                            }
                        });
            });


            // Check password
            password.addEventListener('input', () => {
                passwordMsg.textContent = password.value.length < 8 && password.value.length > 0 ? 'Mật khẩu phải có ít nhất 8 ký tự.' : '';
            });


            confirmPassword.addEventListener('input', () => {
                confirmMsg.textContent = confirmPassword.value !== password.value && confirmPassword.value.length > 0 ? 'Mật khẩu không khớp.' : '';
            });


            // Validate before submit
            form.addEventListener('submit', (e) => {
                let hasError = false;


                if (emailMsg.textContent !== '' || phoneMsg.textContent !== '') {
                    hasError = true;
                }
                if (password.value.length < 8) {
                    passwordMsg.textContent = 'Mật khẩu phải có ít nhất 8 ký tự.';
                    hasError = true;
                }
                if (password.value !== confirmPassword.value) {
                    confirmMsg.textContent = 'Mật khẩu không khớp.';
                    hasError = true;
                }
                if (gender.value === '') {
                    genderMsg.textContent = 'Vui lòng chọn giới tính.';
                    hasError = true;
                }


                if (hasError) {
                    e.preventDefault();
                }
            });


            // Handle pre-opening registration panel if coming from a failed registration or user intent
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('action') === 'register' || '${not empty registerError}' === 'true') {
                container.classList.add("right-panel-active");
            }
        </script>
    </body>


</html>

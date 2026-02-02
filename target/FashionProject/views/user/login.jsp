<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Login - AISTHÉA</title>
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

                /* Logo góc trái */
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

                /* Form container */
                .container {
                    background: rgba(255, 255, 255, 0.45);
                    backdrop-filter: blur(14px);
                    border-radius: 20px;
                    box-shadow: 0 8px 25px rgba(0, 0, 0, .2);
                    width: 420px;
                    padding: 50px 45px;
                    color: #003366;
                    text-align: center;
                    opacity: 0;
                    animation: fadeInUp 1s ease forwards;
                }

                h2 {
                    margin-bottom: 25px;
                    color: #003366;
                    font-weight: 600;
                    font-size: 24px;
                }

                /* Form nội dung */
                form {
                    display: flex;
                    flex-direction: column;
                    align-items: stretch;
                }

                .form-group {
                    display: flex;
                    flex-direction: column;
                    align-items: flex-start;
                    margin-bottom: 18px;
                }

                label {
                    font-weight: 500;
                    margin-bottom: 6px;
                    font-size: 14px;
                    color: #00264d;
                    padding-left: 2px;
                }

                input {
                    width: 100%;
                    padding: 11px 12px;
                    border: none;
                    border-radius: 8px;
                    background: rgba(255, 255, 255, 0.9);
                    outline: none;
                    font-size: 14px;
                    transition: all 0.25s ease;
                    box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.1);
                }

                input:focus {
                    background: rgba(255, 255, 255, 0.98);
                    box-shadow: 0 0 6px rgba(0, 76, 153, 0.3);
                }

                button {
                    width: 100%;
                    background: linear-gradient(135deg, #004c99, #0073e6);
                    color: white;
                    padding: 12px;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    font-weight: 600;
                    transition: all 0.3s ease;
                    margin-top: 10px;
                    font-size: 15px;
                }

                button:hover {
                    transform: translateY(-2px);
                    background: linear-gradient(135deg, #0066cc, #0099ff);
                    box-shadow: 0 4px 15px rgba(0, 102, 204, 0.4);
                }

                /* Forgot password link */
                .extra-options {
                    display: flex;
                    justify-content: flex-end;
                    margin-top: 8px;
                    margin-bottom: 5px;
                }

                .extra-options a {
                    font-size: 13px;
                    color: #004c99;
                    text-decoration: none;
                    font-weight: 500;
                }

                .extra-options a:hover {
                    text-decoration: underline;
                }

                /* Error + đăng ký */
                .error {
                    color: #cc0000;
                    font-weight: 500;
                    text-align: center;
                    margin-top: 10px;
                }

                p.small {
                    text-align: center;
                    margin-top: 18px;
                    font-size: 14px;
                }

                a {
                    color: #004c99;
                    text-decoration: none;
                    font-weight: 500;
                }

                a:hover {
                    text-decoration: underline;
                }

                /* Animation */
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

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                    }

                    to {
                        opacity: 1;
                    }
                }

                /* Divider & Google Login */
                .divider {
                    display: flex;
                    align-items: center;
                    text-align: center;
                    margin: 25px 0 20px;
                    color: #003366;
                    opacity: 0.7;
                    font-size: 14px;
                    font-weight: 500;
                }

                .divider::before,
                .divider::after {
                    content: '';
                    flex: 1;
                    border-bottom: 1px solid #b3d1ff;
                    margin: 0 10px;
                }

                .google-btn-container {
                    display: flex;
                    justify-content: center;
                    width: 100%;
                    margin-bottom: 15px;
                }
            </style>
        </head>

        <body>
            <!-- logo -->
            <div class="logo">
                <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                    <img src="${pageContext.request.contextPath}/images/ata-logo.png" alt="AISTHÉA Logo">
                </a>
                <span>AISTHÉA</span>
            </div>

            <!-- form login -->
            <div class="container">
                <h2>Đăng nhập tài khoản</h2>
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" required placeholder="Nhập email của bạn" />
                    </div>

                    <div class="form-group">
                        <label>Mật khẩu</label>
                        <input type="password" name="password" required placeholder="Nhập mật khẩu" />
                    </div>

                    <button type="submit">Đăng nhập</button>
                </form>





                <!-- SEPARATOR -->
                <div class="divider">
                    <span>HOẶC</span>
                </div>

                <!-- GOOGLE LOGIN -->
                <div class="google-btn-container">
                    <script src="https://accounts.google.com/gsi/client" async defer></script>
                    <div id="g_id_onload"
                        data-client_id="149895780747-i2o54c2tbv6vhg5kb71k8kfnd3n12jrj.apps.googleusercontent.com"
                        data-context="signin" data-ux_mode="popup"
                        data-login_uri="http://localhost:8080${pageContext.request.contextPath}/google-login"
                        data-auto_prompt="false">
                    </div>

                    <div class="g_id_signin" data-type="standard" data-shape="rectangular" data-theme="filled_blue"
                        data-text="signin_with" data-size="large" data-logo_alignment="left" data-width="330">
                    </div>

                </div>

                <div class="extra-options">
                    <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                </div>

                <c:if test="${not empty error}">
                    <p class="error">${error}</p>
                </c:if>

                <p class="small">Chưa có tài khoản?
                    <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                </p>
            </div>
        </body>

        </html>
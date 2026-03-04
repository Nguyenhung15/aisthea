<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="utf-8">
            <title>Forgot Password - AISTHÉA</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                * {
                    box-sizing: border-box;
                }

                body {
                    margin: 0;
                    padding: 0;
                    font-family: 'Inter', sans-serif;
                    background: url('${pageContext.request.contextPath}/images/bg-watercolor.png?v=1') no-repeat center center fixed;
                    background-size: cover;
                    height: 100vh;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }

                /* Logo */
                .logo {
                    position: absolute;
                    top: 25px;
                    left: 35px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    text-decoration: none;
                    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                    z-index: 1000;
                }

                .logo:hover {
                    transform: translateY(-3px) scale(1.02);
                }

                .logo img {
                    height: 55px;
                    filter: drop-shadow(0 4px 8px rgba(0, 51, 102, 0.1));
                    margin-bottom: 5px;
                    transform: translateY(-2px);
                }

                .logo span {
                    font-weight: 700;
                    color: #0f2c52;
                    font-size: 22px;
                    letter-spacing: 2px;
                    text-transform: uppercase;
                    margin: 0;
                }

                /* Container */
                .container {
                    background: rgba(255, 255, 255, 0.15);
                    backdrop-filter: blur(15px);
                    -webkit-backdrop-filter: blur(15px);
                    border-radius: 30px;
                    border: 1px solid rgba(255, 255, 255, 0.35);
                    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                    width: 480px;
                    padding: 50px 40px;
                    color: #0f2c52;
                    text-align: center;
                    opacity: 0;
                    animation: fadeInUp 0.8s ease forwards;
                }

                h2 {
                    margin: 0 0 12px;
                    font-size: 28px;
                    font-weight: 700;
                    color: #0f2c52;
                }

                p.desc {
                    font-size: 15px;
                    line-height: 24px;
                    margin-bottom: 30px;
                    color: #1A4971;
                    font-weight: 500;
                }

                form {
                    display: flex;
                    flex-direction: column;
                    gap: 15px;
                }

                .form-group {
                    text-align: left;
                }

                label {
                    display: block;
                    margin: 0 0 6px 4px;
                    font-weight: 600;
                    font-size: 14px;
                    color: #0f2c52;
                }

                input {
                    width: 100%;
                    padding: 12px 16px;
                    border: 1px solid #e0e6ed;
                    border-radius: 10px;
                    background: rgba(255, 255, 255, 0.9);
                    outline: none;
                    font-size: 14px;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                }

                input:focus {
                    background: #ffffff;
                    border-color: #2b7bff;
                    box-shadow: 0 0 0 3px rgba(43, 123, 255, 0.15);
                }

                button {
                    width: 100%;
                    background: linear-gradient(135deg, #4A8BC2 0%, #286090 100%);
                    color: white;
                    padding: 14px;
                    border: none;
                    border-radius: 12px;
                    cursor: pointer;
                    font-weight: 700;
                    font-size: 15px;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    transition: all 0.3s ease;
                    box-shadow: 0 4px 15px rgba(40, 96, 144, 0.4);
                    margin-top: 10px;
                }

                button:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(40, 96, 144, 0.6);
                    background: linear-gradient(135deg, #5CA0D8 0%, #3174AD 100%);
                }

                button:active {
                    transform: scale(0.98);
                }

                .error {
                    color: #d93025;
                    font-weight: 600;
                    font-size: 14px;
                    margin-top: 15px;
                }

                .success {
                    color: #009933;
                    font-weight: 600;
                    font-size: 14px;
                    margin-top: 15px;
                }

                .back-link {
                    margin-top: 25px;
                    display: block;
                }

                .back-link a {
                    color: #0066cc;
                    text-decoration: none;
                    font-weight: 600;
                    font-size: 14px;
                    transition: all 0.2s;
                }

                .back-link a:hover {
                    color: #004d99;
                    text-decoration: underline;
                }

                @keyframes fadeInUp {
                    from {
                        transform: translateY(30px);
                        opacity: 0;
                    }

                    to {
                        transform: translateY(0);
                        opacity: 1;
                    }
                }
            </style>
        </head>

        <body>
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <img src="${pageContext.request.contextPath}/images/ata-logo.png" alt="AISTHÉA Logo"
                    onerror="this.src='${pageContext.request.contextPath}/assets/images/ata-logo.png'">
                <span>AISTHÉA</span>
            </a>

            <div class="container">
                <h2>Quên mật khẩu</h2>
                <p class="desc">Nhập email bạn đã đăng ký, chúng tôi sẽ gửi liên kết đặt lại mật khẩu đến hộp thư của
                    bạn.</p>

                <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" placeholder="Nhập email của bạn" required>
                    </div>
                    <button type="submit">Gửi liên kết đặt lại</button>
                </form>

                <c:if test="${not empty error}">
                    <p class="error">${error}</p>
                </c:if>
                <c:if test="${not empty message}">
                    <p class="success">${message}</p>
                </c:if>

                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại đăng nhập
                    </a>
                </div>
            </div>
        </body>

        </html>
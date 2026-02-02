<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="utf-8">
            <title>Forgot Password - AISTHÉA</title>
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

                /* --- logo góc trái --- */
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

                /* --- form container --- */
                .container {
                    background: rgba(255, 255, 255, 0.45);
                    backdrop-filter: blur(14px);
                    border-radius: 20px;
                    box-shadow: 0 8px 25px rgba(0, 0, 0, .2);
                    width: 420px;
                    padding: 40px;
                    color: #003366;
                    text-align: left;
                    opacity: 0;
                    animation: fadeInUp 1s ease forwards;
                }

                h2 {
                    text-align: center;
                    margin-bottom: 20px;
                    color: #003366;
                    font-weight: 600;
                }

                p.desc {
                    text-align: center;
                    font-size: 14px;
                    margin-bottom: 20px;
                    color: #003366;
                }

                label {
                    display: block;
                    margin: 8px 0 4px;
                    font-weight: 500;
                }

                input {
                    width: 100%;
                    padding: 10px;
                    margin-bottom: 14px;
                    border: none;
                    border-radius: 8px;
                    background: rgba(255, 255, 255, 0.85);
                    outline: none;
                    font-size: 14px;
                    transition: all 0.25s ease;
                    box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.1);
                }

                input:focus {
                    background: rgba(255, 255, 255, 0.95);
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
                }

                button:hover {
                    transform: translateY(-2px);
                    background: linear-gradient(135deg, #0066cc, #0099ff);
                    box-shadow: 0 4px 15px rgba(0, 102, 204, 0.4);
                }

                a {
                    color: #004c99;
                    text-decoration: none;
                    font-weight: 500;
                }

                a:hover {
                    text-decoration: underline;
                }

                .error {
                    color: #cc0000;
                    font-weight: 500;
                    text-align: center;
                    margin-top: 10px;
                }

                .success {
                    color: #008000;
                    font-weight: 500;
                    text-align: center;
                    margin-top: 10px;
                }

                p.small {
                    text-align: center;
                    margin-top: 14px;
                }

                /* --- animation --- */
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
            </style>
        </head>

        <body>
            <!-- logo + quay về home -->
            <div class="logo">
                <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                    <img src="${pageContext.request.contextPath}/images/ata-logo.png" alt="AISTHÉA Logo">
                </a>
                <span>AISTHÉA</span>
            </div>

            <div class="container">
                <h2>Forgot Password</h2>
                <p class="desc">Nhập email bạn đã đăng ký, chúng tôi sẽ gửi liên kết đặt lại mật khẩu đến hộp thư của
                    bạn.</p>

                <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                    <label>Email</label>
                    <input type="email" name="email" placeholder="Nhập email của bạn" required>
                    <button type="submit">Gửi liên kết đặt lại</button>
                </form>

                <c:if test="${not empty error}">
                    <p class="error">${error}</p>
                </c:if>
                <c:if test="${not empty message}">
                    <p class="success">${message}</p>
                </c:if>

                <p class="small">
                    <a href="${pageContext.request.contextPath}/login">← Quay lại đăng nhập</a>
                </p>
            </div>
        </body>

        </html>
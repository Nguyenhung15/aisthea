<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - AISTHEA</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap');

        body {
            margin: 0; padding: 0;
            font-family: 'Poppins', sans-serif;
            background: url('${pageContext.request.contextPath}/images/bg-watercolor.png') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex; justify-content: center; align-items: center;
        }

        .logo {
            position: absolute; top: 20px; left: 30px;
            display: flex; align-items: center; gap: 10px;
            animation: fadeIn 1.2s ease;
        }
        .logo img { height: 60px; cursor: pointer; transition: transform 0.3s ease; }
        .logo img:hover { transform: scale(1.08); }

        .container {
            background: rgba(255,255,255,0.45);
            backdrop-filter: blur(14px);
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,.25);
            width: 600px;
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

        label { display:block; margin:6px 0 4px; font-weight:500; }

        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 14px;
            border-radius: 8px;
            border: none;
            background: rgba(255,255,255,0.85);
            font-size: 14px;
            transition: all 0.25s ease;
            box-shadow: inset 0 0 0 1px rgba(0,0,0,0.1);
        }

        input:focus, select:focus {
            outline: none;
            background: rgba(255,255,255,0.95);
            box-shadow: 0 0 6px rgba(0,76,153,0.3);
        }

        .row { display:flex; gap:25px; }
        .col { flex:1; }

        .validation-msg {
            color: #cc0000;
            font-size: 13px;
            margin-top: -10px;
            margin-bottom: 10px;
        }

        button {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: none;
            background: linear-gradient(135deg, #004c99, #0073e6);
            color: white;
            font-weight: 600;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        button:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #0066cc, #0099ff);
            box-shadow: 0 4px 15px rgba(0,102,204,0.4);
        }

        .error { color:#cc0000; text-align:center; margin-top:8px; }
        .success { color:#009933; text-align:center; margin-top:8px; }
        p.small { text-align:center; margin-top:12px; }
        a { color:#004c99; text-decoration:none; }
        a:hover { text-decoration:underline; }

        @keyframes fadeInUp {
            from { transform: translateY(40px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="logo">
        <a href="${pageContext.request.contextPath}/views/homepage.jsp">
            <img src="${pageContext.request.contextPath}/images/ata-logo.png" alt="AISTHEA">
        </a>
        <span style="font-weight:600; color:#003366; font-size:20px;">AISTHÉA</span>
    </div>

    <div class="container">
        <h2>Create your account</h2>

        <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post">
            <label>Full name</label>
            <input type="text" name="fullname" required />

            <label>Email</label>
            <input type="email" name="email" required />

            <div class="row">
                <div class="col">
                    <label>Password</label>
                    <input type="password" name="password" id="password" required />
                    <div id="passwordMsg" class="validation-msg"></div>
                </div>
                <div class="col">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" required />
                    <div id="confirmMsg" class="validation-msg"></div>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Gender</label>
                    <select name="gender">
                        <option value="">-- Select --</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="col">
                    <label>Phone</label>
                    <input type="text" name="phone" />
                </div>
            </div>

            <label>Address</label>
            <input type="text" name="address" />

            <button type="submit">Register</button>
        </form>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <c:if test="${not empty success}">
            <p class="success">${success}</p>
        </c:if>

        <p class="small">Already have account? <a href="${pageContext.request.contextPath}/login">Login</a></p>
    </div>

    <script>
        const form = document.getElementById('registerForm');
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordMsg = document.getElementById('passwordMsg');
        const confirmMsg = document.getElementById('confirmMsg');

        password.addEventListener('input', () => {
            if (password.value.length < 8) {
                passwordMsg.textContent = 'Password must be at least 8 characters.';
            } else {
                passwordMsg.textContent = '';
            }
        });

        form.addEventListener('submit', (e) => {
            if (password.value.length < 8) {
                e.preventDefault();
                passwordMsg.textContent = 'Password must be at least 8 characters.';
                return;
            }

            if (password.value !== confirmPassword.value) {
                e.preventDefault();
                confirmMsg.textContent = 'Passwords do not match.';
            } else {
                confirmMsg.textContent = '';
            }
        });
    </script>
</body>
</html>

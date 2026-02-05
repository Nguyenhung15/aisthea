# 🚀 QUICK START - Post Refactoring

## Làm gì tiếp theo?

### 1️⃣ Test trong Browser (BẮT BUỘC)

Mở browser và test homepage:
```
http://localhost:8080/AistheaFashion/views/homepage.jsp
```

**Kiểm tra**:
- ✅ Page loads (không có lỗi)
- ✅ Styles hiển thị đúng
- ✅ Scroll animation hoạt động
- ✅ Mở F12 → Console → KHÔNG có 404 errors

---

### 2️⃣ Cập nhật Database Credentials

Edit file: `src/main/resources/application.properties`

```properties
# Sửa thành credentials THẬT của bạn
db.username=YOUR_USERNAME
db.password=YOUR_PASSWORD
```

---

### 3️⃣ Cập nhật Email Settings (nếu cần)

```properties
mail.username=your-email@gmail.com
mail.password=your-app-password
```

---

### 4️⃣ Files Quan Trọng

#### Configuration
- `application.properties` - Cấu hình chính
- `application-dev.properties` - Dev environment
- `application-prod.properties` - Production environment

#### Backend
- `AppConfig.java` - Load properties
- `DatabaseConfig.java` - Connection pool
- `EmailConfig.java` - Email config

#### Frontend
- `assets/css/main.css` - Main CSS file
- `assets/js/common/utils.js` - JS utilities
- `assets/js/common/api.js` - API client

#### JSP Fragments
- `views/common/meta.jsp` - Common meta tags
- `views/common/scripts.jsp` - Common scripts

---

### 5️⃣ Sử Dụng trong Code

#### Trong Java
```java
// Get config
String baseUrl = AppConfig.getBaseUrl();

// Get database connection
Connection conn = DatabaseConfig.getConnection();

// Send email
MailUtil.sendMail(to, subject, htmlContent);

// Hash password
String hashed = BCryptUtil.hashPassword(password);

// Format date
String formatted = DateUtil.formatForDisplay(date);
```

#### Trong JSP
```jsp
<!DOCTYPE html>
<html>
<head>
    <title>My Page</title>
    
    <%-- Include all common meta tags and CSS --%>
    <jsp:include page="/views/common/meta.jsp"/>
</head>
<body>
    <!-- Your content here -->
    
    <%-- Include common scripts --%>
    <jsp:include page="/views/common/scripts.jsp"/>
    
    <%-- Your page-specific script --%>
    <script src="${pageContext.request.contextPath}/assets/js/pages/my-page.js"></script>
</body>
</html>
```

#### Trong JavaScript
```javascript
// Show notification
Utils.showNotification('Thành công!', 'success');

// Format currency
const price = Utils.formatCurrency(250000); // "250.000 ₫"

// API call
API.user.login(email, password)
    .then(data => {
        Utils.showNotification('Đăng nhập thành công!', 'success');
    })
    .catch(err => {
        Utils.showNotification('Đăng nhập thất bại!', 'error');
    });
```

---

### 6️⃣ Documents

Đọc các documents này để hiểu rõ hơn:

1. **[README.md](README.md)** - Project overview
2. **[REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)** - Chi tiết refactoring
3. **[TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)** - Test checklist
4. **[CHANGELOG.md](CHANGELOG.md)** - Version history

---

### 7️⃣ Cấu Trúc Folders

```
aisthea/
├── src/main/
│   ├── java/com/aisthea/fashion/
│   │   ├── config/          ← Configuration classes
│   │   ├── controller/      ← Servlets
│   │   ├── dao/             ← Database access
│   │   ├── model/           ← Entities
│   │   ├── service/         ← Business logic
│   │   ├── exception/       ← Custom exceptions
│   │   ├── validator/       ← Validation
│   │   ├── util/            ← Utilities
│   │   ├── filter/          ← HTTP filters
│   │   └── listener/        ← Event listeners
│   │
│   ├── resources/
│   │   ├── application.properties
│   │   ├── application-dev.properties
│   │   ├── application-prod.properties
│   │   └── logback.xml
│   │
│   └── webapp/
│       ├── assets/
│       │   ├── css/
│       │   │   ├── main.css
│       │   │   ├── common/
│       │   │   └── pages/
│       │   ├── js/
│       │   │   ├── common/
│       │   │   └── pages/
│       │   └── images/
│       │
│       └── views/
│           ├── common/      ← JSP fragments
│           ├── admin/
│           ├── user/
│           ├── product/
│           ├── cart/
│           └── order/
│
├── logs/                    ← Application logs
├── pom.xml
├── README.md
├── CHANGELOG.md
├── .gitignore
└── .editorconfig
```

---

## ✅ Checklist Trước Khi Deploy

- [ ] Test homepage trong browser
- [ ] Check console không có 404 errors
- [ ] Cập nhật database credentials
- [ ] Cập nhật email settings (nếu cần)
- [ ] Test đăng nhập/đăng ký
- [ ] Test gửi email
- [ ] Kiểm tra logs trong `logs/aisthea.log`
- [ ] Review REFACTORING_SUMMARY.md

---

## 🆘 Troubleshooting

### CSS/JS không load
- Check đường dẫn trong JSP
- Clear browser cache (Ctrl+Shift+R)
- Check browser console for 404 errors

### Database connection error
- Check `application.properties`
- Verify database credentials
- Check SQL Server is running

### Email không gửi
- Check `application.properties`
- Verify Gmail app password
- Check logs for errors

---

**🎉 Chúc mừng! Project đã được refactor xong!**

Bây giờ bạn có:
- ✅ Code sạch sẽ, organized
- ✅ Không còn hardcoded credentials
- ✅ Professional logging
- ✅ Connection pooling
- ✅ Reusable utilities
- ✅ Comprehensive documentation

**Happy coding! 🚀**

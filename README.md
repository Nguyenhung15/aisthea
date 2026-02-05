# AISTHEA Fashion E-commerce

A complete Java web application for fashion e-commerce built with Jakarta EE, featuring user authentication, product management, shopping cart, and order processing.

## 🚀 Features

### Authentication & Authorization
- ✅ User registration with email verification
- ✅ Secure login with BCrypt password hashing
- ✅ Google OAuth integration
- ✅ Password reset functionality
- ✅ Role-based access control (Admin, User, Staff)

### Product Management
- ✅ Product CRUD operations
- ✅ Category management
- ✅ Product images and variants (colors, sizes)
- ✅ Product search and filtering

### Shopping Experience
- ✅ Shopping cart functionality
- ✅ Order placement and tracking
- ✅ Multiple payment methods
- ✅ Order history

### Admin Features
- ✅ Dashboard with analytics
- ✅ User management
- ✅ Product and category management
- ✅ Order management

## 🛠️ Technology Stack

### Backend
- **Java 17**
- **Jakarta EE 10** (Servlets, JSP, JSTL)
- **Maven** (build tool)
- **SQL Server** (database)
- **HikariCP** (connection pooling)
- **BCrypt** (password hashing)

### Libraries
- **SLF4J + Logback** (logging)
- **Jakarta Mail** (email functionality)
- **Google API Client** (OAuth)
- **Gson** (JSON processing)

### Testing
- **JUnit 5**
- **Mockito**
- **AssertJ**

## 📋 Prerequisites

- Java 17 or higher
- Apache Tomcat 10.x
- SQL Server 2019 or higher
- Maven 3.6+
- IDE (IntelliJ IDEA, Eclipse, or NetBeans)

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd aisthea
```

### 2. Database Setup

1. Create a database named `AISTHEA` in SQL Server
2. Run the database schema scripts (located in `database/` folder)
3. Update database credentials in `src/main/resources/application.properties`

### 3. Configure Application Properties

Edit `src/main/resources/application.properties`:

```properties
# Database Configuration
db.url=jdbc:sqlserver://localhost:1433;databaseName=AISTHEA;encrypt=false
db.username=YOUR_USERNAME
db.password=YOUR_PASSWORD

# Email Configuration (for Gmail)
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.username=your-email@gmail.com
mail.password=your-app-password

# Google OAuth (optional)
google.client.id=YOUR_CLIENT_ID
google.client.secret=YOUR_CLIENT_SECRET
```

### 4. Build the Project

```bash
mvn clean install
```

### 5. Deploy to Tomcat

#### Option A: Using IDE
1. Configure Tomcat server in your IDE
2. Deploy the application
3. Access at: `http://localhost:8080/FashionProject/`

#### Option B: Manual Deployment
1. Copy `target/FashionProject.war` to Tomcat's `webapps/` directory
2. Start Tomcat
3. Access at: `http://localhost:8080/FashionProject/`

## 📁 Project Structure

```
aisthea/
├── src/
│   ├── main/
│   │   ├── java/com/aisthea/fashion/
│   │   │   ├── config/         # Configuration classes
│   │   │   ├── controller/     # Servlets
│   │   │   ├── dao/            # Data Access Objects
│   │   │   ├── model/          # Domain models
│   │   │   ├── service/        # Business logic
│   │   │   ├── exception/      # Custom exceptions
│   │   │   ├── validator/      # Input validation
│   │   │   ├── util/           # Utility classes
│   │   │   ├── filter/         # HTTP filters
│   │   │   └── listener/       # Event listeners
│   │   │
│   │   ├── resources/
│   │   │   ├── application.properties
│   │   │   ├── application-dev.properties
│   │   │   ├── application-prod.properties
│   │   │   └── logback.xml
│   │   │
│   │   └── webapp/
│   │       ├── assets/
│   │       │   ├── css/        # Stylesheets
│   │       │   ├── js/         # JavaScript files
│   │       │   └── images/     # Images
│   │       ├── views/          # JSP pages
│   │       └── WEB-INF/
│   │           └── web.xml
│   │
│   └── test/                   # Test files
│
├── pom.xml
└── README.md
```

## 🧪 Running Tests

```bash
mvn test
```

## 📝 Environment Variables

For production, use environment variables instead of hardcoding sensitive data:

```bash
export DB_URL="jdbc:sqlserver://production-server:1433;databaseName=AISTHEA"
export DB_USERNAME="prod_user"
export DB_PASSWORD="secure_password"
export MAIL_USERNAME="noreply@aisthea.com"
export MAIL_PASSWORD="app_password"
export GOOGLE_CLIENT_ID="your_client_id"
export GOOGLE_CLIENT_SECRET="your_client_secret"
```

## 🔒 Security Features

- ✅ BCrypt password hashing (cost factor 12)
- ✅ Email verification for new accounts
- ✅ Token-based password reset (30-minute expiration)
- ✅ Session management
- ✅ Input validation and sanitization
- ✅ SQL injection prevention (PreparedStatements)
- ✅ XSS protection

## 📊 Logging

Logs are stored in the `logs/` directory:
- `aisthea.log` - General application logs
- `aisthea-error.log` - Error logs only

Configure logging levels in `src/main/resources/logback.xml`

## 🚀 Deployment

### Development
```bash
mvn clean package
# Deploy to local Tomcat
```

### Production
1. Update `application-prod.properties` with production settings
2. Set environment variable: `APP_ENVIRONMENT=production`
3. Build: `mvn clean package -P production`
4. Deploy WAR file to production server

## 📖 API Endpoints

### Authentication
- `POST /login` - User login
- `POST /register` - User registration
- `GET /activate` - Email verification
- `POST /forgot-password` - Request password reset
- `POST /reset` - Reset password
- `GET /logout` - User logout

### Products
- `GET /product` - List products
- `GET /product?id=<id>` - Get product details

### Cart & Orders
- `GET /cart` - View cart
- `POST /cart` - Add to cart
- `POST /order` - Place order
- `GET /order` - Order history

### Admin
- `GET /dashboard` - Admin dashboard
- `GET /user` - User management
- `GET /category` - Category management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

- **Project Name**: AISTHEA Fashion E-commerce
- **Version**: 1.0.0
- **Course**: SWP391

## 📞 Support

For issues and questions:
- Check the `ARCHITECTURE.md` for system design
- Review `CODING_STANDARDS.md` for code guidelines
- See `SETUP.md` for detailed setup instructions

---

**Built with ❤️ by the AISTHEA Team**

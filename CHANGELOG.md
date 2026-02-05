# Changelog

All notable changes to the AISTHEA Fashion E-commerce project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Project structure refactoring for better organization
- Configuration management system with environment-specific properties
- Professional logging with SLF4J and Logback
- HikariCP connection pooling for database
- Custom exception classes for better error handling
- Utility classes for common operations
- Base validator class for input validation
- Frontend asset organization (CSS, JavaScript)
- Comprehensive documentation (README, ARCHITECTURE, CODING_STANDARDS)

### Changed
- Database connection now uses HikariCP connection pool
- Hardcoded configuration moved to properties files
- Improved project structure following industry best practices

### Security
- Externalized database credentials
- Enhanced configuration security with environment variables support

## [1.0.0] - Initial Release

### Added
- User authentication (register, login, logout)
- Email verification for new accounts
- Google OAuth integration
- Password reset functionality
- BCrypt password hashing
- Product management (CRUD operations)
- Category management
- Shopping cart functionality
- Order placement and tracking
- Admin dashboard
- User profile management
- Avatar upload functionality
- Role-based access control

### Features Implemented
- User registration with email activation
- Secure login with BCrypt
- Google sign-in
- Password recovery
- Product browsing and search
- Shopping cart
- Order management
- Admin panel
- User profiles
- Email notifications

CREATE DATABASE AISTHEA;
GO
USE AISTHEA;
GO

/* =========================
   1. USERS
========================= */
CREATE TABLE users (
    userid INT IDENTITY PRIMARY KEY,
    username NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    fullname NVARCHAR(255),
    email NVARCHAR(255) NOT NULL UNIQUE,
    gender NVARCHAR(10),
    phone NVARCHAR(20),
    avatar VARCHAR(255),
    address NVARCHAR(255),
    role NVARCHAR(20) NOT NULL
        CHECK (role IN ('ADMIN','CUSTOMER','STAFF'))
        DEFAULT 'CUSTOMER',
    active BIT DEFAULT 0,
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME DEFAULT GETDATE()
);

GO
/* =========================
   2. STAFF
========================= */
CREATE TABLE staff (
    staffid INT IDENTITY PRIMARY KEY,
    userid INT NOT NULL UNIQUE,
    staffcode NVARCHAR(50) UNIQUE,
    position NVARCHAR(100),
    salary DECIMAL(12,2),
    hiredate DATE,
    workstatus NVARCHAR(50) DEFAULT 'Active',
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE
);

GO
/* =========================
   3. CATEGORIES
========================= */
CREATE TABLE categories (
    categoryid INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(50),
    genderid INT NULL,
    parentid INT NULL,
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME NULL,
    FOREIGN KEY (parentid) REFERENCES categories(categoryid)
);

GO
/* =========================
   4. PRODUCTS
========================= */
CREATE TABLE products (
    productid INT IDENTITY PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL,
    categoryid INT NOT NULL,
    brand NVARCHAR(255),
    discount DECIMAL(5,2) DEFAULT 0,
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (categoryid) REFERENCES categories(categoryid)
);

GO
/* =========================
   5. PRODUCT COLOR & SIZE
========================= */
CREATE TABLE product_color_size (
    productcolorsizeid INT IDENTITY PRIMARY KEY,
    productid INT NOT NULL,
    color NVARCHAR(50) NOT NULL,
    size NVARCHAR(50) NOT NULL,
    stock INT DEFAULT 0,
    FOREIGN KEY (productid) REFERENCES products(productid) ON DELETE CASCADE
);

GO
/* =========================
   6. PRODUCT IMAGES
========================= */
CREATE TABLE product_image (
    imageid INT IDENTITY PRIMARY KEY,
    productid INT NOT NULL,
    color NVARCHAR(50),
    imageurl NVARCHAR(500) NOT NULL,
    isprimary BIT DEFAULT 0,
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (productid) REFERENCES products(productid) ON DELETE CASCADE
);

GO
/* =========================
   7. CART
========================= */
CREATE TABLE cart (
    cartid INT IDENTITY PRIMARY KEY,
    userid INT NOT NULL UNIQUE, -- mỗi user chỉ có 1 cart
    createdat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE
);

GO

CREATE TABLE cart_items (
    cartitemid INT IDENTITY PRIMARY KEY,
    cartid INT NOT NULL,
    productcolorsizeid INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    createdat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (cartid) REFERENCES cart(cartid) ON DELETE CASCADE,
    FOREIGN KEY (productcolorsizeid) REFERENCES product_color_size(productcolorsizeid),
    CONSTRAINT UQ_cart_product UNIQUE(cartid, productcolorsizeid) -- không trùng sản phẩm
);

GO

/* =========================
   8. ORDERS
========================= */
CREATE TABLE orders (
    orderid INT IDENTITY PRIMARY KEY,
    userid INT NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    address NVARCHAR(500) NOT NULL,
    payment_method NVARCHAR(50),
    totalprice DECIMAL(10,2),
    status NVARCHAR(50)
        CHECK (status IN ('Pending','Processing','Completed','Cancelled'))
        DEFAULT 'Pending',
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userid) REFERENCES users(userid)
);

GO
/* =========================
   9. ORDER ITEMS
========================= */
CREATE TABLE orderitems (
    orderitemid INT IDENTITY PRIMARY KEY,
    orderid INT NOT NULL,
    productcolorsizeid INT NOT NULL,
    color NVARCHAR(50),
    size NVARCHAR(50),
    image_url NVARCHAR(500),
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (orderid) REFERENCES orders(orderid) ON DELETE CASCADE,
    FOREIGN KEY (productcolorsizeid) REFERENCES product_color_size(productcolorsizeid)
);

GO
/* =========================
   10. PAYMENTS
========================= */
CREATE TABLE payments (
    paymentid INT IDENTITY PRIMARY KEY,
    orderid INT NOT NULL,
    method NVARCHAR(50),
    amount DECIMAL(10,2),
    status NVARCHAR(50),
    transactioncode NVARCHAR(100),
    paidat DATETIME,
    FOREIGN KEY (orderid) REFERENCES orders(orderid)
);

GO
/* =========================
   11. FEEDBACK
========================= */
CREATE TABLE feedback (
    feedbackid INT IDENTITY PRIMARY KEY,
    userid INT NOT NULL,
    productid INT NOT NULL,
    orderid INT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    status NVARCHAR(20) DEFAULT 'Visible',
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userid) REFERENCES users(userid),
    FOREIGN KEY (productid) REFERENCES products(productid),
    FOREIGN KEY (orderid) REFERENCES orders(orderid)
);

GO
/* =========================
   12. CHAT - CONVERSATIONS
========================= */
CREATE TABLE conversations (
    conversationid INT IDENTITY PRIMARY KEY,
    customerid INT NOT NULL,
    staffid INT NULL,
    chattype NVARCHAR(10) NOT NULL,   -- AI | STAFF
    status NVARCHAR(20) DEFAULT 'OPEN',
    createdat DATETIME DEFAULT GETDATE(),
    updatedat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customerid) REFERENCES users(userid),
    FOREIGN KEY (staffid) REFERENCES staff(staffid),
    CHECK (
        (chattype = 'AI' AND staffid IS NULL)
        OR
        (chattype = 'STAFF' AND staffid IS NOT NULL)
    )
);

GO
/* =========================
   13. CHAT - MESSAGES
========================= */
CREATE TABLE messages (
    messageid INT IDENTITY PRIMARY KEY,
    conversationid INT NOT NULL,
    sender NVARCHAR(10) NOT NULL, -- CUSTOMER | STAFF | AI
    content NVARCHAR(MAX) NOT NULL,
    createdat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (conversationid) REFERENCES conversations(conversationid),
    CHECK (sender IN ('CUSTOMER','STAFF','AI'))
);

GO
/* =========================
   14. EMAIL LOGS
========================= */
CREATE TABLE emaillogs (
    emailid INT IDENTITY PRIMARY KEY,
    userid INT,
    subject NVARCHAR(255),
    content NVARCHAR(MAX),
    sentat DATETIME DEFAULT GETDATE(),
    status NVARCHAR(50),
    emailtype NVARCHAR(50),
    recipientemail NVARCHAR(255),
    FOREIGN KEY (userid) REFERENCES users(userid)
);

GO
/* =========================
   15. EMAIL VERIFICATION
========================= */
CREATE TABLE emailverifications (
    token NVARCHAR(255) PRIMARY KEY,
    userid INT NOT NULL,
    expiresat DATETIME,
    verified BIT DEFAULT 0,
    createdat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE
);

GO
/* =========================
   16. LOGS
========================= */
CREATE TABLE logs (
    logid INT IDENTITY PRIMARY KEY,
    userid INT,
    action NVARCHAR(255),
    ipaddress NVARCHAR(45),
    createdat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE
);

GO
/* =========================
   17. VOUCHERS
========================= */
CREATE TABLE vouchers (
    voucherid INT IDENTITY PRIMARY KEY,
    code NVARCHAR(50) NOT NULL UNIQUE,          -- Mã giảm giá
    description NVARCHAR(255),
    discounttype NVARCHAR(20) NOT NULL          -- PERCENT | FIXED
        CHECK (discounttype IN ('PERCENT','FIXED')),
    discountvalue DECIMAL(10,2) NOT NULL,       -- % hoặc số tiền
    minorderamount DECIMAL(10,2) DEFAULT 0,     -- Đơn tối thiểu
    maxdiscount DECIMAL(10,2) NULL,             -- Giảm tối đa (nếu %)
    quantity INT NOT NULL,                      -- Tổng lượt dùng
    usedcount INT DEFAULT 0,                    -- Đã sử dụng
    startdate DATETIME NOT NULL,
    enddate DATETIME NOT NULL,
    status NVARCHAR(20) DEFAULT 'ACTIVE',       -- ACTIVE | INACTIVE | EXPIRED
    createdat DATETIME DEFAULT GETDATE()
);

GO
/* =========================
   18. UPDATE ORDERS – APPLY VOUCHERS
========================= */
ALTER TABLE orders
ADD 
    voucherid INT NULL,
    discountamount DECIMAL(10,2) DEFAULT 0;

ALTER TABLE orders
ADD CONSTRAINT FK_orders_voucher
FOREIGN KEY (voucherid) REFERENCES vouchers(voucherid);

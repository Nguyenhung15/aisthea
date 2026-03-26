-- Migration: Create birthday_discount_usage table
-- Tracks whether a user has already used their birthday discount in the current year.
-- Each user may only use the birthday discount ONCE per calendar year.

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'birthday_discount_usage')
BEGIN
    CREATE TABLE [dbo].[birthday_discount_usage] (
        [id]            INT IDENTITY(1,1) PRIMARY KEY,
        [userid]        INT NOT NULL,
        [used_year]     INT NOT NULL,
        [order_id]      INT NULL,
        [discount_amount] DECIMAL(18,0) NOT NULL DEFAULT 0,
        [created_at]    DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [FK_bdu_user] FOREIGN KEY ([userid]) REFERENCES [dbo].[users]([userid]),
        CONSTRAINT [UQ_bdu_user_year] UNIQUE ([userid], [used_year])
    );
    PRINT 'Created table birthday_discount_usage.';
END
GO

-- Also add birthday_discount column to orders table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('orders') AND name = 'birthday_discount')
BEGIN
    ALTER TABLE [dbo].[orders] ADD [birthday_discount] DECIMAL(18,0) NULL DEFAULT 0;
    PRINT 'Added column birthday_discount to orders table.';
END
GO

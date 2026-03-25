-- Migration: Add tier_discount and tier_name columns to orders table
-- Run this script on your SQL Server database before deploying the new code.

-- Add tier_discount column (stores the auto-discount amount from membership tier)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('orders') AND name = 'tier_discount')
BEGIN
    ALTER TABLE [dbo].[orders] ADD [tier_discount] DECIMAL(18,0) NULL DEFAULT 0;
    PRINT 'Added column tier_discount to orders table.';
END
GO

-- Add tier_name column (stores the tier name at the time of order, e.g. SILVER, GOLD, PLATINUM)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('orders') AND name = 'tier_name')
BEGIN
    ALTER TABLE [dbo].[orders] ADD [tier_name] NVARCHAR(20) NULL;
    PRINT 'Added column tier_name to orders table.';
END
GO

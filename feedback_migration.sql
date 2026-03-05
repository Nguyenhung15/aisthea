-- SQL Migration for Enhanced Feedback System
-- Run this on your database to add the required columns

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'status')
BEGIN
    ALTER TABLE [dbo].[feedback] ADD [status] NVARCHAR(20) DEFAULT 'Visible';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'image_url')
BEGIN
    ALTER TABLE [dbo].[feedback] ADD [image_url] NVARCHAR(500) NULL;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'helpful_count')
BEGIN
    ALTER TABLE [dbo].[feedback] ADD [helpful_count] INT DEFAULT 0;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'admin_reply')
BEGIN
    ALTER TABLE [dbo].[feedback] ADD [admin_reply] NVARCHAR(MAX) NULL;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND name = 'replied_at')
BEGIN
    ALTER TABLE [dbo].[feedback] ADD [replied_at] DATETIME NULL;
END

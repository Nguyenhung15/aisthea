-- SQL Migration for Point History System
-- Run this on your database to create the required table

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'point_history')
BEGIN
    CREATE TABLE [dbo].[point_history] (
        [history_id] INT IDENTITY(1,1) PRIMARY KEY,
        [userid] INT NOT NULL,
        [points_earned] INT NOT NULL,
        [reason] NVARCHAR(255) NULL,
        [createdat] DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_PointHistory_User FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE
    );
END

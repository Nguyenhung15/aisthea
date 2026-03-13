-- Create Notifications table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Notifications')
BEGIN
    CREATE TABLE Notifications (
        notification_id INT PRIMARY KEY IDENTITY(1,1),
        userid INT NOT NULL,
        title NVARCHAR(255) NOT NULL,
        content NVARCHAR(MAX) NOT NULL,
        type NVARCHAR(50) DEFAULT 'SYSTEM', -- ORDER, PROMOTION, SYSTEM
        is_read BIT DEFAULT 0,
        createdat DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Notifications_Users FOREIGN KEY (userid) REFERENCES Users(userid)
    );
END
GO

-- Optional: Sample data for testing
-- INSERT INTO Notifications (userid, title, content, type, is_read, createdat)
-- SELECT userid, N'Chào mừng bạn!', N'Chào mừng bạn đến với AISTHÉA. Khám phá các bộ sưu tập mới nhất ngay nhé.', 'SYSTEM', 0, GETDATE()
-- FROM Users;

-- test/e2e-generator-mock/projects/gmail/db/database.sqlserver.ddl
CREATE TABLE email_message (
  id INT IDENTITY(1,1) PRIMARY KEY,
  message_id NVARCHAR(255),
  subject NVARCHAR(500),
  from_addr NVARCHAR(255),
  to_addr NVARCHAR(255),
  body_preview NVARCHAR(MAX),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

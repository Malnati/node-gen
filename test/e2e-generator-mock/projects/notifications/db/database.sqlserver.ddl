-- test/e2e-generator-mock/projects/notifications/db/database.sqlserver.ddl
CREATE TABLE notification (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  user_id UNIQUEIDENTIFIER,
  contact_id UNIQUEIDENTIFIER,
  channel NVARCHAR(50),
  subject NVARCHAR(500),
  body NVARCHAR(MAX),
  read_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_notification_external_id UNIQUE (external_id)
);

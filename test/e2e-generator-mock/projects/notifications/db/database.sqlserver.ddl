-- test/e2e-generator-mock/projects/notifications/db/database.sqlserver.ddl
CREATE TABLE notification_template (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  code NVARCHAR(100) NOT NULL,
  name NVARCHAR(255),
  channel NVARCHAR(20),
  subject_tpl NVARCHAR(MAX),
  body_tpl NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_notification_template_external_id UNIQUE (external_id),
  CONSTRAINT chk_notification_template_channel CHECK (channel IS NULL OR channel IN ('email','sms','push'))
);

CREATE TABLE notification (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  user_id UNIQUEIDENTIFIER,
  contact_id UNIQUEIDENTIFIER,
  template_id UNIQUEIDENTIFIER,
  channel NVARCHAR(20),
  priority NVARCHAR(20),
  subject NVARCHAR(500),
  body NVARCHAR(MAX),
  read_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_notification_external_id UNIQUE (external_id),
  CONSTRAINT chk_notification_channel CHECK (channel IS NULL OR channel IN ('email','sms','push')),
  CONSTRAINT chk_notification_priority CHECK (priority IS NULL OR priority IN ('low','normal','high','urgent'))
);

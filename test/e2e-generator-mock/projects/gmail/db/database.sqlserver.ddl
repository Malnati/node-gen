-- test/e2e-generator-mock/projects/gmail/db/database.sqlserver.ddl
CREATE TABLE gmail_integration (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  connected_email NVARCHAR(255) NOT NULL,
  oauth_ref NVARCHAR(500),
  last_sync_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_gmail_integration_external_id UNIQUE (external_id)
);

CREATE TABLE gmail_message_template (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER,
  code NVARCHAR(100) NOT NULL,
  name NVARCHAR(255),
  subject_tpl NVARCHAR(MAX),
  body_tpl NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_gmail_message_template_external_id UNIQUE (external_id)
);

CREATE TABLE gmail_message (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  integration_id UNIQUEIDENTIFIER NOT NULL,
  gmail_message_id NVARCHAR(255),
  gmail_thread_id NVARCHAR(255),
  direction NVARCHAR(20) NOT NULL,
  subject NVARCHAR(500),
  from_addr NVARCHAR(255),
  to_addr NVARCHAR(255),
  body_preview NVARCHAR(MAX),
  sent_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_gmail_message_external_id UNIQUE (external_id),
  CONSTRAINT chk_gmail_message_direction CHECK (direction IN ('sent','received'))
);

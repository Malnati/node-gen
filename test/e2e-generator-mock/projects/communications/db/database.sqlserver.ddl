-- test/e2e-generator-mock/projects/communications/db/database.sqlserver.ddl
CREATE TABLE email_template (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  code NVARCHAR(100) NOT NULL,
  name NVARCHAR(255),
  subject_tpl NVARCHAR(MAX),
  body_tpl NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_email_template_external_id UNIQUE (external_id)
);

CREATE TABLE smtp_config (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER,
  host NVARCHAR(255) NOT NULL,
  port INT DEFAULT 587,
  use_tls BIT DEFAULT 1,
  credentials_ref NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_smtp_config_external_id UNIQUE (external_id)
);

CREATE TABLE send_history (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  template_id UNIQUEIDENTIFIER,
  recipient NVARCHAR(255) NOT NULL,
  sent_at DATETIME2,
  status NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_send_history_external_id UNIQUE (external_id)
);

CREATE TABLE delivery_tracking (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  send_history_id UNIQUEIDENTIFIER NOT NULL,
  event_type NVARCHAR(50),
  event_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_delivery_tracking_external_id UNIQUE (external_id)
);

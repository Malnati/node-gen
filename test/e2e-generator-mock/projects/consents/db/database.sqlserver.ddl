-- test/e2e-generator-mock/projects/consents/db/database.sqlserver.ddl
CREATE TABLE consent_record (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  user_id UNIQUEIDENTIFIER,
  consent_type NVARCHAR(100) NOT NULL,
  granted_at DATETIME2,
  ip_address NVARCHAR(45),
  version NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_consent_record_external_id UNIQUE (external_id)
);

CREATE TABLE notification_preference (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  user_id UNIQUEIDENTIFIER,
  channel NVARCHAR(20) NOT NULL,
  opt_in BIT DEFAULT 1,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_notification_preference_external_id UNIQUE (external_id),
  CONSTRAINT chk_notification_preference_channel CHECK (channel IN ('email','sms','push'))
);

-- test/e2e-generator-mock/projects/config/db/database.sqlserver.ddl
CREATE TABLE config (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  config_key NVARCHAR(255) NOT NULL,
  config_value NVARCHAR(MAX),
  value_type NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_config_external_id UNIQUE (external_id)
);

CREATE TABLE integration_config (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  integration_code NVARCHAR(100) NOT NULL,
  endpoint_url NVARCHAR(500),
  credentials_ref NVARCHAR(255),
  enabled BIT DEFAULT 1,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_integration_config_external_id UNIQUE (external_id)
);

CREATE TABLE webhook (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  url NVARCHAR(500) NOT NULL,
  event_type NVARCHAR(100),
  secret_hash NVARCHAR(255),
  enabled BIT DEFAULT 1,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_webhook_external_id UNIQUE (external_id)
);

CREATE TABLE branding (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255),
  logo_url NVARCHAR(500),
  logo_ref NVARCHAR(255),
  favicon_url NVARCHAR(500),
  primary_color NVARCHAR(20),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_branding_external_id UNIQUE (external_id)
);

CREATE TABLE label (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  code NVARCHAR(255) NOT NULL,
  value NVARCHAR(MAX) NOT NULL,
  locale NVARCHAR(10),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_label_external_id UNIQUE (external_id)
);

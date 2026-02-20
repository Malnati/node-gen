-- test/e2e-generator-mock/projects/google-calendar/db/database.sqlserver.ddl
CREATE TABLE calendar_integration (
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
  CONSTRAINT uk_calendar_integration_external_id UNIQUE (external_id)
);

CREATE TABLE calendar (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  integration_id UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  timezone NVARCHAR(100) DEFAULT 'UTC',
  google_calendar_id NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_calendar_external_id UNIQUE (external_id)
);

CREATE TABLE calendar_event (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  integration_id UNIQUEIDENTIFIER NOT NULL,
  calendar_id UNIQUEIDENTIFIER NOT NULL,
  title NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  start_at DATETIME2 NOT NULL,
  end_at DATETIME2 NOT NULL,
  all_day BIT DEFAULT 0,
  google_event_id NVARCHAR(255),
  status NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_calendar_event_external_id UNIQUE (external_id)
);

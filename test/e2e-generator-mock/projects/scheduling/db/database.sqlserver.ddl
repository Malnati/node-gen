-- test/e2e-generator-mock/projects/scheduling/db/database.sqlserver.ddl
CREATE TABLE calendar (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER,
  user_id UNIQUEIDENTIFIER,
  name NVARCHAR(255) NOT NULL,
  timezone NVARCHAR(50) DEFAULT 'UTC',
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_calendar_external_id UNIQUE (external_id)
);

CREATE TABLE time_slot (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  calendar_id UNIQUEIDENTIFIER NOT NULL,
  start_at DATETIME2 NOT NULL,
  end_at DATETIME2 NOT NULL,
  available BIT DEFAULT 1,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_time_slot_external_id UNIQUE (external_id)
);

CREATE TABLE booking (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  time_slot_id UNIQUEIDENTIFIER NOT NULL,
  user_id UNIQUEIDENTIFIER,
  account_id UNIQUEIDENTIFIER,
  status NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_booking_external_id UNIQUE (external_id)
);

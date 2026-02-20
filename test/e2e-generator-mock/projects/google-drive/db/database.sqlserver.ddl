-- test/e2e-generator-mock/projects/google-drive/db/database.sqlserver.ddl
CREATE TABLE drive_folder (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  parent_folder_id UNIQUEIDENTIFIER,
  drive_folder_id NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_drive_folder_external_id UNIQUE (external_id)
);

CREATE TABLE drive_file (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  folder_id UNIQUEIDENTIFIER,
  file_name NVARCHAR(255) NOT NULL,
  mime_type NVARCHAR(255),
  size_bytes BIGINT DEFAULT 0,
  drive_file_id NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_drive_file_external_id UNIQUE (external_id)
);

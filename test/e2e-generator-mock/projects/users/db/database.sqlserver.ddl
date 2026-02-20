-- test/e2e-generator-mock/projects/users/db/database.sqlserver.ddl
CREATE TABLE app_user (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  contact_id UNIQUEIDENTIFIER,
  address_id UNIQUEIDENTIFIER,
  username NVARCHAR(100) NOT NULL,
  email NVARCHAR(255) NOT NULL,
  password_hash NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_app_user_external_id UNIQUE (external_id)
);

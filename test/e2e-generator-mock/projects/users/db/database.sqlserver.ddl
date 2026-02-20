-- test/e2e-generator-mock/projects/users/db/database.sqlserver.ddl
CREATE TABLE app_user (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  address_id UNIQUEIDENTIFIER,
  contact_id UNIQUEIDENTIFIER,
  username NVARCHAR(255) NOT NULL,
  email NVARCHAR(255) NOT NULL,
  password_hash NVARCHAR(255),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

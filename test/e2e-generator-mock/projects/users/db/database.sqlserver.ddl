-- test/e2e-generator-mock/projects/users/db/database.sqlserver.ddl
CREATE TABLE app_user (
  id INT IDENTITY(1,1) PRIMARY KEY,
  username NVARCHAR(255) NOT NULL UNIQUE,
  email NVARCHAR(255) NOT NULL UNIQUE,
  password_hash NVARCHAR(255),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

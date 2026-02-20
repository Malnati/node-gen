-- test/e2e-generator-mock/projects/accounts/db/database.sqlserver.ddl
CREATE TABLE account (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  account_type NVARCHAR(50) NOT NULL,
  balance DECIMAL(12,2) DEFAULT 0,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

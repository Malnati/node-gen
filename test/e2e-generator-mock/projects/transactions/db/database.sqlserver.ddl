-- test/e2e-generator-mock/projects/transactions/db/database.sqlserver.ddl
CREATE TABLE [transaction] (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  payment_method_id UNIQUEIDENTIFIER NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  status NVARCHAR(50) NOT NULL,
  external_reference NVARCHAR(255),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

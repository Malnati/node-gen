-- test/e2e-generator-mock/projects/transactions/db/database.sqlserver.ddl
CREATE TABLE transaction (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  payment_id UNIQUEIDENTIFIER NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  status NVARCHAR(50) NOT NULL,
  external_reference NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_transaction_external_id UNIQUE (external_id)
);

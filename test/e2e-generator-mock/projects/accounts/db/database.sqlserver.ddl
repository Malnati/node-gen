-- test/e2e-generator-mock/projects/accounts/db/database.sqlserver.ddl
CREATE TABLE account (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  account_type NVARCHAR(50) NOT NULL,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_account_external_id UNIQUE (external_id),
  CONSTRAINT chk_account_type CHECK (account_type IN ('checking','savings','credit','wallet','other')),
  CONSTRAINT chk_currency_code CHECK (currency_code IN ('BRL','EUR','USD','GBP','MXN','ARS'))
);

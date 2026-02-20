-- test/e2e-generator-mock/projects/accounts/db/database.sqlserver.ddl
CREATE TABLE account (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  status NVARCHAR(50) NOT NULL DEFAULT 'active',
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_account_external_id UNIQUE (external_id),
  CONSTRAINT chk_account_status CHECK (status IN ('active','suspended','pending_verification','closed'))
);

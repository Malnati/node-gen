-- test/e2e-generator-mock/projects/addresses/db/database.sqlserver.ddl
CREATE TABLE address (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  street NVARCHAR(500) NOT NULL,
  city NVARCHAR(100) NOT NULL,
  state NVARCHAR(50),
  zip_code NVARCHAR(20),
  country NVARCHAR(2) DEFAULT 'BR',
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_address_external_id UNIQUE (external_id)
);

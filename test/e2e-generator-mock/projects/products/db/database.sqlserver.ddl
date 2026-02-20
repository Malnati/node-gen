-- test/e2e-generator-mock/projects/products/db/database.sqlserver.ddl
CREATE TABLE product (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  sku NVARCHAR(100),
  name NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  unit_price DECIMAL(12,2) DEFAULT 0,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_product_external_id UNIQUE (external_id)
);

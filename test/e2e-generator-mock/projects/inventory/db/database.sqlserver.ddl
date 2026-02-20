-- test/e2e-generator-mock/projects/inventory/db/database.sqlserver.ddl
CREATE TABLE inventory_level (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  product_id UNIQUEIDENTIFIER NOT NULL,
  address_id UNIQUEIDENTIFIER NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 0,
  reserved DECIMAL(12,2) DEFAULT 0,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_inventory_level_external_id UNIQUE (external_id)
);

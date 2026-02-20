-- test/e2e-generator-mock/projects/orders/db/database.sqlserver.ddl
CREATE TABLE [order] (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  shipping_address_id UNIQUEIDENTIFIER,
  billing_address_id UNIQUEIDENTIFIER,
  payment_id UNIQUEIDENTIFIER,
  status NVARCHAR(50),
  total DECIMAL(12,2) DEFAULT 0,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_order_external_id UNIQUE (external_id),
  CONSTRAINT chk_order_status CHECK (status IS NULL OR status IN ('draft','confirmed','paid','shipped','delivered','cancelled')),
  CONSTRAINT chk_order_currency_code CHECK (currency_code IS NULL OR currency_code IN ('BRL','EUR','USD','GBP','MXN','ARS'))
);

CREATE TABLE order_item (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  order_id UNIQUEIDENTIFIER NOT NULL,
  product_id UNIQUEIDENTIFIER NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 1,
  unit_price DECIMAL(12,2) DEFAULT 0,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_order_item_external_id UNIQUE (external_id)
);

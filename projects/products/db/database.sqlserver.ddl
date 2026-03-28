-- test/e2e-generator/projects/products/db/database.sqlserver.ddl
CREATE TABLE currency (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER,
  code NVARCHAR(3) NOT NULL,
  name NVARCHAR(100) NOT NULL,
  symbol NVARCHAR(10),
  region NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_currency_external_id UNIQUE (external_id),
  CONSTRAINT uk_currency_code UNIQUE (code),
  CONSTRAINT chk_currency_region CHECK (region IS NULL OR region IN ('SOUTH_AMERICA','NORTH_AMERICA','EUROPE'))
);

CREATE TABLE unit_of_measure (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER,
  code NVARCHAR(20) NOT NULL,
  name NVARCHAR(100),
  symbol NVARCHAR(10),
  category NVARCHAR(30),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_uom_external_id UNIQUE (external_id),
  CONSTRAINT uk_uom_code UNIQUE (code),
  CONSTRAINT chk_uom_category CHECK (category IS NULL OR category IN ('COUNT','WEIGHT','VOLUME','LENGTH','AREA','TIME'))
);

CREATE TABLE product (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  sku NVARCHAR(100),
  name NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  unit_of_measure_id INT NOT NULL,
  currency_id INT NOT NULL,
  unit_price DECIMAL(12,2) DEFAULT 0,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_product_external_id UNIQUE (external_id),
  CONSTRAINT fk_product_currency FOREIGN KEY (currency_id) REFERENCES currency(id),
  CONSTRAINT fk_product_uom FOREIGN KEY (unit_of_measure_id) REFERENCES unit_of_measure(id)
);

-- test/e2e-generator-mock/projects/payments/db/database.sqlserver.ddl
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

CREATE TABLE payment_type (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER,
  code NVARCHAR(20) NOT NULL,
  name NVARCHAR(100),
  description NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_payment_type_external_id UNIQUE (external_id),
  CONSTRAINT uk_payment_type_code UNIQUE (code)
);

CREATE TABLE payment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  contact_id UNIQUEIDENTIFIER,
  billing_address_id UNIQUEIDENTIFIER,
  payment_type_id INT NOT NULL,
  currency_id INT NOT NULL,
  amount DECIMAL(12,2) DEFAULT 0,
  status NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_payment_external_id UNIQUE (external_id),
  CONSTRAINT fk_payment_type FOREIGN KEY (payment_type_id) REFERENCES payment_type(id),
  CONSTRAINT fk_payment_currency FOREIGN KEY (currency_id) REFERENCES currency(id)
);

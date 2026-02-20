-- test/e2e-generator-mock/projects/payments/db/database.sqlserver.ddl
CREATE TABLE payment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  contact_id UNIQUEIDENTIFIER,
  billing_address_id UNIQUEIDENTIFIER,
  method NVARCHAR(20) NOT NULL,
  amount DECIMAL(12,2) DEFAULT 0,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  status NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_payment_external_id UNIQUE (external_id),
  CONSTRAINT chk_payment_method CHECK (method IN ('DEBITO','CREDITO','PIX','BOLETO','CRIPTO','SWIFT','SEPA','ACH'))
);

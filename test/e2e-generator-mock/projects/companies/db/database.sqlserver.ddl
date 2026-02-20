-- test/e2e-generator-mock/projects/companies/db/database.sqlserver.ddl
CREATE TABLE company (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  contact_id UNIQUEIDENTIFIER,
  address_id UNIQUEIDENTIFIER,
  name NVARCHAR(255) NOT NULL,
  legal_name NVARCHAR(255),
  tax_id NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_company_external_id UNIQUE (external_id)
);

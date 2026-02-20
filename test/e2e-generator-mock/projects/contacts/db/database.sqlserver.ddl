-- test/e2e-generator-mock/projects/contacts/db/database.sqlserver.ddl
CREATE TABLE contact (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  address_id UNIQUEIDENTIFIER,
  name NVARCHAR(255) NOT NULL,
  email NVARCHAR(255),
  phone NVARCHAR(50),
  company NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_contact_external_id UNIQUE (external_id)
);

-- test/e2e-generator-mock/projects/companies/db/database.sqlserver.ddl
CREATE TABLE company (
  id INT IDENTITY(1,1) PRIMARY KEY,
  account_id UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  legal_name NVARCHAR(255),
  tax_id NVARCHAR(50),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

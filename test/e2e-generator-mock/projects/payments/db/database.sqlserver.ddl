-- test/e2e-generator-mock/projects/payments/db/database.sqlserver.ddl
CREATE TABLE payment_method (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  contact_id UNIQUEIDENTIFIER,
  code NVARCHAR(50) NOT NULL,
  name NVARCHAR(255) NOT NULL,
  method_type NVARCHAR(50) NOT NULL,
  region NVARCHAR(50),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

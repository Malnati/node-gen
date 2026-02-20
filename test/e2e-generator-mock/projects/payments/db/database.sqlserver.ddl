-- test/e2e-generator-mock/projects/payments/db/database.sqlserver.ddl
CREATE TABLE payment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  amount DECIMAL(12,2) NOT NULL,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  status NVARCHAR(50) NOT NULL,
  method NVARCHAR(50),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

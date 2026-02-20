-- test/e2e-generator-mock/projects/addresses/db/database.sqlserver.ddl
CREATE TABLE address (
  id INT IDENTITY(1,1) PRIMARY KEY,
  street NVARCHAR(255) NOT NULL,
  city NVARCHAR(255) NOT NULL,
  state NVARCHAR(100),
  zip_code NVARCHAR(20),
  country NVARCHAR(2) DEFAULT 'BR',
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

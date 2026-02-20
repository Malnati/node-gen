-- test/e2e-generator-mock/projects/contacts/db/database.sqlserver.ddl
CREATE TABLE contact (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(255) NOT NULL,
  email NVARCHAR(255),
  phone NVARCHAR(50),
  company NVARCHAR(255),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

-- test/e2e-generator-mock/projects/google-drive/db/database.sqlserver.ddl
CREATE TABLE drive_file (
  id INT IDENTITY(1,1) PRIMARY KEY,
  file_name NVARCHAR(255) NOT NULL,
  mime_type NVARCHAR(255),
  size_bytes BIGINT DEFAULT 0,
  drive_file_id NVARCHAR(255),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

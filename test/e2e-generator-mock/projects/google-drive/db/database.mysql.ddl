-- test/e2e-generator-mock/projects/google-drive/db/database.mysql.ddl
CREATE TABLE drive_file (
  id INT AUTO_INCREMENT PRIMARY KEY,
  file_name VARCHAR(255) NOT NULL,
  mime_type VARCHAR(255),
  size_bytes BIGINT DEFAULT 0,
  drive_file_id VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

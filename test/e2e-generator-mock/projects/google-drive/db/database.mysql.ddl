-- test/e2e-generator-mock/projects/google-drive/db/database.mysql.ddl
CREATE TABLE drive_integration (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  connected_email VARCHAR(255) NOT NULL,
  oauth_ref VARCHAR(500),
  last_sync_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_drive_integration_external_id (external_id)
);

CREATE TABLE drive_folder (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  integration_id CHAR(36) NOT NULL,
  name VARCHAR(255) NOT NULL,
  parent_folder_id CHAR(36),
  drive_folder_id VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_drive_folder_external_id (external_id)
);

CREATE TABLE drive_file (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  integration_id CHAR(36) NOT NULL,
  folder_id CHAR(36),
  file_name VARCHAR(255) NOT NULL,
  mime_type VARCHAR(255),
  size_bytes BIGINT DEFAULT 0,
  drive_file_id VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_drive_file_external_id (external_id)
);

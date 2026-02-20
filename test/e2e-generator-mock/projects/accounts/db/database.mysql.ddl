-- test/e2e-generator-mock/projects/accounts/db/database.mysql.ddl
CREATE TABLE account (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_account_external_id (external_id),
  CONSTRAINT chk_account_status CHECK (status IN ('active','suspended','pending_verification','closed'))
);

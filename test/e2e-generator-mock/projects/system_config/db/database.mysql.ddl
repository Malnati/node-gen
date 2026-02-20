-- test/e2e-generator-mock/projects/system_config/db/database.mysql.ddl
CREATE TABLE system_config (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  config_key VARCHAR(255) NOT NULL,
  config_value TEXT,
  value_type VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_system_config_external_id (external_id)
);

CREATE TABLE integration_config (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  integration_code VARCHAR(100) NOT NULL,
  endpoint_url VARCHAR(500),
  credentials_ref VARCHAR(255),
  enabled TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_integration_config_external_id (external_id)
);

CREATE TABLE webhook (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  url VARCHAR(500) NOT NULL,
  event_type VARCHAR(100),
  secret_hash VARCHAR(255),
  enabled TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_webhook_external_id (external_id)
);

-- test/e2e-generator-mock/projects/llm/db/database.mysql.ddl
CREATE TABLE llm_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36),
  model_name VARCHAR(255) NOT NULL,
  prompt TEXT,
  response TEXT,
  tokens_used INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_llm_log_external_id (external_id)
);

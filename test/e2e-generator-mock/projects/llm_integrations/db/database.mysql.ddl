-- test/e2e-generator-mock/projects/llm_integrations/db/database.mysql.ddl
CREATE TABLE llm_provider_config (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36),
  provider_code VARCHAR(50) NOT NULL,
  model_id VARCHAR(100),
  api_key_ref VARCHAR(255),
  fallback_local_endpoint VARCHAR(500),
  routing_priority INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_llm_provider_config_external_id (external_id)
);

CREATE TABLE prompt_template (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(255),
  content TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_prompt_template_external_id (external_id)
);

CREATE TABLE llm_execution_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  provider_config_id CHAR(36),
  model_id VARCHAR(100),
  success TINYINT(1),
  latency_ms INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_llm_execution_log_external_id (external_id)
);

CREATE TABLE llm_usage_summary (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36),
  provider_config_id CHAR(36),
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  total_requests INT DEFAULT 0,
  total_tokens_input INT DEFAULT 0,
  total_tokens_output INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_llm_usage_summary_external_id (external_id)
);

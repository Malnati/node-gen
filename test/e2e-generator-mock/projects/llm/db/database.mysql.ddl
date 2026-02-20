-- test/e2e-generator-mock/projects/llm/db/database.mysql.ddl
CREATE TABLE llm_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  model_name VARCHAR(255) NOT NULL,
  prompt TEXT,
  response TEXT,
  tokens_used INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

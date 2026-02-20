-- test/e2e-generator-mock/projects/llm/db/database.sqlite.ddl
CREATE TABLE llm_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  model_name TEXT NOT NULL,
  prompt TEXT,
  response TEXT,
  tokens_used INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

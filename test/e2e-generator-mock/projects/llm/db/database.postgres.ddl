-- test/e2e-generator-mock/projects/llm/db/database.postgres.ddl
CREATE TABLE llm_log (
  id SERIAL PRIMARY KEY,
  model_name TEXT NOT NULL,
  prompt TEXT,
  response TEXT,
  tokens_used INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

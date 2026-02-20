-- test/e2e-generator-mock/projects/llm/db/database.sqlserver.ddl
CREATE TABLE llm_log (
  id INT IDENTITY(1,1) PRIMARY KEY,
  model_name NVARCHAR(255) NOT NULL,
  prompt NVARCHAR(MAX),
  response NVARCHAR(MAX),
  tokens_used INT DEFAULT 0,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

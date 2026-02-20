-- test/e2e-generator-mock/projects/google-drive/db/database.postgres.ddl
CREATE TABLE drive_file (
  id SERIAL PRIMARY KEY,
  file_name TEXT NOT NULL,
  mime_type TEXT,
  size_bytes BIGINT DEFAULT 0,
  drive_file_id TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

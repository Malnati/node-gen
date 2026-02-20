-- test/e2e-generator-mock/projects/google-drive/db/database.sqlite.ddl
CREATE TABLE drive_file (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  file_name TEXT NOT NULL,
  mime_type TEXT,
  size_bytes INTEGER DEFAULT 0,
  drive_file_id TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

-- test/e2e-generator-mock/projects/gmail/db/database.sqlite.ddl
CREATE TABLE email_message (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  message_id TEXT,
  subject TEXT,
  from_addr TEXT,
  to_addr TEXT,
  body_preview TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

-- test/e2e-generator-mock/projects/gmail/db/database.postgres.ddl
CREATE TABLE email_message (
  id SERIAL PRIMARY KEY,
  message_id TEXT,
  subject TEXT,
  from_addr TEXT,
  to_addr TEXT,
  body_preview TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

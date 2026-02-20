-- test/e2e-generator-mock/projects/gmail/db/database.mysql.ddl
CREATE TABLE email_message (
  id INT AUTO_INCREMENT PRIMARY KEY,
  message_id VARCHAR(255),
  subject VARCHAR(500),
  from_addr VARCHAR(255),
  to_addr VARCHAR(255),
  body_preview TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

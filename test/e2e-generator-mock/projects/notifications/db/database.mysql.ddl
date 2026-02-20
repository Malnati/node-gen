-- test/e2e-generator-mock/projects/notifications/db/database.mysql.ddl
CREATE TABLE notification (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  user_id CHAR(36),
  contact_id CHAR(36),
  channel VARCHAR(50),
  subject VARCHAR(500),
  body TEXT,
  read_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_notification_external_id (external_id)
);

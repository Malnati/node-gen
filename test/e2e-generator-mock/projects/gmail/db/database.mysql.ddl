-- test/e2e-generator-mock/projects/gmail/db/database.mysql.ddl
CREATE TABLE gmail_integration (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  connected_email VARCHAR(255) NOT NULL,
  oauth_ref VARCHAR(500),
  last_sync_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_gmail_integration_external_id (external_id)
);

CREATE TABLE gmail_message_template (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36),
  code VARCHAR(100) NOT NULL,
  name VARCHAR(255),
  subject_tpl TEXT,
  body_tpl TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_gmail_message_template_external_id (external_id)
);

CREATE TABLE gmail_message (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  integration_id CHAR(36) NOT NULL,
  gmail_message_id VARCHAR(255),
  gmail_thread_id VARCHAR(255),
  direction VARCHAR(20) NOT NULL,
  subject VARCHAR(500),
  from_addr VARCHAR(255),
  to_addr VARCHAR(255),
  body_preview TEXT,
  sent_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_gmail_message_external_id (external_id),
  CONSTRAINT chk_gmail_message_direction CHECK (direction IN ('sent','received'))
);

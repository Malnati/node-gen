-- test/e2e-generator-mock/projects/notifications/db/database.mysql.ddl
CREATE TABLE notification_template (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(255),
  channel VARCHAR(20),
  subject_tpl TEXT,
  body_tpl TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_notification_template_external_id (external_id),
  CONSTRAINT chk_notification_template_channel CHECK (channel IS NULL OR channel IN ('email','sms','push'))
);

CREATE TABLE notification (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  user_id CHAR(36),
  contact_id CHAR(36),
  template_id CHAR(36),
  channel VARCHAR(20),
  priority VARCHAR(20),
  subject VARCHAR(500),
  body TEXT,
  read_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_notification_external_id (external_id),
  CONSTRAINT chk_notification_channel CHECK (channel IS NULL OR channel IN ('email','sms','push')),
  CONSTRAINT chk_notification_priority CHECK (priority IS NULL OR priority IN ('low','normal','high','urgent'))
);

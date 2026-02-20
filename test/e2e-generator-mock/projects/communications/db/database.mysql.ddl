-- test/e2e-generator-mock/projects/communications/db/database.mysql.ddl
CREATE TABLE email_template (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(255),
  subject_tpl TEXT,
  body_tpl TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_email_template_external_id (external_id)
);

CREATE TABLE smtp_config (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36),
  host VARCHAR(255) NOT NULL,
  port INT DEFAULT 587,
  use_tls TINYINT(1) DEFAULT 1,
  credentials_ref VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_smtp_config_external_id (external_id)
);

CREATE TABLE send_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  template_id CHAR(36),
  recipient VARCHAR(255) NOT NULL,
  sent_at DATETIME,
  status VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_send_history_external_id (external_id)
);

CREATE TABLE delivery_tracking (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  send_history_id CHAR(36) NOT NULL,
  event_type VARCHAR(50),
  event_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_delivery_tracking_external_id (external_id)
);

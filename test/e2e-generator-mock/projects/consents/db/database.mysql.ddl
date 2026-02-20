-- test/e2e-generator-mock/projects/consents/db/database.mysql.ddl
CREATE TABLE consent_record (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  user_id CHAR(36),
  consent_type VARCHAR(100) NOT NULL,
  granted_at DATETIME,
  ip_address VARCHAR(45),
  version VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_consent_record_external_id (external_id)
);

CREATE TABLE notification_preference (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  user_id CHAR(36),
  channel VARCHAR(20) NOT NULL,
  opt_in TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_notification_preference_external_id (external_id),
  CONSTRAINT chk_notification_preference_channel CHECK (channel IN ('email','sms','push'))
);

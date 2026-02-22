-- test/e2e-generator/projects/consents/db/database.mysql.ddl
CREATE TABLE consent_record (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  user_id CHAR(36) COMMENT 'Usuário (UUID externo).',
  consent_type VARCHAR(100) NOT NULL COMMENT 'Tipo de consentimento.',
  granted_at DATETIME COMMENT 'Data de concessão.',
  ip_address VARCHAR(45) COMMENT 'IP da solicitação.',
  version VARCHAR(50) COMMENT 'Versão do termo.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_consent_record_external_id (external_id)
) COMMENT = 'Registros de consentimento por conta e tenant.';

CREATE TABLE notification_preference (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  user_id CHAR(36) COMMENT 'Usuário (UUID externo).',
  channel VARCHAR(20) NOT NULL COMMENT 'Canal (email, sms, push).',
  opt_in TINYINT(1) DEFAULT 1 COMMENT 'Opt-in ativo.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_notification_preference_external_id (external_id),
  CONSTRAINT chk_notification_preference_channel CHECK (channel IN ('email','sms','push'))
) COMMENT = 'Preferências de notificação por canal e usuário.';

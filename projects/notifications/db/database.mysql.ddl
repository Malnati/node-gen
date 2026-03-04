-- test/e2e-generator/projects/notifications/db/database.mysql.ddl
CREATE TABLE notification_template (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  code VARCHAR(100) NOT NULL COMMENT 'Código do template.',
  name VARCHAR(255) COMMENT 'Nome.',
  channel VARCHAR(20) COMMENT 'Canal (email, sms, push).',
  subject_tpl TEXT COMMENT 'Template do assunto.',
  body_tpl TEXT COMMENT 'Template do corpo.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_notification_template_external_id (external_id),
  CONSTRAINT chk_notification_template_channel CHECK (channel IS NULL OR channel IN ('email','sms','push'))
) COMMENT = 'Templates de notificação por tenant.';

CREATE TABLE notification (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  user_id CHAR(36) COMMENT 'Usuário (UUID externo).',
  contact_id CHAR(36) COMMENT 'Contato (UUID externo).',
  template_id CHAR(36) COMMENT 'Template (UUID externo).',
  channel VARCHAR(20) COMMENT 'Canal (email, sms, push).',
  priority VARCHAR(20) COMMENT 'Prioridade (low, normal, high, urgent).',
  subject VARCHAR(500) COMMENT 'Assunto.',
  body TEXT COMMENT 'Corpo.',
  read_at DATETIME COMMENT 'Data de leitura.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_notification_external_id (external_id),
  CONSTRAINT chk_notification_channel CHECK (channel IS NULL OR channel IN ('email','sms','push')),
  CONSTRAINT chk_notification_priority CHECK (priority IS NULL OR priority IN ('low','normal','high','urgent'))
) COMMENT = 'Notificações enviadas por tenant/conta.';

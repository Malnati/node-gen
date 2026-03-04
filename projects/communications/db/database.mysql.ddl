-- test/e2e-generator/projects/communications/db/database.mysql.ddl
CREATE TABLE email_template (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  code VARCHAR(100) NOT NULL COMMENT 'Código do template.',
  name VARCHAR(255) COMMENT 'Nome.',
  subject_tpl TEXT COMMENT 'Template do assunto.',
  body_tpl TEXT COMMENT 'Template do corpo.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_email_template_external_id (external_id)
) COMMENT = 'Templates de e-mail por tenant.';

CREATE TABLE smtp_config (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) COMMENT 'Conta (UUID externo).',
  host VARCHAR(255) NOT NULL COMMENT 'Host SMTP.',
  port INT DEFAULT 587 COMMENT 'Porta.',
  use_tls TINYINT(1) DEFAULT 1 COMMENT 'Usar TLS.',
  credentials_ref VARCHAR(255) COMMENT 'Referência às credenciais.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_smtp_config_external_id (external_id)
) COMMENT = 'Configuração SMTP por tenant/conta.';

CREATE TABLE send_history (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  template_id CHAR(36) COMMENT 'Template (UUID externo).',
  recipient VARCHAR(255) NOT NULL COMMENT 'Destinatário.',
  sent_at DATETIME COMMENT 'Data de envio.',
  status VARCHAR(50) COMMENT 'Status.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_send_history_external_id (external_id)
) COMMENT = 'Histórico de envios por tenant.';

CREATE TABLE delivery_tracking (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  send_history_id CHAR(36) NOT NULL COMMENT 'Envio (UUID externo).',
  event_type VARCHAR(50) COMMENT 'Tipo do evento.',
  event_at DATETIME COMMENT 'Data do evento.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_delivery_tracking_external_id (external_id)
) COMMENT = 'Rastreio de entrega por envio.';

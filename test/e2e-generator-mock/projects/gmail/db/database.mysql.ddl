-- test/e2e-generator-mock/projects/gmail/db/database.mysql.ddl
CREATE TABLE gmail_integration (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  connected_email VARCHAR(255) NOT NULL COMMENT 'E-mail conectado.',
  oauth_ref VARCHAR(500) COMMENT 'Referência OAuth.',
  last_sync_at DATETIME COMMENT 'Última sincronização.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_gmail_integration_external_id (external_id)
) COMMENT = 'Integração Gmail por conta e tenant.';

CREATE TABLE gmail_message_template (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) COMMENT 'Conta (UUID externo).',
  code VARCHAR(100) NOT NULL COMMENT 'Código do template.',
  name VARCHAR(255) COMMENT 'Nome.',
  subject_tpl TEXT COMMENT 'Template do assunto.',
  body_tpl TEXT COMMENT 'Template do corpo.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_gmail_message_template_external_id (external_id)
) COMMENT = 'Templates de mensagem Gmail por tenant.';

CREATE TABLE gmail_message (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  integration_id CHAR(36) NOT NULL COMMENT 'Integração (UUID externo).',
  gmail_message_id VARCHAR(255) COMMENT 'ID da mensagem no Gmail.',
  gmail_thread_id VARCHAR(255) COMMENT 'ID do thread no Gmail.',
  direction VARCHAR(20) NOT NULL COMMENT 'Direção (sent, received).',
  subject VARCHAR(500) COMMENT 'Assunto.',
  from_addr VARCHAR(255) COMMENT 'Remetente.',
  to_addr VARCHAR(255) COMMENT 'Destinatário.',
  body_preview TEXT COMMENT 'Prévia do corpo.',
  sent_at DATETIME COMMENT 'Data de envio.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_gmail_message_external_id (external_id),
  CONSTRAINT chk_gmail_message_direction CHECK (direction IN ('sent','received'))
) COMMENT = 'Mensagens Gmail por integração e tenant.';

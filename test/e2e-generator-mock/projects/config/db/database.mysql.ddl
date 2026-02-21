-- test/e2e-generator-mock/projects/config/db/database.mysql.ddl
CREATE TABLE config (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  config_key VARCHAR(255) NOT NULL COMMENT 'Chave da configuração.',
  config_value TEXT COMMENT 'Valor.',
  value_type VARCHAR(50) COMMENT 'Tipo do valor.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_config_external_id (external_id)
) COMMENT = 'Configurações chave-valor por tenant.';

CREATE TABLE integration_config (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  integration_code VARCHAR(100) NOT NULL COMMENT 'Código da integração.',
  endpoint_url VARCHAR(500) COMMENT 'URL do endpoint.',
  credentials_ref VARCHAR(255) COMMENT 'Referência às credenciais.',
  enabled TINYINT(1) DEFAULT 1 COMMENT 'Integração ativa.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_integration_config_external_id (external_id)
) COMMENT = 'Configuração de integrações por tenant.';

CREATE TABLE webhook (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  url VARCHAR(500) NOT NULL COMMENT 'URL de callback.',
  event_type VARCHAR(100) COMMENT 'Tipo de evento.',
  secret_hash VARCHAR(255) COMMENT 'Hash do segredo.',
  enabled TINYINT(1) DEFAULT 1 COMMENT 'Webhook ativo.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_webhook_external_id (external_id)
) COMMENT = 'Webhooks por tenant.';

CREATE TABLE branding (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  name VARCHAR(255) COMMENT 'Nome da marca.',
  logo_url VARCHAR(500) COMMENT 'URL do logo.',
  logo_ref VARCHAR(255) COMMENT 'Referência ao logo.',
  favicon_url VARCHAR(500) COMMENT 'URL do favicon.',
  primary_color VARCHAR(20) COMMENT 'Cor primária.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_branding_external_id (external_id)
) COMMENT = 'Identidade visual por tenant.';

CREATE TABLE label (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  code VARCHAR(255) NOT NULL COMMENT 'Código do label.',
  value TEXT NOT NULL COMMENT 'Valor do texto.',
  locale VARCHAR(10) COMMENT 'Locale (ex.: pt-BR).',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_label_external_id (external_id)
) COMMENT = 'Labels de internacionalização por tenant.';

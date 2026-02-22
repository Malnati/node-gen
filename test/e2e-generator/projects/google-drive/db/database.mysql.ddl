-- test/e2e-generator/projects/google-drive/db/database.mysql.ddl
CREATE TABLE drive_integration (
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
  UNIQUE KEY uk_drive_integration_external_id (external_id)
) COMMENT = 'Integração Google Drive por conta e tenant.';

CREATE TABLE drive_folder (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  integration_id CHAR(36) NOT NULL COMMENT 'Integração (UUID externo).',
  name VARCHAR(255) NOT NULL COMMENT 'Nome da pasta.',
  parent_folder_id CHAR(36) COMMENT 'Pasta pai (UUID externo).',
  drive_folder_id VARCHAR(255) COMMENT 'ID da pasta no Google Drive.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_drive_folder_external_id (external_id)
) COMMENT = 'Pastas do Drive por integração e tenant.';

CREATE TABLE drive_file (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  integration_id CHAR(36) NOT NULL COMMENT 'Integração (UUID externo).',
  folder_id CHAR(36) COMMENT 'Pasta (UUID externo).',
  file_name VARCHAR(255) NOT NULL COMMENT 'Nome do arquivo.',
  mime_type VARCHAR(255) COMMENT 'Tipo MIME.',
  size_bytes BIGINT DEFAULT 0 COMMENT 'Tamanho em bytes.',
  drive_file_id VARCHAR(255) COMMENT 'ID do arquivo no Google Drive.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_drive_file_external_id (external_id)
) COMMENT = 'Arquivos do Drive por tenant e conta.';

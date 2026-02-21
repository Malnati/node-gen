-- test/e2e-generator-mock/projects/auth/db/database.mysql.ddl
CREATE TABLE auth_session (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  user_id CHAR(36) NOT NULL COMMENT 'Usuário (UUID externo).',
  token_hash VARCHAR(255) COMMENT 'Hash do token.',
  expires_at DATETIME COMMENT 'Data de expiração.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_auth_session_external_id (external_id)
) COMMENT = 'Sessões de autenticação por usuário e tenant.';

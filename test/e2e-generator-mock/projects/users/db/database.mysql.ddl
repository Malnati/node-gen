-- test/e2e-generator-mock/projects/users/db/database.mysql.ddl
CREATE TABLE app_user (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  contact_id CHAR(36) COMMENT 'Contato (UUID externo).',
  address_id CHAR(36) COMMENT 'Endereço (UUID externo).',
  username VARCHAR(100) NOT NULL COMMENT 'Nome de usuário.',
  email VARCHAR(255) NOT NULL COMMENT 'E-mail.',
  password_hash VARCHAR(255) COMMENT 'Hash da senha.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_app_user_external_id (external_id)
) COMMENT = 'Usuários da aplicação por conta e tenant.';

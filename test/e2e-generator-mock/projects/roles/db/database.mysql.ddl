-- test/e2e-generator-mock/projects/roles/db/database.mysql.ddl
CREATE TABLE `role` (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  name VARCHAR(100) NOT NULL COMMENT 'Nome do papel.',
  description VARCHAR(500) COMMENT 'Descrição.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_role_external_id (external_id)
) COMMENT = 'Papéis por tenant.';

CREATE TABLE feature (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  code VARCHAR(100) NOT NULL COMMENT 'Código da funcionalidade.',
  name VARCHAR(255) COMMENT 'Nome.',
  description VARCHAR(500) COMMENT 'Descrição.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_feature_external_id (external_id)
) COMMENT = 'Funcionalidades por tenant.';

CREATE TABLE role_feature (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  role_id CHAR(36) NOT NULL COMMENT 'Papel (UUID externo).',
  feature_id CHAR(36) NOT NULL COMMENT 'Funcionalidade (UUID externo).',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_role_feature_external_id (external_id)
) COMMENT = 'Associação papel-funcionalidade.';

CREATE TABLE user_role (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  user_id CHAR(36) NOT NULL COMMENT 'Usuário (UUID externo).',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  role_id CHAR(36) NOT NULL COMMENT 'Papel (UUID externo).',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_user_role_external_id (external_id)
) COMMENT = 'Associação usuário-papel por conta.';

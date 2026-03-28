-- test/e2e-generator/projects/contacts/db/database.mysql.ddl
CREATE TABLE contact (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  address_id CHAR(36) COMMENT 'Endereço (UUID externo).',
  name VARCHAR(255) NOT NULL COMMENT 'Nome do contato.',
  email VARCHAR(255) COMMENT 'E-mail.',
  phone VARCHAR(50) COMMENT 'Telefone.',
  company VARCHAR(255) COMMENT 'Empresa.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_contact_external_id (external_id)
) COMMENT = 'Contatos por conta e tenant.';

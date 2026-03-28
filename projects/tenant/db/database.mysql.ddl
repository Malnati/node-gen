-- test/e2e-generator/projects/tenant/db/database.mysql.ddl
CREATE TABLE tenant (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  contact_id CHAR(36) COMMENT 'Contato (UUID externo).',
  address_id CHAR(36) COMMENT 'Endereço (UUID externo).',
  name VARCHAR(255) NOT NULL COMMENT 'Nome do tenant.',
  legal_name VARCHAR(255) COMMENT 'Razão social.',
  tax_id VARCHAR(50) COMMENT 'CNPJ/CPF.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_tenant_external_id (external_id)
) COMMENT = 'Tenants (organizações) por conta.';

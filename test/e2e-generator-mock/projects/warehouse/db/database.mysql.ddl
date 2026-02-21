-- test/e2e-generator-mock/projects/warehouse/db/database.mysql.ddl
CREATE TABLE warehouse_stock (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  product_id CHAR(36) NOT NULL COMMENT 'Produto (UUID externo).',
  address_id CHAR(36) NOT NULL COMMENT 'Endereço do armazém (UUID externo).',
  quantity DECIMAL(12,2) DEFAULT 0 COMMENT 'Quantidade disponível.',
  reserved DECIMAL(12,2) DEFAULT 0 COMMENT 'Quantidade reservada.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_warehouse_stock_external_id (external_id)
) COMMENT = 'Estoque por produto e endereço (tenant).';

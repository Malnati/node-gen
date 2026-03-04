-- test/e2e-generator/projects/transactions/db/database.mysql.ddl
CREATE TABLE transaction (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  payment_id CHAR(36) NOT NULL COMMENT 'Pagamento (UUID externo).',
  amount DECIMAL(12,2) NOT NULL COMMENT 'Valor.',
  currency_code VARCHAR(3) DEFAULT 'BRL' COMMENT 'Código da moeda (ex.: BRL).',
  status VARCHAR(50) NOT NULL COMMENT 'Status da transação.',
  external_reference VARCHAR(255) COMMENT 'Referência externa.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_transaction_external_id (external_id)
) COMMENT = 'Transações financeiras por conta e tenant.';

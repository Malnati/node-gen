-- test/e2e-generator/projects/orders/db/database.mysql.ddl
CREATE TABLE `order` (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  shipping_address_id CHAR(36) COMMENT 'Endereço de entrega (UUID externo).',
  billing_address_id CHAR(36) COMMENT 'Endereço de cobrança (UUID externo).',
  payment_id CHAR(36) COMMENT 'Pagamento (UUID externo).',
  status VARCHAR(50) COMMENT 'Status do pedido.',
  total DECIMAL(12,2) DEFAULT 0 COMMENT 'Total.',
  currency_code VARCHAR(3) DEFAULT 'BRL' COMMENT 'Moeda (BRL, EUR, etc.).',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_order_external_id (external_id),
  CONSTRAINT chk_order_status CHECK (status IS NULL OR status IN ('draft','confirmed','paid','shipped','delivered','cancelled')),
  CONSTRAINT chk_order_currency_code CHECK (currency_code IS NULL OR currency_code IN ('BRL','EUR','USD','GBP','MXN','ARS'))
) COMMENT = 'Pedidos por conta e tenant.';

CREATE TABLE order_item (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  order_id CHAR(36) NOT NULL COMMENT 'Pedido (UUID externo).',
  product_id CHAR(36) NOT NULL COMMENT 'Produto (UUID externo).',
  quantity DECIMAL(12,2) DEFAULT 1 COMMENT 'Quantidade.',
  unit_price DECIMAL(12,2) DEFAULT 0 COMMENT 'Preço unitário.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_order_item_external_id (external_id)
) COMMENT = 'Itens do pedido.';

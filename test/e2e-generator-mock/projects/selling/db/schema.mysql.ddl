-- test/e2e-generator-mock/projects/selling/db/schema.mysql.ddl
CREATE TABLE tb_order (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna do pedido.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs e referência entre serviços.',
  account_id CHAR(36) NOT NULL COMMENT 'Referência lógica ao comprador (serviço accounts).',
  billing_address_id CHAR(36) COMMENT 'Referência lógica ao endereço de faturação (serviço addresses).',
  shipping_address_id CHAR(36) COMMENT 'Referência lógica ao endereço de envio (serviço addresses).',
  payment_id CHAR(36) COMMENT 'Referência lógica ao pagamento (serviço payments).',
  status VARCHAR(50) NOT NULL COMMENT 'Estado do pedido.',
  total DECIMAL(12,2) NOT NULL COMMENT 'Valor total do pedido.',
  discount DECIMAL(5,2) DEFAULT 0 COMMENT 'Desconto aplicado.',
  ordered_at DATETIME COMMENT 'Data/hora do pedido.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação do registro.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME
) COMMENT = 'Pedidos de venda; comprador e endereços/pagamento referenciados por UUID aos serviços accounts, addresses e payments.';

CREATE TABLE tb_order_line (
  order_id INT NOT NULL COMMENT 'Chave interna do pedido (FK local).',
  line_number INT NOT NULL COMMENT 'Número da linha no pedido.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  product_id CHAR(36) NOT NULL COMMENT 'Referência lógica ao produto (serviço products).',
  product_name VARCHAR(255) COMMENT 'Cache do nome do produto para exibição (opcional).',
  quantity INT NOT NULL COMMENT 'Quantidade.',
  unit_price DECIMAL(12,2) NOT NULL COMMENT 'Preço unitário.',
  line_total DECIMAL(12,2) NOT NULL COMMENT 'Total da linha.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação do registro.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME COMMENT 'Exclusão lógica (soft delete).',
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
) COMMENT = 'Itens do pedido; produto referenciado por UUID ao serviço products.';

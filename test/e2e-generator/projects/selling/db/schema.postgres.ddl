-- test/e2e-generator/projects/selling/db/schema.postgres.ddl
CREATE TABLE tb_order (
  id SERIAL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL,
  account_id UUID NOT NULL,
  billing_address_id UUID,
  shipping_address_id UUID,
  payment_id UUID,
  status TEXT NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0,
  ordered_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  CONSTRAINT pk_tb_order PRIMARY KEY (id),
  CONSTRAINT uk_tb_order_external_id UNIQUE(external_id)
);
COMMENT ON TABLE tb_order IS 'Pedidos de venda; comprador e endereços/pagamento referenciados por UUID aos serviços accounts, addresses e payments.';
COMMENT ON COLUMN tb_order.id IS 'Chave interna do pedido.';
COMMENT ON COLUMN tb_order.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_order.external_id IS 'Identificador público para APIs e referência entre serviços.';
COMMENT ON COLUMN tb_order.account_id IS 'Referência lógica ao comprador (serviço accounts).';
COMMENT ON COLUMN tb_order.billing_address_id IS 'Referência lógica ao endereço de faturação (serviço addresses).';
COMMENT ON COLUMN tb_order.shipping_address_id IS 'Referência lógica ao endereço de envio (serviço addresses).';
COMMENT ON COLUMN tb_order.payment_id IS 'Referência lógica ao pagamento (serviço payments).';
COMMENT ON COLUMN tb_order.status IS 'Estado do pedido.';
COMMENT ON COLUMN tb_order.total IS 'Valor total do pedido.';
COMMENT ON COLUMN tb_order.discount IS 'Desconto aplicado.';
COMMENT ON COLUMN tb_order.ordered_at IS 'Data/hora do pedido.';
COMMENT ON COLUMN tb_order.created_at IS 'Data/hora de criação do registro.';
COMMENT ON COLUMN tb_order.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_order.deleted_at IS 'Exclusão lógica (soft delete).';
COMMENT ON CONSTRAINT pk_tb_order ON tb_order IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_tb_order_external_id ON tb_order IS 'UUID único.';

CREATE TABLE tb_order_line (
  order_id INTEGER NOT NULL,
  line_number INTEGER NOT NULL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL,
  product_id UUID NOT NULL,
  product_name TEXT,
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  CONSTRAINT pk_tb_order_line PRIMARY KEY (order_id, line_number),
  CONSTRAINT uk_tb_order_line_external_id UNIQUE(external_id),
  CONSTRAINT fk_tb_order_line_order FOREIGN KEY (order_id) REFERENCES tb_order(id)
);
COMMENT ON TABLE tb_order_line IS 'Itens do pedido; produto referenciado por UUID ao serviço products.';
COMMENT ON COLUMN tb_order_line.order_id IS 'Chave interna do pedido (FK local).';
COMMENT ON COLUMN tb_order_line.line_number IS 'Número da linha no pedido.';
COMMENT ON COLUMN tb_order_line.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_order_line.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_order_line.product_id IS 'Referência lógica ao produto (serviço products).';
COMMENT ON COLUMN tb_order_line.product_name IS 'Cache do nome do produto para exibição (opcional).';
COMMENT ON COLUMN tb_order_line.quantity IS 'Quantidade.';
COMMENT ON COLUMN tb_order_line.unit_price IS 'Preço unitário.';
COMMENT ON COLUMN tb_order_line.line_total IS 'Total da linha.';
COMMENT ON COLUMN tb_order_line.created_at IS 'Data/hora de criação do registro.';
COMMENT ON COLUMN tb_order_line.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_order_line.deleted_at IS 'Exclusão lógica (soft delete).';
COMMENT ON CONSTRAINT pk_tb_order_line ON tb_order_line IS 'Chave primária composta.';
COMMENT ON CONSTRAINT uk_tb_order_line_external_id ON tb_order_line IS 'UUID único.';
COMMENT ON CONSTRAINT fk_tb_order_line_order ON tb_order_line IS 'Referência ao pedido.';

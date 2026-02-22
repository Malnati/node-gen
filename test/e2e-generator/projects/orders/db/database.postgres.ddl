-- test/e2e-generator/projects/orders/db/database.postgres.ddl
CREATE TABLE "order" (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  shipping_address_id UUID,
  billing_address_id UUID,
  payment_id UUID,
  status TEXT,
  total DECIMAL(12,2) DEFAULT 0,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_order PRIMARY KEY (id),
  CONSTRAINT uk_order_external_id UNIQUE(external_id),
  CONSTRAINT chk_order_status CHECK (status IS NULL OR status IN ('draft','confirmed','paid','shipped','delivered','cancelled')),
  CONSTRAINT chk_order_currency_code CHECK (currency_code IS NULL OR currency_code IN ('BRL','EUR','USD','GBP','MXN','ARS'))
);

COMMENT ON TABLE "order" IS 'Pedidos por conta e tenant.';
COMMENT ON COLUMN "order".id IS 'Identificador interno.';
COMMENT ON COLUMN "order".external_id IS 'UUID público.';
COMMENT ON COLUMN "order".tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN "order".account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN "order".shipping_address_id IS 'Endereço de entrega (UUID externo).';
COMMENT ON COLUMN "order".billing_address_id IS 'Endereço de cobrança (UUID externo).';
COMMENT ON COLUMN "order".payment_id IS 'Pagamento (UUID externo).';
COMMENT ON COLUMN "order".status IS 'Status do pedido.';
COMMENT ON COLUMN "order".total IS 'Total.';
COMMENT ON COLUMN "order".currency_code IS 'Moeda (BRL, EUR, etc.).';
COMMENT ON COLUMN "order".created_at IS 'Data de criação.';
COMMENT ON COLUMN "order".updated_at IS 'Última atualização.';
COMMENT ON COLUMN "order".deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_order ON "order" IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_order_external_id ON "order" IS 'UUID único.';
COMMENT ON CONSTRAINT chk_order_status ON "order" IS 'Status permitidos.';
COMMENT ON CONSTRAINT chk_order_currency_code ON "order" IS 'Moedas permitidas.';

CREATE TABLE order_item (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  order_id UUID NOT NULL,
  product_id UUID NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 1,
  unit_price DECIMAL(12,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_order_item PRIMARY KEY (id),
  CONSTRAINT uk_order_item_external_id UNIQUE(external_id)
);

COMMENT ON TABLE order_item IS 'Itens do pedido.';
COMMENT ON COLUMN order_item.id IS 'Identificador interno.';
COMMENT ON COLUMN order_item.external_id IS 'UUID público.';
COMMENT ON COLUMN order_item.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN order_item.order_id IS 'Pedido (UUID externo).';
COMMENT ON COLUMN order_item.product_id IS 'Produto (UUID externo).';
COMMENT ON COLUMN order_item.quantity IS 'Quantidade.';
COMMENT ON COLUMN order_item.unit_price IS 'Preço unitário.';
COMMENT ON COLUMN order_item.created_at IS 'Data de criação.';
COMMENT ON COLUMN order_item.updated_at IS 'Última atualização.';
COMMENT ON COLUMN order_item.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_order_item ON order_item IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_order_item_external_id ON order_item IS 'UUID único.';

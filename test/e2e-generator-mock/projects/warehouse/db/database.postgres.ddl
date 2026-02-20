-- test/e2e-generator-mock/projects/warehouse/db/database.postgres.ddl
CREATE TABLE warehouse_stock (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  product_id UUID NOT NULL,
  address_id UUID NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 0,
  reserved DECIMAL(12,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_warehouse_stock PRIMARY KEY (id),
  CONSTRAINT uk_warehouse_stock_external_id UNIQUE(external_id)
);

COMMENT ON TABLE warehouse_stock IS 'Estoque por produto e endereço (tenant).';
COMMENT ON COLUMN warehouse_stock.id IS 'Identificador interno.';
COMMENT ON COLUMN warehouse_stock.external_id IS 'UUID público.';
COMMENT ON COLUMN warehouse_stock.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN warehouse_stock.product_id IS 'Produto (UUID externo).';
COMMENT ON COLUMN warehouse_stock.address_id IS 'Endereço do armazém (UUID externo).';
COMMENT ON COLUMN warehouse_stock.quantity IS 'Quantidade disponível.';
COMMENT ON COLUMN warehouse_stock.reserved IS 'Quantidade reservada.';
COMMENT ON COLUMN warehouse_stock.created_at IS 'Data de criação.';
COMMENT ON COLUMN warehouse_stock.updated_at IS 'Última atualização.';
COMMENT ON COLUMN warehouse_stock.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_warehouse_stock ON warehouse_stock IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_warehouse_stock_external_id ON warehouse_stock IS 'UUID único.';

-- test/e2e-generator-mock/projects/selling/db/database.postgres.ddl
CREATE TABLE tb_customer (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  tax_id TEXT,
  credit_limit DECIMAL(10,2),
  birth_date DATE,
  metadata JSONB,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_customer IS 'Dados cadastrais de clientes.';
COMMENT ON COLUMN tb_customer.tenant IS 'Referência lógica para a empresa proprietária do dado.';

CREATE TABLE tb_payment_method (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_payment_method IS 'Métodos de pagamento disponíveis para transações.';

CREATE TABLE tb_order (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  customer_id INTEGER NOT NULL,
  payment_method_id INTEGER NOT NULL,
  status TEXT NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0,
  ordered_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES tb_customer(id),
  FOREIGN KEY (payment_method_id) REFERENCES tb_payment_method(id)
);
COMMENT ON TABLE tb_order IS 'Pedidos de venda consolidados.';

CREATE TABLE tb_order_line (
  order_id INTEGER NOT NULL,
  line_number INTEGER NOT NULL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  product_sku TEXT NOT NULL,
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);
COMMENT ON TABLE tb_order_line IS 'Itens detalhados pertencentes a um pedido.';

CREATE TABLE tb_payment (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  order_id INTEGER NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  paid_at TIMESTAMP,
  reference TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);
COMMENT ON TABLE tb_payment IS 'Pagamentos efetuados vinculados a um pedido.';

CREATE TABLE tb_stock_movement (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  product_sku TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  movement_type TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_stock_movement IS 'Log de movimentos de inventário.';

CREATE TABLE tb_customer_address (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  customer_id INTEGER NOT NULL,
  street TEXT,
  city TEXT,
  state TEXT,
  zip_code TEXT,
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES tb_customer(id)
);
COMMENT ON TABLE tb_customer_address IS 'Endereços associados ao cliente para entrega ou cobrança.';

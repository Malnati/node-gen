-- test/e2e-generator-mock/projects/selling/db/database.sqlite.ddl
-- Pedidos de venda; comprador e endereços/pagamento referenciados por UUID aos serviços accounts, addresses e payments.
CREATE TABLE tb_order (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna do pedido.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs e referência entre serviços.
  account_id TEXT NOT NULL, -- Referência lógica ao comprador (serviço accounts).
  billing_address_id TEXT, -- Referência lógica ao endereço de faturação (serviço addresses).
  shipping_address_id TEXT, -- Referência lógica ao endereço de envio (serviço addresses).
  payment_id TEXT, -- Referência lógica ao pagamento (serviço payments).
  status TEXT NOT NULL, -- Estado do pedido.
  total REAL NOT NULL, -- Valor total do pedido.
  discount REAL DEFAULT 0, -- Desconto aplicado.
  ordered_at TEXT, -- Data/hora do pedido.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação do registro.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT -- Exclusão lógica (soft delete).
);

-- Itens do pedido; produto referenciado por UUID ao serviço products.
CREATE TABLE tb_order_line (
  order_id INTEGER NOT NULL, -- Chave interna do pedido (FK local).
  line_number INTEGER NOT NULL, -- Número da linha no pedido.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  product_id TEXT NOT NULL, -- Referência lógica ao produto (serviço products).
  product_name TEXT, -- Cache do nome do produto para exibição (opcional).
  quantity INTEGER NOT NULL, -- Quantidade.
  unit_price REAL NOT NULL, -- Preço unitário.
  line_total REAL NOT NULL, -- Total da linha.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação do registro.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT, -- Exclusão lógica (soft delete).
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

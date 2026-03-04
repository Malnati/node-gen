-- test/e2e-generator/projects/orders/db/database.sqlite.ddl
-- Pedidos por conta e tenant.
CREATE TABLE "order" (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  shipping_address_id TEXT, -- Endereço de entrega (UUID externo).
  billing_address_id TEXT, -- Endereço de cobrança (UUID externo).
  payment_id TEXT, -- Pagamento (UUID externo).
  status TEXT CHECK (status IS NULL OR status IN ('draft','confirmed','paid','shipped','delivered','cancelled')), -- Status do pedido.
  total REAL DEFAULT 0, -- Total.
  currency_code TEXT DEFAULT 'BRL' CHECK (currency_code IS NULL OR currency_code IN ('BRL','EUR','USD','GBP','MXN','ARS')), -- Moeda (BRL, EUR, etc.).
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Itens do pedido.
CREATE TABLE order_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  order_id TEXT NOT NULL, -- Pedido (UUID externo).
  product_id TEXT NOT NULL, -- Produto (UUID externo).
  quantity REAL DEFAULT 1, -- Quantidade.
  unit_price REAL DEFAULT 0, -- Preço unitário.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

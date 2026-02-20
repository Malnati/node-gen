-- test/e2e-generator-mock/projects/orders/db/database.sqlite.ddl
CREATE TABLE "order" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  shipping_address_id TEXT,
  billing_address_id TEXT,
  payment_id TEXT,
  status TEXT CHECK (status IS NULL OR status IN ('draft','confirmed','paid','shipped','delivered','cancelled')),
  total REAL DEFAULT 0,
  currency_code TEXT DEFAULT 'BRL' CHECK (currency_code IS NULL OR currency_code IN ('BRL','EUR','USD','GBP','MXN','ARS')),
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE order_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  order_id TEXT NOT NULL,
  product_id TEXT NOT NULL,
  quantity REAL DEFAULT 1,
  unit_price REAL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

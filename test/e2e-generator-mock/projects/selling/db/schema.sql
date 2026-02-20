-- test/e2e-generator-mock/projects/selling/db/schema.sql
CREATE TABLE sale (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  order_id TEXT NOT NULL,
  payment_id TEXT,
  billing_address_id TEXT,
  shipping_address_id TEXT,
  status TEXT,
  total REAL DEFAULT 0,
  currency_code TEXT DEFAULT 'BRL',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE sale_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  sale_id INTEGER NOT NULL,
  product_id TEXT NOT NULL,
  quantity REAL DEFAULT 1,
  unit_price REAL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id),
  FOREIGN KEY (sale_id) REFERENCES sale(id)
);

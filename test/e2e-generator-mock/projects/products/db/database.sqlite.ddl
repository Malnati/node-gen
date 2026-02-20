-- test/e2e-generator-mock/projects/products/db/database.sqlite.ddl
CREATE TABLE product (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  sku TEXT,
  name TEXT NOT NULL,
  description TEXT,
  unit_price REAL DEFAULT 0,
  currency_code TEXT DEFAULT 'BRL',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

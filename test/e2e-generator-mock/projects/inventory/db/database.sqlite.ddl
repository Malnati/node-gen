-- test/e2e-generator-mock/projects/inventory/db/database.sqlite.ddl
CREATE TABLE inventory_level (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  product_id TEXT NOT NULL,
  address_id TEXT NOT NULL,
  quantity REAL DEFAULT 0,
  reserved REAL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

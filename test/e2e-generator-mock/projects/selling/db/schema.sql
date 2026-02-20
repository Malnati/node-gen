-- test/e2e-generator-mock/projects/selling/db/schema.sql
CREATE TABLE tb_order (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  account_id TEXT NOT NULL,
  billing_address_id TEXT,
  shipping_address_id TEXT,
  payment_id TEXT,
  status TEXT NOT NULL,
  total REAL NOT NULL,
  discount REAL DEFAULT 0,
  ordered_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE TABLE tb_order_line (
  order_id INTEGER NOT NULL,
  line_number INTEGER NOT NULL,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  product_id TEXT NOT NULL,
  product_name TEXT,
  quantity INTEGER NOT NULL,
  unit_price REAL NOT NULL,
  line_total REAL NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

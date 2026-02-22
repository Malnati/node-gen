-- test/e2e-generator/projects/payments/db/database.sqlite.ddl
CREATE TABLE payment_type (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT,
  code TEXT NOT NULL,
  name TEXT,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id),
  UNIQUE(code)
);

CREATE TABLE payment (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  contact_id TEXT,
  billing_address_id TEXT,
  payment_type_id INTEGER NOT NULL,
  currency_id TEXT NOT NULL,
  amount REAL DEFAULT 0,
  status TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id),
  FOREIGN KEY (payment_type_id) REFERENCES payment_type(id)
);

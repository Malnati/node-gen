-- test/e2e-generator-mock/projects/transactions/db/database.sqlite.ddl
CREATE TABLE transaction (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  payment_id TEXT NOT NULL,
  amount REAL NOT NULL,
  currency_code TEXT DEFAULT 'BRL',
  status TEXT NOT NULL,
  external_reference TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

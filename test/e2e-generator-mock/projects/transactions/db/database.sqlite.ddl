-- test/e2e-generator-mock/projects/transactions/db/database.sqlite.ddl
CREATE TABLE transaction (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  payment_method_id TEXT NOT NULL,
  amount REAL NOT NULL,
  currency_code TEXT DEFAULT 'BRL',
  status TEXT NOT NULL,
  external_reference TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

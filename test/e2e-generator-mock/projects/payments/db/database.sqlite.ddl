-- test/e2e-generator-mock/projects/payments/db/database.sqlite.ddl
CREATE TABLE payment_method (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  code TEXT NOT NULL,
  name TEXT NOT NULL,
  method_type TEXT NOT NULL,
  region TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

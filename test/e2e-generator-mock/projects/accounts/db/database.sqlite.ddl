-- test/e2e-generator-mock/projects/accounts/db/database.sqlite.ddl
CREATE TABLE account (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  name TEXT NOT NULL,
  account_type TEXT NOT NULL,
  balance REAL DEFAULT 0,
  currency_code TEXT DEFAULT 'BRL',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

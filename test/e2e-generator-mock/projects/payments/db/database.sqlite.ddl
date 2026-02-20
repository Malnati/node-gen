-- test/e2e-generator-mock/projects/payments/db/database.sqlite.ddl
CREATE TABLE payment (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  amount REAL NOT NULL,
  currency_code TEXT DEFAULT 'BRL',
  status TEXT NOT NULL,
  method TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

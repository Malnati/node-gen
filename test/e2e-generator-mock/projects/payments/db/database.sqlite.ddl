-- test/e2e-generator-mock/projects/payments/db/database.sqlite.ddl
CREATE TABLE payment (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  contact_id TEXT,
  billing_address_id TEXT,
  method TEXT NOT NULL CHECK (method IN ('DEBITO','CREDITO','PIX','BOLETO','CRIPTO','SWIFT','SEPA','ACH')),
  amount REAL DEFAULT 0,
  currency_code TEXT DEFAULT 'BRL',
  status TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

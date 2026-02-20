-- test/e2e-generator-mock/projects/accounts/db/database.sqlite.ddl
CREATE TABLE account (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  name TEXT NOT NULL,
  account_type TEXT NOT NULL CHECK (account_type IN ('checking','savings','credit','wallet','other')),
  currency_code TEXT DEFAULT 'BRL' CHECK (currency_code IN ('BRL','EUR','USD','GBP','MXN','ARS')),
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

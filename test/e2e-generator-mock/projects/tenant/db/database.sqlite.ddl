-- test/e2e-generator-mock/projects/tenant/db/database.sqlite.ddl
CREATE TABLE tenant (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  contact_id TEXT,
  address_id TEXT,
  name TEXT NOT NULL,
  legal_name TEXT,
  tax_id TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

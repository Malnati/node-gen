-- test/e2e-generator-mock/projects/addresses/db/database.sqlite.ddl
CREATE TABLE address (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  street TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT,
  zip_code TEXT,
  country TEXT DEFAULT 'BR',
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

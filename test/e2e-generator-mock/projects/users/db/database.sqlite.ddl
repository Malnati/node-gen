-- test/e2e-generator-mock/projects/users/db/database.sqlite.ddl
CREATE TABLE app_user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  contact_id TEXT,
  address_id TEXT,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  password_hash TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

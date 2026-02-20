-- test/e2e-generator-mock/projects/notifications/db/database.sqlite.ddl
CREATE TABLE notification (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  user_id TEXT,
  contact_id TEXT,
  channel TEXT,
  subject TEXT,
  body TEXT,
  read_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

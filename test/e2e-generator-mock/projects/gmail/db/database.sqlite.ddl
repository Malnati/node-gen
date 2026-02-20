-- test/e2e-generator-mock/projects/gmail/db/database.sqlite.ddl
CREATE TABLE gmail_integration (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  connected_email TEXT NOT NULL,
  oauth_ref TEXT,
  last_sync_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE gmail_message_template (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT,
  code TEXT NOT NULL,
  name TEXT,
  subject_tpl TEXT,
  body_tpl TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE gmail_message (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  integration_id TEXT NOT NULL,
  gmail_message_id TEXT,
  gmail_thread_id TEXT,
  direction TEXT NOT NULL CHECK (direction IN ('sent','received')),
  subject TEXT,
  from_addr TEXT,
  to_addr TEXT,
  body_preview TEXT,
  sent_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

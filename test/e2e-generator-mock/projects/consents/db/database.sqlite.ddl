-- test/e2e-generator-mock/projects/consents/db/database.sqlite.ddl
CREATE TABLE consent_record (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  user_id TEXT,
  consent_type TEXT NOT NULL,
  granted_at TEXT,
  ip_address TEXT,
  version TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE notification_preference (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  user_id TEXT,
  channel TEXT NOT NULL CHECK (channel IN ('email','sms','push')),
  opt_in INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

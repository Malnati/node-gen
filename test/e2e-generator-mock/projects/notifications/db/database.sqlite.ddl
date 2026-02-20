-- test/e2e-generator-mock/projects/notifications/db/database.sqlite.ddl
CREATE TABLE notification_template (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  code TEXT NOT NULL,
  name TEXT,
  channel TEXT CHECK (channel IS NULL OR channel IN ('email','sms','push')),
  subject_tpl TEXT,
  body_tpl TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE notification (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  user_id TEXT,
  contact_id TEXT,
  template_id TEXT,
  channel TEXT CHECK (channel IS NULL OR channel IN ('email','sms','push')),
  priority TEXT CHECK (priority IS NULL OR priority IN ('low','normal','high','urgent')),
  subject TEXT,
  body TEXT,
  read_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

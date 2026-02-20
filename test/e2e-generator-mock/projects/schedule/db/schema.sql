-- test/e2e-generator-mock/projects/schedule/db/schema.sql
CREATE TABLE tb_resource (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  capacity INTEGER DEFAULT 1,
  parent_id INTEGER,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_slot (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  resource_id INTEGER NOT NULL,
  start_at TEXT NOT NULL,
  end_at TEXT NOT NULL,
  status TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_recurrence_rule (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  cron_expression TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE TABLE tb_booking (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  slot_id INTEGER NOT NULL,
  recurrence_rule_id INTEGER,
  title TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);

CREATE TABLE tb_participant (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE TABLE tb_booking_participant (
  booking_id INTEGER NOT NULL,
  participant_id INTEGER NOT NULL,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  PRIMARY KEY (booking_id, participant_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id),
  FOREIGN KEY (participant_id) REFERENCES tb_participant(id)
);

CREATE TABLE tb_booking_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  booking_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  changed_at TEXT NOT NULL,
  snapshot TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

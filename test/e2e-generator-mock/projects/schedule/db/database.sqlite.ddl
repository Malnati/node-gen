-- test/e2e-generator-mock/projects/schedule/db/database.sqlite.ddl
-- DDL SQLite para fixture (mesmo modelo de agendamento).

CREATE TABLE tb_resource (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  name TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  capacity INTEGER DEFAULT 1,
  parent_id INTEGER,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_slot (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  resource_id INTEGER NOT NULL,
  start_at TEXT NOT NULL,
  end_at TEXT NOT NULL,
  status TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_recurrence_rule (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  cron_expression TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE tb_booking (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  slot_id INTEGER NOT NULL,
  recurrence_rule_id INTEGER,
  title TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);

CREATE TABLE tb_participant (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE tb_booking_participant (
  booking_id INTEGER NOT NULL,
  participant_id INTEGER NOT NULL,
  role TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  PRIMARY KEY (booking_id, participant_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id),
  FOREIGN KEY (participant_id) REFERENCES tb_participant(id)
);

CREATE TABLE tb_booking_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  changed_at TEXT NOT NULL,
  snapshot TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

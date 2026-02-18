-- test/e2e-generator-mock/projects/schedule/db/database.postgres.ddl
CREATE TABLE tb_resource (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  name TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  capacity INTEGER DEFAULT 1,
  parent_id INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_slot (
  id SERIAL PRIMARY KEY,
  resource_id INTEGER NOT NULL,
  start_at TIMESTAMP NOT NULL,
  end_at TIMESTAMP NOT NULL,
  status TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_recurrence_rule (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  cron_expression TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_booking (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  slot_id INTEGER NOT NULL,
  recurrence_rule_id INTEGER,
  title TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);

CREATE TABLE tb_participant (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_booking_participant (
  booking_id INTEGER NOT NULL,
  participant_id INTEGER NOT NULL,
  role TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (booking_id, participant_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id),
  FOREIGN KEY (participant_id) REFERENCES tb_participant(id)
);

CREATE TABLE tb_booking_history (
  id SERIAL PRIMARY KEY,
  booking_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  changed_at TIMESTAMP NOT NULL,
  snapshot JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

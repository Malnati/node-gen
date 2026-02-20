-- test/e2e-generator-mock/projects/logistics/db/database.sqlite.ddl
CREATE TABLE shipment (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  order_id TEXT NOT NULL,
  origin_address_id TEXT,
  destination_address_id TEXT,
  driver_contact_id TEXT,
  receiver_contact_id TEXT,
  status TEXT,
  tracking_code TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

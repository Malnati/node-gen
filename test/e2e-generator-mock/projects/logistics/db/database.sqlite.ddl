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
  carrier TEXT,
  status TEXT CHECK (status IS NULL OR status IN ('pending','picked_up','in_transit','out_for_delivery','delivered','exception')),
  tracking_code TEXT,
  estimated_delivery_at TEXT,
  delivered_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE shipment_event (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  shipment_id TEXT NOT NULL,
  event_type TEXT,
  event_at TEXT,
  location_text TEXT,
  raw_payload TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

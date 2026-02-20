-- test/e2e-generator-mock/projects/logistics/db/database.mysql.ddl
CREATE TABLE shipment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  order_id CHAR(36) NOT NULL,
  origin_address_id CHAR(36),
  destination_address_id CHAR(36),
  driver_contact_id CHAR(36),
  receiver_contact_id CHAR(36),
  carrier VARCHAR(255),
  status VARCHAR(50),
  tracking_code VARCHAR(100),
  estimated_delivery_at DATETIME,
  delivered_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_shipment_external_id (external_id),
  CONSTRAINT chk_shipment_status CHECK (status IS NULL OR status IN ('pending','picked_up','in_transit','out_for_delivery','delivered','exception'))
);

CREATE TABLE shipment_event (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  shipment_id CHAR(36) NOT NULL,
  event_type VARCHAR(100),
  event_at DATETIME,
  location_text VARCHAR(500),
  raw_payload TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_shipment_event_external_id (external_id)
);

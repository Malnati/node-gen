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
  status VARCHAR(50),
  tracking_code VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_shipment_external_id (external_id)
);

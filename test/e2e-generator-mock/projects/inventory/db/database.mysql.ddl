-- test/e2e-generator-mock/projects/inventory/db/database.mysql.ddl
CREATE TABLE inventory_level (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  product_id CHAR(36) NOT NULL,
  address_id CHAR(36) NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 0,
  reserved DECIMAL(12,2) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_inventory_level_external_id (external_id)
);

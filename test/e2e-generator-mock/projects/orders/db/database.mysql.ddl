-- test/e2e-generator-mock/projects/orders/db/database.mysql.ddl
CREATE TABLE `order` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  shipping_address_id CHAR(36),
  billing_address_id CHAR(36),
  payment_id CHAR(36),
  status VARCHAR(50),
  total DECIMAL(12,2) DEFAULT 0,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_order_external_id (external_id)
);

CREATE TABLE order_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  order_id CHAR(36) NOT NULL,
  product_id CHAR(36) NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 1,
  unit_price DECIMAL(12,2) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_order_item_external_id (external_id)
);

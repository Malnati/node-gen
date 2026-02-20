-- test/e2e-generator-mock/projects/selling/db/schema.mysql.sql
CREATE TABLE sale (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  order_id CHAR(36) NOT NULL,
  payment_id CHAR(36),
  billing_address_id CHAR(36),
  shipping_address_id CHAR(36),
  status VARCHAR(50),
  total DECIMAL(12,2) DEFAULT 0,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_sale_external_id (external_id)
);

CREATE TABLE sale_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  sale_id INT NOT NULL,
  product_id CHAR(36) NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 1,
  unit_price DECIMAL(12,2) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_sale_item_external_id (external_id),
  CONSTRAINT fk_sale_item_sale FOREIGN KEY (sale_id) REFERENCES sale(id)
);

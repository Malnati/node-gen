-- test/e2e-generator-mock/projects/products/db/database.mysql.ddl
CREATE TABLE product (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  sku VARCHAR(100),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  unit_price DECIMAL(12,2) DEFAULT 0,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_product_external_id (external_id)
);

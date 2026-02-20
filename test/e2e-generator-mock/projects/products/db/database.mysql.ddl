-- test/e2e-generator-mock/projects/products/db/database.mysql.ddl
CREATE TABLE currency (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36),
  code VARCHAR(3) NOT NULL,
  name VARCHAR(100) NOT NULL,
  symbol VARCHAR(10),
  region VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_currency_external_id (external_id),
  UNIQUE KEY uk_currency_code (code),
  CONSTRAINT chk_currency_region CHECK (region IS NULL OR region IN ('SOUTH_AMERICA','NORTH_AMERICA','EUROPE'))
);

CREATE TABLE unit_of_measure (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36),
  code VARCHAR(20) NOT NULL,
  name VARCHAR(100),
  symbol VARCHAR(10),
  category VARCHAR(30),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_uom_external_id (external_id),
  UNIQUE KEY uk_uom_code (code),
  CONSTRAINT chk_uom_category CHECK (category IS NULL OR category IN ('COUNT','WEIGHT','VOLUME','LENGTH','AREA','TIME'))
);

CREATE TABLE product (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  sku VARCHAR(100),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  unit_of_measure_id INT NOT NULL,
  currency_id INT NOT NULL,
  unit_price DECIMAL(12,2) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_product_external_id (external_id),
  CONSTRAINT fk_product_currency FOREIGN KEY (currency_id) REFERENCES currency(id),
  CONSTRAINT fk_product_uom FOREIGN KEY (unit_of_measure_id) REFERENCES unit_of_measure(id)
);

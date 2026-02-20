-- test/e2e-generator-mock/projects/payments/db/database.mysql.ddl
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

CREATE TABLE payment_type (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36),
  code VARCHAR(20) NOT NULL,
  name VARCHAR(100),
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_payment_type_external_id (external_id),
  UNIQUE KEY uk_payment_type_code (code)
);

CREATE TABLE payment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  contact_id CHAR(36),
  billing_address_id CHAR(36),
  payment_type_id INT NOT NULL,
  currency_id INT NOT NULL,
  amount DECIMAL(12,2) DEFAULT 0,
  status VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_payment_external_id (external_id),
  CONSTRAINT fk_payment_type FOREIGN KEY (payment_type_id) REFERENCES payment_type(id),
  CONSTRAINT fk_payment_currency FOREIGN KEY (currency_id) REFERENCES currency(id)
);

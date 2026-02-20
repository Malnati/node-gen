-- test/e2e-generator-mock/projects/addresses/db/database.mysql.ddl
CREATE TABLE address (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  street VARCHAR(500) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(50),
  zip_code VARCHAR(20),
  country VARCHAR(2) DEFAULT 'BR',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_address_external_id (external_id),
  CONSTRAINT chk_address_country CHECK (country IN ('BR','PT','US','ES','AR','MX','GB','FR','DE'))
);

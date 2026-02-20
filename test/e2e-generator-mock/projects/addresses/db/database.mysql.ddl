-- test/e2e-generator-mock/projects/addresses/db/database.mysql.ddl
CREATE TABLE address (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  street VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL,
  state VARCHAR(100),
  zip_code VARCHAR(20),
  country VARCHAR(2) DEFAULT 'BR',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

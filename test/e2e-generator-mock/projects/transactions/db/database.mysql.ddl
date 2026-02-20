-- test/e2e-generator-mock/projects/transactions/db/database.mysql.ddl
CREATE TABLE `transaction` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  payment_method_id CHAR(36) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  status VARCHAR(50) NOT NULL,
  external_reference VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

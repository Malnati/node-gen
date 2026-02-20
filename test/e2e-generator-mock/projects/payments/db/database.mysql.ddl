-- test/e2e-generator-mock/projects/payments/db/database.mysql.ddl
CREATE TABLE payment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  amount DECIMAL(12,2) NOT NULL,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  status VARCHAR(50) NOT NULL,
  method VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

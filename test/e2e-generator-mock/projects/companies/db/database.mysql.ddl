-- test/e2e-generator-mock/projects/companies/db/database.mysql.ddl
CREATE TABLE company (
  id INT AUTO_INCREMENT PRIMARY KEY,
  account_id CHAR(36) NOT NULL,
  name VARCHAR(255) NOT NULL,
  legal_name VARCHAR(255),
  tax_id VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

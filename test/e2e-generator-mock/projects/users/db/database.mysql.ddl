-- test/e2e-generator-mock/projects/users/db/database.mysql.ddl
CREATE TABLE app_user (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  address_id CHAR(36),
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

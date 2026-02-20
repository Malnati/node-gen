-- test/e2e-generator-mock/projects/schedule/db/database.mysql.ddl
CREATE TABLE tb_resource (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  resource_type VARCHAR(100) NOT NULL,
  capacity INT DEFAULT 1,
  parent_id INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_slot (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  resource_id INT NOT NULL,
  start_at DATETIME NOT NULL,
  end_at DATETIME NOT NULL,
  status VARCHAR(50) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_recurrence_rule (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  cron_expression TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME
);

CREATE TABLE tb_booking (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  slot_id INT NOT NULL,
  recurrence_rule_id INT,
  organizer_account_id CHAR(36),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);

CREATE TABLE tb_booking_participant (
  booking_id INT NOT NULL,
  account_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  role VARCHAR(100) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  PRIMARY KEY (booking_id, account_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

CREATE TABLE tb_booking_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  booking_id INT NOT NULL,
  action VARCHAR(100) NOT NULL,
  changed_at DATETIME NOT NULL,
  snapshot JSON,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

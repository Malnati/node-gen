-- MySQL init: database schedule_mock para E2E (projeto schedule)
CREATE DATABASE IF NOT EXISTS schedule_mock;
GRANT ALL PRIVILEGES ON schedule_mock.* TO 'e2e'@'%';
FLUSH PRIVILEGES;
USE schedule_mock;

CREATE TABLE tb_resource (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id VARCHAR(36),
  name VARCHAR(255) NOT NULL,
  resource_type VARCHAR(50) NOT NULL,
  capacity INT DEFAULT 1,
  parent_id INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_slot (
  id INT AUTO_INCREMENT PRIMARY KEY,
  resource_id INT NOT NULL,
  start_at DATETIME NOT NULL,
  end_at DATETIME NOT NULL,
  status VARCHAR(50) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_recurrence_rule (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  cron_expression VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_booking (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id VARCHAR(36),
  slot_id INT NOT NULL,
  recurrence_rule_id INT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);

CREATE TABLE tb_participant (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_booking_participant (
  booking_id INT NOT NULL,
  participant_id INT NOT NULL,
  role VARCHAR(50) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (booking_id, participant_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id),
  FOREIGN KEY (participant_id) REFERENCES tb_participant(id)
);

CREATE TABLE tb_booking_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT NOT NULL,
  action VARCHAR(50) NOT NULL,
  changed_at DATETIME NOT NULL,
  snapshot JSON,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

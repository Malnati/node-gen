-- test/e2e-generator/projects/addresses/db/database.mysql.ddl
CREATE TABLE country (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(2) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_country_code (code)
);

CREATE TABLE state (
  id INT AUTO_INCREMENT PRIMARY KEY,
  country_id INT NOT NULL,
  code VARCHAR(20) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_state_country_code (country_id, code),
  CONSTRAINT fk_state_country FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE city (
  id INT AUTO_INCREMENT PRIMARY KEY,
  state_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES state(id)
);

CREATE TABLE address (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  street VARCHAR(500) NOT NULL,
  zip_code VARCHAR(20),
  country_id INT NOT NULL,
  state_id INT NOT NULL,
  city_id INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_address_external_id (external_id),
  CONSTRAINT fk_address_country FOREIGN KEY (country_id) REFERENCES country(id),
  CONSTRAINT fk_address_state FOREIGN KEY (state_id) REFERENCES state(id),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city(id)
);

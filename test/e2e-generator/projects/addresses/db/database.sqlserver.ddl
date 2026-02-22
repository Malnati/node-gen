-- test/e2e-generator/projects/addresses/db/database.sqlserver.ddl
CREATE TABLE country (
  id INT IDENTITY(1,1) PRIMARY KEY,
  code NVARCHAR(2) NOT NULL,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_country_code UNIQUE (code)
);

CREATE TABLE [state] (
  id INT IDENTITY(1,1) PRIMARY KEY,
  country_id INT NOT NULL,
  code NVARCHAR(20) NOT NULL,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_state_country_code UNIQUE (country_id, code),
  CONSTRAINT fk_state_country FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE city (
  id INT IDENTITY(1,1) PRIMARY KEY,
  state_id INT NOT NULL,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES [state](id)
);

CREATE TABLE address (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  street NVARCHAR(500) NOT NULL,
  zip_code NVARCHAR(20),
  country_id INT NOT NULL,
  state_id INT NOT NULL,
  city_id INT NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_address_external_id UNIQUE (external_id),
  CONSTRAINT fk_address_country FOREIGN KEY (country_id) REFERENCES country(id),
  CONSTRAINT fk_address_state FOREIGN KEY (state_id) REFERENCES [state](id),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city(id)
);

-- test/e2e-generator-mock/projects/schedule/db/database.sqlserver.ddl
CREATE TABLE tb_resource (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  name NVARCHAR(255) NOT NULL,
  resource_type NVARCHAR(100) NOT NULL,
  capacity INT DEFAULT 1,
  parent_id INT,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_slot (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  resource_id INT NOT NULL,
  start_at DATETIME2 NOT NULL,
  end_at DATETIME2 NOT NULL,
  status NVARCHAR(50) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_recurrence_rule (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  code NVARCHAR(50) NOT NULL UNIQUE,
  name NVARCHAR(255) NOT NULL,
  cron_expression NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
);

CREATE TABLE tb_booking (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  slot_id INT NOT NULL,
  recurrence_rule_id INT,
  organizer_account_id UNIQUEIDENTIFIER,
  title NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);

CREATE TABLE tb_booking_participant (
  booking_id INT NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  role NVARCHAR(100) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  PRIMARY KEY (booking_id, account_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

CREATE TABLE tb_booking_history (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  booking_id INT NOT NULL,
  action NVARCHAR(100) NOT NULL,
  changed_at DATETIME2 NOT NULL,
  snapshot NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

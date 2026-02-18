-- test/e2e-generator-mock/projects/schedule/db/database.sqlserver.ddl
CREATE TABLE tb_resource (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id NVARCHAR(36),
  name NVARCHAR(255) NOT NULL,
  resource_type NVARCHAR(50) NOT NULL,
  capacity INT DEFAULT 1,
  parent_id INT,
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  updated_at DATETIME2,
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_slot (
  id INT IDENTITY(1,1) PRIMARY KEY,
  resource_id INT NOT NULL,
  start_at DATETIME2 NOT NULL,
  end_at DATETIME2 NOT NULL,
  status NVARCHAR(50) NOT NULL,
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);

CREATE TABLE tb_recurrence_rule (
  id INT IDENTITY(1,1) PRIMARY KEY,
  code NVARCHAR(50) NOT NULL UNIQUE,
  name NVARCHAR(255) NOT NULL,
  cron_expression NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETUTCDATE()
);

CREATE TABLE tb_booking (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id NVARCHAR(36),
  slot_id INT NOT NULL,
  recurrence_rule_id INT,
  title NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  updated_at DATETIME2,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);

CREATE TABLE tb_participant (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(255) NOT NULL,
  email NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETUTCDATE()
);

CREATE TABLE tb_booking_participant (
  booking_id INT NOT NULL,
  participant_id INT NOT NULL,
  role NVARCHAR(50) NOT NULL,
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  CONSTRAINT PK_booking_participant PRIMARY KEY (booking_id, participant_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id),
  FOREIGN KEY (participant_id) REFERENCES tb_participant(id)
);

CREATE TABLE tb_booking_history (
  id INT IDENTITY(1,1) PRIMARY KEY,
  booking_id INT NOT NULL,
  action NVARCHAR(50) NOT NULL,
  changed_at DATETIME2 NOT NULL,
  snapshot NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

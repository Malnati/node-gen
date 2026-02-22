-- test/e2e-generator/projects/selling/db/init.mysql.sql
CREATE DATABASE IF NOT EXISTS selling;
CREATE DATABASE IF NOT EXISTS google_calendar;
GRANT ALL PRIVILEGES ON selling.* TO 'e2e'@'%';
GRANT ALL PRIVILEGES ON google_calendar.* TO 'e2e'@'%';
FLUSH PRIVILEGES;
USE selling;

CREATE TABLE tb_order (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  account_id CHAR(36) NOT NULL,
  billing_address_id CHAR(36),
  shipping_address_id CHAR(36),
  payment_id CHAR(36),
  status VARCHAR(50) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0,
  ordered_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME
);

CREATE TABLE tb_order_line (
  order_id INT NOT NULL,
  line_number INT NOT NULL,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  product_id CHAR(36) NOT NULL,
  product_name VARCHAR(255),
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

USE google_calendar;
CREATE TABLE calendar_integration (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  connected_email VARCHAR(255) NOT NULL COMMENT 'E-mail conectado.',
  oauth_ref VARCHAR(500) COMMENT 'Referência OAuth.',
  last_sync_at DATETIME COMMENT 'Última sincronização.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_calendar_integration_external_id (external_id)
) COMMENT = 'Integração Google Calendar por conta e tenant.';
CREATE TABLE calendar (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  integration_id CHAR(36) NOT NULL COMMENT 'Integração (UUID externo).',
  name VARCHAR(255) NOT NULL COMMENT 'Nome do calendário.',
  timezone VARCHAR(100) DEFAULT 'UTC' COMMENT 'Fuso horário.',
  google_calendar_id VARCHAR(255) COMMENT 'ID do calendário no Google.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_calendar_external_id (external_id)
) COMMENT = 'Calendários por integração e tenant.';
CREATE TABLE calendar_event (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) NOT NULL COMMENT 'Conta (UUID externo).',
  integration_id CHAR(36) NOT NULL COMMENT 'Integração (UUID externo).',
  calendar_id CHAR(36) NOT NULL COMMENT 'Calendário (UUID externo).',
  title VARCHAR(255) NOT NULL COMMENT 'Título do evento.',
  description TEXT COMMENT 'Descrição.',
  start_at DATETIME NOT NULL COMMENT 'Início.',
  end_at DATETIME NOT NULL COMMENT 'Fim.',
  all_day TINYINT(1) DEFAULT 0 COMMENT 'Evento dia inteiro.',
  google_event_id VARCHAR(255) COMMENT 'ID do evento no Google.',
  status VARCHAR(50) COMMENT 'Status.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_calendar_event_external_id (external_id)
) COMMENT = 'Eventos do calendário por tenant e conta.';

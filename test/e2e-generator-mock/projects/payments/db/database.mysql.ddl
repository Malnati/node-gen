-- test/e2e-generator-mock/projects/payments/db/database.mysql.ddl
CREATE TABLE payment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  contact_id CHAR(36),
  billing_address_id CHAR(36),
  method VARCHAR(20) NOT NULL,
  amount DECIMAL(12,2) DEFAULT 0,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  status VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_payment_external_id (external_id),
  CONSTRAINT chk_payment_method CHECK (method IN ('DEBITO','CREDITO','PIX','BOLETO','CRIPTO','SWIFT','SEPA','ACH'))
);

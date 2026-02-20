-- test/e2e-generator-mock/projects/payments/db/database.postgres.ddl
CREATE TABLE payment (
  id SERIAL PRIMARY KEY,
  amount DECIMAL(12,2) NOT NULL,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  status TEXT NOT NULL,
  method TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

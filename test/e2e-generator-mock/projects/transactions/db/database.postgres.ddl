-- test/e2e-generator-mock/projects/transactions/db/database.postgres.ddl
CREATE TABLE transaction (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  payment_method_id UUID NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  status TEXT NOT NULL,
  external_reference TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

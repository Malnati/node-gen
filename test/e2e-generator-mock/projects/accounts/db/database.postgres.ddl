-- test/e2e-generator-mock/projects/accounts/db/database.postgres.ddl
CREATE TABLE account (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  name TEXT NOT NULL,
  account_type TEXT NOT NULL,
  balance DECIMAL(12,2) DEFAULT 0,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

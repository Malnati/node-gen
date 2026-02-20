-- test/e2e-generator-mock/projects/payments/db/database.postgres.ddl
CREATE TABLE payment_method (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  contact_id UUID,
  code TEXT NOT NULL,
  name TEXT NOT NULL,
  method_type TEXT NOT NULL,
  region TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

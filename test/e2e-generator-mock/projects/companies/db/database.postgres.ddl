-- test/e2e-generator-mock/projects/companies/db/database.postgres.ddl
CREATE TABLE company (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  contact_id UUID,
  name TEXT NOT NULL,
  legal_name TEXT,
  tax_id TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

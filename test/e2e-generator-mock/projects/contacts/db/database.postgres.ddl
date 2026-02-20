-- test/e2e-generator-mock/projects/contacts/db/database.postgres.ddl
CREATE TABLE contact (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  address_id UUID,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  company TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

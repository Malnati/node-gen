-- test/e2e-generator-mock/projects/addresses/db/database.postgres.ddl
CREATE TABLE address (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  street TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT,
  zip_code TEXT,
  country TEXT DEFAULT 'BR',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

-- test/e2e-generator-mock/projects/addresses/db/database.postgres.ddl
CREATE TABLE address (
  id SERIAL PRIMARY KEY,
  street TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT,
  zip_code TEXT,
  country TEXT DEFAULT 'BR',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

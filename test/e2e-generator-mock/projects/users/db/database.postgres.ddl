-- test/e2e-generator-mock/projects/users/db/database.postgres.ddl
CREATE TABLE app_user (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  address_id UUID,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  password_hash TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

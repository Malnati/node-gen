-- test/e2e-generator-mock/projects/addresses/db/database.postgres.ddl
CREATE TABLE address (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  street TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT,
  zip_code TEXT,
  country VARCHAR(2) DEFAULT 'BR',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id),
  CONSTRAINT chk_address_country CHECK (country IN ('BR','PT','US','ES','AR','MX','GB','FR','DE'))
);

-- test/e2e-generator-mock/projects/accounts/db/database.postgres.ddl
CREATE TABLE account (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  name TEXT NOT NULL,
  account_type TEXT NOT NULL,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id),
  CONSTRAINT chk_account_type CHECK (account_type IN ('checking','savings','credit','wallet','other')),
  CONSTRAINT chk_currency_code CHECK (currency_code IN ('BRL','EUR','USD','GBP','MXN','ARS'))
);

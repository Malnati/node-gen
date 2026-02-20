-- test/e2e-generator-mock/projects/payments/db/database.postgres.ddl
CREATE TABLE payment (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  contact_id UUID,
  billing_address_id UUID,
  method VARCHAR(20) NOT NULL,
  amount DECIMAL(12,2) DEFAULT 0,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  status TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id),
  CONSTRAINT chk_payment_method CHECK (method IN ('DEBITO','CREDITO','PIX','BOLETO','CRIPTO','SWIFT','SEPA','ACH'))
);

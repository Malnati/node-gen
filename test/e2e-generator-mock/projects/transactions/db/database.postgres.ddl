-- test/e2e-generator-mock/projects/transactions/db/database.postgres.ddl
CREATE TABLE transaction (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  payment_id UUID NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  status TEXT NOT NULL,
  external_reference TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_transaction PRIMARY KEY (id),
  CONSTRAINT uk_transaction_external_id UNIQUE(external_id)
);

COMMENT ON TABLE transaction IS 'Transações financeiras por conta e tenant.';
COMMENT ON COLUMN transaction.id IS 'Identificador interno.';
COMMENT ON COLUMN transaction.external_id IS 'UUID público.';
COMMENT ON COLUMN transaction.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN transaction.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN transaction.payment_id IS 'Pagamento (UUID externo).';
COMMENT ON COLUMN transaction.amount IS 'Valor.';
COMMENT ON COLUMN transaction.currency_code IS 'Código da moeda (ex.: BRL).';
COMMENT ON COLUMN transaction.status IS 'Status da transação.';
COMMENT ON COLUMN transaction.external_reference IS 'Referência externa.';
COMMENT ON COLUMN transaction.created_at IS 'Data de criação.';
COMMENT ON COLUMN transaction.updated_at IS 'Última atualização.';
COMMENT ON COLUMN transaction.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_transaction ON transaction IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_transaction_external_id ON transaction IS 'UUID único.';

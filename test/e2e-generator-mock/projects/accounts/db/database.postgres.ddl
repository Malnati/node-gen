-- test/e2e-generator-mock/projects/accounts/db/database.postgres.ddl
CREATE TABLE account (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_account PRIMARY KEY (id),
  CONSTRAINT uk_account_external_id UNIQUE(external_id),
  CONSTRAINT chk_account_status CHECK (status IN ('active','suspended','pending_verification','closed'))
);

COMMENT ON TABLE account IS 'Contas por tenant.';
COMMENT ON COLUMN account.id IS 'Identificador interno.';
COMMENT ON COLUMN account.external_id IS 'UUID público.';
COMMENT ON COLUMN account.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN account.name IS 'Nome da conta.';
COMMENT ON COLUMN account.status IS 'Status (active, suspended, etc.).';
COMMENT ON COLUMN account.created_at IS 'Data de criação.';
COMMENT ON COLUMN account.updated_at IS 'Última atualização.';
COMMENT ON COLUMN account.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_account ON account IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_account_external_id ON account IS 'UUID único.';
COMMENT ON CONSTRAINT chk_account_status ON account IS 'Valores de status permitidos.';

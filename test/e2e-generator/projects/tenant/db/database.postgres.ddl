-- test/e2e-generator/projects/tenant/db/database.postgres.ddl
CREATE TABLE tenant (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  contact_id UUID,
  address_id UUID,
  name TEXT NOT NULL,
  legal_name TEXT,
  tax_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_tenant PRIMARY KEY (id),
  CONSTRAINT uk_tenant_external_id UNIQUE(external_id)
);

COMMENT ON TABLE tenant IS 'Tenants (organizações) por conta.';
COMMENT ON COLUMN tenant.id IS 'Identificador interno.';
COMMENT ON COLUMN tenant.external_id IS 'UUID público.';
COMMENT ON COLUMN tenant.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN tenant.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN tenant.contact_id IS 'Contato (UUID externo).';
COMMENT ON COLUMN tenant.address_id IS 'Endereço (UUID externo).';
COMMENT ON COLUMN tenant.name IS 'Nome do tenant.';
COMMENT ON COLUMN tenant.legal_name IS 'Razão social.';
COMMENT ON COLUMN tenant.tax_id IS 'CNPJ/CPF.';
COMMENT ON COLUMN tenant.created_at IS 'Data de criação.';
COMMENT ON COLUMN tenant.updated_at IS 'Última atualização.';
COMMENT ON COLUMN tenant.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_tenant ON tenant IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_tenant_external_id ON tenant IS 'UUID único.';

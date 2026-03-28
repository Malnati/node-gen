-- test/e2e-generator/projects/contacts/db/database.postgres.ddl
CREATE TABLE contact (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  address_id UUID,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  company TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_contact PRIMARY KEY (id),
  CONSTRAINT uk_contact_external_id UNIQUE(external_id)
);

COMMENT ON TABLE contact IS 'Contatos por conta e tenant.';
COMMENT ON COLUMN contact.id IS 'Identificador interno.';
COMMENT ON COLUMN contact.external_id IS 'UUID público.';
COMMENT ON COLUMN contact.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN contact.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN contact.address_id IS 'Endereço (UUID externo).';
COMMENT ON COLUMN contact.name IS 'Nome do contato.';
COMMENT ON COLUMN contact.email IS 'E-mail.';
COMMENT ON COLUMN contact.phone IS 'Telefone.';
COMMENT ON COLUMN contact.company IS 'Empresa.';
COMMENT ON COLUMN contact.created_at IS 'Data de criação.';
COMMENT ON COLUMN contact.updated_at IS 'Última atualização.';
COMMENT ON COLUMN contact.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_contact ON contact IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_contact_external_id ON contact IS 'UUID único.';

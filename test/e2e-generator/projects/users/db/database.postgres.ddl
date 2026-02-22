-- test/e2e-generator/projects/users/db/database.postgres.ddl
CREATE TABLE app_user (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  contact_id UUID,
  address_id UUID,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  password_hash TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_app_user PRIMARY KEY (id),
  CONSTRAINT uk_app_user_external_id UNIQUE(external_id)
);

COMMENT ON TABLE app_user IS 'Usuários da aplicação por conta e tenant.';
COMMENT ON COLUMN app_user.id IS 'Identificador interno.';
COMMENT ON COLUMN app_user.external_id IS 'UUID público.';
COMMENT ON COLUMN app_user.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN app_user.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN app_user.contact_id IS 'Contato (UUID externo).';
COMMENT ON COLUMN app_user.address_id IS 'Endereço (UUID externo).';
COMMENT ON COLUMN app_user.username IS 'Nome de usuário.';
COMMENT ON COLUMN app_user.email IS 'E-mail.';
COMMENT ON COLUMN app_user.password_hash IS 'Hash da senha.';
COMMENT ON COLUMN app_user.created_at IS 'Data de criação.';
COMMENT ON COLUMN app_user.updated_at IS 'Última atualização.';
COMMENT ON COLUMN app_user.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_app_user ON app_user IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_app_user_external_id ON app_user IS 'UUID único.';

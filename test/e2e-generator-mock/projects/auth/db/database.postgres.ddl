-- test/e2e-generator-mock/projects/auth/db/database.postgres.ddl
CREATE TABLE auth_session (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  user_id UUID NOT NULL,
  token_hash TEXT,
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_auth_session PRIMARY KEY (id),
  CONSTRAINT uk_auth_session_external_id UNIQUE(external_id)
);

COMMENT ON TABLE auth_session IS 'Sessões de autenticação por usuário e tenant.';
COMMENT ON COLUMN auth_session.id IS 'Identificador interno.';
COMMENT ON COLUMN auth_session.external_id IS 'UUID público.';
COMMENT ON COLUMN auth_session.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN auth_session.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN auth_session.user_id IS 'Usuário (UUID externo).';
COMMENT ON COLUMN auth_session.token_hash IS 'Hash do token.';
COMMENT ON COLUMN auth_session.expires_at IS 'Data de expiração.';
COMMENT ON COLUMN auth_session.created_at IS 'Data de criação.';
COMMENT ON COLUMN auth_session.updated_at IS 'Última atualização.';
COMMENT ON COLUMN auth_session.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_auth_session ON auth_session IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_auth_session_external_id ON auth_session IS 'UUID único.';

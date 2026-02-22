-- test/e2e-generator/projects/roles/db/database.postgres.ddl
CREATE TABLE role (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_role PRIMARY KEY (id),
  CONSTRAINT uk_role_external_id UNIQUE(external_id)
);

COMMENT ON TABLE role IS 'Papéis por tenant.';
COMMENT ON COLUMN role.id IS 'Identificador interno.';
COMMENT ON COLUMN role.external_id IS 'UUID público.';
COMMENT ON COLUMN role.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN role.name IS 'Nome do papel.';
COMMENT ON COLUMN role.description IS 'Descrição.';
COMMENT ON COLUMN role.created_at IS 'Data de criação.';
COMMENT ON COLUMN role.updated_at IS 'Última atualização.';
COMMENT ON COLUMN role.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_role ON role IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_role_external_id ON role IS 'UUID único.';

CREATE TABLE feature (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  code TEXT NOT NULL,
  name TEXT,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_feature PRIMARY KEY (id),
  CONSTRAINT uk_feature_external_id UNIQUE(external_id)
);

COMMENT ON TABLE feature IS 'Funcionalidades por tenant.';
COMMENT ON COLUMN feature.id IS 'Identificador interno.';
COMMENT ON COLUMN feature.external_id IS 'UUID público.';
COMMENT ON COLUMN feature.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN feature.code IS 'Código da funcionalidade.';
COMMENT ON COLUMN feature.name IS 'Nome.';
COMMENT ON COLUMN feature.description IS 'Descrição.';
COMMENT ON COLUMN feature.created_at IS 'Data de criação.';
COMMENT ON COLUMN feature.updated_at IS 'Última atualização.';
COMMENT ON COLUMN feature.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_feature ON feature IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_feature_external_id ON feature IS 'UUID único.';

CREATE TABLE role_feature (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  role_id UUID NOT NULL,
  feature_id UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_role_feature PRIMARY KEY (id),
  CONSTRAINT uk_role_feature_external_id UNIQUE(external_id)
);

COMMENT ON TABLE role_feature IS 'Associação papel-funcionalidade.';
COMMENT ON COLUMN role_feature.id IS 'Identificador interno.';
COMMENT ON COLUMN role_feature.external_id IS 'UUID público.';
COMMENT ON COLUMN role_feature.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN role_feature.role_id IS 'Papel (UUID externo).';
COMMENT ON COLUMN role_feature.feature_id IS 'Funcionalidade (UUID externo).';
COMMENT ON COLUMN role_feature.created_at IS 'Data de criação.';
COMMENT ON COLUMN role_feature.updated_at IS 'Última atualização.';
COMMENT ON COLUMN role_feature.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_role_feature ON role_feature IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_role_feature_external_id ON role_feature IS 'UUID único.';

CREATE TABLE user_role (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  user_id UUID NOT NULL,
  account_id UUID NOT NULL,
  role_id UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_user_role PRIMARY KEY (id),
  CONSTRAINT uk_user_role_external_id UNIQUE(external_id)
);

COMMENT ON TABLE user_role IS 'Associação usuário-papel por conta.';
COMMENT ON COLUMN user_role.id IS 'Identificador interno.';
COMMENT ON COLUMN user_role.external_id IS 'UUID público.';
COMMENT ON COLUMN user_role.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN user_role.user_id IS 'Usuário (UUID externo).';
COMMENT ON COLUMN user_role.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN user_role.role_id IS 'Papel (UUID externo).';
COMMENT ON COLUMN user_role.created_at IS 'Data de criação.';
COMMENT ON COLUMN user_role.updated_at IS 'Última atualização.';
COMMENT ON COLUMN user_role.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_user_role ON user_role IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_user_role_external_id ON user_role IS 'UUID único.';

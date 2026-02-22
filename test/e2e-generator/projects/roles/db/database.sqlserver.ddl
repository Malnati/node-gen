-- test/e2e-generator/projects/roles/db/database.sqlserver.ddl
CREATE TABLE [role] (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(100) NOT NULL,
  description NVARCHAR(500),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_role_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_role PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Papéis por tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Nome do papel.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'COLUMN', @level2name = N'name';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Descrição.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'COLUMN', @level2name = N'description';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'CONSTRAINT', @level2name = N'uk_role_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role', @level2type = N'CONSTRAINT', @level2name = N'pk_role';

CREATE TABLE feature (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  code NVARCHAR(100) NOT NULL,
  name NVARCHAR(255),
  description NVARCHAR(500),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_feature_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_feature PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Funcionalidades por tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Código da funcionalidade.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'code';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Nome.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'name';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Descrição.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'description';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'CONSTRAINT', @level2name = N'uk_feature_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'feature', @level2type = N'CONSTRAINT', @level2name = N'pk_feature';

CREATE TABLE role_feature (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  role_id UNIQUEIDENTIFIER NOT NULL,
  feature_id UNIQUEIDENTIFIER NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_role_feature_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_role_feature PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Associação papel-funcionalidade.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Papel (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'COLUMN', @level2name = N'role_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Funcionalidade (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'COLUMN', @level2name = N'feature_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'CONSTRAINT', @level2name = N'uk_role_feature_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'role_feature', @level2type = N'CONSTRAINT', @level2name = N'pk_role_feature';

CREATE TABLE user_role (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  user_id UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  role_id UNIQUEIDENTIFIER NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_user_role_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_user_role PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Associação usuário-papel por conta.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Usuário (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'user_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Conta (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'account_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Papel (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'role_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'CONSTRAINT', @level2name = N'uk_user_role_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'user_role', @level2type = N'CONSTRAINT', @level2name = N'pk_user_role';

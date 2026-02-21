-- test/e2e-generator-mock/projects/users/db/database.sqlserver.ddl
CREATE TABLE app_user (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  contact_id UNIQUEIDENTIFIER,
  address_id UNIQUEIDENTIFIER,
  username NVARCHAR(100) NOT NULL,
  email NVARCHAR(255) NOT NULL,
  password_hash NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_app_user_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_app_user PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Usuários da aplicação por conta e tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Conta (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'account_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Contato (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'contact_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Endereço (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'address_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Nome de usuário.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'username';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'E-mail.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'email';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Hash da senha.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'password_hash';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'CONSTRAINT', @level2name = N'uk_app_user_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'app_user', @level2type = N'CONSTRAINT', @level2name = N'pk_app_user';

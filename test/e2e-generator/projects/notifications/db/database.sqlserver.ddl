-- test/e2e-generator/projects/notifications/db/database.sqlserver.ddl
CREATE TABLE notification_template (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  code NVARCHAR(100) NOT NULL,
  name NVARCHAR(255),
  channel NVARCHAR(20),
  subject_tpl NVARCHAR(MAX),
  body_tpl NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_notification_template_external_id UNIQUE (external_id),
  CONSTRAINT chk_notification_template_channel CHECK (channel IS NULL OR channel IN ('email','sms','push'))
,
  CONSTRAINT pk_notification_template PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Templates de notificação por tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Código do template.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'code';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Nome.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'name';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Canal (email, sms, push).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'channel';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Template do assunto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'subject_tpl';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Template do corpo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'body_tpl';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'CONSTRAINT', @level2name = N'uk_notification_template_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Canal permitido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'CONSTRAINT', @level2name = N'chk_notification_template_channel';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification_template', @level2type = N'CONSTRAINT', @level2name = N'pk_notification_template';

CREATE TABLE notification (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  user_id UNIQUEIDENTIFIER,
  contact_id UNIQUEIDENTIFIER,
  template_id UNIQUEIDENTIFIER,
  channel NVARCHAR(20),
  priority NVARCHAR(20),
  subject NVARCHAR(500),
  body NVARCHAR(MAX),
  read_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_notification_external_id UNIQUE (external_id),
  CONSTRAINT chk_notification_channel CHECK (channel IS NULL OR channel IN ('email','sms','push')),
  CONSTRAINT chk_notification_priority CHECK (priority IS NULL OR priority IN ('low','normal','high','urgent'))
,
  CONSTRAINT pk_notification PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Notificações enviadas por tenant/conta.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Conta (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'account_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Usuário (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'user_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Contato (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'contact_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Template (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'template_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Canal (email, sms, push).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'channel';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Prioridade (low, normal, high, urgent).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'priority';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Assunto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'subject';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Corpo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'body';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de leitura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'read_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'CONSTRAINT', @level2name = N'uk_notification_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Canal permitido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'CONSTRAINT', @level2name = N'chk_notification_channel';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Prioridade permitida.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'CONSTRAINT', @level2name = N'chk_notification_priority';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notification', @level2type = N'CONSTRAINT', @level2name = N'pk_notification';

-- test/e2e-generator-mock/projects/google-calendar/db/database.sqlserver.ddl
CREATE TABLE calendar_integration (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  connected_email NVARCHAR(255) NOT NULL,
  oauth_ref NVARCHAR(500),
  last_sync_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_calendar_integration_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_calendar_integration PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Integração Google Calendar por conta e tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Conta (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'account_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'E-mail conectado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'connected_email';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência OAuth.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'oauth_ref';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última sincronização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'last_sync_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'CONSTRAINT', @level2name = N'uk_calendar_integration_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_integration', @level2type = N'CONSTRAINT', @level2name = N'pk_calendar_integration';

CREATE TABLE calendar (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  integration_id UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  timezone NVARCHAR(100) DEFAULT 'UTC',
  google_calendar_id NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_calendar_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_calendar PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Calendários por integração e tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Conta (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'account_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Integração (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'integration_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Nome do calendário.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'name';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Fuso horário.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'timezone';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'ID do calendário no Google.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'google_calendar_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'CONSTRAINT', @level2name = N'uk_calendar_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar', @level2type = N'CONSTRAINT', @level2name = N'pk_calendar';

CREATE TABLE calendar_event (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  integration_id UNIQUEIDENTIFIER NOT NULL,
  calendar_id UNIQUEIDENTIFIER NOT NULL,
  title NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  start_at DATETIME2 NOT NULL,
  end_at DATETIME2 NOT NULL,
  all_day BIT DEFAULT 0,
  google_event_id NVARCHAR(255),
  status NVARCHAR(50),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_calendar_event_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_calendar_event PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Eventos do calendário por tenant e conta.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Conta (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'account_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Integração (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'integration_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Calendário (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'calendar_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Título do evento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'title';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Descrição.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'description';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Início.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'start_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Fim.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'end_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Evento dia inteiro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'all_day';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'ID do evento no Google.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'google_event_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Status.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'status';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'CONSTRAINT', @level2name = N'uk_calendar_event_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'calendar_event', @level2type = N'CONSTRAINT', @level2name = N'pk_calendar_event';

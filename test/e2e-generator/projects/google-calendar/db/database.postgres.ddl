-- test/e2e-generator/projects/google-calendar/db/database.postgres.ddl
CREATE TABLE calendar_integration (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  connected_email TEXT NOT NULL,
  oauth_ref TEXT,
  last_sync_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_calendar_integration PRIMARY KEY (id),
  CONSTRAINT uk_calendar_integration_external_id UNIQUE(external_id)
);

COMMENT ON TABLE calendar_integration IS 'Integração Google Calendar por conta e tenant.';
COMMENT ON COLUMN calendar_integration.id IS 'Identificador interno.';
COMMENT ON COLUMN calendar_integration.external_id IS 'UUID público.';
COMMENT ON COLUMN calendar_integration.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN calendar_integration.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN calendar_integration.connected_email IS 'E-mail conectado.';
COMMENT ON COLUMN calendar_integration.oauth_ref IS 'Referência OAuth.';
COMMENT ON COLUMN calendar_integration.last_sync_at IS 'Última sincronização.';
COMMENT ON COLUMN calendar_integration.created_at IS 'Data de criação.';
COMMENT ON COLUMN calendar_integration.updated_at IS 'Última atualização.';
COMMENT ON COLUMN calendar_integration.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_calendar_integration ON calendar_integration IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_calendar_integration_external_id ON calendar_integration IS 'UUID único.';

CREATE TABLE calendar (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  integration_id UUID NOT NULL,
  name TEXT NOT NULL,
  timezone TEXT DEFAULT 'UTC',
  google_calendar_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_calendar PRIMARY KEY (id),
  CONSTRAINT uk_calendar_external_id UNIQUE(external_id)
);

COMMENT ON TABLE calendar IS 'Calendários por integração e tenant.';
COMMENT ON COLUMN calendar.id IS 'Identificador interno.';
COMMENT ON COLUMN calendar.external_id IS 'UUID público.';
COMMENT ON COLUMN calendar.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN calendar.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN calendar.integration_id IS 'Integração (UUID externo).';
COMMENT ON COLUMN calendar.name IS 'Nome do calendário.';
COMMENT ON COLUMN calendar.timezone IS 'Fuso horário.';
COMMENT ON COLUMN calendar.google_calendar_id IS 'ID do calendário no Google.';
COMMENT ON COLUMN calendar.created_at IS 'Data de criação.';
COMMENT ON COLUMN calendar.updated_at IS 'Última atualização.';
COMMENT ON COLUMN calendar.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_calendar ON calendar IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_calendar_external_id ON calendar IS 'UUID único.';

CREATE TABLE calendar_event (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  integration_id UUID NOT NULL,
  calendar_id UUID NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  start_at TIMESTAMP WITH TIME ZONE NOT NULL,
  end_at TIMESTAMP WITH TIME ZONE NOT NULL,
  all_day BOOLEAN DEFAULT false,
  google_event_id TEXT,
  status TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_calendar_event PRIMARY KEY (id),
  CONSTRAINT uk_calendar_event_external_id UNIQUE(external_id)
);

COMMENT ON TABLE calendar_event IS 'Eventos do calendário por tenant e conta.';
COMMENT ON COLUMN calendar_event.id IS 'Identificador interno.';
COMMENT ON COLUMN calendar_event.external_id IS 'UUID público.';
COMMENT ON COLUMN calendar_event.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN calendar_event.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN calendar_event.integration_id IS 'Integração (UUID externo).';
COMMENT ON COLUMN calendar_event.calendar_id IS 'Calendário (UUID externo).';
COMMENT ON COLUMN calendar_event.title IS 'Título do evento.';
COMMENT ON COLUMN calendar_event.description IS 'Descrição.';
COMMENT ON COLUMN calendar_event.start_at IS 'Início.';
COMMENT ON COLUMN calendar_event.end_at IS 'Fim.';
COMMENT ON COLUMN calendar_event.all_day IS 'Evento dia inteiro.';
COMMENT ON COLUMN calendar_event.google_event_id IS 'ID do evento no Google.';
COMMENT ON COLUMN calendar_event.status IS 'Status.';
COMMENT ON COLUMN calendar_event.created_at IS 'Data de criação.';
COMMENT ON COLUMN calendar_event.updated_at IS 'Última atualização.';
COMMENT ON COLUMN calendar_event.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_calendar_event ON calendar_event IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_calendar_event_external_id ON calendar_event IS 'UUID único.';

-- test/e2e-generator/projects/google-calendar/db/database.sqlite.ddl
-- Integração Google Calendar por conta e tenant.
CREATE TABLE calendar_integration (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  connected_email TEXT NOT NULL, -- E-mail conectado.
  oauth_ref TEXT, -- Referência OAuth.
  last_sync_at TEXT, -- Última sincronização.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Calendários por integração e tenant.
CREATE TABLE calendar (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  integration_id TEXT NOT NULL, -- Integração (UUID externo).
  name TEXT NOT NULL, -- Nome do calendário.
  timezone TEXT DEFAULT 'UTC', -- Fuso horário.
  google_calendar_id TEXT, -- ID do calendário no Google.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Eventos do calendário por tenant e conta.
CREATE TABLE calendar_event (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  integration_id TEXT NOT NULL, -- Integração (UUID externo).
  calendar_id TEXT NOT NULL, -- Calendário (UUID externo).
  title TEXT NOT NULL, -- Título do evento.
  description TEXT, -- Descrição.
  start_at TEXT NOT NULL, -- Início.
  end_at TEXT NOT NULL, -- Fim.
  all_day INTEGER DEFAULT 0, -- Evento dia inteiro.
  google_event_id TEXT, -- ID do evento no Google.
  status TEXT, -- Status.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

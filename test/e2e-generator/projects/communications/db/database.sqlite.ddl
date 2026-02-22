-- test/e2e-generator/projects/communications/db/database.sqlite.ddl
-- Templates de e-mail por tenant.
CREATE TABLE email_template (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  code TEXT NOT NULL, -- Código do template.
  name TEXT, -- Nome.
  subject_tpl TEXT, -- Template do assunto.
  body_tpl TEXT, -- Template do corpo.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Configuração SMTP por tenant/conta.
CREATE TABLE smtp_config (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT, -- Conta (UUID externo).
  host TEXT NOT NULL, -- Host SMTP.
  port INTEGER DEFAULT 587, -- Porta.
  use_tls INTEGER DEFAULT 1, -- Usar TLS.
  credentials_ref TEXT, -- Referência às credenciais.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Histórico de envios por tenant.
CREATE TABLE send_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  template_id TEXT, -- Template (UUID externo).
  recipient TEXT NOT NULL, -- Destinatário.
  sent_at TEXT, -- Data de envio.
  status TEXT, -- Status.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Rastreio de entrega por envio.
CREATE TABLE delivery_tracking (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  send_history_id TEXT NOT NULL, -- Envio (UUID externo).
  event_type TEXT, -- Tipo do evento.
  event_at TEXT, -- Data do evento.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- test/e2e-generator/projects/gmail/db/database.sqlite.ddl
-- Integração Gmail por conta e tenant.
CREATE TABLE gmail_integration (
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

-- Templates de mensagem Gmail por tenant.
CREATE TABLE gmail_message_template (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT, -- Conta (UUID externo).
  code TEXT NOT NULL, -- Código do template.
  name TEXT, -- Nome.
  subject_tpl TEXT, -- Template do assunto.
  body_tpl TEXT, -- Template do corpo.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Mensagens Gmail por integração e tenant.
CREATE TABLE gmail_message (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  integration_id TEXT NOT NULL, -- Integração (UUID externo).
  gmail_message_id TEXT, -- ID da mensagem no Gmail.
  gmail_thread_id TEXT, -- ID do thread no Gmail.
  direction TEXT NOT NULL CHECK (direction IN ('sent','received')), -- Direção (sent, received).
  subject TEXT, -- Assunto.
  from_addr TEXT, -- Remetente.
  to_addr TEXT, -- Destinatário.
  body_preview TEXT, -- Prévia do corpo.
  sent_at TEXT, -- Data de envio.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

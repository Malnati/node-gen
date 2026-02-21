-- test/e2e-generator-mock/projects/notifications/db/database.sqlite.ddl
-- Templates de notificação por tenant.
CREATE TABLE notification_template (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  code TEXT NOT NULL, -- Código do template.
  name TEXT, -- Nome.
  channel TEXT CHECK (channel IS NULL OR channel IN ('email','sms','push')), -- Canal (email, sms, push).
  subject_tpl TEXT, -- Template do assunto.
  body_tpl TEXT, -- Template do corpo.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Notificações enviadas por tenant/conta.
CREATE TABLE notification (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  user_id TEXT, -- Usuário (UUID externo).
  contact_id TEXT, -- Contato (UUID externo).
  template_id TEXT, -- Template (UUID externo).
  channel TEXT CHECK (channel IS NULL OR channel IN ('email','sms','push')), -- Canal (email, sms, push).
  priority TEXT CHECK (priority IS NULL OR priority IN ('low','normal','high','urgent')), -- Prioridade (low, normal, high, urgent).
  subject TEXT, -- Assunto.
  body TEXT, -- Corpo.
  read_at TEXT, -- Data de leitura.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

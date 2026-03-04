-- test/e2e-generator/projects/consents/db/database.sqlite.ddl
-- Registros de consentimento por conta e tenant.
CREATE TABLE consent_record (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  user_id TEXT, -- Usuário (UUID externo).
  consent_type TEXT NOT NULL, -- Tipo de consentimento.
  granted_at TEXT, -- Data de concessão.
  ip_address TEXT, -- IP da solicitação.
  version TEXT, -- Versão do termo.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Preferências de notificação por canal e usuário.
CREATE TABLE notification_preference (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  user_id TEXT, -- Usuário (UUID externo).
  channel TEXT NOT NULL CHECK (channel IN ('email','sms','push')), -- Canal (email, sms, push).
  opt_in INTEGER DEFAULT 1, -- Opt-in ativo.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

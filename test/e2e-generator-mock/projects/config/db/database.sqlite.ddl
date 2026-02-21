-- test/e2e-generator-mock/projects/config/db/database.sqlite.ddl
-- Configurações chave-valor por tenant.
CREATE TABLE config (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  config_key TEXT NOT NULL, -- Chave da configuração.
  config_value TEXT, -- Valor.
  value_type TEXT, -- Tipo do valor.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Configuração de integrações por tenant.
CREATE TABLE integration_config (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  integration_code TEXT NOT NULL, -- Código da integração.
  endpoint_url TEXT, -- URL do endpoint.
  credentials_ref TEXT, -- Referência às credenciais.
  enabled INTEGER DEFAULT 1, -- Integração ativa.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Webhooks por tenant.
CREATE TABLE webhook (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  url TEXT NOT NULL, -- URL de callback.
  event_type TEXT, -- Tipo de evento.
  secret_hash TEXT, -- Hash do segredo.
  enabled INTEGER DEFAULT 1, -- Webhook ativo.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Identidade visual por tenant.
CREATE TABLE branding (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  name TEXT, -- Nome da marca.
  logo_url TEXT, -- URL do logo.
  logo_ref TEXT, -- Referência ao logo.
  favicon_url TEXT, -- URL do favicon.
  primary_color TEXT, -- Cor primária.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Labels de internacionalização por tenant.
CREATE TABLE label (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  code TEXT NOT NULL, -- Código do label.
  value TEXT NOT NULL, -- Valor do texto.
  locale TEXT, -- Locale (ex.: pt-BR).
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

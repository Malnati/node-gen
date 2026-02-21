-- test/e2e-generator-mock/projects/google-drive/db/database.sqlite.ddl
-- Integração Google Drive por conta e tenant.
CREATE TABLE drive_integration (
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

-- Pastas do Drive por integração e tenant.
CREATE TABLE drive_folder (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  integration_id TEXT NOT NULL, -- Integração (UUID externo).
  name TEXT NOT NULL, -- Nome da pasta.
  parent_folder_id TEXT, -- Pasta pai (UUID externo).
  drive_folder_id TEXT, -- ID da pasta no Google Drive.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Arquivos do Drive por tenant e conta.
CREATE TABLE drive_file (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  integration_id TEXT NOT NULL, -- Integração (UUID externo).
  folder_id TEXT, -- Pasta (UUID externo).
  file_name TEXT NOT NULL, -- Nome do arquivo.
  mime_type TEXT, -- Tipo MIME.
  size_bytes INTEGER DEFAULT 0, -- Tamanho em bytes.
  drive_file_id TEXT, -- ID do arquivo no Google Drive.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

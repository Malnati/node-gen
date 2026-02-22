-- test/e2e-generator/projects/roles/db/database.sqlite.ddl
-- Papéis por tenant.
CREATE TABLE role (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  name TEXT NOT NULL, -- Nome do papel.
  description TEXT, -- Descrição.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Funcionalidades por tenant.
CREATE TABLE feature (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  code TEXT NOT NULL, -- Código da funcionalidade.
  name TEXT, -- Nome.
  description TEXT, -- Descrição.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Associação papel-funcionalidade.
CREATE TABLE role_feature (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  role_id TEXT NOT NULL, -- Papel (UUID externo).
  feature_id TEXT NOT NULL, -- Funcionalidade (UUID externo).
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Associação usuário-papel por conta.
CREATE TABLE user_role (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  user_id TEXT NOT NULL, -- Usuário (UUID externo).
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  role_id TEXT NOT NULL, -- Papel (UUID externo).
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

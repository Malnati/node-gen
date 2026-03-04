-- test/e2e-generator/projects/auth/db/database.sqlite.ddl
-- Sessões de autenticação por usuário e tenant.
CREATE TABLE auth_session (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  user_id TEXT NOT NULL, -- Usuário (UUID externo).
  token_hash TEXT, -- Hash do token.
  expires_at TEXT, -- Data de expiração.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

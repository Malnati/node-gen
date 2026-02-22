-- test/e2e-generator/projects/users/db/database.sqlite.ddl
-- Usuários da aplicação por conta e tenant.
CREATE TABLE app_user (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  contact_id TEXT, -- Contato (UUID externo).
  address_id TEXT, -- Endereço (UUID externo).
  username TEXT NOT NULL, -- Nome de usuário.
  email TEXT NOT NULL, -- E-mail.
  password_hash TEXT, -- Hash da senha.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

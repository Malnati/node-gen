-- test/e2e-generator/projects/contacts/db/database.sqlite.ddl
-- Contatos por conta e tenant.
CREATE TABLE contact (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  address_id TEXT, -- Endereço (UUID externo).
  name TEXT NOT NULL, -- Nome do contato.
  email TEXT, -- E-mail.
  phone TEXT, -- Telefone.
  company TEXT, -- Empresa.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

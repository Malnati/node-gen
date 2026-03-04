-- test/e2e-generator/projects/tenant/db/database.sqlite.ddl
-- Tenants (organizações) por conta.
CREATE TABLE tenant (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  contact_id TEXT, -- Contato (UUID externo).
  address_id TEXT, -- Endereço (UUID externo).
  name TEXT NOT NULL, -- Nome do tenant.
  legal_name TEXT, -- Razão social.
  tax_id TEXT, -- CNPJ/CPF.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

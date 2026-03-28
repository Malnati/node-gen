-- test/e2e-generator/projects/transactions/db/database.sqlite.ddl
-- Transações financeiras por conta e tenant.
CREATE TABLE [transaction] (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT NOT NULL, -- Conta (UUID externo).
  payment_id TEXT NOT NULL, -- Pagamento (UUID externo).
  amount REAL NOT NULL, -- Valor.
  currency_code TEXT DEFAULT 'BRL', -- Código da moeda (ex.: BRL).
  status TEXT NOT NULL, -- Status da transação.
  external_reference TEXT, -- Referência externa.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

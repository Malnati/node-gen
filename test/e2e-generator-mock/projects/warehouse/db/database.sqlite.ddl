-- test/e2e-generator-mock/projects/warehouse/db/database.sqlite.ddl
-- Estoque por produto e endereço (tenant).
CREATE TABLE warehouse_stock (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  product_id TEXT NOT NULL, -- Produto (UUID externo).
  address_id TEXT NOT NULL, -- Endereço do armazém (UUID externo).
  quantity REAL DEFAULT 0, -- Quantidade disponível.
  reserved REAL DEFAULT 0, -- Quantidade reservada.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

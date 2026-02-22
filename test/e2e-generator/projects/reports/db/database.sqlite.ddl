-- test/e2e-generator/projects/reports/db/database.sqlite.ddl
-- Vendas consolidadas por mês e tenant.
CREATE TABLE consolidated_sales_monthly (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  tenant TEXT NOT NULL, -- Tenant.
  year_month TEXT NOT NULL, -- Ano-mês (YYYY-MM).
  total_amount REAL, -- Valor total.
  order_count INTEGER, -- Quantidade de pedidos.
  currency_code TEXT DEFAULT 'BRL', -- Moeda.
  updated_at TEXT -- Última atualização.
);

-- Snapshot atual de estoque por tenant.
CREATE TABLE current_warehouse_stock (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  tenant TEXT NOT NULL, -- Tenant.
  warehouse_stock_external_id TEXT NOT NULL, -- Estoque (UUID externo).
  snapshot_at TEXT, -- Data do snapshot.
  updated_at TEXT -- Última atualização.
);

-- Métricas de desempenho logístico por tenant e período.
CREATE TABLE logistics_performance (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  tenant TEXT NOT NULL, -- Tenant.
  period_type TEXT, -- Tipo do período.
  period_key TEXT, -- Chave do período.
  on_time_rate REAL, -- Taxa de entrega no prazo.
  avg_delivery_days REAL, -- Média de dias para entrega.
  updated_at TEXT -- Última atualização.
);

CREATE VIEW v_sales_monthly AS SELECT * FROM consolidated_sales_monthly;
CREATE VIEW v_warehouse_stock AS SELECT * FROM current_warehouse_stock;
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

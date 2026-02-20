-- test/e2e-generator-mock/projects/reports/db/database.sqlite.ddl
-- Tabelas de consolidação físicas. Sem soft delete. Periodicidade em comentário.

-- Consolidação vendas mensais. Atualização esperada: mensal.
CREATE TABLE consolidated_sales_monthly (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  year_month TEXT NOT NULL,
  total_amount REAL,
  order_count INTEGER,
  currency_code TEXT DEFAULT 'BRL',
  updated_at TEXT
);

-- Consolidação stock por armazém. Atualização esperada: sob demanda ou diária.
CREATE TABLE current_warehouse_stock (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  product_id TEXT NOT NULL,
  address_id TEXT NOT NULL,
  quantity REAL,
  reserved REAL,
  updated_at TEXT
);

-- Consolidação desempenho logística. Atualização esperada: diária ou semanal.
CREATE TABLE logistics_performance (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  period_type TEXT,
  period_key TEXT,
  on_time_rate REAL,
  avg_delivery_days REAL,
  updated_at TEXT
);

CREATE VIEW v_sales_monthly AS SELECT * FROM consolidated_sales_monthly;
CREATE VIEW v_warehouse_stock AS SELECT * FROM current_warehouse_stock;
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

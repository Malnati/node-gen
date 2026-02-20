-- test/e2e-generator-mock/projects/reports/db/database.postgres.ddl
-- Tabelas de consolidação físicas. Sem soft delete. Periodicidade em comentário.

-- Consolidação vendas mensais. Atualização esperada: mensal.
CREATE TABLE consolidated_sales_monthly (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  year_month VARCHAR(7) NOT NULL,
  total_amount DECIMAL(14,2),
  order_count INT,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Consolidação níveis de stock. Atualização esperada: sob demanda ou diária.
CREATE TABLE current_inventory_levels (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  product_id UUID NOT NULL,
  address_id UUID NOT NULL,
  quantity DECIMAL(12,2),
  reserved DECIMAL(12,2),
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Consolidação desempenho logística. Atualização esperada: diária ou semanal.
CREATE TABLE logistics_performance (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  period_type VARCHAR(20),
  period_key VARCHAR(20),
  on_time_rate DECIMAL(5,2),
  avg_delivery_days DECIMAL(5,2),
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE VIEW v_sales_monthly AS SELECT * FROM consolidated_sales_monthly;
CREATE VIEW v_inventory_levels AS SELECT * FROM current_inventory_levels;
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

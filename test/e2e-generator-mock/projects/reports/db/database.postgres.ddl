-- test/e2e-generator-mock/projects/reports/db/database.postgres.ddl
CREATE TABLE consolidated_sales_monthly (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  year_month VARCHAR(7) NOT NULL,
  total_amount DECIMAL(14,2),
  order_count INT,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE current_warehouse_stock (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  warehouse_stock_external_id UUID NOT NULL,
  snapshot_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE
);

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
CREATE VIEW v_warehouse_stock AS SELECT * FROM current_warehouse_stock;
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

-- test/e2e-generator/projects/reports/db/database.postgres.ddl
CREATE TABLE consolidated_sales_monthly (
  id SERIAL,
  tenant UUID NOT NULL,
  year_month VARCHAR(7) NOT NULL,
  total_amount DECIMAL(14,2),
  order_count INT,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  updated_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_consolidated_sales_monthly PRIMARY KEY (id)
);

COMMENT ON TABLE consolidated_sales_monthly IS 'Vendas consolidadas por mês e tenant.';
COMMENT ON COLUMN consolidated_sales_monthly.id IS 'Identificador interno.';
COMMENT ON COLUMN consolidated_sales_monthly.tenant IS 'Tenant.';
COMMENT ON COLUMN consolidated_sales_monthly.year_month IS 'Ano-mês (YYYY-MM).';
COMMENT ON COLUMN consolidated_sales_monthly.total_amount IS 'Valor total.';
COMMENT ON COLUMN consolidated_sales_monthly.order_count IS 'Quantidade de pedidos.';
COMMENT ON COLUMN consolidated_sales_monthly.currency_code IS 'Moeda.';
COMMENT ON COLUMN consolidated_sales_monthly.updated_at IS 'Última atualização.';
COMMENT ON CONSTRAINT pk_consolidated_sales_monthly ON consolidated_sales_monthly IS 'Chave primária.';

CREATE TABLE current_warehouse_stock (
  id SERIAL,
  tenant UUID NOT NULL,
  warehouse_stock_external_id UUID NOT NULL,
  snapshot_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_current_warehouse_stock PRIMARY KEY (id)
);

COMMENT ON TABLE current_warehouse_stock IS 'Snapshot atual de estoque por tenant.';
COMMENT ON COLUMN current_warehouse_stock.id IS 'Identificador interno.';
COMMENT ON COLUMN current_warehouse_stock.tenant IS 'Tenant.';
COMMENT ON COLUMN current_warehouse_stock.warehouse_stock_external_id IS 'Estoque (UUID externo).';
COMMENT ON COLUMN current_warehouse_stock.snapshot_at IS 'Data do snapshot.';
COMMENT ON COLUMN current_warehouse_stock.updated_at IS 'Última atualização.';
COMMENT ON CONSTRAINT pk_current_warehouse_stock ON current_warehouse_stock IS 'Chave primária.';

CREATE TABLE logistics_performance (
  id SERIAL,
  tenant UUID NOT NULL,
  period_type VARCHAR(20),
  period_key VARCHAR(20),
  on_time_rate DECIMAL(5,2),
  avg_delivery_days DECIMAL(5,2),
  updated_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_logistics_performance PRIMARY KEY (id)
);

COMMENT ON TABLE logistics_performance IS 'Métricas de desempenho logístico por tenant e período.';
COMMENT ON COLUMN logistics_performance.id IS 'Identificador interno.';
COMMENT ON COLUMN logistics_performance.tenant IS 'Tenant.';
COMMENT ON COLUMN logistics_performance.period_type IS 'Tipo do período.';
COMMENT ON COLUMN logistics_performance.period_key IS 'Chave do período.';
COMMENT ON COLUMN logistics_performance.on_time_rate IS 'Taxa de entrega no prazo.';
COMMENT ON COLUMN logistics_performance.avg_delivery_days IS 'Média de dias para entrega.';
COMMENT ON COLUMN logistics_performance.updated_at IS 'Última atualização.';
COMMENT ON CONSTRAINT pk_logistics_performance ON logistics_performance IS 'Chave primária.';

CREATE VIEW v_sales_monthly AS SELECT * FROM consolidated_sales_monthly;
CREATE VIEW v_warehouse_stock AS SELECT * FROM current_warehouse_stock;
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

COMMENT ON VIEW v_sales_monthly IS 'Visão de vendas mensais consolidadas.';
COMMENT ON VIEW v_warehouse_stock IS 'Visão de estoque atual.';
COMMENT ON VIEW v_logistics_performance IS 'Visão de desempenho logístico.';

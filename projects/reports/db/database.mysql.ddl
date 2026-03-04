-- test/e2e-generator/projects/reports/db/database.mysql.ddl
CREATE TABLE consolidated_sales_monthly (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant.',
  year_month VARCHAR(7) NOT NULL COMMENT 'Ano-mês (YYYY-MM).',
  total_amount DECIMAL(14,2) COMMENT 'Valor total.',
  order_count INT COMMENT 'Quantidade de pedidos.',
  currency_code VARCHAR(3) DEFAULT 'BRL' COMMENT 'Moeda.',
  updated_at DATETIME
) COMMENT = 'Vendas consolidadas por mês e tenant.';

CREATE TABLE current_warehouse_stock (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant.',
  warehouse_stock_external_id CHAR(36) NOT NULL COMMENT 'Estoque (UUID externo).',
  snapshot_at DATETIME COMMENT 'Data do snapshot.',
  updated_at DATETIME
) COMMENT = 'Snapshot atual de estoque por tenant.';

CREATE TABLE logistics_performance (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant.',
  period_type VARCHAR(20) COMMENT 'Tipo do período.',
  period_key VARCHAR(20) COMMENT 'Chave do período.',
  on_time_rate DECIMAL(5,2) COMMENT 'Taxa de entrega no prazo.',
  avg_delivery_days DECIMAL(5,2) COMMENT 'Média de dias para entrega.',
  updated_at DATETIME
) COMMENT = 'Métricas de desempenho logístico por tenant e período.';

CREATE VIEW v_sales_monthly AS SELECT * FROM consolidated_sales_monthly;
CREATE VIEW v_warehouse_stock AS SELECT * FROM current_warehouse_stock;
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

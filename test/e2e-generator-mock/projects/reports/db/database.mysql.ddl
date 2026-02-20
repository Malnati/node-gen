-- test/e2e-generator-mock/projects/reports/db/database.mysql.ddl
-- Tabelas de consolidação físicas. Sem soft delete. Periodicidade em comentário.

-- Consolidação vendas mensais. Atualização esperada: mensal.
CREATE TABLE consolidated_sales_monthly (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  year_month VARCHAR(7) NOT NULL,
  total_amount DECIMAL(14,2),
  order_count INT,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  updated_at DATETIME
);

-- Consolidação stock por armazém. Atualização esperada: sob demanda ou diária.
CREATE TABLE current_warehouse_stock (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  product_id CHAR(36) NOT NULL,
  address_id CHAR(36) NOT NULL,
  quantity DECIMAL(12,2),
  reserved DECIMAL(12,2),
  updated_at DATETIME
);

-- Consolidação desempenho logística. Atualização esperada: diária ou semanal.
CREATE TABLE logistics_performance (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  period_type VARCHAR(20),
  period_key VARCHAR(20),
  on_time_rate DECIMAL(5,2),
  avg_delivery_days DECIMAL(5,2),
  updated_at DATETIME
);

CREATE VIEW v_sales_monthly AS SELECT * FROM consolidated_sales_monthly;
CREATE VIEW v_warehouse_stock AS SELECT * FROM current_warehouse_stock;
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

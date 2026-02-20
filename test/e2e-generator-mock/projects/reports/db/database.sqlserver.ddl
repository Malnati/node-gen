-- test/e2e-generator-mock/projects/reports/db/database.sqlserver.ddl
-- Tabelas de consolidação físicas. Sem soft delete. Periodicidade em comentário.

-- Consolidação vendas mensais. Atualização esperada: mensal.
CREATE TABLE consolidated_sales_monthly (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  year_month NVARCHAR(7) NOT NULL,
  total_amount DECIMAL(14,2),
  order_count INT,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  updated_at DATETIME2
);

-- Consolidação níveis de stock. Atualização esperada: sob demanda ou diária.
CREATE TABLE current_inventory_levels (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  product_id UNIQUEIDENTIFIER NOT NULL,
  address_id UNIQUEIDENTIFIER NOT NULL,
  quantity DECIMAL(12,2),
  reserved DECIMAL(12,2),
  updated_at DATETIME2
);

-- Consolidação desempenho logística. Atualização esperada: diária ou semanal.
CREATE TABLE logistics_performance (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  period_type NVARCHAR(20),
  period_key NVARCHAR(20),
  on_time_rate DECIMAL(5,2),
  avg_delivery_days DECIMAL(5,2),
  updated_at DATETIME2
);

GO
CREATE VIEW v_sales_monthly AS SELECT * FROM consolidated_sales_monthly;
GO
CREATE VIEW v_inventory_levels AS SELECT * FROM current_inventory_levels;
GO
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

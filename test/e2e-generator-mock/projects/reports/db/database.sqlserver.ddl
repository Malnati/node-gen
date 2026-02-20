-- test/e2e-generator-mock/projects/reports/db/database.sqlserver.ddl
CREATE TABLE consolidated_sales_monthly (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  year_month NVARCHAR(7) NOT NULL,
  total_amount DECIMAL(14,2),
  order_count INT,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  updated_at DATETIME2
);

CREATE TABLE current_warehouse_stock (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  warehouse_stock_external_id UNIQUEIDENTIFIER NOT NULL,
  snapshot_at DATETIME2,
  updated_at DATETIME2
);

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
CREATE VIEW v_warehouse_stock AS SELECT * FROM current_warehouse_stock;
GO
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

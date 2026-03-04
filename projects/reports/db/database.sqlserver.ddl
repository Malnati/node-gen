-- test/e2e-generator/projects/reports/db/database.sqlserver.ddl
CREATE TABLE consolidated_sales_monthly (
  id INT IDENTITY(1,1),
  tenant UNIQUEIDENTIFIER NOT NULL,
  year_month NVARCHAR(7) NOT NULL,
  total_amount DECIMAL(14,2),
  order_count INT,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  updated_at DATETIME2
,
  CONSTRAINT pk_consolidated_sales_monthly PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Vendas consolidadas por mês e tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Ano-mês (YYYY-MM).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly', @level2type = N'COLUMN', @level2name = N'year_month';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Valor total.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly', @level2type = N'COLUMN', @level2name = N'total_amount';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Quantidade de pedidos.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly', @level2type = N'COLUMN', @level2name = N'order_count';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Moeda.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly', @level2type = N'COLUMN', @level2name = N'currency_code';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'consolidated_sales_monthly', @level2type = N'CONSTRAINT', @level2name = N'pk_consolidated_sales_monthly';

CREATE TABLE current_warehouse_stock (
  id INT IDENTITY(1,1),
  tenant UNIQUEIDENTIFIER NOT NULL,
  warehouse_stock_external_id UNIQUEIDENTIFIER NOT NULL,
  snapshot_at DATETIME2,
  updated_at DATETIME2
,
  CONSTRAINT pk_current_warehouse_stock PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Snapshot atual de estoque por tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'current_warehouse_stock';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'current_warehouse_stock', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'current_warehouse_stock', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Estoque (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'current_warehouse_stock', @level2type = N'COLUMN', @level2name = N'warehouse_stock_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data do snapshot.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'current_warehouse_stock', @level2type = N'COLUMN', @level2name = N'snapshot_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'current_warehouse_stock', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'current_warehouse_stock', @level2type = N'CONSTRAINT', @level2name = N'pk_current_warehouse_stock';

CREATE TABLE logistics_performance (
  id INT IDENTITY(1,1),
  tenant UNIQUEIDENTIFIER NOT NULL,
  period_type NVARCHAR(20),
  period_key NVARCHAR(20),
  on_time_rate DECIMAL(5,2),
  avg_delivery_days DECIMAL(5,2),
  updated_at DATETIME2
,
  CONSTRAINT pk_logistics_performance PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Métricas de desempenho logístico por tenant e período.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo do período.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance', @level2type = N'COLUMN', @level2name = N'period_type';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave do período.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance', @level2type = N'COLUMN', @level2name = N'period_key';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Taxa de entrega no prazo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance', @level2type = N'COLUMN', @level2name = N'on_time_rate';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Média de dias para entrega.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance', @level2type = N'COLUMN', @level2name = N'avg_delivery_days';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'logistics_performance', @level2type = N'CONSTRAINT', @level2name = N'pk_logistics_performance';

GO
CREATE VIEW v_sales_monthly AS SELECT * FROM consolidated_sales_monthly;
GO
CREATE VIEW v_warehouse_stock AS SELECT * FROM current_warehouse_stock;
GO
CREATE VIEW v_logistics_performance AS SELECT * FROM logistics_performance;

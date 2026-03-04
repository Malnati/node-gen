-- test/e2e-generator/projects/selling/db/schema.sqlserver.ddl
CREATE TABLE tb_order (
  id INT IDENTITY(1,1),
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  account_id UNIQUEIDENTIFIER NOT NULL,
  billing_address_id UNIQUEIDENTIFIER,
  shipping_address_id UNIQUEIDENTIFIER,
  payment_id UNIQUEIDENTIFIER,
  status NVARCHAR(50) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0,
  ordered_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
,
  CONSTRAINT pk_tb_order PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Pedidos de venda; comprador e endereços/pagamento referenciados por UUID aos serviços accounts, addresses e payments.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave interna do pedido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência lógica ao locatário (serviço companies).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador público para APIs e referência entre serviços.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência lógica ao comprador (serviço accounts).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'account_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência lógica ao endereço de faturação (serviço addresses).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'billing_address_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência lógica ao endereço de envio (serviço addresses).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'shipping_address_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência lógica ao pagamento (serviço payments).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'payment_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Estado do pedido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'status';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Valor total do pedido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'total';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Desconto aplicado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'discount';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data/hora do pedido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'ordered_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data/hora de criação do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data/hora da última alteração.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica (soft delete).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order', @level2type = N'CONSTRAINT', @level2name = N'pk_tb_order';

CREATE TABLE tb_order_line (
  order_id INT NOT NULL,
  line_number INT NOT NULL,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  product_id UNIQUEIDENTIFIER NOT NULL,
  product_name NVARCHAR(255),
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  CONSTRAINT pk_tb_order_line PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Itens do pedido; produto referenciado por UUID ao serviço products.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave interna do pedido (FK local).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'order_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Número da linha no pedido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'line_number';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência lógica ao locatário (serviço companies).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador público para APIs.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência lógica ao produto (serviço products).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'product_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Cache do nome do produto para exibição (opcional).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'product_name';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Quantidade.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'quantity';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Preço unitário.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'unit_price';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Total da linha.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'line_total';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data/hora de criação do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data/hora da última alteração.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica (soft delete).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária composta.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tb_order_line', @level2type = N'CONSTRAINT', @level2name = N'pk_tb_order_line';

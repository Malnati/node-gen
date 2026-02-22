-- test/e2e-generator/projects/transactions/db/database.sqlserver.ddl
CREATE TABLE transaction (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  payment_id UNIQUEIDENTIFIER NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  currency_code NVARCHAR(3) DEFAULT 'BRL',
  status NVARCHAR(50) NOT NULL,
  external_reference NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_transaction_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_transaction PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Transações financeiras por conta e tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Conta (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'account_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Pagamento (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'payment_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Valor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'amount';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Código da moeda (ex.: BRL).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'currency_code';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Status da transação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'status';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência externa.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'external_reference';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'CONSTRAINT', @level2name = N'uk_transaction_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'transaction', @level2type = N'CONSTRAINT', @level2name = N'pk_transaction';

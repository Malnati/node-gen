-- test/e2e-generator-mock/projects/payments/db/database.postgres.ddl
CREATE TABLE payment_type (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID,
  code VARCHAR(20) NOT NULL,
  name VARCHAR(100),
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_payment_type PRIMARY KEY (id),
  CONSTRAINT uk_payment_type_external_id UNIQUE(external_id),
  CONSTRAINT uk_payment_type_code UNIQUE(code)
);

COMMENT ON TABLE payment_type IS 'Tipos de pagamento (cartão, PIX, etc.).';
COMMENT ON COLUMN payment_type.id IS 'Identificador interno.';
COMMENT ON COLUMN payment_type.external_id IS 'UUID público.';
COMMENT ON COLUMN payment_type.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN payment_type.code IS 'Código do tipo.';
COMMENT ON COLUMN payment_type.name IS 'Nome do tipo.';
COMMENT ON COLUMN payment_type.description IS 'Descrição.';
COMMENT ON COLUMN payment_type.created_at IS 'Data de criação.';
COMMENT ON COLUMN payment_type.updated_at IS 'Última atualização.';
COMMENT ON COLUMN payment_type.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_payment_type ON payment_type IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_payment_type_external_id ON payment_type IS 'UUID único.';
COMMENT ON CONSTRAINT uk_payment_type_code ON payment_type IS 'Código único.';

CREATE TABLE payment (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  contact_id UUID,
  billing_address_id UUID,
  payment_type_id INT NOT NULL,
  currency_id UUID NOT NULL,
  amount DECIMAL(12,2) DEFAULT 0,
  status TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_payment PRIMARY KEY (id),
  CONSTRAINT uk_payment_external_id UNIQUE(external_id),
  CONSTRAINT fk_payment_type FOREIGN KEY (payment_type_id) REFERENCES payment_type(id)
);

COMMENT ON TABLE payment IS 'Pagamentos por conta e tenant.';
COMMENT ON COLUMN payment.id IS 'Identificador interno.';
COMMENT ON COLUMN payment.external_id IS 'UUID público.';
COMMENT ON COLUMN payment.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN payment.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN payment.contact_id IS 'Contato (UUID externo).';
COMMENT ON COLUMN payment.billing_address_id IS 'Endereço de cobrança (UUID externo).';
COMMENT ON COLUMN payment.payment_type_id IS 'Tipo de pagamento (FK).';
COMMENT ON COLUMN payment.currency_id IS 'Moeda (UUID externo).';
COMMENT ON COLUMN payment.amount IS 'Valor.';
COMMENT ON COLUMN payment.status IS 'Status do pagamento.';
COMMENT ON COLUMN payment.created_at IS 'Data de criação.';
COMMENT ON COLUMN payment.updated_at IS 'Última atualização.';
COMMENT ON COLUMN payment.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_payment ON payment IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_payment_external_id ON payment IS 'UUID único.';
COMMENT ON CONSTRAINT fk_payment_type ON payment IS 'Referência ao tipo de pagamento.';

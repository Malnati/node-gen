-- test/e2e-generator-mock/projects/products/db/database.postgres.ddl
CREATE TABLE currency (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID,
  code VARCHAR(3) NOT NULL,
  name VARCHAR(100) NOT NULL,
  symbol VARCHAR(10),
  region VARCHAR(50),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_currency PRIMARY KEY (id),
  CONSTRAINT uk_currency_external_id UNIQUE(external_id),
  CONSTRAINT uk_currency_code UNIQUE(code),
  CONSTRAINT chk_currency_region CHECK (region IS NULL OR region IN ('SOUTH_AMERICA','NORTH_AMERICA','EUROPE'))
);

COMMENT ON TABLE currency IS 'Moedas por tenant.';
COMMENT ON COLUMN currency.id IS 'Identificador interno.';
COMMENT ON COLUMN currency.external_id IS 'UUID público.';
COMMENT ON COLUMN currency.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN currency.code IS 'Código ISO da moeda (ex.: BRL, USD).';
COMMENT ON COLUMN currency.name IS 'Nome da moeda.';
COMMENT ON COLUMN currency.symbol IS 'Símbolo (ex.: R$, $).';
COMMENT ON COLUMN currency.region IS 'Região de uso (enum).';
COMMENT ON COLUMN currency.created_at IS 'Data de criação.';
COMMENT ON COLUMN currency.updated_at IS 'Última atualização.';
COMMENT ON COLUMN currency.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_currency ON currency IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_currency_external_id ON currency IS 'UUID único.';
COMMENT ON CONSTRAINT uk_currency_code ON currency IS 'Código único por tenant.';
COMMENT ON CONSTRAINT chk_currency_region ON currency IS 'Região permitida.';

CREATE TABLE unit_of_measure (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID,
  code VARCHAR(20) NOT NULL,
  name VARCHAR(100),
  symbol VARCHAR(10),
  category VARCHAR(30),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_unit_of_measure PRIMARY KEY (id),
  CONSTRAINT uk_uom_external_id UNIQUE(external_id),
  CONSTRAINT uk_uom_code UNIQUE(code),
  CONSTRAINT chk_uom_category CHECK (category IS NULL OR category IN ('COUNT','WEIGHT','VOLUME','LENGTH','AREA','TIME'))
);

COMMENT ON TABLE unit_of_measure IS 'Unidades de medida (peso, volume, etc.).';
COMMENT ON COLUMN unit_of_measure.id IS 'Identificador interno.';
COMMENT ON COLUMN unit_of_measure.external_id IS 'UUID público.';
COMMENT ON COLUMN unit_of_measure.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN unit_of_measure.code IS 'Código da unidade (ex.: KG, L).';
COMMENT ON COLUMN unit_of_measure.name IS 'Nome da unidade.';
COMMENT ON COLUMN unit_of_measure.symbol IS 'Símbolo.';
COMMENT ON COLUMN unit_of_measure.category IS 'Categoria (enum).';
COMMENT ON COLUMN unit_of_measure.created_at IS 'Data de criação.';
COMMENT ON COLUMN unit_of_measure.updated_at IS 'Última atualização.';
COMMENT ON COLUMN unit_of_measure.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_unit_of_measure ON unit_of_measure IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_uom_external_id ON unit_of_measure IS 'UUID único.';
COMMENT ON CONSTRAINT uk_uom_code ON unit_of_measure IS 'Código único.';
COMMENT ON CONSTRAINT chk_uom_category ON unit_of_measure IS 'Categoria permitida.';

CREATE TABLE product (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  sku TEXT,
  name TEXT NOT NULL,
  description TEXT,
  unit_of_measure_id INT NOT NULL,
  currency_id INT NOT NULL,
  unit_price DECIMAL(12,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_product PRIMARY KEY (id),
  CONSTRAINT uk_product_external_id UNIQUE(external_id),
  CONSTRAINT fk_product_currency FOREIGN KEY (currency_id) REFERENCES currency(id),
  CONSTRAINT fk_product_uom FOREIGN KEY (unit_of_measure_id) REFERENCES unit_of_measure(id)
);

COMMENT ON TABLE product IS 'Produtos do catálogo por conta e tenant.';
COMMENT ON COLUMN product.id IS 'Identificador interno.';
COMMENT ON COLUMN product.external_id IS 'UUID público.';
COMMENT ON COLUMN product.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN product.account_id IS 'Conta responsável (UUID externo).';
COMMENT ON COLUMN product.sku IS 'Código SKU.';
COMMENT ON COLUMN product.name IS 'Nome do produto.';
COMMENT ON COLUMN product.description IS 'Descrição.';
COMMENT ON COLUMN product.unit_of_measure_id IS 'Unidade de medida (FK).';
COMMENT ON COLUMN product.currency_id IS 'Moeda do preço (FK).';
COMMENT ON COLUMN product.unit_price IS 'Preço unitário.';
COMMENT ON COLUMN product.created_at IS 'Data de criação.';
COMMENT ON COLUMN product.updated_at IS 'Última atualização.';
COMMENT ON COLUMN product.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_product ON product IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_product_external_id ON product IS 'UUID único.';
COMMENT ON CONSTRAINT fk_product_currency ON product IS 'Referência à moeda.';
COMMENT ON CONSTRAINT fk_product_uom ON product IS 'Referência à unidade de medida.';

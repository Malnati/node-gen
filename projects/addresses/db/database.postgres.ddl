-- test/e2e-generator/projects/addresses/db/database.postgres.ddl
CREATE TABLE country (
  id SERIAL,
  code VARCHAR(2) NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_country PRIMARY KEY (id),
  CONSTRAINT uk_country_code UNIQUE(code)
);

COMMENT ON TABLE country IS 'Países.';
COMMENT ON COLUMN country.id IS 'Identificador interno.';
COMMENT ON COLUMN country.code IS 'Código ISO (ex.: BR).';
COMMENT ON COLUMN country.name IS 'Nome do país.';
COMMENT ON COLUMN country.created_at IS 'Data de criação.';
COMMENT ON COLUMN country.updated_at IS 'Última atualização.';
COMMENT ON COLUMN country.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_country ON country IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_country_code ON country IS 'Código único.';

CREATE TABLE state (
  id SERIAL,
  country_id INT NOT NULL,
  code VARCHAR(20) NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_state PRIMARY KEY (id),
  CONSTRAINT fk_state_country FOREIGN KEY (country_id) REFERENCES country(id),
  CONSTRAINT uk_state_country_code UNIQUE(country_id, code)
);

COMMENT ON TABLE state IS 'Estados/UF por país.';
COMMENT ON COLUMN state.id IS 'Identificador interno.';
COMMENT ON COLUMN state.country_id IS 'País (FK).';
COMMENT ON COLUMN state.code IS 'Código do estado (ex.: SP).';
COMMENT ON COLUMN state.name IS 'Nome do estado.';
COMMENT ON COLUMN state.created_at IS 'Data de criação.';
COMMENT ON COLUMN state.updated_at IS 'Última atualização.';
COMMENT ON COLUMN state.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_state ON state IS 'Chave primária.';
COMMENT ON CONSTRAINT fk_state_country ON state IS 'Referência ao país.';
COMMENT ON CONSTRAINT uk_state_country_code ON state IS 'Código único por país.';

CREATE TABLE city (
  id SERIAL,
  state_id INT NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_city PRIMARY KEY (id),
  CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES state(id)
);

COMMENT ON TABLE city IS 'Cidades por estado.';
COMMENT ON COLUMN city.id IS 'Identificador interno.';
COMMENT ON COLUMN city.state_id IS 'Estado (FK).';
COMMENT ON COLUMN city.name IS 'Nome da cidade.';
COMMENT ON COLUMN city.created_at IS 'Data de criação.';
COMMENT ON COLUMN city.updated_at IS 'Última atualização.';
COMMENT ON COLUMN city.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_city ON city IS 'Chave primária.';
COMMENT ON CONSTRAINT fk_city_state ON city IS 'Referência ao estado.';

CREATE TABLE address (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  street TEXT NOT NULL,
  zip_code TEXT,
  country_id INT NOT NULL,
  state_id INT NOT NULL,
  city_id INT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_address PRIMARY KEY (id),
  CONSTRAINT uk_address_external_id UNIQUE(external_id),
  CONSTRAINT fk_address_country FOREIGN KEY (country_id) REFERENCES country(id),
  CONSTRAINT fk_address_state FOREIGN KEY (state_id) REFERENCES state(id),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city(id)
);

COMMENT ON TABLE address IS 'Endereços por conta e tenant.';
COMMENT ON COLUMN address.id IS 'Identificador interno.';
COMMENT ON COLUMN address.external_id IS 'UUID público.';
COMMENT ON COLUMN address.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN address.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN address.street IS 'Logradouro.';
COMMENT ON COLUMN address.zip_code IS 'CEP.';
COMMENT ON COLUMN address.country_id IS 'País (FK).';
COMMENT ON COLUMN address.state_id IS 'Estado (FK).';
COMMENT ON COLUMN address.city_id IS 'Cidade (FK).';
COMMENT ON COLUMN address.created_at IS 'Data de criação.';
COMMENT ON COLUMN address.updated_at IS 'Última atualização.';
COMMENT ON COLUMN address.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_address ON address IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_address_external_id ON address IS 'UUID único.';
COMMENT ON CONSTRAINT fk_address_country ON address IS 'Referência ao país.';
COMMENT ON CONSTRAINT fk_address_state ON address IS 'Referência ao estado.';
COMMENT ON CONSTRAINT fk_address_city ON address IS 'Referência à cidade.';

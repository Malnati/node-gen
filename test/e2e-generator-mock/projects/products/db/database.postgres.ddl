-- test/e2e-generator-mock/projects/products/db/database.postgres.ddl
CREATE TABLE currency (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID,
  code VARCHAR(3) NOT NULL,
  name VARCHAR(100) NOT NULL,
  symbol VARCHAR(10),
  region VARCHAR(50),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id),
  UNIQUE(code),
  CONSTRAINT chk_currency_region CHECK (region IS NULL OR region IN ('SOUTH_AMERICA','NORTH_AMERICA','EUROPE'))
);

CREATE TABLE unit_of_measure (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID,
  code VARCHAR(20) NOT NULL,
  name VARCHAR(100),
  symbol VARCHAR(10),
  category VARCHAR(30),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id),
  UNIQUE(code),
  CONSTRAINT chk_uom_category CHECK (category IS NULL OR category IN ('COUNT','WEIGHT','VOLUME','LENGTH','AREA','TIME'))
);

CREATE TABLE product (
  id SERIAL PRIMARY KEY,
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
  UNIQUE(external_id),
  CONSTRAINT fk_product_currency FOREIGN KEY (currency_id) REFERENCES currency(id),
  CONSTRAINT fk_product_uom FOREIGN KEY (unit_of_measure_id) REFERENCES unit_of_measure(id)
);

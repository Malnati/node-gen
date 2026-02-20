-- test/e2e-generator-mock/projects/addresses/db/database.postgres.ddl
CREATE TABLE country (
  id SERIAL PRIMARY KEY,
  code VARCHAR(2) NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(code)
);

CREATE TABLE state (
  id SERIAL PRIMARY KEY,
  country_id INT NOT NULL REFERENCES country(id),
  code VARCHAR(20) NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(country_id, code)
);

CREATE TABLE city (
  id SERIAL PRIMARY KEY,
  state_id INT NOT NULL REFERENCES state(id),
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE address (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  street TEXT NOT NULL,
  zip_code TEXT,
  country_id INT NOT NULL REFERENCES country(id),
  state_id INT NOT NULL REFERENCES state(id),
  city_id INT NOT NULL REFERENCES city(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id)
);

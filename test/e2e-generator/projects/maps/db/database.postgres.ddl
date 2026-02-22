-- test/e2e-generator/projects/maps/db/database.postgres.ddl
CREATE TABLE map_provider_config (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  provider_code TEXT NOT NULL,
  endpoint_url TEXT,
  api_key_ref TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_map_provider_config PRIMARY KEY (id),
  CONSTRAINT uk_map_provider_config_external_id UNIQUE(external_id)
);

COMMENT ON TABLE map_provider_config IS 'Configuração de provedor de mapas por tenant.';
COMMENT ON COLUMN map_provider_config.id IS 'Identificador interno.';
COMMENT ON COLUMN map_provider_config.external_id IS 'UUID público.';
COMMENT ON COLUMN map_provider_config.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN map_provider_config.provider_code IS 'Código do provedor.';
COMMENT ON COLUMN map_provider_config.endpoint_url IS 'URL do endpoint.';
COMMENT ON COLUMN map_provider_config.api_key_ref IS 'Referência à API key.';
COMMENT ON COLUMN map_provider_config.created_at IS 'Data de criação.';
COMMENT ON COLUMN map_provider_config.updated_at IS 'Última atualização.';
COMMENT ON COLUMN map_provider_config.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_map_provider_config ON map_provider_config IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_map_provider_config_external_id ON map_provider_config IS 'UUID único.';

CREATE TABLE geocode_cache (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  address_hash TEXT,
  raw_address TEXT,
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_geocode_cache PRIMARY KEY (id),
  CONSTRAINT uk_geocode_cache_external_id UNIQUE(external_id)
);

COMMENT ON TABLE geocode_cache IS 'Cache de geocódigo por endereço.';
COMMENT ON COLUMN geocode_cache.id IS 'Identificador interno.';
COMMENT ON COLUMN geocode_cache.external_id IS 'UUID público.';
COMMENT ON COLUMN geocode_cache.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN geocode_cache.address_hash IS 'Hash do endereço.';
COMMENT ON COLUMN geocode_cache.raw_address IS 'Endereço bruto.';
COMMENT ON COLUMN geocode_cache.latitude IS 'Latitude.';
COMMENT ON COLUMN geocode_cache.longitude IS 'Longitude.';
COMMENT ON COLUMN geocode_cache.created_at IS 'Data de criação.';
COMMENT ON COLUMN geocode_cache.updated_at IS 'Última atualização.';
COMMENT ON COLUMN geocode_cache.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_geocode_cache ON geocode_cache IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_geocode_cache_external_id ON geocode_cache IS 'UUID único.';

CREATE TABLE route_cache (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  origin_key TEXT,
  destination_key TEXT,
  distance_km DECIMAL(10,2),
  duration_min DECIMAL(8,2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_route_cache PRIMARY KEY (id),
  CONSTRAINT uk_route_cache_external_id UNIQUE(external_id)
);

COMMENT ON TABLE route_cache IS 'Cache de rotas (origem-destino).';
COMMENT ON COLUMN route_cache.id IS 'Identificador interno.';
COMMENT ON COLUMN route_cache.external_id IS 'UUID público.';
COMMENT ON COLUMN route_cache.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN route_cache.origin_key IS 'Chave da origem.';
COMMENT ON COLUMN route_cache.destination_key IS 'Chave do destino.';
COMMENT ON COLUMN route_cache.distance_km IS 'Distância em km.';
COMMENT ON COLUMN route_cache.duration_min IS 'Duração em minutos.';
COMMENT ON COLUMN route_cache.created_at IS 'Data de criação.';
COMMENT ON COLUMN route_cache.updated_at IS 'Última atualização.';
COMMENT ON COLUMN route_cache.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_route_cache ON route_cache IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_route_cache_external_id ON route_cache IS 'UUID único.';

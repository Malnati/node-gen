-- test/e2e-generator/projects/maps/db/database.sqlite.ddl
-- Configuração de provedor de mapas por tenant.
CREATE TABLE map_provider_config (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  provider_code TEXT NOT NULL, -- Código do provedor.
  endpoint_url TEXT, -- URL do endpoint.
  api_key_ref TEXT, -- Referência à API key.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Cache de geocódigo por endereço.
CREATE TABLE geocode_cache (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  address_hash TEXT, -- Hash do endereço.
  raw_address TEXT, -- Endereço bruto.
  latitude REAL, -- Latitude.
  longitude REAL, -- Longitude.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Cache de rotas (origem-destino).
CREATE TABLE route_cache (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  origin_key TEXT, -- Chave da origem.
  destination_key TEXT, -- Chave do destino.
  distance_km REAL, -- Distância em km.
  duration_min REAL, -- Duração em minutos.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

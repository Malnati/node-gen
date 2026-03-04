-- test/e2e-generator/projects/maps/db/database.mysql.ddl
CREATE TABLE map_provider_config (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  provider_code VARCHAR(50) NOT NULL COMMENT 'Código do provedor.',
  endpoint_url VARCHAR(500) COMMENT 'URL do endpoint.',
  api_key_ref VARCHAR(255) COMMENT 'Referência à API key.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_map_provider_config_external_id (external_id)
) COMMENT = 'Configuração de provedor de mapas por tenant.';

CREATE TABLE geocode_cache (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  address_hash VARCHAR(64) COMMENT 'Hash do endereço.',
  raw_address VARCHAR(500) COMMENT 'Endereço bruto.',
  latitude DECIMAL(10,7) COMMENT 'Latitude.',
  longitude DECIMAL(10,7) COMMENT 'Longitude.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_geocode_cache_external_id (external_id)
) COMMENT = 'Cache de geocódigo por endereço.';

CREATE TABLE route_cache (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  origin_key VARCHAR(255) COMMENT 'Chave da origem.',
  destination_key VARCHAR(255) COMMENT 'Chave do destino.',
  distance_km DECIMAL(10,2) COMMENT 'Distância em km.',
  duration_min DECIMAL(8,2) COMMENT 'Duração em minutos.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_route_cache_external_id (external_id)
) COMMENT = 'Cache de rotas (origem-destino).';

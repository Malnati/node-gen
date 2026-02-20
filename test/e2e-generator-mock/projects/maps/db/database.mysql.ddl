-- test/e2e-generator-mock/projects/maps/db/database.mysql.ddl
CREATE TABLE map_provider_config (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  provider_code VARCHAR(50) NOT NULL,
  endpoint_url VARCHAR(500),
  api_key_ref VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_map_provider_config_external_id (external_id)
);

CREATE TABLE geocode_cache (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  address_hash VARCHAR(64),
  raw_address VARCHAR(500),
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_geocode_cache_external_id (external_id)
);

CREATE TABLE route_cache (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  origin_key VARCHAR(255),
  destination_key VARCHAR(255),
  distance_km DECIMAL(10,2),
  duration_min DECIMAL(8,2),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_route_cache_external_id (external_id)
);

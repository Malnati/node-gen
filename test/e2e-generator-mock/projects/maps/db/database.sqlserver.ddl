-- test/e2e-generator-mock/projects/maps/db/database.sqlserver.ddl
CREATE TABLE map_provider_config (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  provider_code NVARCHAR(50) NOT NULL,
  endpoint_url NVARCHAR(500),
  api_key_ref NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_map_provider_config_external_id UNIQUE (external_id)
);

CREATE TABLE geocode_cache (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  address_hash NVARCHAR(64),
  raw_address NVARCHAR(500),
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_geocode_cache_external_id UNIQUE (external_id)
);

CREATE TABLE route_cache (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  origin_key NVARCHAR(255),
  destination_key NVARCHAR(255),
  distance_km DECIMAL(10,2),
  duration_min DECIMAL(8,2),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_route_cache_external_id UNIQUE (external_id)
);

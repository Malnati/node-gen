-- test/e2e-generator-mock/projects/maps/db/database.sqlserver.ddl
CREATE TABLE map_provider_config (
  id INT IDENTITY(1,1),
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  provider_code NVARCHAR(50) NOT NULL,
  endpoint_url NVARCHAR(500),
  api_key_ref NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_map_provider_config_external_id UNIQUE (external_id)
,
  CONSTRAINT pk_map_provider_config PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Configuração de provedor de mapas por tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Código do provedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'provider_code';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'URL do endpoint.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'endpoint_url';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Referência à API key.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'api_key_ref';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'CONSTRAINT', @level2name = N'uk_map_provider_config_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'map_provider_config', @level2type = N'CONSTRAINT', @level2name = N'pk_map_provider_config';

CREATE TABLE geocode_cache (
  id INT IDENTITY(1,1),
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
,
  CONSTRAINT pk_geocode_cache PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Cache de geocódigo por endereço.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Hash do endereço.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'address_hash';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Endereço bruto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'raw_address';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Latitude.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'latitude';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Longitude.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'longitude';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'CONSTRAINT', @level2name = N'uk_geocode_cache_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'geocode_cache', @level2type = N'CONSTRAINT', @level2name = N'pk_geocode_cache';

CREATE TABLE route_cache (
  id INT IDENTITY(1,1),
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
,
  CONSTRAINT pk_route_cache PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Cache de rotas (origem-destino).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave da origem.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'origin_key';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave do destino.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'destination_key';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Distância em km.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'distance_km';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Duração em minutos.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'duration_min';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'CONSTRAINT', @level2name = N'uk_route_cache_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'route_cache', @level2type = N'CONSTRAINT', @level2name = N'pk_route_cache';

-- test/e2e-generator-mock/projects/maps/db/database.postgres.sql
INSERT INTO map_provider_config (external_id, tenant, provider_code, endpoint_url, api_key_ref) VALUES
('mp1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','osm','https://nominatim.fic-example.example','vault:osm:ref');

INSERT INTO geocode_cache (external_id, tenant, address_hash, raw_address, latitude, longitude) VALUES
('gc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a1b2c3d4','Rua Fictícia 1, Lisboa',38.722252,-9.139337);

INSERT INTO route_cache (external_id, tenant, origin_key, destination_key, distance_km, duration_min) VALUES
('rc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','38.72,-9.14','38.73,-9.15',2.50,8.00);

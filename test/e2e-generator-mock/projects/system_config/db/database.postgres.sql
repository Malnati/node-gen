-- test/e2e-generator-mock/projects/system_config/db/database.postgres.sql
INSERT INTO system_config (external_id, tenant, config_key, config_value, value_type) VALUES
('sc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','app.timezone','Europe/Lisbon','string'),
('sc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','app.locale','pt-PT','string');

INSERT INTO integration_config (external_id, tenant, integration_code, endpoint_url, credentials_ref, enabled) VALUES
('ic1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','payment_gateway','https://api.fic-gateway.example/v1','vault:payment:ref',true);

INSERT INTO webhook (external_id, tenant, url, event_type, secret_hash, enabled) VALUES
('wb1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','https://app-ficticia.example/webhooks/orders','order.created',NULL,true);

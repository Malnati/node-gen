-- test/e2e-generator/projects/config/db/database.sqlite.sql
INSERT INTO config (external_id, tenant, config_key, config_value, value_type) VALUES
('sc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','app.timezone','Europe/Lisbon','string'),
('sc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','app.locale','pt-PT','string');

INSERT INTO integration_config (external_id, tenant, integration_code, endpoint_url, credentials_ref, enabled) VALUES
('ic1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','payment_gateway','https://api.fic-gateway.example/v1','vault:payment:ref',1);

INSERT INTO webhook (external_id, tenant, url, event_type, secret_hash, enabled) VALUES
('wb1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','https://app-ficticia.example/webhooks/orders','order.created',NULL,1);

INSERT INTO branding (external_id, tenant, name, logo_url, logo_ref, favicon_url, primary_color) VALUES
('br1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Minha Marca','https://cdn.example.com/logo.png','vault:branding:logo','https://cdn.example.com/favicon.ico','#2D0F55');

INSERT INTO label (external_id, tenant, code, value, locale) VALUES
('lb1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','app.name','Minha Marca','pt-PT'),
('lb1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','login.title','Entrar',NULL),
('lb1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','welcome.message','Bem-vindo ao sistema',NULL);

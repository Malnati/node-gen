-- test/e2e-generator-mock/projects/payments/db/database.sqlite.sql
INSERT INTO currency (external_id, code, name, symbol, region) VALUES
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','BRL','Real brasileiro','R$','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','USD','US Dollar','$','NORTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','EUR','Euro','€','EUROPE'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a04','GBP','British Pound','£','EUROPE'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a05','MXN','Mexican Peso','$','NORTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a06','ARS','Argentine Peso','$','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a07','COP','Colombian Peso','$','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a08','CLP','Chilean Peso','$','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a09','PEN','Peruvian Sol','S/','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0a','CAD','Canadian Dollar','$','NORTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0b','CHF','Swiss Franc','CHF','EUROPE');

INSERT INTO payment_type (external_id, code, name, description) VALUES
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','DEBITO','Débito',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','CREDITO','Crédito',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','PIX','Pix',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a04','BOLETO','Boleto',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a05','CRIPTO','Criptomoeda',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a06','SWIFT','SWIFT',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a07','SEPA','SEPA',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a08','ACH','ACH',NULL);

INSERT INTO payment (external_id, tenant, account_id, contact_id, billing_address_id, payment_type_id, currency_id, amount, status) VALUES
('p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',(SELECT id FROM payment_type WHERE code='PIX' LIMIT 1),(SELECT id FROM currency WHERE code='BRL' LIMIT 1),100.00,'completed'),
('p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',(SELECT id FROM payment_type WHERE code='CREDITO' LIMIT 1),(SELECT id FROM currency WHERE code='BRL' LIMIT 1),250.50,'pending'),
('p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',NULL,NULL,(SELECT id FROM payment_type WHERE code='BOLETO' LIMIT 1),(SELECT id FROM currency WHERE code='BRL' LIMIT 1),500.00,'pending');

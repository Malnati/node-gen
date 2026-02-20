-- test/e2e-generator-mock/projects/transactions/db/database.sqlite.sql
INSERT INTO transaction (tenant, account_id, payment_method_id, amount, currency_code, status, external_reference) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',99.90,'BRL','completed','PIX-001'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',250.00,'BRL','pending','CARD-002'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',50.00,'BRL','refunded','PIX-003');

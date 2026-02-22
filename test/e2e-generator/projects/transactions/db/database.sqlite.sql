-- test/e2e-generator/projects/transactions/db/database.sqlite.sql
INSERT INTO "transaction" (external_id, tenant, account_id, payment_id, amount, currency_code, status, external_reference) VALUES
('t1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',100.00,'BRL','completed','ref-001'),
('t1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',250.50,'BRL','pending',NULL),
('t1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',500.00,'BRL','pending','boleto-002');

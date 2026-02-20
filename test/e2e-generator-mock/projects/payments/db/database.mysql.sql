-- test/e2e-generator-mock/projects/payments/db/database.mysql.sql
INSERT INTO payment_type (external_id, code, name, description) VALUES
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','DEBITO','Débito',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','CREDITO','Crédito',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','PIX','Pix',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a04','BOLETO','Boleto',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a05','CRIPTO','Criptomoeda',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a06','SWIFT','SWIFT',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a07','SEPA','SEPA',NULL),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a08','ACH','ACH',NULL);

INSERT INTO payment (external_id, tenant, account_id, contact_id, billing_address_id, payment_type_id, currency_id, amount, status)
SELECT 'p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',pt.id,'a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',100.00,'completed'
FROM payment_type pt WHERE pt.code='PIX' LIMIT 1;
INSERT INTO payment (external_id, tenant, account_id, contact_id, billing_address_id, payment_type_id, currency_id, amount, status)
SELECT 'p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',pt.id,'a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',250.50,'pending'
FROM payment_type pt WHERE pt.code='CREDITO' LIMIT 1;
INSERT INTO payment (external_id, tenant, account_id, contact_id, billing_address_id, payment_type_id, currency_id, amount, status)
SELECT 'p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',NULL,NULL,pt.id,'a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',500.00,'pending'
FROM payment_type pt WHERE pt.code='BOLETO' LIMIT 1;

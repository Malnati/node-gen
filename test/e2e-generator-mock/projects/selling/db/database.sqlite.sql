-- test/e2e-generator-mock/projects/selling/db/database.sqlite.sql
INSERT INTO sale (external_id, tenant, account_id, order_id, payment_id, billing_address_id, shipping_address_id, status, total, currency_code) VALUES
('s1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','confirmed',129.80,'BRL'),
('s1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',NULL,'f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','draft',250.50,'BRL');

INSERT INTO sale_item (external_id, tenant, sale_id, product_id, quantity, unit_price) VALUES
('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',2,29.90),
('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',1,45.00),
('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',2,'d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',3,45.00);

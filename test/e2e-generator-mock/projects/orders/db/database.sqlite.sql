-- test/e2e-generator-mock/projects/orders/db/database.sqlite.sql
INSERT INTO "order" (external_id, tenant, account_id, shipping_address_id, billing_address_id, payment_id, status, total, currency_code) VALUES
('w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','confirmed',129.80,'BRL'),
('w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','p1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','draft',250.50,'BRL');

INSERT INTO order_item (external_id, tenant, order_id, product_id, quantity, unit_price) VALUES
('z1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',2,29.90),
('z1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',1,45.00),
('z1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',3,45.00);

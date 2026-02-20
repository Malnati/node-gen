-- test/e2e-generator-mock/projects/selling/db/database.sqlserver.sql
INSERT INTO tb_customer (external_id, tenant, name, email, is_active) VALUES
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Cliente A','cliente.a@example.com',1);

INSERT INTO tb_payment_method (external_id, tenant, code, name) VALUES
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','CARD','Cartão');

INSERT INTO tb_order (external_id, tenant, customer_id, payment_method_id, status, total, discount) VALUES
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,1,'confirmed',100.00,0);

INSERT INTO tb_order_line (order_id, line_number, tenant, external_id, product_sku, product_name, quantity, unit_price, line_total) VALUES
(1,1,'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','SKU-001','Produto 1',2,50.00,100.00);

INSERT INTO tb_payment (external_id, tenant, order_id, amount, reference) VALUES
('e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,100.00,'REF-001');

INSERT INTO tb_stock_movement (external_id, tenant, product_sku, quantity, movement_type) VALUES
('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','SKU-001',-2,'out');

INSERT INTO tb_customer_address (external_id, tenant, customer_id, street, city, state, zip_code, is_default) VALUES
('g1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'Rua Exemplo 1','São Paulo','SP','01000-000',1);

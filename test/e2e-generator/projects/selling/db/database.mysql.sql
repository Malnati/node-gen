-- test/e2e-generator/projects/selling/db/database.mysql.sql
INSERT INTO tb_order (external_id, tenant, account_id, status, total, discount) VALUES
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','confirmed',100.00,0);

INSERT INTO tb_order_line (order_id, line_number, tenant, external_id, product_id, product_name, quantity, unit_price, line_total) VALUES
(1,1,'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','Produto 1',2,50.00,100.00);

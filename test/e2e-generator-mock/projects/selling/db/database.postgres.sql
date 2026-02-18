-- test/e2e-generator-mock/projects/selling/db/database.postgres.sql
INSERT INTO tb_payment_method (code, name) VALUES ('CARD','Cartão'),('PIX','PIX'),('BOLETO','Boleto');
INSERT INTO tb_customer (name, email, credit_limit, is_active) VALUES
('Cliente A','a@example.com',1000.00,true),('Cliente B','b@example.com',2000.00,true),('Cliente C','c@example.com',3000.00,true);
INSERT INTO tb_order (customer_id, payment_method_id, status, total, discount) VALUES
(1,1,'pending',150.00,0),(2,2,'paid',320.50,10.00),(3,1,'cancelled',0,0);
INSERT INTO tb_order_line (order_id, line_number, product_sku, product_name, quantity, unit_price, line_total) VALUES
(1,1,'SKU-001','Produto 1',2,75.00,150.00),(2,1,'SKU-002','Produto 2',1,320.50,320.50);
INSERT INTO tb_payment (order_id, amount, reference) VALUES (2,310.50,'PIX-001');
INSERT INTO tb_customer_address (customer_id, street, city, state, is_default) VALUES
(1,'Rua 1','Cidade A','SP',true),(2,'Rua 2','Cidade B','RJ',true);

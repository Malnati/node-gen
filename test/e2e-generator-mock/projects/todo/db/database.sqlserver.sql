-- test/e2e-generator-mock/projects/todo/db/database.sqlserver.sql
INSERT INTO tb_simple_item (external_id, tenant, name) VALUES
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Item 1');

INSERT INTO tb_category (external_id, tenant, code, name, is_active) VALUES
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','CAT-A','Categoria A',1);

INSERT INTO tb_product (external_id, tenant, category_id, name, unit_price, stock_quantity) VALUES
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'Produto 1',10.50,100);

INSERT INTO tb_sale (external_id, tenant, total) VALUES
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',21.00);

INSERT INTO tb_sale_item (sale_id, product_id, tenant, external_id, quantity, unit_price) VALUES
(1,1,'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',2,10.50);

INSERT INTO tb_tag (external_id, tenant, name, slug) VALUES
('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','destaque','destaque');

INSERT INTO tb_product_tag (product_id, tag_id, tenant, external_id) VALUES
(1,1,'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','g1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01');

INSERT INTO tb_document (external_id, tenant, product_id, file_name, mime_type, file_size) VALUES
('h1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'doc1.pdf','application/pdf',0);

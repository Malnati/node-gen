-- test/e2e-generator-mock/projects/products/db/database.sqlserver.sql
INSERT INTO product (external_id, tenant, account_id, sku, name, description, unit_price, currency_code) VALUES
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','SKU-001','Produto Alfa','Descrição fictícia do produto Alfa.',29.90,'BRL'),
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','SKU-002','Produto Beta','Descrição fictícia do produto Beta.',45.00,'BRL'),
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','SKU-003','Produto Gama',NULL,99.00,'BRL');

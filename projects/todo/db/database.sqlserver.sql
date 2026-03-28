-- test/e2e-generator/projects/todo/db/database.sqlserver.sql
INSERT INTO tb_category (external_id, tenant, code, name, is_active) VALUES
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','CAT-A','Categoria A',1);

INSERT INTO tb_simple_item (external_id, tenant, name, category_id) VALUES
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Item 1',1);

INSERT INTO tb_tag (external_id, tenant, name, slug) VALUES
('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','destaque','destaque');

INSERT INTO tb_simple_item_tag (simple_item_id, tag_id, tenant, external_id) VALUES
(1,1,'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','g1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01');

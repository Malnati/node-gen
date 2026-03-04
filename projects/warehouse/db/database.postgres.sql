-- test/e2e-generator/projects/warehouse/db/database.postgres.sql
INSERT INTO warehouse_stock (external_id, tenant, product_id, address_id, quantity, reserved) VALUES
('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',100,5),
('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',50,0),
('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',200,10);

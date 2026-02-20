-- test/e2e-generator-mock/projects/contacts/db/database.sqlite.sql
INSERT INTO contact (tenant, account_id, address_id, name, email, phone, company) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','João Silva','joao@example.com','+5511999990001','Empresa A'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',NULL,'Maria Santos','maria@example.com','+5511999990002','Empresa B'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','Pedro Costa','pedro@example.com','+5511999990003',NULL);

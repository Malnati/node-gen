-- test/e2e-generator-mock/projects/roles/db/database.sqlserver.sql
INSERT INTO [role] (external_id, tenant, name, description) VALUES
('ra1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','admin','Administrador do sistema'),
('ra1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','operador','Operador com permissões limitadas');

INSERT INTO feature (external_id, tenant, code, name, description) VALUES
('fa1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','orders.create','Criar pedidos',NULL),
('fa1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','orders.read','Consultar pedidos',NULL);

INSERT INTO role_feature (external_id, tenant, role_id, feature_id) VALUES
('rf1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ra1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','fa1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
('rf1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ra1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','fa1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12'),
('rf1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ra1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','fa1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12');

INSERT INTO user_role (external_id, tenant, user_id, account_id, role_id) VALUES
('ur1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ra1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
('ur1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','ra1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12');

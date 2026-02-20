-- test/e2e-generator-mock/projects/notifications/db/database.sqlserver.sql
INSERT INTO notification (external_id, tenant, account_id, user_id, contact_id, channel, subject, body, read_at) VALUES
('n1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',NULL,'email','Bem-vindo','Mensagem de boas-vindas ao sistema.',NULL),
('n1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','email','Pagamento pendente','O pagamento está pendente de confirmação.',NULL);

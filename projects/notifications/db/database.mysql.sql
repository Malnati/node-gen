-- test/e2e-generator/projects/notifications/db/database.mysql.sql
INSERT INTO notification_template (external_id, tenant, code, name, channel, subject_tpl, body_tpl) VALUES
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','welcome','Boas-vindas','email','Bem-vindo','Mensagem de boas-vindas ao sistema.');

INSERT INTO notification (external_id, tenant, account_id, user_id, contact_id, template_id, channel, priority, subject, body, read_at) VALUES
('n1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',NULL,'a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','email','normal','Bem-vindo','Mensagem de boas-vindas ao sistema.',NULL),
('n1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',NULL,'email','high','Pagamento pendente','O pagamento está pendente de confirmação.',NULL);

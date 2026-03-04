-- test/e2e-generator/projects/gmail/db/database.sqlite.sql
INSERT INTO gmail_integration (external_id, tenant, account_id, connected_email, oauth_ref, last_sync_at) VALUES
('a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','integracao@example.com','vault:gmail:oauth-ref','2025-02-20 10:00:00');

INSERT INTO gmail_message_template (external_id, tenant, account_id, code, name, subject_tpl, body_tpl) VALUES
('b01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','boas_vindas','Boas-vindas','Bem-vindo, {{nome}}','Olá {{nome}}, obrigado por se cadastrar.');

INSERT INTO gmail_message (external_id, tenant, account_id, integration_id, gmail_message_id, gmail_thread_id, direction, subject, from_addr, to_addr, body_preview, sent_at) VALUES
('c01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','msg-api-001',NULL,'sent','Assunto 1','integracao@example.com','destino@example.com','Preview do corpo 1','2025-02-19 14:00:00'),
('c01eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','msg-api-002',NULL,'received','Re: Assunto 1','destino@example.com','integracao@example.com','Resposta breve.','2025-02-19 15:30:00');

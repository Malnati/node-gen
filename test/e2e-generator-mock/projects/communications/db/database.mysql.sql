-- test/e2e-generator-mock/projects/communications/db/database.mysql.sql
INSERT INTO email_template (external_id, tenant, code, name, subject_tpl, body_tpl) VALUES
('et1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','welcome_email','Bem-vindo','Bem-vindo, {{name}}','Corpo do e-mail de boas-vindas.');

INSERT INTO smtp_config (external_id, tenant, account_id, host, port, use_tls, credentials_ref) VALUES
('sm1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','smtp.fic-example.example',587,1,'vault:smtp:ref');

INSERT INTO send_history (external_id, tenant, template_id, recipient, sent_at, status) VALUES
('sh1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','et1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','destinatario@fic.example',NOW(),'sent');

INSERT INTO delivery_tracking (external_id, tenant, send_history_id, event_type, event_at) VALUES
('dt1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','sh1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','delivered',NOW());

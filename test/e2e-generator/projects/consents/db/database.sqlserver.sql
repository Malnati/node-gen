-- test/e2e-generator/projects/consents/db/database.sqlserver.sql
INSERT INTO consent_record (external_id, tenant, account_id, user_id, consent_type, granted_at, ip_address, version) VALUES
('cr1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','marketing',GETDATE(),'192.168.1.1','1.0'),
('cr1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','privacy',GETDATE(),NULL,'1.0');

INSERT INTO notification_preference (external_id, tenant, account_id, user_id, channel, opt_in) VALUES
('np1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','email',1),
('np1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','sms',0),
('np1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','push',1);

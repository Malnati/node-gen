-- test/e2e-generator-mock/projects/accounts/db/database.sqlserver.sql
INSERT INTO account (external_id, tenant, name, account_type, balance, currency_code) VALUES
('e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Conta Corrente Alpha','checking',1500.00,'BRL'),
('e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Conta Poupança Beta','savings',5000.00,'BRL'),
('e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','Conta Gama','checking',320.50,'BRL');

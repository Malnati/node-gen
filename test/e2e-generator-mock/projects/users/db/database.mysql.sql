-- test/e2e-generator-mock/projects/users/db/database.mysql.sql
INSERT INTO app_user (tenant, account_id, address_id, username, email, password_hash) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','alice','alice@example.com','$2a$10$hash1'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',NULL,'bob','bob@example.com','$2a$10$hash2'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','carol','carol@example.com','$2a$10$hash3');

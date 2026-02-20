-- test/e2e-generator-mock/projects/users/db/database.sqlserver.sql
INSERT INTO app_user (username, email, password_hash) VALUES
('alice','alice@example.com','$2a$10$hash1'),
('bob','bob@example.com','$2a$10$hash2'),
('carol','carol@example.com','$2a$10$hash3');

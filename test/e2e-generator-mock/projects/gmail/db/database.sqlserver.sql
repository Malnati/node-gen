-- test/e2e-generator-mock/projects/gmail/db/database.sqlserver.sql
INSERT INTO email_message (message_id, subject, from_addr, to_addr, body_preview) VALUES
('msg-001','Assunto 1','from@example.com','to@example.com','Preview do corpo 1'),
('msg-002','Assunto 2','outro@example.com','dest@example.com','Preview do corpo 2'),
('msg-003','Re: Assunto 1','to@example.com','from@example.com','Resposta breve.');

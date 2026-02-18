-- test/e2e-generator-mock/projects/schedule/db/database.mysql.sql
INSERT INTO tb_recurrence_rule (code, name, cron_expression) VALUES ('DAILY','Diário','0 9 * * *'),('WEEKLY','Semanal','0 9 * * 1');
INSERT INTO tb_resource (name, resource_type, capacity, parent_id) VALUES ('Sala A','room',10,NULL),('Sala B','room',5,1);
INSERT INTO tb_slot (resource_id, start_at, end_at, status) VALUES
(1,'2025-02-18 09:00:00','2025-02-18 10:00:00','available'),
(1,'2025-02-18 10:00:00','2025-02-18 11:00:00','available'),
(2,'2025-02-18 14:00:00','2025-02-18 15:00:00','available');
INSERT INTO tb_booking (slot_id, recurrence_rule_id, title, description) VALUES (1,1,'Reunião 1','Desc'),(2,NULL,'Reunião 2',NULL);
INSERT INTO tb_participant (name, email) VALUES ('Alice','alice@example.com'),('Bob','bob@example.com');
INSERT INTO tb_booking_participant (booking_id, participant_id, role) VALUES (1,1,'owner'),(1,2,'attendee'),(2,1,'owner');
INSERT INTO tb_booking_history (booking_id, action, changed_at, snapshot) VALUES (1,'created','2025-02-18 08:00:00','{"title":"Reunião 1"}');

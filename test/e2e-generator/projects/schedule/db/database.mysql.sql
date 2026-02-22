-- test/e2e-generator/projects/schedule/db/database.mysql.sql
USE schedule;
INSERT INTO tb_resource (external_id, tenant, name, resource_type, capacity) VALUES
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Sala A','room',10);

INSERT INTO tb_slot (external_id, tenant, resource_id, start_at, end_at, status) VALUES
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'2024-12-01 09:00:00','2024-12-01 10:00:00','available');

INSERT INTO tb_recurrence_rule (external_id, tenant, code, name, cron_expression) VALUES
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','DAILY','Diário','0 9 * * *');

INSERT INTO tb_booking (external_id, tenant, slot_id, organizer_account_id, title) VALUES
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','Reunião');

INSERT INTO tb_booking_participant (booking_id, account_id, tenant, external_id, role) VALUES
(1,'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','organizer');

INSERT INTO tb_booking_history (external_id, tenant, booking_id, action, changed_at, snapshot) VALUES
('g1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'created','2024-12-01 08:00:00','{}');

-- test/e2e-generator-mock/projects/scheduling/db/database.sqlserver.sql
INSERT INTO calendar (external_id, tenant, account_id, user_id, name, timezone) VALUES
('ca1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Calendário Principal','Europe/Lisbon');

INSERT INTO time_slot (external_id, tenant, calendar_id, start_at, end_at, available) VALUES
('ts1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ca1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','2025-03-01 09:00:00','2025-03-01 10:00:00',1),
('ts1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ca1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','2025-03-01 10:00:00','2025-03-01 11:00:00',1);

INSERT INTO booking (external_id, tenant, time_slot_id, user_id, account_id, status) VALUES
('bk1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ts1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','u1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','confirmed');

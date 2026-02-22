-- test/e2e-generator/projects/google-calendar/db/database.postgres.sql
INSERT INTO calendar_integration (external_id, tenant, account_id, connected_email, oauth_ref, last_sync_at) VALUES
('a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','calendar@example.com','vault:gcal:oauth-ref','2025-02-20 10:00:00+00');

INSERT INTO calendar (external_id, tenant, account_id, integration_id, name, timezone, google_calendar_id) VALUES
('ca1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Calendário Principal','Europe/Lisbon','gcal-primary-001');

INSERT INTO calendar_event (external_id, tenant, account_id, integration_id, calendar_id, title, description, start_at, end_at, all_day, google_event_id, status) VALUES
('ev1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ca1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Reunião E2E','Descrição da reunião.','2025-03-01 09:00:00+00','2025-03-01 10:00:00+00',false,'gcal-event-001','confirmed'),
('ev1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ca1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Almoço','Evento dia inteiro.','2025-03-02 00:00:00+00','2025-03-02 23:59:59+00',true,'gcal-event-002','confirmed');

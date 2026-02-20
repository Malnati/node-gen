-- test/e2e-generator-mock/projects/logistics/db/database.sqlserver.sql
INSERT INTO shipment (external_id, tenant, order_id, origin_address_id, destination_address_id, driver_contact_id, receiver_contact_id, status, tracking_code) VALUES
('l1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','in_transit','TRK-2025-001'),
('l1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',NULL,'c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','pending',NULL);

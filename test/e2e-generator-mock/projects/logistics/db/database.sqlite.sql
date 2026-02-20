-- test/e2e-generator-mock/projects/logistics/db/database.sqlite.sql
INSERT INTO shipment (external_id, tenant, order_id, origin_address_id, destination_address_id, driver_contact_id, receiver_contact_id, carrier, status, tracking_code, estimated_delivery_at) VALUES
('l1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Transportadora Fictícia','in_transit','TRK-2025-001','2025-03-05 18:00:00'),
('l1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',NULL,'c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','pending',NULL,NULL);

INSERT INTO shipment_event (external_id, tenant, shipment_id, event_type, event_at, location_text) VALUES
('se1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','l1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','in_transit','2025-02-20 10:00:00','Centro de distribuição São Paulo');

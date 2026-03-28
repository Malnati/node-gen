-- test/e2e-generator/projects/google-drive/db/database.mysql.sql
INSERT INTO drive_integration (external_id, tenant, account_id, connected_email, oauth_ref, last_sync_at) VALUES
('a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','drive@example.com','vault:gdrive:oauth-ref','2025-02-20 10:00:00');

INSERT INTO drive_folder (external_id, tenant, account_id, integration_id, name, drive_folder_id) VALUES
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Documentos','gdrive-folder-001');

INSERT INTO drive_file (external_id, tenant, account_id, integration_id, folder_id, file_name, mime_type, size_bytes, drive_file_id) VALUES
('df1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','doc.pdf','application/pdf',102400,'drive-id-001'),
('df1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','planilha.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',51200,'drive-id-002'),
('df1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',NULL,'foto.png','image/png',204800,NULL);

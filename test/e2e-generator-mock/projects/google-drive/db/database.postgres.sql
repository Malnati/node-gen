-- test/e2e-generator-mock/projects/google-drive/db/database.postgres.sql
INSERT INTO drive_file (file_name, mime_type, size_bytes, drive_file_id) VALUES
('doc.pdf','application/pdf',102400,'drive-id-001'),
('planilha.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',51200,'drive-id-002'),
('foto.png','image/png',204800,NULL);

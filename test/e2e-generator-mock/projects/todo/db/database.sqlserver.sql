-- test/e2e-generator-mock/projects/todo/db/database.sqlserver.sql
INSERT INTO project (external_id, tenant, name) VALUES
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Project1'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Project2'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','Project3');

INSERT INTO status (external_id, tenant, code, name) VALUES
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',NULL,'open','Open'),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02',NULL,'in_progress','In Progress'),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03',NULL,'closed','Closed');

INSERT INTO tag (external_id, tenant, name) VALUES
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','urgent'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','task');

INSERT INTO todo (external_id, tenant, account_id, project_id, status_id, title, description, due_date) VALUES
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',1,1,'Todo 1','Desc 1','2024-12-01'),
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02',2,2,'Todo 2','Desc 2','2024-12-02'),
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03',3,3,'Todo 3','Desc 3','2024-12-03');

INSERT INTO todo_tag (todo_id, tag_id) VALUES (1,1),(2,2),(3,1);

INSERT INTO project_member (external_id, tenant, account_id, project_id, role) VALUES
('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',1,'admin'),
('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02',2,'member'),
('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03',3,'member');

INSERT INTO comment (external_id, tenant, todo_id, author_id, content) VALUES
('g1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','Comment 1'),
('g1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',2,'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','Comment 2');

INSERT INTO attachment (external_id, tenant, todo_id, file_ref) VALUES
('h1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',1,'storage://todo/attachments/att1'),
('h1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',2,'storage://todo/attachments/att2');

INSERT INTO note (external_id, tenant, account_id, content) VALUES
('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','Note 1'),
('i1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','Note 2');

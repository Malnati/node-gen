INSERT INTO `user` (name, email, is_active) VALUES
('Alice','alice@example.com', true),
('Bob','bob@example.com', true),
('Carol','carol@example.com', true),
('Dave','dave@example.com', true),
('Eve','eve@example.com', true),
('Frank','frank@example.com', true),
('Grace','grace@example.com', true),
('Heidi','heidi@example.com', true),
('Ivan','ivan@example.com', true),
('Judy','judy@example.com', true);

INSERT INTO project (name, budget) VALUES
('Project A', 1000.00),('Project B', 2000.00),('Project C', 3000.00),('Project D', 4000.00),('Project E', 5000.00),('Project F', 6000.00),('Project G', 7000.00),('Project H', 8000.00),('Project I', 9000.00),('Project J', 10000.00);

INSERT INTO user_project (user_id, project_id, role) VALUES
(1,1,'admin'),(2,1,'member'),(3,2,'member'),(4,3,'member'),(5,4,'member'),(6,5,'member'),(7,6,'member'),(8,7,'member'),(9,8,'member'),(10,9,'member');

INSERT INTO todo (user_id, project_id, title, status, completed) VALUES
(1,1,'Tarefa 1','open', false),(2,1,'Tarefa 2','open', false),(3,2,'Tarefa 3','open', false),(4,3,'Tarefa 4','open', false),(5,4,'Tarefa 5','open', false),(6,5,'Tarefa 6','open', false),(7,6,'Tarefa 7','open', false),(8,7,'Tarefa 8','open', false),(9,8,'Tarefa 9','open', false),(10,9,'Tarefa 10','open', false);

INSERT INTO tag (name) VALUES
('urgent'),('low'),('medium'),('high'),('enhancement'),('bug'),('task'),('idea'),('research'),('misc');

INSERT INTO todo_tag (todo_id, tag_id) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);

INSERT INTO comment (todo_id, user_id, message) VALUES
(1,2,'ok'),(2,3,'ok'),(3,4,'ok'),(4,5,'ok'),(5,6,'ok'),(6,7,'ok'),(7,8,'ok'),(8,9,'ok'),(9,10,'ok'),(10,1,'ok');

INSERT INTO attachment (todo_id,file) VALUES
(1,X'00'),(2,X'00'),(3,X'00'),(4,X'00'),(5,X'00'),(6,X'00'),(7,X'00'),(8,X'00'),(9,X'00'),(10,X'00');

INSERT INTO address (user_id,street,city,state) VALUES
(1,'R1','C1','S1'),(2,'R2','C2','S2'),(3,'R3','C3','S3'),(4,'R4','C4','S4'),(5,'R5','C5','S5'),(6,'R6','C6','S6'),(7,'R7','C7','S7'),(8,'R8','C8','S8'),(9,'R9','C9','S9'),(10,'R10','C10','S10');

INSERT INTO note (user_id,content) VALUES
(1,'n1'),(2,'n2'),(3,'n3'),(4,'n4'),(5,'n5'),(6,'n6'),(7,'n7'),(8,'n8'),(9,'n9'),(10,'n10');

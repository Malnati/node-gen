INSERT INTO user (name, email) VALUES
('Alice','alice@example.com'),
('Bob','bob@example.com'),
('Carol','carol@example.com'),
('Dave','dave@example.com'),
('Eve','eve@example.com'),
('Frank','frank@example.com'),
('Grace','grace@example.com'),
('Heidi','heidi@example.com'),
('Ivan','ivan@example.com'),
('Judy','judy@example.com');

INSERT INTO project (name) VALUES
('Project A'),('Project B'),('Project C'),('Project D'),('Project E'),('Project F'),('Project G'),('Project H'),('Project I'),('Project J');

INSERT INTO user_project (user_id, project_id, role) VALUES
(1,1,'admin'),(2,1,'member'),(3,2,'member'),(4,3,'member'),(5,4,'member'),(6,5,'member'),(7,6,'member'),(8,7,'member'),(9,8,'member'),(10,9,'member');

INSERT INTO todo (user_id, project_id, title, status) VALUES
(1,1,'Tarefa 1','open'),(2,1,'Tarefa 2','open'),(3,2,'Tarefa 3','open'),(4,3,'Tarefa 4','open'),(5,4,'Tarefa 5','open'),(6,5,'Tarefa 6','open'),(7,6,'Tarefa 7','open'),(8,7,'Tarefa 8','open'),(9,8,'Tarefa 9','open'),(10,9,'Tarefa 10','open');

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

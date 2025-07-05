INSERT INTO users (name, email) VALUES
  ('User1','user1@example.com'),
  ('User2','user2@example.com'),
  ('User3','user3@example.com'),
  ('User4','user4@example.com'),
  ('User5','user5@example.com'),
  ('User6','user6@example.com'),
  ('User7','user7@example.com'),
  ('User8','user8@example.com'),
  ('User9','user9@example.com'),
  ('User10','user10@example.com');

INSERT INTO projects (name) VALUES
  ('Project1'),('Project2'),('Project3'),('Project4'),('Project5'),('Project6'),('Project7'),('Project8'),('Project9'),('Project10');

INSERT INTO statuses (name) VALUES
  ('Open'),('In Progress'),('Closed'),('Blocked'),('Done'),('Pending'),('New'),('Reviewed'),('Merged'),('Archived');

INSERT INTO todos (user_id, project_id, status_id, title, description, due_date) VALUES
  (1,1,1,'Todo1','Desc1','2024-12-01'),
  (2,2,2,'Todo2','Desc2','2024-12-02'),
  (3,3,3,'Todo3','Desc3','2024-12-03'),
  (4,4,4,'Todo4','Desc4','2024-12-04'),
  (5,5,5,'Todo5','Desc5','2024-12-05'),
  (6,6,6,'Todo6','Desc6','2024-12-06'),
  (7,7,7,'Todo7','Desc7','2024-12-07'),
  (8,8,8,'Todo8','Desc8','2024-12-08'),
  (9,9,9,'Todo9','Desc9','2024-12-09'),
  (10,10,10,'Todo10','Desc10','2024-12-10');

INSERT INTO tags (name) VALUES
  ('tag1'),('tag2'),('tag3'),('tag4'),('tag5'),('tag6'),('tag7'),('tag8'),('tag9'),('tag10');

INSERT INTO todo_tag (todo_id, tag_id) VALUES
  (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);

INSERT INTO user_projects (user_id, project_id, role) VALUES
  (1,1,'admin'),(2,2,'user'),(3,3,'user'),(4,4,'user'),(5,5,'user'),(6,6,'user'),(7,7,'user'),(8,8,'user'),(9,9,'user'),(10,10,'user');

INSERT INTO comments (todo_id, content) VALUES
  (1,'Comment1'),(2,'Comment2'),(3,'Comment3'),(4,'Comment4'),(5,'Comment5'),(6,'Comment6'),(7,'Comment7'),(8,'Comment8'),(9,'Comment9'),(10,'Comment10');

INSERT INTO attachments (todo_id, file_data) VALUES
  (1,'\\xDEADBEEF'),(2,'\\xDEADBEEF'),(3,'\\xDEADBEEF'),(4,'\\xDEADBEEF'),(5,'\\xDEADBEEF'),(6,'\\xDEADBEEF'),(7,'\\xDEADBEEF'),(8,'\\xDEADBEEF'),(9,'\\xDEADBEEF'),(10,'\\xDEADBEEF');

INSERT INTO notes (user_id, note) VALUES
  (1,'Note1'),(2,'Note2'),(3,'Note3'),(4,'Note4'),(5,'Note5'),(6,'Note6'),(7,'Note7'),(8,'Note8'),(9,'Note9'),(10,'Note10');

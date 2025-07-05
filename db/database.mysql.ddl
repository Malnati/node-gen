CREATE TABLE `user` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE project (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  budget DECIMAL(10,2),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE user_project (
  user_id INT,
  project_id INT,
  role VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  PRIMARY KEY (user_id, project_id),
  FOREIGN KEY (user_id) REFERENCES `user`(id),
  FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE todo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  project_id INT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50),
  completed BOOLEAN DEFAULT FALSE,
  due_date DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES `user`(id),
  FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE tag (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE todo_tag (
  todo_id INT,
  tag_id INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  PRIMARY KEY (todo_id, tag_id),
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (tag_id) REFERENCES tag(id)
);

CREATE TABLE comment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  todo_id INT NOT NULL,
  user_id INT NOT NULL,
  message TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (user_id) REFERENCES `user`(id)
);

CREATE TABLE attachment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  todo_id INT NOT NULL,
  file BLOB,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (todo_id) REFERENCES todo(id)
);

CREATE TABLE address (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  street VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES `user`(id)
);

CREATE TABLE note (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES `user`(id)
);

CREATE TABLE [user] (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(255) NOT NULL,
  email NVARCHAR(255) UNIQUE NOT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE project (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE user_project (
  user_id INT,
  project_id INT,
  role NVARCHAR(100),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  PRIMARY KEY (user_id, project_id),
  FOREIGN KEY (user_id) REFERENCES [user](id),
  FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE todo (
  id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  project_id INT,
  title NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  status NVARCHAR(50),
  due_date DATE,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES [user](id),
  FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE tag (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE todo_tag (
  todo_id INT,
  tag_id INT,
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  CONSTRAINT PK_todo_tag PRIMARY KEY (todo_id, tag_id),
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (tag_id) REFERENCES tag(id)
);

CREATE TABLE comment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  todo_id INT NOT NULL,
  user_id INT NOT NULL,
  message NVARCHAR(MAX),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (user_id) REFERENCES [user](id)
);

CREATE TABLE attachment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  todo_id INT NOT NULL,
  file VARBINARY(MAX),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (todo_id) REFERENCES todo(id)
);

CREATE TABLE address (
  id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  street NVARCHAR(255),
  city NVARCHAR(255),
  state NVARCHAR(255),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES [user](id)
);

CREATE TABLE note (
  id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  content NVARCHAR(MAX),
  created_at DATETIME DEFAULT GETDATE(),
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES [user](id)
);

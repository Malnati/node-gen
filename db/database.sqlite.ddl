CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE project (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE user_project (
  user_id INTEGER,
  project_id INTEGER,
  role TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  PRIMARY KEY (user_id, project_id),
  FOREIGN KEY (user_id) REFERENCES user(id),
  FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE todo (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  project_id INTEGER,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT,
  due_date DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES user(id),
  FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE tag (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);

CREATE TABLE todo_tag (
  todo_id INTEGER,
  tag_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  PRIMARY KEY (todo_id, tag_id),
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (tag_id) REFERENCES tag(id)
);

CREATE TABLE comment (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  todo_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  message TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (todo_id) REFERENCES todo(id),
  FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE attachment (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  todo_id INTEGER NOT NULL,
  file BLOB,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (todo_id) REFERENCES todo(id)
);

CREATE TABLE address (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  street TEXT,
  city TEXT,
  state TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE note (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  content TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES user(id)
);

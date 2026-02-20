-- test/e2e-generator-mock/projects/todo/db/database.mysql.ddl
CREATE TABLE project (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_project_external_id (external_id)
);

CREATE TABLE status (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36),
  code VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_status_external_id (external_id)
);

CREATE TABLE tag (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_tag_external_id (external_id)
);

CREATE TABLE todo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  project_id INT NOT NULL,
  status_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  due_date DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_todo_external_id (external_id),
  CONSTRAINT fk_todo_project FOREIGN KEY (project_id) REFERENCES project(id),
  CONSTRAINT fk_todo_status FOREIGN KEY (status_id) REFERENCES status(id)
);

CREATE TABLE todo_tag (
  todo_id INT NOT NULL,
  tag_id INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  PRIMARY KEY (todo_id, tag_id),
  CONSTRAINT fk_todo_tag_todo FOREIGN KEY (todo_id) REFERENCES todo(id),
  CONSTRAINT fk_todo_tag_tag FOREIGN KEY (tag_id) REFERENCES tag(id)
);

CREATE TABLE project_member (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  project_id INT NOT NULL,
  role VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_project_member_external_id (external_id),
  CONSTRAINT fk_project_member_project FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE comment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  todo_id INT NOT NULL,
  author_id CHAR(36) NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_comment_external_id (external_id),
  CONSTRAINT fk_comment_todo FOREIGN KEY (todo_id) REFERENCES todo(id)
);

CREATE TABLE attachment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  todo_id INT NOT NULL,
  file_ref TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_attachment_external_id (external_id),
  CONSTRAINT fk_attachment_todo FOREIGN KEY (todo_id) REFERENCES todo(id)
);

CREATE TABLE note (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id CHAR(36) NOT NULL,
  tenant CHAR(36) NOT NULL,
  account_id CHAR(36) NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME,
  UNIQUE KEY uk_note_external_id (external_id)
);

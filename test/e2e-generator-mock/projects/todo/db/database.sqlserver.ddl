-- test/e2e-generator-mock/projects/todo/db/database.sqlserver.ddl
CREATE TABLE project (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_project_external_id UNIQUE (external_id)
);

CREATE TABLE status (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER,
  code NVARCHAR(50) NOT NULL,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_status_external_id UNIQUE (external_id)
);

CREATE TABLE tag (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_tag_external_id UNIQUE (external_id)
);

CREATE TABLE todo (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  project_id INT NOT NULL,
  status_id INT NOT NULL,
  title NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  due_date DATE,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_todo_external_id UNIQUE (external_id),
  CONSTRAINT fk_todo_project FOREIGN KEY (project_id) REFERENCES project(id),
  CONSTRAINT fk_todo_status FOREIGN KEY (status_id) REFERENCES status(id)
);

CREATE TABLE todo_tag (
  todo_id INT NOT NULL,
  tag_id INT NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT PK_todo_tag PRIMARY KEY (todo_id, tag_id),
  CONSTRAINT fk_todo_tag_todo FOREIGN KEY (todo_id) REFERENCES todo(id),
  CONSTRAINT fk_todo_tag_tag FOREIGN KEY (tag_id) REFERENCES tag(id)
);

CREATE TABLE project_member (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  project_id INT NOT NULL,
  role NVARCHAR(100),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_project_member_external_id UNIQUE (external_id),
  CONSTRAINT fk_project_member_project FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE comment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  todo_id INT NOT NULL,
  author_id UNIQUEIDENTIFIER NOT NULL,
  content NVARCHAR(MAX) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_comment_external_id UNIQUE (external_id),
  CONSTRAINT fk_comment_todo FOREIGN KEY (todo_id) REFERENCES todo(id)
);

CREATE TABLE attachment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  todo_id INT NOT NULL,
  file_ref NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_attachment_external_id UNIQUE (external_id),
  CONSTRAINT fk_attachment_todo FOREIGN KEY (todo_id) REFERENCES todo(id)
);

CREATE TABLE note (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER NOT NULL,
  content NVARCHAR(MAX) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_note_external_id UNIQUE (external_id)
);

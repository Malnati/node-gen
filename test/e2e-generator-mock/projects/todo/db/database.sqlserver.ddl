-- test/e2e-generator-mock/projects/todo/db/database.sqlserver.ddl
CREATE TABLE tb_category (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  code NVARCHAR(50),
  name NVARCHAR(255) NOT NULL,
  full_description NVARCHAR(MAX),
  status NVARCHAR(50),
  price DECIMAL(10,2),
  sort_order INT DEFAULT 0,
  is_active BIT DEFAULT 1,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
);

CREATE TABLE tb_simple_item (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  name NVARCHAR(255) NOT NULL,
  category_id INT,
  product_id UNIQUEIDENTIFIER,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

CREATE TABLE tb_tag (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  name NVARCHAR(255) NOT NULL,
  slug NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
);

CREATE TABLE tb_simple_item_tag (
  simple_item_id INT NOT NULL,
  tag_id INT NOT NULL,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  PRIMARY KEY (simple_item_id, tag_id),
  FOREIGN KEY (simple_item_id) REFERENCES tb_simple_item(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);

-- test/e2e-generator-mock/projects/todo/db/schema.sqlserver.ddl
-- Mesmo modelo do schema.sql em sintaxe T-SQL (E2E mock).

CREATE TABLE tb_simple_item (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id NVARCHAR(MAX),
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  updated_at DATETIME2 DEFAULT GETUTCDATE()
);

CREATE TABLE tb_category (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id NVARCHAR(MAX),
  code NVARCHAR(255),
  name NVARCHAR(255) NOT NULL,
  full_description NVARCHAR(MAX),
  status NVARCHAR(255),
  price FLOAT(53),
  sort_order INT DEFAULT 0,
  is_active INT DEFAULT 1,
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  updated_at DATETIME2
);

CREATE TABLE tb_product (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id NVARCHAR(MAX),
  category_id INT NOT NULL,
  name NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  unit_price FLOAT(53) NOT NULL,
  stock_quantity INT DEFAULT 0,
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  updated_at DATETIME2,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

CREATE TABLE tb_sale (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id NVARCHAR(MAX),
  total FLOAT(53),
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  updated_at DATETIME2
);

CREATE TABLE tb_sale_item (
  sale_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price FLOAT(53),
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  PRIMARY KEY (sale_id, product_id),
  FOREIGN KEY (sale_id) REFERENCES tb_sale(id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);

CREATE TABLE tb_tag (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id NVARCHAR(MAX),
  name NVARCHAR(255) NOT NULL,
  slug NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETUTCDATE()
);

CREATE TABLE tb_product_tag (
  product_id INT NOT NULL,
  tag_id INT NOT NULL,
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);

CREATE TABLE tb_document (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id NVARCHAR(MAX),
  product_id INT NOT NULL,
  file_name NVARCHAR(255) NOT NULL,
  mime_type NVARCHAR(255),
  content VARBINARY(MAX),
  file_size INT DEFAULT 0,
  description NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETUTCDATE(),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);

-- test/e2e-generator-mock/projects/todo/db/database.sqlserver.ddl
CREATE TABLE tb_simple_item (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
);

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

CREATE TABLE tb_product (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  category_id INT NOT NULL,
  name NVARCHAR(255) NOT NULL,
  description NVARCHAR(MAX),
  unit_price DECIMAL(12,2) NOT NULL,
  stock_quantity INT DEFAULT 0,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

CREATE TABLE tb_sale (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  total DECIMAL(12,2),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
);

CREATE TABLE tb_sale_item (
  sale_id INT NOT NULL,
  product_id INT NOT NULL,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(12,2),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  PRIMARY KEY (sale_id, product_id),
  FOREIGN KEY (sale_id) REFERENCES tb_sale(id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
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

CREATE TABLE tb_product_tag (
  product_id INT NOT NULL,
  tag_id INT NOT NULL,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);

CREATE TABLE tb_document (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  product_id INT NOT NULL,
  file_name NVARCHAR(255) NOT NULL,
  mime_type NVARCHAR(100),
  content VARBINARY(MAX),
  file_size INT DEFAULT 0,
  description NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);

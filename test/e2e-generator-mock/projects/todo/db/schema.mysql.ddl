-- test/e2e-generator-mock/projects/todo/db/schema.mysql.ddl
-- Mesmo modelo do schema.sql em sintaxe MySQL (E2E mock).

CREATE TABLE tb_simple_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id TEXT,
  name TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE tb_category (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id TEXT,
  code VARCHAR(255),
  name VARCHAR(255) NOT NULL,
  full_description TEXT,
  status VARCHAR(255),
  price DOUBLE,
  sort_order INT DEFAULT 0,
  is_active INT DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME
);

CREATE TABLE tb_product (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id TEXT,
  category_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  unit_price DOUBLE NOT NULL,
  stock_quantity INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

CREATE TABLE tb_sale (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id TEXT,
  total DOUBLE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME
);

CREATE TABLE tb_sale_item (
  sale_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DOUBLE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (sale_id, product_id),
  FOREIGN KEY (sale_id) REFERENCES tb_sale(id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);

CREATE TABLE tb_tag (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id TEXT,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_product_tag (
  product_id INT NOT NULL,
  tag_id INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);

CREATE TABLE tb_document (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id TEXT,
  product_id INT NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  mime_type VARCHAR(255),
  content BLOB,
  file_size INT DEFAULT 0,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);

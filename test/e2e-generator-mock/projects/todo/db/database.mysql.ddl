-- test/e2e-generator-mock/projects/todo/db/database.mysql.ddl
CREATE TABLE tb_category (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  code VARCHAR(50),
  name VARCHAR(255) NOT NULL,
  full_description TEXT,
  status VARCHAR(50),
  price DECIMAL(10,2),
  sort_order INT DEFAULT 0,
  is_active TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME
);

CREATE TABLE tb_simple_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  category_id INT,
  product_id CHAR(36),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

CREATE TABLE tb_tag (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME
);

CREATE TABLE tb_simple_item_tag (
  simple_item_id INT NOT NULL,
  tag_id INT NOT NULL,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  PRIMARY KEY (simple_item_id, tag_id),
  FOREIGN KEY (simple_item_id) REFERENCES tb_simple_item(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);

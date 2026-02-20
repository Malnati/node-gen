-- test/e2e-generator-mock/projects/selling/db/schema.mysql.ddl
CREATE TABLE tb_order (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  account_id CHAR(36) NOT NULL,
  billing_address_id CHAR(36),
  shipping_address_id CHAR(36),
  payment_id CHAR(36),
  status VARCHAR(50) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0,
  ordered_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME
);

CREATE TABLE tb_order_line (
  order_id INT NOT NULL,
  line_number INT NOT NULL,
  tenant CHAR(36) NOT NULL,
  external_id CHAR(36) NOT NULL UNIQUE,
  product_id CHAR(36) NOT NULL,
  product_name VARCHAR(255),
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

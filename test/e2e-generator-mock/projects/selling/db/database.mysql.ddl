-- test/e2e-generator-mock/projects/selling/db/database.mysql.ddl
CREATE TABLE tb_customer (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id VARCHAR(36),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  tax_id VARCHAR(50),
  credit_limit DECIMAL(10,2),
  birth_date DATE,
  metadata JSON,
  is_active TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME
);

CREATE TABLE tb_payment_method (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_order (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id VARCHAR(36),
  customer_id INT NOT NULL,
  payment_method_id INT NOT NULL,
  status VARCHAR(50) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0,
  ordered_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  FOREIGN KEY (customer_id) REFERENCES tb_customer(id),
  FOREIGN KEY (payment_method_id) REFERENCES tb_payment_method(id)
);

CREATE TABLE tb_order_line (
  order_id INT NOT NULL,
  line_number INT NOT NULL,
  product_sku VARCHAR(100) NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

CREATE TABLE tb_payment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  paid_at DATETIME,
  reference VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

CREATE TABLE tb_stock_movement (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_sku VARCHAR(100) NOT NULL,
  quantity INT NOT NULL,
  movement_type VARCHAR(20) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_customer_address (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  street VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  zip_code VARCHAR(20),
  is_default TINYINT(1) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES tb_customer(id)
);

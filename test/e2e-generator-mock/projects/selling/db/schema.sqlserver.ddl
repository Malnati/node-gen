-- test/e2e-generator-mock/projects/selling/db/schema.sqlserver.ddl
CREATE TABLE tb_customer (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  name NVARCHAR(255) NOT NULL,
  email NVARCHAR(255) UNIQUE NOT NULL,
  tax_id NVARCHAR(50),
  credit_limit DECIMAL(10,2),
  birth_date DATE,
  metadata NVARCHAR(MAX),
  is_active BIT DEFAULT 1,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
);

CREATE TABLE tb_payment_method (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  code NVARCHAR(50) NOT NULL UNIQUE,
  name NVARCHAR(255) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
);

CREATE TABLE tb_order (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  customer_id INT NOT NULL,
  payment_method_id INT NOT NULL,
  status NVARCHAR(50) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0,
  ordered_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (customer_id) REFERENCES tb_customer(id),
  FOREIGN KEY (payment_method_id) REFERENCES tb_payment_method(id)
);

CREATE TABLE tb_order_line (
  order_id INT NOT NULL,
  line_number INT NOT NULL,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  product_sku NVARCHAR(100) NOT NULL,
  product_name NVARCHAR(255) NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

CREATE TABLE tb_payment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  order_id INT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  paid_at DATETIME2,
  reference NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

CREATE TABLE tb_stock_movement (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  product_sku NVARCHAR(100) NOT NULL,
  quantity INT NOT NULL,
  movement_type NVARCHAR(50) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2
);

CREATE TABLE tb_customer_address (
  id INT IDENTITY(1,1) PRIMARY KEY,
  tenant UNIQUEIDENTIFIER NOT NULL,
  external_id UNIQUEIDENTIFIER NOT NULL UNIQUE,
  customer_id INT NOT NULL,
  street NVARCHAR(255),
  city NVARCHAR(100),
  state NVARCHAR(100),
  zip_code NVARCHAR(20),
  is_default BIT DEFAULT 0,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  deleted_at DATETIME2,
  FOREIGN KEY (customer_id) REFERENCES tb_customer(id)
);

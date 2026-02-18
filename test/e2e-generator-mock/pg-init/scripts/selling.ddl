CREATE TABLE tb_customer (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  tax_id TEXT,
  credit_limit DECIMAL(10,2),
  birth_date DATE,
  metadata JSONB,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE tb_payment_method (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_order (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  customer_id INTEGER NOT NULL,
  payment_method_id INTEGER NOT NULL,
  status TEXT NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0,
  ordered_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES tb_customer(id),
  FOREIGN KEY (payment_method_id) REFERENCES tb_payment_method(id)
);

CREATE TABLE tb_order_line (
  order_id INTEGER NOT NULL,
  line_number INTEGER NOT NULL,
  product_sku TEXT NOT NULL,
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id, line_number),
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

CREATE TABLE tb_payment (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  paid_at TIMESTAMP,
  reference TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES tb_order(id)
);

CREATE TABLE tb_stock_movement (
  id SERIAL PRIMARY KEY,
  product_sku TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  movement_type TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_customer_address (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  street TEXT,
  city TEXT,
  state TEXT,
  zip_code TEXT,
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES tb_customer(id)
);
